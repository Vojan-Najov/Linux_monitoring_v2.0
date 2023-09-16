#!/bin/bash

function get_cpu_info() {
  local cpu_info=$( top -n 1 | grep "%Cpu(s)" )
  local cpu_user=$( echo "$cpu_info" | awk '{ print $2 }' )
  local cpu_system=$( echo "$cpu_info" | awk '{ print $4 }' )
  local cpu_load=$( bc <<<"scale = 1; $cpu_system + $cpu_user" )
  echo "cpu_load $cpu_load"
}

function get_mem_info() {
  local mem_info=$( free -b | grep "Mem" )
  local mem_free=$( echo "$mem_info" | awk '{ print $4 }' )
  local mem_used=$( echo "$mem_info" | awk '{ print $3 }' )
  echo "mem_bytes{id=\"free\"} $mem_free"
  echo "mem_bytes{id=\"used\"} $mem_used"
}

function get_disk_info() {
  local disk_info=$( df --block-size=1 / | grep -v Filesystem )
  local disk_used=$( echo $disk_info | awk '{ print $3 }' )
  local disk_available=$( echo $disk_info | awk '{ print $4 }' )
  echo "disk_bytes{id=\"used\"} $disk_used"
  echo "disk_bytes{id=\"available\"} $disk_available"
}

