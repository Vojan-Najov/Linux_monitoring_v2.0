#!/bin/bash

if [ ! -f node_exporter-1.6.1.linux-amd64.tar.gz ]; then
  wget 'https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz'
fi
if [ ! -d node_exporter-1.6.1.linux-amd64 ]; then
  tar xvzf node_exporter-1.6.1.linux-amd64.tar.gz
fi
if ! ps | grep 'node_exporter'; then
  ./node_exporter-1.6.1.linux-amd64/node_exporter &
fi

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

answer=""
while [ "$answer" != 'q' ]; do
  echo "enter 'q' for quite"
  read answer
done

kill -s SIGTERM $( ps | grep prometheus | awk '{ print $1 }' )
kill -s SIGTERM $( ps | grep node_exporter | awk '{ print $1 }' )

rm -rf data
rm -rf prometheus-2.45.0.linux-amd64.tar.gz
rm -rf prometheus-2.45.0.linux-amd64
rm -rf node_exporter-1.6.1.linux-amd64.tar.gz
rm -rf node_exporter-1.6.1.linux-amd64

