#!/usr/bin/env bash
# PreToolUse hook: PR merges are human-only. Blocks merging or auto-merging a pull request
# through the Atlassian MCP (Bitbucket) or the shell (gh, Bitbucket/GitHub REST). Local `git merge` passes.

command -v jq >/dev/null 2>&1 || { echo "block-pr-merge hook: jq not installed, blocking to be safe" >&2; exit 2; }

input=$(cat)
tool=$(jq -r '.tool_name // empty' <<<"$input")

case "$tool" in
  mcp__*Atlassian*__execute*)
    op=$(jq -r '.tool_input.name // empty' <<<"$input")
    [[ "$op" =~ [Mm]erge ]] || exit 0
    reason="Atlassian operation '$op'"
    ;;
  Bash)
    cmd=$(jq -r '.tool_input.command // empty' <<<"$input")
    grep -qE 'gh +pr +merge|pullrequests/[0-9{}<>$a-zA-Z_]+/merge|pulls/[0-9{}<>$a-zA-Z_]+/merge|enablePullRequestAutoMerge|mergePullRequest' <<<"$cmd" || exit 0
    reason="shell command"
    ;;
  *) exit 0 ;;
esac

echo "Blocked: PR merges are human-only ($reason). Stop at pushed + PR open and tell the user it's ready to merge." >&2
exit 2
