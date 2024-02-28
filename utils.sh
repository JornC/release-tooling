#!/bin/bash
# Utility functions

# Function to setup and move to a Git worktree
setup_and_move_to_worktree() {
    local BRANCH_NAME=$1
    local WORKTREE_PATH="worktrees/$BRANCH_NAME"

    # Check if worktree already exists
    if [ ! -d "$WORKTREE_PATH" ]; then
        mkdir -p worktrees
        git worktree add "$WORKTREE_PATH" "$BRANCH_NAME" &>/dev/null || {
            echo "Failed to setup worktree for '$BRANCH_NAME'."
            exit 1
        }
    fi

    # Move to the worktree directory
    cd "$WORKTREE_PATH" || {
        echo "Failed to move to worktree for '$BRANCH_NAME'."
        exit 1
    }
}

# Function to change to the Git root directory and save the original directory
change_to_git_root() {
    ORIGINAL_DIR=$(pwd)
    GIT_ROOT=$(git rev-parse --show-toplevel)
    if [ -z "$GIT_ROOT" ]; then
        echo "Not in a Git repository."
        exit 1
    else
        cd "$GIT_ROOT" || exit
    fi
}

# Function to return to the original directory
return_to_original_dir() {
    cd "$ORIGINAL_DIR" || exit
}

# Function to check for changes in the index or working tree
check_for_uncommitted_changes() {
    if ! git diff-index --quiet HEAD --; then
        echo "Uncommitted changes detected."
        exit 1
    fi
}

# Function to find the pom.xml location
find_pom_location() {
    local pom_locations=("pom.xml" "source/pom.xml")
    for location in "${pom_locations[@]}"; do
        if [[ -f "$location" ]]; then
            echo "$location"
            return
        fi
    done
    echo "pom.xml not found."
    exit 1
}

# Function to get the version from the pom.xml
get_pom_version() {
    local pom_location
    pom_location=$(find_pom_location) # Call find_pom_location to get the pom.xml path
    if [[ $pom_location == "pom.xml not found." ]]; then
        echo "$pom_location"
        exit 1
    else
        cd "$(dirname "$pom_location")" || exit
        mvn help:evaluate -Dexpression=project.version -q -DforceStdout -o
    fi
}

# Function to set the new version in the pom.xml using Maven Versions plugin
set_pom_version() {
    local NEW_VERSION="$1" # Expecting the new version as the first argument to the function
    local pom_location
    pom_location=$(find_pom_location) # Call find_pom_location to get the pom.xml path
    if [[ $pom_location == "pom.xml not found." ]]; then
        echo "$pom_location"
        exit 1
    else
        cd "$(dirname "$pom_location")" || exit # Navigate to the directory containing pom.xml
        mvn versions:set -DnewVersion="$NEW_VERSION" -DgenerateBackupPoms=false
    fi
}
