#!/bin/bash

# Directory path and the word are received as command line arguments
directory="$1"
word="$2"

# Check if both directory and word are passed as arguments
if [ -z "$directory" ] || [ -z "$word" ]; then 
  echo "Usage: \$0 <directory> <word>"
  exit 1
fi

# -r: Disable filename expansion.
# -d: If the -d option is supplied, directory arguments are read from the input rather than being operands.
# For each file in the directory
for file in $(find "$directory" -type f); do
   # Use grep to see if the word is in the file
   if cat "$file" | grep -wq "$word"; then
       echo "The word \"$word\" found in $file"
   fi
done