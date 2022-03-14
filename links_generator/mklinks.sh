#!/bin/bash

path=$(pwd | sed -r 's/.*_data//g')

(ls -l | grep -v 'links' | awk '{print $9}') > links.txt
sed -ri '/^\s*$/d' links.txt
sed -ri 's,^,https:\/\/awesome.website.ru\'$path'\/,g' links.txt
