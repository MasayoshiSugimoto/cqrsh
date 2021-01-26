#!/bin/bash

source def.sh

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

function game.play {
	local PLAYER="$1"
	local CELL="$2"

	local MARK='X'
	if [[ "$PLAYER" == 1 ]]; then
		MARK='O'
	fi
	$XSED -i -e "s/$CELL/$MARK/" $STATE_FOLDER/board
}

# Process the event repository and apply command to the game state.
function game.restaure {
	cat $STATE_FOLDER/events | xargs -L1 ./game.sh
}

$@
