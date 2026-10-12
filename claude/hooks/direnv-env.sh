#!/bin/bash
dir=$(jq -r '.new_cwd // .cwd // empty')
[ -n "$CLAUDE_ENV_FILE" ] && [ -n "$dir" ] && cd "$dir" || exit 0
/opt/homebrew/bin/direnv export bash 2>/dev/null > "$CLAUDE_ENV_FILE"
exit 0
