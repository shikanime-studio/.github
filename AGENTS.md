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



## Protect `main`

- Require 1 approving review
- Require linear history (no merge commits)
- Require signed commits
- Squash+rebase merge only

Informational repo; changes are mostly to the org profile README

## Environment

This repository ships a `.envrc` for direnv. Run `direnv allow` once after
cloning; direnv then loads the Nix flake dev shell automatically on every
directory change (`.envrc` runs
`use flake . --accept-flake-config --no-pure-eval`). Without direnv, enter
the same shell manually with `nix develop`.
