#!/usr/bin/env bash
# fetch-prs.sh: Fetch open PRs updated since last check
# Usage: fetch-prs.sh [--all] [--since ISO_DATE]
# Output: JSON array of PR objects, also updates timestamps

set -euo pipefail

TIMESTAMP_FILE="$HOME/.claude/tmp/pr-review/timestamps.json"
SINCE_OVERRIDE=""
ALL_PRS=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)    ALL_PRS=true; shift ;;
    --since)  SINCE_OVERRIDE="$2"; shift 2 ;;
    *)        echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

mkdir -p "$(dirname "$TIMESTAMP_FILE")"

if [[ -f "$TIMESTAMP_FILE" ]]; then
  TIMESTAMPS=$(cat "$TIMESTAMP_FILE")
else
  TIMESTAMPS="{}"
fi

# Detect repos: single repo if we're inside a git worktree, else scan subdirs
REPOS=()
CWD=$(pwd)

if git rev-parse --is-inside-work-tree 2>/dev/null; then
  REPOS+=("$(git rev-parse --show-toplevel)")
else
  for dir in "$CWD"/*/; do
    [[ -d "$dir" ]] || continue
    if git -C "$dir" rev-parse --is-inside-work-tree 2>/dev/null 2>&1; then
      REPOS+=("${dir%/}")
    fi
  done
fi

if [[ ${#REPOS[@]} -eq 0 ]]; then
  echo "[]"
  exit 0
fi

NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
ALL_OUTPUT="[]"
CHECKED_REPOS=()

for REPO_PATH in "${REPOS[@]}"; do
  REPO_SLUG=$(git -C "$REPO_PATH" remote get-url origin 2>/dev/null | sed -E 's#.*github\.com[:/]##; s/\.git$//' ) || continue
  [[ -z "$REPO_SLUG" ]] && continue

  if [[ "$ALL_PRS" == "true" ]]; then
    SINCE="1970-01-01T00:00:00Z"
  elif [[ -n "$SINCE_OVERRIDE" ]]; then
    SINCE="$SINCE_OVERRIDE"
  else
    SINCE=$(echo "$TIMESTAMPS" | jq -r --arg r "$REPO_SLUG" '.[$r] // "1970-01-01T00:00:00Z"')
  fi

  PRS=$(gh pr list -R "$REPO_SLUG" \
    --state open \
    --json number,title,author,updatedAt,createdAt,url,labels,isDraft,headRefName,baseRefName,body,additions,deletions,changedFiles \
    --limit 100 2>/dev/null) || continue

  FILTERED=$(echo "$PRS" | jq \
    --arg since "$SINCE" \
    --arg repo "$REPO_SLUG" \
    --arg path "$REPO_PATH" \
    '[.[] | select(.updatedAt > $since and .isDraft == false) | . + {repo: $repo, repoPath: $path}]')

  ALL_OUTPUT=$(jq -n --argjson a "$ALL_OUTPUT" --argjson b "$FILTERED" '$a + $b')
  CHECKED_REPOS+=("$REPO_SLUG")
done

# Update timestamps for repos we successfully checked
for REPO_SLUG in "${CHECKED_REPOS[@]}"; do
  TIMESTAMPS=$(echo "$TIMESTAMPS" | jq --arg r "$REPO_SLUG" --arg ts "$NOW" '. + {($r): $ts}')
done

echo "$TIMESTAMPS" > "$TIMESTAMP_FILE"

echo "$ALL_OUTPUT"
