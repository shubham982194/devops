#!/bin/bash

gh auth status > /dev/null 2>&1

if [ $? -ne 0 ];then
	        echo "You are not logged in to GITHUB cli"
		        exit 1
fi

read -p "Enter your Repo Name : " repo_name
if [[ -z "$repo_name" ]];then
	        echo "Repo already exist plz create new"
		        exit 1
fi

repo_path="$HOME/$repo_name"
if [[ -d "$repo_path" ]];then
	        echo "Directory $repo_path already exist"
	else
		        mkdir "$repo_path" && echo "creadted Directory $repo_path"
fi
cd "$repo_path" || { echo "failed to enter $repo_path";exit 1;}

git init
git branch -M main
echo "Initialize git repo in $repo_path with branch main"

git config user.name "Your username"
git config user.email "Your email"

echo "git user.name and user.email configured dome."

echo "# $repo_name" > README.md

git add README.md
git commit -m "commit is done"

read -p "make repo public/private ;" visibility

visibility=${visibility:-public}

echo "creating github repo
'$repo_name' as $visibility and pushing code... "

gh repo create "$repo_name" --"$visibility" --source=. --remote=origin --push

if [[ $? -eq 0 ]];then
	        echo "repo created and pushed successfully"
	else
		        echo "failed to create 👎"
fi

if ! gh auth status > /dev/null 2>&1; then
	                echo "You are not login in please login first..."
			                        exit 1
fi

github_owner=$(gh api user --jq '.login')

if [[ -z "$github_owner" ]]; then
	                echo "Owner account could not found..."
			                        exit 1
fi

repo_list=$(gh repo list "$github_owner" --json name --jq '.[].name' )

echo "$repo_list"
