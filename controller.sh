
function controller.main_loop {
	clear
	ui.play_screen 0
	local USER_INPUT=''
	while true; do
		# Ask user the cell he wants to play.
		USER_INPUT="$(input.get_user_move)"
		clear
		if input.ok "$USER_INPUT"; then
			event.on_player_play "$(input.value "$USER_INPUT")"
			ui.play_screen 0
		else
			ui.play_screen 1
		fi
	done
}

function controller.launch {
	# Stop listeners when interrupted
	trap "controller.shutdown; exit $EXIT_CODE_INTERRUPTED" SIGINT
	controller.listen & 2>$ERROR_LOG
	game.init_state
	controller.main_loop
}

function controller.shutdown {
	pkill -g $$ # Kill all child processes
}

# Process the event repository and apply command to the game state.
function controller.listen {
	tail -n+1 -F $STATE_FOLDER/events \
		| $XSED -u -e 's/^player_play/game.play,1/' -e 's/,/ /g' \
		| xargs -L1 ./game.sh
}
