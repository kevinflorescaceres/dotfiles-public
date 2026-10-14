#!/usr/bin/env bash
# Status line: ponytail mode tag + context window usage, colored by how full it is.

input=$(cat)

tag=$(bash "$(ls -d "$HOME"/.claude/plugins/cache/ponytail/ponytail/*/hooks/ponytail-statusline.sh 2>/dev/null | sort -V | tail -1)" 2>/dev/null <<<"$input")

pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input" | cut -d. -f1)
size=$(jq -r '.context_window.context_window_size // empty' <<<"$input")

ctx=""
if [ -n "$pct" ] && [ -n "$size" ]; then
  if [ "$pct" -ge 80 ]; then color=31; elif [ "$pct" -ge 50 ]; then color=33; else color=32; fi
  used_k=$(( pct * size / 100 / 1000 ))
  [ "$size" -ge 1000000 ] && cap="$(( size / 1000000 ))M" || cap="$(( size / 1000 ))k"
  ctx=$(printf '\033[%sm ctx %s%% (%sk/%s)\033[0m' "$color" "$pct" "$used_k" "$cap")
fi

printf '%s%s' "$tag" "$ctx"
