#!/bin/bash

# Script for syncing itminedu github mirror repos and print output in simple
# log format.

homedir="$HOME"

echo -e "\n$(date)"

for org in 'itminedu' 'PDM-OpenGov' 'eellak' 'OBI-GRIPO'
do
  dir="$homedir/mirrors-$org"
  echo -e "Now doing ##### $org ##### repos\n-------------------------"
  for repo in $(ls "$dir")
  do
    cd "$dir/$repo"
    echo "$repo"
    git fetch -p origin
    git push --mirror
    echo "---------------------"
  done
done
