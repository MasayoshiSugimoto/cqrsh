
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
Player: X
COM:    O

----------------------------------------------


Your turn. You can play in one of the empty cells by typing the letter it contains then press <ENTER>.
EOF
}


