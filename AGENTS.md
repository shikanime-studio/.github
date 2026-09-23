# GitHub

Organization profile and metadata for Shikanime Studio.
Contains the public README, shared GitHub configuration, and organizational assets.

**Language:** Nix

## Structure

- `README.md` — Organization profile README displayed on the GitHub org page
- `workflows/` — Shared or template workflow configurations

## Commit Style

- Plain-text capitalized title, no conventional-commit prefix
- Body with labels: `Design:`, `Related:`, `Closes #`
- Keep Markdown lines wrapped at 80 columns and run `nix fmt` before shipping

## Stack Workflow

- Install the official GitHub extension once: `gh extension install github/gh-stack`
  (requires GitHub CLI ≥ 2.0; `gh stack` is in public preview and may change).
- Keep one logical change per PR; split large work into a stack of PRs.
- Create a stack: `gh stack init`, then `gh stack add` for each new branch, and
  commit on the active branch. `gh stack view` lists the stack.
- Submit/update: `gh stack submit` (add `--open` to open PRs, `--auto` to skip
  prompts). Resubmit after each change to refresh titles, bodies, and branches.
- Pull down an existing stack: `gh stack checkout <PR_NUMBER>` (also accepts a
  stack number, PR URL, or branch name).
- Rebase onto updated trunk: `gh stack rebase` (cascading), then `gh stack submit`.
- Land a stack: `gh stack merge` (interactive) or
  `gh stack merge <PR_NUMBER> --yes --squash` to merge up to a PR.
- Never `gh pr merge` on a stacked PR — only `gh stack merge` lands stacks.
- Never force-push stack branches; `gh stack` owns the branch pointers.



## Editing Pull Requests

- The commit title and description **are** the pull request title and body.
- To edit the PR body after creation, use `gh pr edit <PR_NUMBER>`:
  - `gh pr edit <PR_NUMBER> --title "New title"` — update the title
  - `gh pr edit <PR_NUMBER> --body "New body"` — update the body
  - `gh pr edit <PR_NUMBER> --body-file /path/to/file.md` — set body from file
- Amending the commit (`jj squash` / `git commit --amend`) and resubmitting
  with `ghstack` will also update the PR automatically.
## Protect `main`

- Require 1 approving review
- Require linear history (no merge commits)
- Require signed commits
- Squash+rebase merge only

*Informational repo; changes are mostly to the org profile README*
## Environment

This repository ships a `.envrc` for direnv. Run `direnv allow` once after
cloning; direnv then loads the Nix flake dev shell automatically on every
directory change (`.envrc` runs
`use flake . --accept-flake-config --no-pure-eval`). Without direnv, enter
the same shell manually with `nix develop`.
