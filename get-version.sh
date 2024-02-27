#!/bin/bash

# Source utility functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/utils.sh"

# Change to the Git root directory
change_to_git_root

# Save the current branch name
BRANCH_NAME=${1:-$(git symbolic-ref --short HEAD)}
current_branch=$(git symbolic-ref --short HEAD)

# Ensure there are no uncommitted changes
check_for_uncommitted_changes

# Setup worktree and move to it if not on the targeted branch
if [ "$BRANCH_NAME" != "$current_branch" ]; then
    setup_and_move_to_worktree "$BRANCH_NAME"
fi

# Attempt to retrieve the Maven project version
POM_VERSION=$(get_pom_version)
if [ -n "$POM_VERSION" ]; then
    echo "$POM_VERSION"
else
    echo "Failed to retrieve version."
    exit 1
fi
