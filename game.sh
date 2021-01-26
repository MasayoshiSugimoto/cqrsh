
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

	# TODO: Add error handling

	$XSED -i "s/$2/$([[ $PLAYER == 1 ]] && echo 'X' || echo 'Y')/" $STATE_FOLDER/board
}

# Process the event repository and apply command to the game state.
function game.listen {
	tail -n+1 -F $STATE_FOLDER/events\
		| tr ',' ' '\
		| $XSED 's/^player_play/game.play 1 /'\
		| xargs eval
}
