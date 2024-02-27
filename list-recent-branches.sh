#!/bin/bash
set -e

# Remote name to fetch from, default to 'upstream' if not specified
REMOTE_NAME=${1:-upstream}

# Number of branches to list, default to 10 if not specified
NUM_BRANCHES=${2:-10}

git fetch $REMOTE_NAME

# List and sort branches by commit date, exclude specified branches, limit to NUM_BRANCHES, remove '$REMOTE_NAME/' prefix
git for-each-ref --sort=-committerdate refs/remotes/$REMOTE_NAME --format="%(refname:short)" \
  | grep -v -E "^$REMOTE_NAME\$|^$REMOTE_NAME/main\$|^$REMOTE_NAME/master\$" \
  | sed "s|$REMOTE_NAME/||" \
  | head -n $NUM_BRANCHES \
  | sort
