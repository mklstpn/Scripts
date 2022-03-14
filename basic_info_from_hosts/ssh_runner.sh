#!/bin/bash

hosts_list=(
"host1.domain.dc"
"host2.domain.dc"
"host3.domain.dc"
)

for item in ${hosts_list[*]}
do
  echo "Connecting to $item"
  ssh username@$item 'bash -s' < info.sh
  scp username@$item:/home/User/*-info /home/User/result
  echo "Done!"
done
