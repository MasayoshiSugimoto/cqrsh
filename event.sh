
function event.on_player_play {
	local CELL=$1
	event.send_game_event "game.play 1 $CELL"
}

function event.send_game_event {
	local EVENT="$1" 
	echo "$EVENT" >> $STATE_FOLDER/events
	$EVENT
}

function event.replay {
	source $STATE_FOLDER/events
}
