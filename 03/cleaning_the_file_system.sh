
function cleaning_by_logfile() {
  local logfile="$1"

  for line in $( cat "$logfile" ); do
    filename=$( echo "$line" | awk '{print $0}' )
    rm -rf "$filename" 2>/dev/null
  done
}

function cleaning_by_timestamps() {
  local start="$1"
  local end="$2"

  local start_year=${start:0:4}
  local start_month=${start:5:2}
  local start_day=${start:8:2}
  local start_hour=${start:11:2}
  local start_minute=${start:14:2}
  local end_year=${end:0:4}
  local end_month=${end:5:2}
  local end_day=${end:8:2}
  local end_hour=${end:11:2}
  local end_minute=${end:14:2}

  local tmp_start="tmp_start_file_""$RANDOM"
  local tmp_end="tmp_end_file_""$RANDOM"

  touch -t "$start_year$start_month$start_day$start_hour$start_minute" $tmp_start
  touch -t "$end_year$end_month$end_day$end_hour$end_minute" $tmp_end

  for file in $( find / -newer $tmp_start -and -not -newer $tmp_end 2>/dev/null )
  do
    filename=$( basename $file )
    if [ -d $file ]; then
      if ! [[ $filename =~ ^[a-zA-Z]+_[0-9]{6}$ ]]; then
        continue
      fi
    else
      if ! [[ $filename =~ ^[a-zA-Z]+_[0-9]{6}\.[a-zA-Z]+$ ]]; then
        continue
      fi
    fi

    rm -rf $file
  done

  rm -rf $tmp_start
  rm -rf $tmp_end
}

function cleaning_by_mask() {
  mask="$1"

  letters=$( cut -d'_' -f1 <<< "$mask" )
  datestr=$( cut -d'_' -f2 <<< "$mask" )

  i=0
  last_idx=${#letters}
  (( last_idx = $last_idx - 1 ))
  while [ $i -le $last_idx ]; do
    character=${letters:$i:1}
    replace_characters="$character""*"
    letters=${letters/"$character"/"$replace_characters"}
		
    (( i = $i + 2 ))
    (( last_idx = $last_idx + 1 ))
  done

  mask="$letters"_"$datestr"

  for file in $( find / -type d -name "$mask" 2>/dev/null ); do
    filename=$( basename $file )
    rm -rf "$file"
  done
}
