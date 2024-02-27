#!/bin/bash

# Determine the directory in which list-versions.sh is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the utility functions
source $SCRIPT_DIR/utils.sh

# Main logic of the script
main() {
    local BRANCH_NAME=${1:-$(git symbolic-ref --short HEAD)}
    local current_branch=$(git symbolic-ref --short HEAD)

    check_for_uncommitted_changes

    # Only setup worktree if not on the targeted branch
    if [ "$BRANCH_NAME" != "$current_branch" ]; then
        local WORKTREE_PATH="worktrees/$BRANCH_NAME"
        # Setup or reuse worktree without logging unless necessary
        if [ ! -d "$WORKTREE_PATH" ]; then
            mkdir -p worktrees
            git worktree add "$WORKTREE_PATH" "$BRANCH_NAME" &>/dev/null || {
                echo "Failed to setup worktree for '$BRANCH_NAME'."
                exit 1
            }
        fi
        cd "$WORKTREE_PATH" || exit
    fi

    # Attempt to get the Maven project version
    local POM_VERSION=$(get_pom_version)
    if [ -n "$POM_VERSION" ]; then
        echo "$POM_VERSION"
    else
        echo "Failed to retrieve version."
        exit 1
    fi
}

# Execute the main function with all passed arguments
main "$@"
