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
	touch $STATE_FOLDER/events
}

function game.empty_cells {
	paste -s -d, <(cat $STATE_FOLDER/board | tr , '\n' | grep -vE 'X|O')
}

function game.play {
	local PLAYER="$1"
	local CELL="$2"

	local MARK='X'
	if [[ "$PLAYER" == 1 ]]; then
		MARK='O'
	fi
	$XSED -i -e "s/$CELL/$MARK/" $STATE_FOLDER/board
}
