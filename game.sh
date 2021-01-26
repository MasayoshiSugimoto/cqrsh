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
	local PLAYER="$1"
	local CELL="$2"

	local MARK='X'
	if [[ "$PLAYER" == 1 ]]; then
		MARK='O'
	fi
	$XSED -i -e "s/$CELL/$MARK/" $STATE_FOLDER/board

	if [[ "$(game.get_turn)" == 1 ]]; then
		game.set_turn 2
	else
		game.set_turn 1
	fi
}
