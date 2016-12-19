#!/bin/bash

# Script to initialize syncing to itminedu github mirror repos

homedir="$HOME"

domain="$1"
st_org="$2"
repo="$3"

des_org="$4"

token="$5"

## Prepare the destination organisation for importing the repo.

# Only work for itminedu, PDM-OpenGov, eellak destination organisations.
if [[ "$des_org" == "itminedu" || "$des_org" == "PDM-OpenGov" || "$des_org" == "eellak" ]]
then
  # If repo comes from a github repo and is not a wiki repo.
  # Get repo homepage & description and save it in variables desc & hmpg.
  if [[ "$domain" == "github.com"  && "$repo" != "*.mirror" ]]
  then
    vars=$(grep -m 2 -e description -e homepage <<< \
      "$(curl https://api.github.com/repos/$st_org/$repo 2> /dev/null)")
    
    desc="$(head -n 1 <<< $vars |cut -d \" -f 4)"
    hmpg="$(tail -n 1 <<< $vars |cut -d \" -f 4)"
  # if its a repo without a homepage or description reset variables.
  else
    desc=""
    hmpg=""
  fi

  # If repo is not a wiki then create a new repo in destination organisation.
  if [[ "$repo" != "*.mirror" ]]
  then
    curl \
      -H "Authorization: token $token" \
      -d "{\"name\":\"${repo}\",\"description\":\"${desc}\",\"homepage\": \"${hmpg}\"}" \
      "https://api.github.com/orgs/$des_org/repos &> /dev/null"
  fi

  ## Manage the actual repo.
  cd "$homedir/mirrors-$des_org"

  # Clone the repo in mirror format if it doesn't already exist and set fetch,
  # pull settings to "exclude pull refs".
  if git clone --mirror "https://$domain/$st_org/$repo.git"
  then
    cd "$repo.git"
    sed -i '/fetch/d' config
    sed -i '/pull/d' packed-refs
    echo -e "        fetch = +refs/heads/*:refs/heads/*\n        fetch = +refs/tags/*:refs/tags/*" >> config
  else
    cd "$repo.git"
  fi

  # Set destination repo in local repo configuration.
  git remote set-url --push origin "git@github.com:$des_org/$repo"

  # Fetch any updated content from initial repo and push to new cloned repo.
  git fetch -p origin
  git push --mirror
else
  exit 1
fi
