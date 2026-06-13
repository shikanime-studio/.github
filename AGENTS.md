# .github

Organization profile and metadata for Shikanime Studio.

**Language:** Nix

**Structure:** `README.md` — org profile; `workflows/` — shared CI templates

**Commit style:** Plain-text capitalized title, no prefix. Body with labels: `Design:`, `Related:`, `Closes #`.

**Stack:** 1 commit == 1 PR via ghstack. Amend + `ghstack` to resubmit. `ghstack land` on head PR to land stack. Never `gh pr merge`. Never force-push.

**Protect `main`:** 1 review, linear history, signed commits, squash+rebase only.

*Informational repo; changes are mostly to the org profile README*
