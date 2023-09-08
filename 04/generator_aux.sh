
function gen_random_date() {
	local data=0
	(( data = ((10 + ($RANDOM % 13)) * 100 + (1 + ($RANDOM % 12))) * 100 + \
              1 + $RANDOM % 28 ))
	echo $data
}

function gen_ip() {
	echo "$(( $RANDOM % 256 ))"."$(( $RANDOM % 256 ))"."$(( $RANDOM % 256 ))"."$(( $RANDOM % 256 ))"
}

function gen_client_rfc_id() {
	echo "-"
}

function gen_username() {
	echo "-"
}

function gen_timestamp() {
	local data=$1
	local time_step=$2
	local n=$3
	local vtime=$(( $time_step * $n ))
	local hours=$(( $vtime / 3600 ))
	(( vtime = $vtime % 3600 ))
	local minutes=$(( $vtime / 60 ))
	local seconds=$(( $vtime % 60 ))

	echo '['"$( date --date="$data $hours:$minutes:$seconds" "+%d/%b/%Y:%H:%M:%S %z" )"']'
}

function gen_request() {
	local requests=( "GET" "POST" "PUT" "PATCH" "DELETE" )
	local index=$(( $RANDOM % 5 ))
	echo '"'"${requests[$index]} /stuff.html HTTP/1.1"'"'
}

function gen_status() {
	local status=( 200 201 400 401 403 404 500 501 502 503 )
	local index=$(( $RANDOM % 10 ))
	echo ${status[$index]}
}

function gen_number_of_bytes() {
	echo $(( $RANDOM % 2048 ))
}

function gen_url() {
	local url=( "https://www.google.com/" "https://yandex.com/" "https://duckduckgo.com/" )
	local index=$(( $RANDOM % 3 ))
	echo '"'"${url[$index]}"'"'
}

function gen_agent() {
	local agent=( "Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" \
	              "Crawler and bot" "Library and net tool" )
	local index=$(( $RANDOM % ${#agent[@]} ))
	echo '"'"${agent[$index]}"'"'
}

function gen_logfile() {
	local entry_count=$1
	local curdate=$2
	local logfile=$3
	local time_step
	(( time_step = 24 * 60 * 60 / $entry_count ))
	
	: >"$logfile"
	for i in $( seq 1 $entry_count ); do
		echo -n "$( gen_ip )" "" >>"$logfile"
		echo -n "$( gen_client_rfc_id )" "" >>"$logfile"
		echo -n "$( gen_username )" "" >>"$logfile"
		echo -n "$( gen_timestamp $curdate $time_step $i )" "" >>"$logfile"
		echo -n "$( gen_request )" "" >>"$logfile"
		echo -n "$( gen_status )" "" >>"$logfile"
		echo -n "$( gen_number_of_bytes )" "" >>"$logfile"
		echo -n "$( gen_url )" "" >>"$logfile"
		echo "$( gen_agent )" >>"$logfile"
	done	
}

