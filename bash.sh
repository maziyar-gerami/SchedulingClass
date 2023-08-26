#!/bin/bash

# Function to create commits for a given file
create_commits() {
    local file="$1"
    local commit_date="$2"
    
    git add "$file"
    GIT_COMMITTER_DATE="$commit_date" git commit -m "Commit for $file" --date="$commit_date"
}

# Recursive function to iterate over files and subfolders
recurse_files() {
    local dir="$1"
    local commit_date
    
    for entry in "$dir"/*; do
        if [ -f "$entry" ]; then
            commit_date=$(stat -c %y "$entry" | awk '{print $1, $2}')
            create_commits "$entry" "$commit_date"
            echo "Committed: $entry"
        elif [ -d "$entry" ]; then
            recurse_files "$entry"
        fi
    done
}

# Start the recursive iteration from the current directory
recurse_files "."

echo "Commits with creation and modification dates have been created."

