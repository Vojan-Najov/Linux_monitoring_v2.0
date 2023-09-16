#!/bin/bash

function disk_is_full() {
  cur_size=$( df --block-size=1 / | grep -v Filesystem | awk '{print $4}')
  if [ $cur_size -le 1000000000 ]; then
    return 0;
  else
    return 1;
  fi
}

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

  : >"$logfile"

  while [ ${#subdir_name} -lt 4 ]; do
    first_character=${subdir_name:0:1}
    replace_characters=$first_character$first_character
    subdir_name=${subdir_name/$first_character/$replace_characters}
  done

  dir_letters_idx=0
  while [ $subdirs_count -gt 0 ]; do
    if disk_is_full; then
      break
    fi

    mkdir -p "$directory""$subdir_name"_"$now" 2>/dev/null
	
    printf "%s " $(realpath "$directory""$subdir_name"_"$now""/") >>$logfile
    printf "%s\n" "$( date +"%S/%M/%H/%d/%m/%Y" )" >>$logfile

    filename=$file_letters

    while [ ${#filename} -lt 4 ]; do
      first_character=${filename:0:1}
      replace_characters=$first_character$first_character
      filename=${filename/$first_character/$replace_characters}
    done

    file_letters_idx=0
    for i in $( seq 1 $files_count ); do
      if disk_is_full; then
        return
      fi

      fullname="$directory""$subdir_name"_"$now""/""$filename"_"$now"."$ext"

      fallocate -l $file_size "$fullname"

      printf "%s " $(realpath "$fullname") >>$logfile
      printf "%s " "$( date +"%S/%M/%H/%d/%m/%Y" )" >>$logfile
      printf "%s\n" "$file_size""B" >>$logfile
			
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
  done
}

