#!/bin/bash

source "$(dirname $0)"/print_usage.sh
source "$(dirname $0)"/is_alphabet.sh
source "$(dirname $0)"/is_natural_number.sh
source "$(dirname $0)"/file_generator.sh

if [ $# -ne 6 ]; then
	echo "Error: 6 arguments are expected."
	echo "$( print_usage )"
	exit 1
fi

directory="$1"
if [ ${directory: -1} != "/" ]; then
	directory="$directory""/"
fi
if [ ! -d "$directory" ]; then
  echo "Error: the directory $1 does not exist."
	exit 1
fi
if [ ! -x "$directory" ]; then
  echo "Error: no permissions to write to the directory $1."
	exit 1;
fi

subdirs_count="$2"
if ! is_natural_number "$subdirs_count"; then
  echo "Error: natural number are expected for number of subfolders."
	exit 1;
fi

dir_letters="$3"
if ! is_alphabet "$dir_letters"; then
  echo "Error: alphabet letters are expected for subfolder's name.";
	exit 1;
fi
if [ ${#dir_letters} -gt 7 ]; then
  echo "Error: no more than 7 letters are expected for subfolder's name."
	exit 1;
fi

files_count="$4"
if ! is_natural_number "$files_count"; then
  echo "Error: natural number are expected for number of files."
	exit 1;
fi

file_letters=$( cut -d'.' -f1 <<< "$5" )
ext_letters=$( cut -d'.' -f2 <<< "$5" )
if ! [[ $5 =~ ^[a-zA-Z]+\.[a-zA-Z]+$ ]]; then
  echo "Error: [a-zA-Z].[a-zA-z] are expected for file's name."
	exit 1
fi
if ! (is_alphabet "$file_letters" && is_alphabet "$ext_letters"); then
  echo "Error: [a-zA-Z].[a-zA-z] are expected for file's name."
	exit 1
fi
if [ ${#file_letters} -gt 7 ] || [ ${#ext_letters} -gt 3 ]; then
	echo "Error: to the left of the dot, no more than 7 letters are "
  echo "       expected for the filename, to the right of the dot,"
  echo "       no more than 3 letters are expected for the extension."
  exit 1;
fi

file_size="$6"
KB=$(echo ${file_size: -2} | awk '{print tolower($0)}')
if [ "$KB" != "kb" ]; then
	echo "Error: expected kb dimension for file's size argument."
	exit 1
fi
file_size=${file_size:0:-2}
if ! is_natural_number "$file_size" || [ $file_size -gt 100 ]; then
	echo "Error: incorrect file's size (natural number not more than 100)."
	exit 1
fi
(( file_size = $file_size * 1000 ))

timestamp=$( date  "+%Y%m%d%H%M%S" )
logfile="$( dirname $0 )"/file_generator_"$timestamp".log

$(file_generator "$directory" $subdirs_count $dir_letters $files_count \
                  $file_letters $ext_letters $file_size $logfile)

