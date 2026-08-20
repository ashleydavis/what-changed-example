# Instructions for coding agents

- The pre-commit hook tests whatever the change affects. If it refuses a commit, the code is broken. Fix the code.
- Never use `git commit --no-verify`, `-n`, or `git config --unset core.hooksPath`, and never edit or delete anything under `.githooks/`. Bypassing the hook is not a fix.
- Never run `what-changed baseline capture` by hand to make a target look up to date. The baseline is captured by a suite's own command after that suite passes, and nowhere else.
- Never commit with tests failing or skipped. A commit is a claim that the tests pass.
