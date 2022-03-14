#!/bin/bash

read -p "First 3 octets e.g. '10.20.30': " first_octets
read -p "Start from: " start
read -p "End: " end

for ((i = $start; i <= $end; i++))
  do
    echo "$first_octets.$i" >> ip_list.tmp
  done

ip_list=$(cat ip_list.tmp)

echo "Available hosts:" > available_host.txt

for item in ${ip_list[*]}
do
  echo "Trying $item"

  if ping -c 1 -W 1 $item &> /dev/null
  then
    echo "IP $item is busy" # if host reachable
  else
    echo "$item" >> available_host.txt # if host unreachable
  fi
done

rm -f ip_list.tmp
