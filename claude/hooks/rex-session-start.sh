#!/bin/sh
# Rex's SessionStart context for agents, minus its instruction to rename the
# session after the task: session labels are left to Zach. Usage:
# rex-session-start.sh AGENT (claude, codex, ...)
[ -n "$REX_SESSION" ] || exit 0
rex __internal session-start --agent "${1:-claude}" 2>/dev/null |
    awk '/^Name the session/ { skip = 1 } skip && /^$/ { skip = 0; next } !skip'
echo "Don't rename the Rex session or its tabs, even where the rex skill's guide says to."
exit 0
