
function query.get_game {
	game.get_board
}

function query.get_empty_cells {
	game.empty_cells
}

function query.get_game_turn {
	game.get_turn
}

function query.player_1_mark {
	game.get_mark 1
}

function query.player_2_mark {
	game.get_mark 2
}

function query.game_who_won {
	if [[ $(game.has_won 1) == 1 ]]; then
		echo 1
	elif [[ $(game.has_won 2) == 1 ]]; then
		echo 2
	else
		echo 0
	fi
}

function query.ui_state {
	local KEY=$1
	cat $STATE_FOLDER/ui | grep $KEY | cut -f2 -d=
}

function query.get_ui_screen {
	query.ui_state 'screen'
}

function query.get_ui_notification {
	query.ui_state 'notification'
}
