#!/bin/bash

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Change to the Git root directory
change_to_git_root

# Validate arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <branch_name> <new_version>"
    exit 1
fi

BRANCH_NAME=$1
NEW_VERSION=$2

# Setup worktree and move to it, or stay in current directory if already on the target branch
setup_and_move_to_worktree "$BRANCH_NAME"

# Check for uncommitted changes in the current branch or worktree
check_for_uncommitted_changes

# Ensure the local branch's HEAD is the same as the remote's HEAD
REMOTE_HEAD=$(git rev-parse "upstream/$BRANCH_NAME")
LOCAL_HEAD=$(git rev-parse HEAD)
if [ "$LOCAL_HEAD" != "$REMOTE_HEAD" ]; then
    echo "Error: Local HEAD ($LOCAL_HEAD) is not equal to remote 'origin/$BRANCH_NAME' HEAD ($REMOTE_HEAD)."
    exit 1
fi

# Set the new version
set_pom_version $NEW_VERSION

# Commit the change
git commit -am "Set project version to $NEW_VERSION"

# Push the changes to the origin remote
git push origin "$BRANCH_NAME"

# Echo the command to create a pull request from the current branch to the base branch of upstream
echo gh pr create --base "$BRANCH_NAME" --head "origin:$BRANCH_NAME" --title "Set version to $NEW_VERSION" --body "Updating version to $NEW_VERSION"
