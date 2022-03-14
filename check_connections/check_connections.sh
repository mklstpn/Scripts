#!/bin/bash

echo "" > success.txt
echo "" > failed.txt

array=$(cat link_list.txt) # every link on new line

for item in ${array[*]}
  do
  echo "Trying $item"
  if curl $item &> /dev/null
    then
    echo "$item" >> success.txt
  else
    echo "$tem" >> failed.txt
  fi
  done
