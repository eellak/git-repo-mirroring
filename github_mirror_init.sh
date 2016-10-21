#!/bin/bash

token="aed3f9851146a29fabb9fa52f88ab258a45b4c4a"

domain="$1"
st_org="$2"
repo="$3"

des_org="$4"

if [[ "$des_org" == "itminedu" || "$des_org" == "PDM-OpenGov" || "$des_org" == "eellak" ]]
then
  if [[ "$domain" == "github.com"  && "$repo" != "*.mirror" ]]
  then
    vars=$(grep -m 2 -e description -e homepage <<< \
      "$(curl https://api.github.com/repos/"$st_org"/"$repo" 2> /dev/null)")
    
    desc="$(head -n 1 <<< "$vars"| cut -d \" -f 4)"
    hmpg="$(tail -n 1 <<< "$vars"| cut -d \" -f 4)"
  else
    desc=""
    hmpg=""
  fi
    
  if [[ "$repo" != "*.mirror" ]]
  then
    curl \
      -H "Authorization: token $token" \
      -d "{\"name\":\"${repo}\",\"description\":\"${desc}\",\"homepage\": \"${hmpg}\"}" \
      https://api.github.com/orgs/"$des_org"/repos &> /dev/null
  fi
      
  cd /home/git/mirrors-"$des_org"
  
  if git clone --mirror https://"$domain"/"$st_org"/"$repo".git
  then
    cd "$repo".git
    sed -i '/fetch/d' config
    sed -i '/pull/d' packed-refs
    echo -e "        fetch = +refs/heads/*:refs/heads/*\n        fetch = +refs/tags/*:refs/tags/*" >> config
  else
    cd "$repo".git
  fi
  
  git remote set-url --push origin git@github.com:"$des_org"/"$repo"
  
  git fetch -p origin
  git push --mirror
else
  exit 1
fi
