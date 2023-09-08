#!/bin/bash

if [ $# -ne 1 ] || ! [[ $1 =~ ^[1-4]$ ]]; then
	echo "The script is run with 1 parameter, which has a value of 1, 2, 3 or 4."
	echo "Depending on the value of the parameter, output the following:"
	echo "1. All entries sorted by response code."
	echo "2. All unique IPs found in the entries."
	echo "3. All requests with errors (response code - 4xx or 5xxx)."
	echo "4. All unique IPs found among the erroneous requests."
	echo; echo "Sctipt expects log file names on the stdin."
	exit 1;
fi

while read logfile; do
	if [ ! -f "$logfile" ]; then
		echo "File '$logfile' not exist." 1>&2
		continue
	fi
	
	if [ $1 -eq 1 ]; then
		awk -f "$( dirname $0 )""/sort_by_respond_code.awk" "$logfile"
	elif [ $1 -eq 2 ]; then
		awk -f "$( dirname $0 )""/get_unique_ips.awk" "$logfile"
	elif [ $1 -eq 3 ]; then
		awk -f "$( dirname $0 )""/choose_request_error.awk" "$logfile"
	else
		awk -f "$( dirname $0 )""/get_unique_ips_with_request_error.awk" "$logfile"
	fi
done
