
function check_timestamp() {
	local timestamp="$1"

	year=${timestamp:0:4}
	month=${timestamp:5:2}
	day=${timestamp:8:2}
	hour=${timestamp:11:2}
	minute=${timestamp:14:2}

	if ! [[ "$timestamp" =~ ^[0-9]{4}/[0-1][0-9]/[0-3][0-9]/[0-2][0-9]/[0-5][0-9]$ ]]
	then
		return 1
	fi
	if ! $( date -d "$timestamp_year$timestamp_month$timestamp_day" >/dev/null 2>&1 )
	then
		return 1
	fi
	if ! $( date -d "$timestamp_hour$timestamp_minute" >/dev/null 2>&1 ); then
		return 1
	fi

	return 0
}

