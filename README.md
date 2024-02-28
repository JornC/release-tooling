# Release Tooling Repository

This repository includes a set of scripts designed to facilitate the release process for Maven-based projects. These scripts automate tasks such as identifying recent release branches, determining Maven project versions, and updating project versions with the ability to create pull requests for version updates.

## Scripts Overview

- `get-version.sh`: Creates a worktree for a specified branch and determines the Maven version of the project within that branch. It outputs the version number found.

- `list-recent-branches.sh`: Outputs a list of recent branches that are likely to be release branches. This script takes a "remote" (name) and "num branches" as arguments to determine how many recent branches to list and from which remote.

- `list-versions.sh`: Integrates `list-recent-branches.sh` and `get-version.sh` to list recent branches alongside their Maven project versions. This script provides a comprehensive view of the versions across different release branches.

- `set-version.sh`: Accepts a branch name and a version number as arguments. It updates the project's version using the `mvn versions:set` command and creates a GitHub pull request to apply the version change upstream.

- `utils.sh`: Contains utility functions used by the other scripts to perform common tasks such as logging and error handling.

## Usage

Each script is designed to be executed from the command line. For specific usage instructions, please refer to the comments at the beginning of each script file. 

For convenience, these scripts should be available on the PATH.

### Example

To list recent branches and their versions:
```bash
list-versions.sh origin 5
```

To set a new version for a branch and create a pull request:
```bash
set-version.sh branch-name new-version-number
```

## Requirements

- Git
- Maven
- GitHub CLI (for creating pull requests with `set-version.sh`)

Ensure that all dependencies are installed and properly configured before using these scripts.

## Contributing

Contributions to improve these scripts or add new features are welcome. Please submit issues or pull requests following the standard GitHub workflow.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
