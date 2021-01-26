
function event.on_player_play {
	local CELL=$1
	echo "player_play,$CELL" >> $STATE_FOLDER/events
}
