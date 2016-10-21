#!/bin/bash

# Script for syncing itminedu github mirror repos

echo -e "\n$(date)"

for org in 'itminedu' 'PDM-OpenGov' 'eellak'
do
  dir="/home/git/mirrors-$org"
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
