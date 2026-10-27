#!/usr/bin/env bash
# Label reset: converge every non-fork repo to the SEP-0007 canonical table.
# Modes: check (report only) | apply (create missing, fix drifted colors/descriptions).
# Automation-owned labels are never touched. Unknown labels are never deleted.
set -uo pipefail
MODE="${1:-check}"

# Canonical standard set: name|color|description
CANON=(
  "bug|d73a4a|Something isn't working"
  "documentation|0075ca|Improvements or additions to documentation"
  "duplicate|cfd3d7|This issue or pull request already exists"
  "enhancement|a2eeef|New feature or request"
  "good first issue|7057ff|Good for newcomers"
  "help wanted|008672|Extra attention is needed"
  "invalid|e4e669|This doesn't seem right"
  "question|d876e3|Further information is requested"
  "wontfix|ffffff|This will not be worked on"
)
# Scoped families: prefix|values... (repo-scoped; applied where the family's repo declares it)
# area: lives on shikanime-studio/hakurei
AREA=(
  "area:core|5319e7|Progression / combat core loop spine"
  "area:combat|5319e7|Boss AI / tactical depth"
  "area:content|5319e7|World / social / economy / MP features"
  "area:retention|5319e7|MMO retention & new-player respect"
  "area:security|5319e7|Auth / transport / ownership hardening"
  "area:release|5319e7|Build / packaging / CI / shipping"
)
EXCLUDE_RE='^(dependencies|Review effort [1-5]$|Review effort [1-5]/5$|Possible security concern)$'

orgs=(shikanime shikanime-labs shikanime-studio)
converged=0; deviations=0

for org in "${orgs[@]}"; do
  repos=$(gh repo list "$org" --limit 300 --json name,isArchived,isFork \
    --jq '.[] | select(.isArchived | not) | select(.isFork | not) | .name')
  for name in $repos; do
    r="$org/$name"
    current=$(gh api "repos/$r/labels?per_page=100" --paginate --jq '.[] | [.name,.color,.description] | @tsv' 2>/dev/null) || continue
    declare -A have
    while IFS=$'\t' read -r n c d; do have["$n"]="$c|$d"; done <<< "$current"
    drift=""
    for row in "${CANON[@]}"; do
      IFS='|' read -r n c d <<< "$row"
      want="$c|$d"
      if [[ -z "${have[$n]:-}" ]]; then
        drift+="missing:$n; "
        if [ "$MODE" = "apply" ]; then
          printf '{"name":"%s","color":"%s","description":"%s"}' "$n" "$c" "$d" \
            | gh api --input - "repos/$r/labels" --jq .name >/dev/null 2>&1 \
            || drift+="create-failed:$n; "
        fi
      elif [[ "${have[$n]}" != "$want" ]]; then
        drift+="drift:$n; "
        if [ "$MODE" = "apply" ]; then
          gh api -X PATCH "repos/$r/labels/$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "$n")" \
            -f new_name="$n" -f color="$c" -f description="$d" >/dev/null 2>&1 || drift+="fix-failed:$n; "
        fi
      fi
    done
    # hakurei carries the area: family
    if [ "$r" = "shikanime-studio/hakurei" ]; then
      for row in "${AREA[@]}"; do
        IFS='|' read -r n c d <<< "$row"
        want="$c|$d"
        if [[ -z "${have[$n]:-}" ]]; then
          drift+="missing:$n; "
          if [ "$MODE" = "apply" ]; then
            printf '{"name":"%s","color":"%s","description":"%s"}' "$n" "$c" "$d" \
              | gh api --input - "repos/$r/labels" --jq .name >/dev/null 2>&1 \
              || drift+="create-failed:$n; "
          fi
        elif [[ "${have[$n]}" != "$want" ]]; then
          drift+="drift:$n; "
          if [ "$MODE" = "apply" ]; then
            gh api -X PATCH "repos/$r/labels/$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "$n")" \
              -f new_name="$n" -f color="$c" -f description="$d" >/dev/null 2>&1 || drift+="fix-failed:$n; "
          fi
        fi
      done
    fi
    if [ -z "$drift" ]; then
      converged=$((converged+1))
    else
      deviations=$((deviations+1))
      echo "DEVIATION $r: $drift"
    fi
  done
done
echo "== mode=$MODE converged=$converged deviations=$deviations =="
