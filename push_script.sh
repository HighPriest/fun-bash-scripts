#!/bin/bash
# A bash script which creates a gitea remotes for all the projects in current folder and pushes all the branches and history to created remotes.
# Perfect for transfering repositories to Gitea
# The script takes 4 arguments:
# 1. The name of the user on the remote Gitea server
# 2. The authorisation token on the remote Gitea server
# 3. The name of the organization on the remote Gitea server
# 4. The URL of the remote Gitea server
# 5. The port of the remote Gitea server (optional, defaults to 22)
#TODO: Add support for private repositories
#Note: There might be a conflict with the git repository ssh username (git)

# Check if all 4 arguments are provided
if [ $# -ne 4 ] || [ $# -ne 5 ]; then
    echo "Usage: $0 <user_name> <auth_token> <organization_name> <remote_gitea_url> <port>(optional))"
    echo "e.g.: $0 username 9f4651b63792fb7aae0ec908169b771663f3f5dc my_organisation gitea.company.org 2222"
    exit 1
fi

# Sanitize the URL
# Check the url prefix for existence of http:// or https://
if [[ "$1" != http://* ]] && [[ "$1" != https://* ]]; then
    # Add https:// prefix to URL if it's not there
    url="https://$4"
else
    url="$4"
fi

if [ $# -ne 5 ]; then
    port="22"
else
    port="$5"
fi

# Loop through all directories in the current folder
for dir in */; do
    # Remove trailing slash from directory name
    dir=${dir%*/}
    # Create repository on remote Gitea server
    echo $dir
    curl -X POST -H "Authorization: token $2" -H "Content-Type: application/json" -d '{"name": "'"$dir"'"}' "$url/api/v1/org/$3/repos"
    # Remove remote repository if it already exists
    echo "2"
    git -C "$dir" remote remove gitea
    # Add remote repository
    echo "3"
    git -C "$dir" remote add gitea "ssh://git@$4:$5/$3/$dir.git"
    # Push changes to remote repository
    echo "4"
    git -C "$dir" push --mirror gitea
done