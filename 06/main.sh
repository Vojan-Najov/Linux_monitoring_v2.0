#!/bin/bash

if [ $# -ne 1 ] || ! [[ $1 =~ ^[1-4]$ ]]; then
	echo "The script is run with 1 parameter, which has a value of 1, 2, 3 or 4, 5."
	echo "Depending on the value of the parameter, output the following:"
	echo "1. All entries sorted by response code."
	echo "2. All unique IPs found in the entries."
	echo "3. All requests with errors (response code - 4xx or 5xxx)."
	echo "4. All unique IPs found among the erroneous requests."
	echo; echo "Sctipt expects log file names on the stdin."
	exit 1;
fi

echo -n "Enter a logfile path (or 'q' for quite): "
while read logfile; do
	if [ "X$logfile" = "Xq" ]; then
		break
	fi
	if [ ! -f "$logfile" ]; then
		echo "File \"$logfile\" not exist." 1>&2
		continue
	fi

	if [ $1 -eq 1 ]; then
		awk -f "$( dirname $0 )""/sort_by_respond_code.awk" "$logfile" | \
		goaccess - -c -a -d --log-format=COMBINED --max-items=1000
	elif [ $1 -eq 2 ]; then 
		awk -f "$( dirname $0 )""/get_unique_ips.awk" "$logfile" | \
		goaccess - -c -a -d --log-format=COMBINED --max-items=1000
	elif [ $1 -eq 3 ]; then
		awk -f "$( dirname $0 )""/choose_request_error.awk" "$logfile" | \
		goaccess - -c -a -d --log-format=COMBINED --max-items=1000
	else
		awk -f "$( dirname $0 )""/get_unique_ips_with_request_error.awk" "$logfile" | \
		goaccess - -c -a -d --log-format=COMBINED --max-items=1000
	fi

	echo -n "Enter a logfile path (or 'q' for quite): "
done


echo -n "Enter the directory where the logs are located: "
read directory
if [ ! -d "$directory" ]; then
	echo "Error: incorrect directory '$directory'."
fi
sudo goaccess -f "$directory"/*.log -a -d -o /var/www/html/index.html --real-time-html  --log-format=COMBINED

