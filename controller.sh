function controller.main_loop {
	while true; do
		clear
		case $(query.get_ui_screen) in
		start)
			controller.start_screen
			;;
		play)
			controller.play_screen
			;;
		continue)
			controller.continue_screen
			;;
		*)
			controller.start_screen
			;;
		esac
	done
}

function controller.launch {
	controller.init
	controller.main_loop
}

function controller.shutdown {
	pkill -g $$ # Kill all child processes
}

function controller.init {
	echo '
screen=start
notification=
' > $STATE_FOLDER/ui
}

function controller.set_state {
	local KEY=$1
	local VALUE="$2"
	$XSED -I -e "s/$KEY=(.*)/$KEY=$VALUE/" $STATE_FOLDER/ui
}

function controller.set_screen {
	local SCREEN=$1
	controller.set_state 'screen' $SCREEN
}

function controller.set_notification {
	local NOTIFICATION="$1"
	controller.set_state 'notification' "$NOTIFICATION"
}

function controller.start_screen {
	ui.start_screen

	local NEXT_SCREEN=''
	read NEXT_SCREEN
	if [[ "$NEXT_SCREEN" == 1 ]]; then
		event.new_game
		controller.set_screen 'play'
		controller.set_notification ''	
	elif [[ "$NEXT_SCREEN" == 2 ]]; then
		controller.set_screen 'continue'
		controller.set_notification ''	
	else
		controller.set_notification 'Invalid input.'
	fi
}

function controller.play_screen {
	ui.play_screen

	local WINNER=$(query.game_who_won)
	if [[ $WINNER != 0 ]]; then
		read
		controller.init
		return
	fi

	local USER_INPUT="$(input.get_user_move)"
	if input.ok "$USER_INPUT"; then
		event.on_player_play "$(input.value "$USER_INPUT")"
		controller.set_notification "Cell $(input.value "$USER_INPUT") played."
	else
		controller.set_notification 'Invalid input.'
	fi

	WINNER=$(query.game_who_won)
	if [[ $WINNER != 0 ]]; then
		controller.set_notification "Player $WINNER won."
	fi
}

function controller.continue_screen {
	ui.continue_screen

	local INDEX
	read INDEX

	if query.game_is_valid "$INDEX"; then
		event.replay $INDEX	
		controller.set_notification "Game with id $(query.game_get_game_by_index $INDEX) loaded."
		controller.set_screen 'play'
	else
		controller.set_notification 'Invalid input.'
	fi
}
