#!/bin/bash

source "$( dirname $0 )""/cleaning_the_file_system.sh"
source "$( dirname $0 )""/check_timestamp.sh"

if [ $# -ne 1 ] || ! [[ "$1" =~ ^[1-3]$ ]]; then
	echo "Error: one parametr is expected."
	echo
	echo "Usage: The cleaning method is set as a parametr with value of 1, 2 or 3."
	echo "1. By log file."
	echo "2. By creation date and time."
	echo "3. By name mask (i.e. characters, underlining and date)."
	exit 1
fi

if [ $1 -eq 1 ]; then
	echo -n "Enter the pathname of the log file: "
	read logfile

	if [ ! -r "$logfile" ]; then
		echo "Error: read permission denied."
		exit 1
	fi
	if [ -d "$logfile" ]; then
		echo "Error: file is directory."
		exit 1
	fi

	cleaning_by_logfile "$logfile"
elif [ $1 -eq 2 ]; then
	echo -n "Enter the lower bound of time in the format yyyy/mm/dd/hh/mm: "
	read start

	if ! check_timestamp "$start"; then
		echo "Error: incorrect format in lower bound of the time"
		exit 1
	fi

	echo -n "Enter the upper bound of time in the format yyyy/mm/dd/hh/mm: "
	read end

	if ! check_timestamp "$end"; then
		echo "Error: incorrect format in uper bound of the time"
		exit 1
	fi

	cleaning_by_timestamps "$start" "$end"
else
	echo -n "Enter the mask of filenames [a-zA-z]_ddmmyy: "
	read mask

	if ! [[ "$mask" =~ ^[a-zA-Z]+_[0-9]{6}$ ]]; then
		echo "Error: incorrect mask."
		exit 1
	fi

	cleaning_by_mask "$mask"
fi

