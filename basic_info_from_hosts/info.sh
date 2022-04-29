#!/bin/bash

exec > $(hostname)_info.txt
echo "Host: "$(hostname)
echo -e "$(lscpu | grep -v 'NUMA' | grep 'CPU(s):'| sed -r 's/: */: /g')"
echo -e "$(df -h | awk '{print $6 ": " $2}' | grep 'data')"
echo -e "$(free -h | awk '{print $1 " " $2}' | grep Mem | sed 's/Mem/RAM/')"
echo  "===================="
