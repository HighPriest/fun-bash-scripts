#!/bin/bash
# Description:
# Script which dumps all the repositories associated with a group.
# Perfect when transfering between services
# The script takes 4 arguments:
# 1. GitLab username
# 2. GitLab access token
# 3. GitLab group name
# 4. GitLab URL (optional, defaults to https://gitlab.com)

# Check if arguments are provided
if [ $# -ne 3 ] || [ $# -ne 4 ]; then
    echo "Usage: $0 <user_name> <private_auth_token> <group_name> <remote_gitea_url>(optional)"
    echo "e.g.: $0 user_name 9f4651b63792fb7aae0ec908169b771663f3f5dc my_organisation https://gitlab.company.org"
    exit 1
fi

if [ $# -eq 3 ]; then
    url="https://gitlab.com"
else
    url="$4"
fi

# Get the list of projects associated with the group
projects=$(curl --silent -H "PRIVATE-TOKEN: $2" "$url/api/v4/groups/$3?include_subgroups=true&page=1&per_page=100")

# Loop through each project and clone it
for project_url in $(echo "$projects" | jq -r '.[] | @base64'); do
  project_id=$(echo "$project_url" | base64 --decode | jq -r '.id')
  project_name=$(echo "$project_url" | base64 --decode | jq -r '.name')
  git clone --mirror $url/"$1"/ "$project_name".git
done