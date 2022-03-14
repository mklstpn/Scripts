#!/bin/bash

echo "Gathering host info"

hostname=$(hostname)

echo "Host: "$hostname > $hostname"-info.txt"

lscpu | grep -v 'NUMA' | grep 'CPU(s):'| sed -r 's/: */: /g' >> $hostname"-info.txt"

df -h | awk '{print $6 ": " $2}' | grep 'data' >> $hostname"-info.txt"

free -h | awk '{print $1 " " $2}' | grep Mem | sed 's/Mem/RAM/' >> $hostname"-info.txt"

echo "====================" >> $hostname"-info.txt"
