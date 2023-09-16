#!/bin/bash

LOGFILE=/home/ccartman/nginx/html/index.html

source "$( dirname $0 )""/node_exporter_aux.sh"


#!/bin/bash

if [ ! -f prometheus-2.45.0.linux-amd64.tar.gz ]; then
  wget 'https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz'
fi
if [ ! -d prometheus-2.45.0.linux-amd64 ]; then
  tar xvzf prometheus-2.45.0.linux-amd64.tar.gz
fi
cp prometheus.yml prometheus-2.45.0.linux-amd64/
if ! ps | grep 'prometheus'; then
  ./prometheus-2.45.0.linux-amd64/prometheus --config.file=prometheus.yml &
fi

while true; do
: >"$LOGFILE"
  printf "%s\n" "$( get_cpu_info )" >>"$LOGFILE"
  printf "%s\n" "$( get_mem_info )" >>"$LOGFILE"
  printf "%s\n" "$( get_disk_info )" >>"$LOGFILE"
  sleep 3
done

