#!/bin/bash
# Utility functions

# Function to check for changes in the index or working tree
check_for_uncommitted_changes() {
    if ! git diff-index --quiet HEAD --; then
        echo "Uncommitted changes detected."
        exit 1
    fi
}

# Function to find the pom.xml location and get the version
get_pom_version() {
    local pom_locations=("pom.xml" "source/pom.xml")
    for location in "${pom_locations[@]}"; do
        if [[ -f "$location" ]]; then
            cd "$(dirname "$location")" || exit
            mvn help:evaluate -Dexpression=project.version -q -DforceStdout -o
            return
        fi
    done
    echo "pom.xml not found."
    exit 1
}
