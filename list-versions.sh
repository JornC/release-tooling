#!/bin/bash

# Determine the directory in which list-versions.sh is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

sh list-recent-branches.sh | xargs -I {} sh -c 'echo -n "{};"; sh get-version.sh "{}"'
