function game.get_board {
	cat $STATE_FOLDER/board
}

function game.init_board {
	echo 'A,B,C
D,E,F
G,H,I' > $STATE_FOLDER/board
}

function game.init_state {
	local ID=$1
	if [[ $ID == "" ]]; then
		ID=$(date "+%Y%m%d_%H%M%S")
	fi

	mkdir -p $STATE_FOLDER
	game.init_board

	echo "
turn=1
id=$ID
" > $STATE_FOLDER/game_state

	touch $(game.get_event_file $ID)
}

function game.empty_cells {
	paste -s -d, <(game.get_board | tr , '\n' | grep -vE 'X|O')
}

function game.set_turn {
	$XSED -I -e "s/turn=(.*)/turn=$1/" $STATE_FOLDER/game_state
}

function game.get_turn {
	game.get_state_value 'turn'
}

function game.get_id {
	game.get_state_value 'id'
}

function game.get_state_value {
	local KEY=$1
	cat $STATE_FOLDER/game_state | $XGREP "$KEY" | cut -f2 -d=
}

function game.play {
	local CELL="$1"

	local MARK=$(game.get_mark $(game.get_turn))
	$XSED -i -e "s/$CELL/$MARK/" $STATE_FOLDER/board

	if [[ "$(game.get_turn)" == 1 ]]; then
		game.set_turn 2
	else
		game.set_turn 1
	fi
}

function game.get_mark {
	local PLAYER="$1"
	if [[ "$PLAYER" == 1 ]]; then
		echo 'X'
	else
		echo 'O'
	fi
}

function game.has_won {
	local PLAYER=$1
	game.get_board\
		| tr $(game.get_mark $PLAYER) 1\
		| tr -d '[:alpha:]'\
		| $XAWK '
			{
				i = 0
				board[i++, NR-1] = $1
				board[i++, NR-1] = $2
				board[i++, NR-1] = $3
			}
			END {
				if (\
					(board[0,0] && board[0,1] && board[0,2])\
					|| (board[1,0] && board[1,1] && board[1,2])\
					|| (board[2,0] && board[2,1] && board[2,2])\
					|| (board[0,0] && board[1,0] && board[2,0])\
					|| (board[0,1] && board[1,1] && board[2,1])\
					|| (board[0,2] && board[1,2] && board[2,2])\
					|| (board[0,0] && board[1,1] && board[2,2])\
					|| (board[0,2] && board[1,1] && board[2,0])\
				) {
					print 1
				} else {
					print 0
				}
			}
		'
}

function game.is_game_over {
	[[ $(game.get_board | tr -d ',XO\n' | wc -c) -eq 0 ]]\
	|| [[ $(game.has_won 1) == 1 ]]\
	|| [[ $(game.has_won 2) == 1 ]]
}

function game.get_event_file {
	local ID=$1
	echo "$STATE_FOLDER/event.$ID"
}

function game.get_current_event_file {
	game.get_event_file $(game.get_id)
}

function game.load {
	local ID=$1
	game.init_state $ID
	source $(game.get_event_file $ID)
}

# Get the list of ids of all games.
function game.get_games {
	ls $STATE_FOLDER/event.* | $XSED "s;$STATE_FOLDER/event\.;;"
}

function game.is_valid_game {
	local INDEX="$1"
	local NB_GAMES=$(game.get_games | wc -l)
	[[ 0 -lt $INDEX ]] && [[ $INDEX -le $NB_GAMES ]]
}

function game.get_game_by_index {
	local INDEX=$1
	game.get_games | $XSED "$INDEX!d"
}
