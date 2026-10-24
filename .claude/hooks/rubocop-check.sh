#!/usr/bin/env bash
# PostToolUse hook (Edit|Write): report-only rubocop on the edited Ruby file.
# Silent unless rubocop finds offenses (exit 1); then feeds them back to Claude via exit 2.
# Skips non-Ruby files, repos without rubocop in Gemfile.lock, repos whose own
# .claude/hooks already run rubocop, and rubocop/bundler errors.

command -v jq >/dev/null 2>&1 || { echo "rubocop hook: jq not installed, skipping" >&2; exit 1; }

f=$(jq -r '.tool_input.file_path // empty')
case "$f" in *.rb|*.rake|*.ru|*/Gemfile) ;; *) exit 0 ;; esac
[ -f "$f" ] || exit 0

root=$(git -C "$(dirname "$f")" rev-parse --show-toplevel 2>/dev/null) || exit 0
grep -q '^    rubocop (' "$root/Gemfile.lock" 2>/dev/null || exit 0
grep -qs rubocop "$root"/.claude/hooks/* && exit 0

cd "$root" || exit 0
out=$(DISABLE_SPRING=1 timeout 60 bundle exec rubocop --force-exclusion --format emacs "$f" 2>/dev/null)
[ $? -eq 1 ] && [ -n "$out" ] || exit 0

{
  echo "rubocop offenses in ${f#"$root"/} (report-only; fix the ones your change introduced):"
  echo "$out"
} >&2
exit 2
