
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
	game.init_state
	controller.main_loop
}

function controller.shutdown {
	pkill -g $$ # Kill all child processes
}

