
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
	cat << EOF
TICTACTOE
=========

----------------------------------------------

$(ui.render_board)

----------------------------------------------

Notification: $(query.get_ui_notification)
Player 1:     $(query.player_1_mark)
Player 2:     $(query.player_2_mark)
Turn:         Player $(query.get_game_turn)

----------------------------------------------

$(
	if ! query.game_is_over; then
		echo 'Type a letter and type <ENTER>:'
	else
		echo 'GAME OVER

Press <ENTER> to continue.
'
	fi
)
EOF
}

function ui.start_screen {
	cat << EOF
TICTACTOE
=========

----------------------------------------------

Tictactoe implemented with bash and CQRS.
Built by Masayoshi Sugimoto.

----------------------------------------------

Notification: $(query.get_ui_notification)

----------------------------------------------

1. New Game
2. Continue

Type number and press <ENTER>:
EOF
}

function ui.continue_screen {
	cat << EOF
TICTACTOE
=========

----------------------------------------------

Continue Screen

----------------------------------------------

Notification: $(query.get_ui_notification)

----------------------------------------------

Select the game you want to continue or select
an option and press <ENTER>:
0. Back
$(game.get_games | awk '{print NR". "$0}')
EOF
}
