#!/bin/bash
## A bash script which renames the author in all commits in a git repository
## chmod +x git_rename.sh
## USE: ./git_rename.sh old_email@email.com

# Get the current global git user name and email
GIT_USER=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)

# Create a mailmap file with the new author info
echo "$GIT_USER <$GIT_EMAIL> <$GIT_EMAIL>" > .mailmap

# Use git-filter-repo to rewrite the author info using the mailmap
git-filter-repo --mailmap .mailmap

# Remove the mailmap file
rm .mailmap
