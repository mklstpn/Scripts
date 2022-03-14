#!/bin/bash

key=your_trello_key
token=your_trello_token

backlog=custom_column
other=custom_column
done=custom_column

ids=(
array with ids of trello columns
)

rm -f yesterday.txt
mv today.txt yesterday.txt

echo "" > today.txt
for id in ${ids[*]}
  do
    if [ $id = $backlog ] || [ $id = $other ] || [ $id = $done ]
      then
        echo -n $(curl --request GET --url 'https://api.trello.com/1/lists/'$id'/cards?key='$key'&token='$token'' --header 'Accept: application/json' | grep -o '"dueReminder":' | wc -l)  >> today.txt
      else
        echo -n $(curl --request GET --url 'https://api.trello.com/1/lists/'$id'/cards?key='$key'&token='$token'' --header 'Accept: application/json' | grep -o 'Created:' | wc -l)  >> today.txt
    fi
    echo -e " \c" >> today.txt
  done

read -a today < today.txt
read -a yesterday < yesterday.txt

echo "" > arr3.tmp
for ((i=0; i<${#today[@]} || i<${#yesterday[@]}; i++))
  do
    echo -en $(echo ${today[i]}-${yesterday[i]} | bc -l) >> arr3.tmp
    echo -en " " >> arr3.tmp
  done

sed -ri 's/-../0 /g' arr3.tmp
sed -i 's/  / /g' arr3.tmp
read -a arr3 < arr3.tmp

echo -en "" > arr4.tmp
tail -n 1 output.csv > arr4.tmp
sed -ri 's/^.{11}//' arr4.tmp
sed -i 's/;/ /g' arr4.tmp
read -a arr4 < arr4.tmp

echo -e "" >> output.csv
echo -en $(date +%d-%m-%Y)";\c" >> output.csv
for ((i=0; i<${#arr3[@]} || i<${#arr4[@]}; i++))
  do
    echo -en $(echo ${arr3[i]}+${arr4[i]} | bc -l) >> output.csv
    echo -en ";" >> output.csv
  done

rm -f arr3.tmp arr4.tmp
#echo -e "\n" >> output.csv
