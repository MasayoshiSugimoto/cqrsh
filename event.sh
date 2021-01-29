
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
	local INDEX=$1
	local ID=$(game.get_games | $XSED "$INDEX!d")
	game.load $ID
}

function event.new_game {
	game.init_state
}
