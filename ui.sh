
function ui.render_board {
	query.get_game \
		| $XAWK '
			BEGIN { first = 1 }
			{
				if (first) first = 0
				else print "---+---+---"
				print " "$1" | "$2" | "$3" "
			}
		'	
}

function ui.render_list {
	tr ',' '\n' | $XSED 's/(.*)/- \1/'
}

function ui.play_screen {
	local INVALID_CELL=$1

	cat << EOF
TICTACTOE
=========

----------------------------------------------

$(ui.render_board)

----------------------------------------------

NOTIFICATION: $(
	if [[ $INVALID_CELL != 0 ]]; then
		echo 'Invalid cell.'
	fi
)
Player 1:     X
Player 2:     O
Turn:         Player $(query.get_game_turn)

----------------------------------------------

Type a letter and type <ENTER>:
EOF
}


