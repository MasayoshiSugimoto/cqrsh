
function event.on_player_play {
	local CELL=$1
	event.send_game_event "game.play $CELL"
}

function event.send_game_event {
	local EVENT="$1" 
	echo "$EVENT" >> $(game.get_current_event_file)
	$EVENT
}

function event.replay {
	local ID=$1
	game.load $ID
}

function event.new_game {
	game.init_state
}
