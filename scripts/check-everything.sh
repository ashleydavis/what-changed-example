#!/usr/bin/env bash
#
# Runs only the targets that have changes since they last passed.
#
# `what-changed targets` prints one target name per line, and nothing at all when there is nothing to
# do. This script turns each name into the command that does that work.
#
# Nothing here captures a baseline. Each target's own command does that as its last step, so it
# happens the same way whether the command was run by this script, by the hook, or by hand.
#
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

TARGETS=()
while IFS= read -r LINE; do
    if [ -n "$LINE" ]; then
        TARGETS+=("$LINE")
    fi
done <<< "$(what-changed targets)"

if [ ${#TARGETS[@]} -eq 0 ]; then
    echo "Nothing has changed since the last passing run. Nothing to do."
    exit 0
fi

for TARGET_NAME in "${TARGETS[@]}"; do
    echo "==> $TARGET_NAME"
    case "$TARGET_NAME" in
        compile) npm run --silent compile ;;
        test)    npm test --silent ;;
        e2e)     npm run --silent e2e ;;
        *)
            echo "This script does not know how to run \"$TARGET_NAME\"." >&2
            exit 1
            ;;
    esac
done
