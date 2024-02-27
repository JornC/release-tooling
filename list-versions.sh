#!/bin/bash

# Determine the directory in which list-versions.sh is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Save the current branch name to return to it later
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Use list-recent-branches.sh to list branches, pass any arguments it receives
branches=$("${SCRIPT_DIR}/list-recent-branches.sh" "$@")

# Check if branches were found
if [ -z "$branches" ]; then
    echo "No branches found."
    exit 1
fi

# For each branch, get the version and print "branch name - version"
echo "$branches" | while read branch; do
    # Remove the 'upstream/' prefix for better readability, if present
    clean_branch_name=$(echo "$branch" | sed 's|upstream/||')

    # Get the version for the branch using get-version.sh, located in the same directory as list-versions.sh
    version=$("${SCRIPT_DIR}/get-version.sh" "$branch")

    # Check if version was successfully retrieved
    if [ -n "$version" ]; then
        echo "$clean_branch_name;$version"
    else
        echo "$clean_branch_name (Version not found)"
    fi
done

# Return to the original branch
git checkout "$current_branch" &> /dev/null
