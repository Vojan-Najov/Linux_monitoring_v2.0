#!/bin/bash

function disk_is_full() {
  local size=$1
  local min_size=0
  local cur_size=$( df --block-size=1K / | grep -v Filesystem | awk '{print $4}' )
  (( min_size = 1024 * 1024 ))
  size=$( bc <<<"size / 1024" )
  (( cur_size = $cur_size - $size ))

  if [ $cur_size -le $min_size ]; then
    return 0;
  else
    return 1;
  fi
}

#  returns 0 if it was possible to create all directories and files
#+ returns 1 if the disk has run out of space
#+ returns 2 if it was not possible to create a directory
#+ returns 3 if the file could not be created
function file_generator() {
  directory=$1
  subdirs_count=$2
  dir_letters=$3
  files_count=$4
  file_letters=$5
  ext=$6
  file_size=$7
  logfile=$8
  subdir_name=$3
  now=$(date +%d%m%y)

  while [ ${#subdir_name} -lt 4 ]; do
    first_character=${subdir_name:0:1}
    replace_characters=$first_character$first_character
    subdir_name=${subdir_name/$first_character/$replace_characters}
  done

  dir_letters_idx=0
  while [ $subdirs_count -gt 0 ]; do
    if disk_is_full 4096 ; then
      return 1
    fi

    mkdir -p "$directory""$subdir_name"_"$now" 2>/dev/null
    if [ $? -ne 0 ]; then
      return 2
    fi
	
    printf "%s " $(realpath "$directory""$subdir_name"_"$now""/") >>"$logfile"
    printf "%s\n" "$( date +"%d/%m/%y %T" )" >>"$logfile"

    filename=$file_letters

    while [ ${#filename} -lt 4 ]; do
      first_character=${filename:0:1}
      replace_characters=$first_character$first_character
      filename=${filename/$first_character/$replace_characters}
    done

    file_letters_idx=0
    for i in $( seq 1 $files_count ); do
      if disk_is_full $file_size ; then
        return 1
      fi

      fullname="$directory""$subdir_name"_"$now""/""$filename"_"$now"."$ext"

      fallocate -l $file_size $fullname 2>/dev/null
      if [ $? -ne 0 ]; then
        return 3
      fi

      printf "%s " $(realpath "$fullname") >>"$logfile"
      printf "%s " "$( date +"%d/%m/%y %T" )" >>"$logfile"
      printf "%s\n" "$file_size""B" >>"$logfile"
			
      character=${file_letters:$file_letters_idx:1}
      replace_characters=$character$character
      filename=${filename/$character/$replace_characters}
      (( file_letters_idx = ($file_letters_idx + 1) % ${#file_letters} ))
    done

    character=${dir_letters:$dir_letters_idx:1}
    replace_characters=$character$character
    subdir_name=${subdir_name/$character/$replace_characters}
    (( dir_letters_idx = ($dir_letters_idx + 1) % ${#dir_letters} ))
    (( subdirs_count = $subdirs_count - 1 ))

    (( files_count = $RANDOM % 100 ))
  done

  return 0
}

