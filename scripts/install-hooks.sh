#!/usr/bin/env bash
#
# Points git at this project's checked-in hooks. Run once per clone.
#
# Git never runs a hook from a checked-in directory on its own. It only runs what is in the clone's
# own .git/hooks, which is not version controlled, so a hook committed to the repository does nothing
# until someone sets core.hooksPath. That setting is per clone, so everyone who clones has to run
# this, and nothing runs it for them.
#
# The path is set relative rather than absolute so it resolves against whichever working tree git is
# running in, which is what makes the hooks work in a git worktree as well as in the main clone.
#
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [ ! -d .githooks ]; then
    echo "ERROR: no .githooks directory here. Run this from a checkout of the project." >&2
    exit 1
fi

chmod +x .githooks/* scripts/*.sh

git config core.hooksPath .githooks

echo "Hooks installed: core.hooksPath = $(git config --get core.hooksPath)"
echo "  pre-commit: run the targets affected by the change, and refuse the commit if any of them fail"
