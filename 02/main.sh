#!/bin/bash

source "$( dirname $0 )"/print_usage.sh
source "$( dirname $0 )"/is_alphabet.sh
source "$( dirname $0 )"/is_natural_number.sh
source "$( dirname $0 )"/file_generator.sh

START_TIME=$( date "+%T" )

if [ $# -ne 3 ]; then
	echo "Error: 3 arguments are expected."
	echo "$( print_usage )"
	exit 1
fi

DIR_LETTERS=$1
if ! is_alphabet "$DIR_LETTERS"; then
	echo "Error: aplhabet letters are expected for subfolder's name."
	exit 1;
fi
if [ ${#DIR_LETTERS} -gt 7 ]; then
	echo "Error: no more than 7 letters are expected for subfolder's name."
	exit 1
fi

FILE_LETTERS=$( cut -d'.' -f1 <<< "$2" )
EXT_LETTERS=$( cut -d'.' -f2 <<< "$2" )
if ! [[ "$2" =~ ^[a-zA-Z]+\.[a-zA-Z]+$ ]]; then
  echo "Error: [a-zA-Z].[a-zA-z] are expected for file's name."
	exit 1
fi
if [ ${#FILE_LETTERS} -gt 7 ] || [ ${#EXT_LETTERS} -gt 3 ]; then
	echo "Error: to the left of the dot, no more than 7 letters are "`
       `"expected for the file name, to the right of the dot, no more "`
       `"than 3 letters are expected for the extension."
  exit 1;
fi

FILE_SIZE="$3"
mb=$(echo ${FILE_SIZE: -2} | awk '{print tolower($0)}')
if [ "$mb" != "mb" ]; then
	echo "Error: expected mb dimension for file's size argument."
	exit 1
fi
FILE_SIZE=${FILE_SIZE:0:-2}
if ! is_natural_number "$FILE_SIZE" || [ $FILE_SIZE -gt 100 ]; then
	echo "Error: incorrect file's size (natural number not more than 100)."
	exit 1
fi
(( FILE_SIZE = $FILE_SIZE * 1024 * 1024 ))

TIMESTAMP=$( date "+%Y%m%d%H%M%S" )
LOGFILE="$(dirname $0)"/file_system_clogging_"$TIMESTAMP".log

: >"$LOGFILE"

TIMEFORMAT="Script execution time (in seconds) = %1R"
{
	time {
		for dir in $( find / -type d 2>/dev/null ); do
			#(( SUBDIRS_COUNT = $RANDOM % 100 ))
			SUBDIRS_COUNT=3 
			(( FILES_COUNT = $RANDOM % 100 )) 

			if [[ "$dir" =~ s?bin ]]; then
				continue
			fi

			if [ ! -x "$dir" ] || [ ! -w "$dir" ]; then
				continue;
			fi

			file_generator "$dir""/" $SUBDIRS_COUNT $DIR_LETTERS $FILES_COUNT \
                     $FILE_LETTERS $EXT_LETTERS $FILE_SIZE "$LOGFILE"

			if [ $? -ne 0 ]; then
				break;
			fi
		done;

		printf "\n%s%s\n" "Start time of script execution: " "$START_TIME" >>"$LOGFILE"
		end_time=$( date "+%T" )
		printf "%s%s\n" "End time of script execution: " "$end_time" >>"$LOGFILE"
	}
} 2>>"$LOGFILE"


echo "$( tail -3 "$LOGFILE" )"

