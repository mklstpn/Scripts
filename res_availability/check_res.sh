#!/bin/bash

exec > $(hostname)_res.txt
echo -e $(hostname)
echo -e '\nMemory:'
echo -e "Total: Free: \n $(free -h | awk '{print $2 " " $3}' | grep -v 'used' | head -n 1)" | column -t
echo -e '\nDisk usage: '
echo -e "Mount: Total: Free: \n $(df -h | awk '{print $6 " " $2 " " $4 }' | grep 'data\|log')" | column -t
echo -e "\nCPU usage: $(echo 100-$(mpstat | awk '{print $NF}'| grep -v 'idle\|CPU') | sed -e 's/- /-/' -e 's/,/./' | bc)%"
echo "----------------------------------------------------------------------------------"

