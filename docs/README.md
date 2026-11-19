<!-- owner: Automata | zone: technical | purpose: Canonical technical index for the Shikanime Studio .github org profile repository -->
# .github

Public organization profile, assets and metadata for
[Shikanime Studio](https://github.com/shikanime-studio). This is the org-level
home for the profile README, community health docs, the organization-wide
label taxonomy and its reset automation, and shared issue and PR templates.

## Canonical sources

- [Repository README](https://github.com/shikanime-studio/.github#readme)
- [Technical wiki](https://github.com/shikanime-studio/.github/wiki)

## Layout

- `profile/README.md` — the org profile shown on the GitHub organization
  page. It embeds `assets/github-header.webp` and describes the company as
  founded in 2011, focused on mindful, data-driven technology.
- Root community docs: `README.md`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`,
  `SECURITY.md`, `SUPPORT.md` and `LICENSE`.
- `assets/` — the org header image `github-header.webp`.
- `scripts/reset-labels.sh` — converges repository labels to the canonical
  table: `check` reports drift, `apply` writes it.
- `.github/ISSUE_TEMPLATE/` — issue forms `BUG-REPORT.yml`,
  `EXPERIMENT.yml`, `IMPROVEMENT.yml`, `TASK.yml` and `config.yml`; plus
  `.github/PULL_REQUEST_TEMPLATE.md`, `.github/CODEOWNERS` and
  `.github/renovate.json`.
- `.github/workflows/` — `label-reset.yaml`, `nix.yaml`, `release.yaml`.

## Label reset automation

`label-reset.yaml` runs on a weekly cron (`17 4 * * 1`) and on
`workflow_dispatch` with a `mode` choice of `check` (report deviations only)
or `apply` (converge to the canonical table). It mints a short-lived GitHub
App token with `actions/create-github-app-token` (issues:write,
administration:read), falls back to `GITHUB_TOKEN`, then runs
`bash scripts/reset-labels.sh "$MODE"`. The mode is passed through an env var
to keep it out of the `run:` script per injection guidance.

## Dependency maintenance

Renovate extends `config:best-practices` and `security:openssf-scorecard`,
enables the `nix` manager, and runs `nix fmt` once per update branch scoped
to `**/*.nix`.

## Documentation rule

In-repo `docs/` is canonical for technical detail. The wiki is a rendered
human index that links here.
