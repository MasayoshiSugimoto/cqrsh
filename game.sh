function game.get_board {
	cat $STATE_FOLDER/board
}

function game.init_board {
	echo 'A,B,C
D,E,F
G,H,I' > $STATE_FOLDER/board
}

function game.init_state {
	mkdir -p $STATE_FOLDER
	game.init_board
	game.set_turn 1
	touch $STATE_FOLDER/events
	
	echo '
turn=1
' > $STATE_FOLDER/game_state
}

function game.empty_cells {
	paste -s -d, <(cat $STATE_FOLDER/board | tr , '\n' | grep -vE 'X|O')
}

function game.set_turn {
	$XSED -I -e "s/turn=(.*)/turn=$1/" $STATE_FOLDER/game_state
}

function game.get_turn {
	cat $STATE_FOLDER/game_state | $XGREP 'turn' | cut -f2 -d=
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
	cat $STATE_FOLDER/board\
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
