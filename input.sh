readonly INPUT_OK='OK'
readonly INPUT_NG='NG'

# Get and validate next user move.
function input.get_user_move {
	local CELL=''
	read CELL

	if [[ "$CELL" != '' ]] \
		&& [[ "$CELL" != ',' ]] \
		&& query.get_empty_cells | input.contains "$CELL" ; then
		echo "$INPUT_OK,$CELL"
	else
		echo "$INPUT_NG"
	fi
}

function input.contains {
	grep --quiet "$1"
}

function input.ok {
	echo "$1" | grep --quiet "^$INPUT_OK,"
}

function input.value {
	echo "$1" | cut -d, -f2
}


