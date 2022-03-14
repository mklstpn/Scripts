#!/bin/bash

echo "" > result.txt
domains_list=$(cat list.txt)

for item in ${domains_list[*]}
	do
		echo "$item - $(nslookup $item | grep 'Address: 10')" >> result.txt
	done
