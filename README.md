# what-changed-example

An example of using [what-changed](https://github.com/ashleydavis/what-changed) to make a Git pre-commit hook only compile/build/test what has changed prior to each commit.

**This repository ships with a failing test on purpose.** That is the demo: try to commit, get refused, fix one word, then watch how little each following commit has to do.

Three targets, and the third one is slow on purpose:

| Target | Runs | Watches |
| --- | --- | --- |
| `compile` | `node --check src/greet.js` | `src` |
| `test` | `node --test test/` | `src`, `test` |
| `e2e` | a script that sleeps for five seconds | `src`, `e2e` |

Five seconds stands in for the real thing: a browser to start, a server to wait for, fixtures to load. It is the cost you do not want to pay to commit a typo fix in the README.

## What's in it

| File | What it is |
| --- | --- |
| [`what-changed.yaml`](what-changed.yaml) | The targets, and which files each one watches |
| [`scripts/check-everything.sh`](scripts/check-everything.sh) | Asks what changed and runs only that |
| [`.githooks/pre-commit`](.githooks/pre-commit) | Runs the above before every commit |
| [`scripts/install-hooks.sh`](scripts/install-hooks.sh) | Points git at that hook, once per clone |
| [`package.json`](package.json) | Each target's command, each capturing its own baseline on success |
| [`mise.toml`](mise.toml) | Fetches Node and the what-changed binary |
| [`src/`](src/), [`test/`](test/), [`e2e/`](e2e/) | One function, one fast test, one slow test |

## Setup

Get the tools and install the hook:

```bash
mise trust && mise install    # Node, and the what-changed binary
./scripts/install-hooks.sh
```

`mise trust` is needed because mise will not read a config file it has not been told to trust. Without mise, download the [what-changed binary](https://github.com/ashleydavis/what-changed/releases) and put it on your PATH.

## Try it

The test is failing to start with, so the first commit is refused:

```bash
git add -A
git commit -m "Fix the greeting"   # compile passes, the tests fail, refused
```

Fix the one word and commit again. Everything runs, everything passes, and each target records that it passed:

```bash
sed -i 's/Hi, /Hello, /' src/greet.js
git add -A
git commit -m "Fix the greeting"
```

Now watch what each following commit decides to do:

```bash
echo "Notes." > NOTES.md
git add -A
git commit -m "Add notes"             # nothing runs: .md is ignored

printf '\n// A comment.\n' >> test/greet.test.js
git add -A
git commit -m "Comment the test"      # only the tests run: e2e does not watch test/

sed -i 's/Hello/Hi/' src/greet.js
git add -A
git commit -m "Break it"              # src changed, so everything runs, and the commit is refused
```

Ask it what it thinks at any point, without running or recording anything:

```bash
what-changed summary
```

## The two pieces that matter

**The config says what each target watches.** Anything outside those paths can change and that target still counts as up to date. `always` is for the files that affect everything, which is usually the lockfile.

**Each target captures its own baseline, as the last step of its own command.** In `package.json`:

```json
"test": "node --test --test-reporter=spec test/ && what-changed baseline capture test"
```

The `&&` is what stops a failing suite from recording a pass. Capturing the baseline is a claim that this suite passed against these exact files, so it has to happen after the suite passed and nowhere else.

Putting it in the target's own command rather than in the runner means it happens however the command was started: by hand, by the hook, or by CI. A run of just `npm test` records the tests and leaves `e2e` correctly reported as still needing to run.

## Notes

what-changed compares file hashes against the last recorded pass, not against a commit, so it does not agree with `git status` and is not trying to. Pulling or switching branches changes files, and the targets watching those files are reported even though git considers the tree clean.

Matching is by path, not by imports, so it errs towards running too much. See [the project README](https://github.com/ashleydavis/what-changed) for what it can and cannot see.

The simpler companion project, `git-pre-commit-hook-example`, is the same hook with no target selection at all. Read that one first.
