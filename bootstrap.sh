#!/bin/sh
# Symlink every tracked dotfile into $HOME, mirroring this repo's layout.
# Existing real files are moved aside to <name>.backup.<timestamp>; existing symlinks are replaced.
# Usage: ./bootstrap.sh [--dry-run]
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=""
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

# git and jq are required (jq: Claude statusline, rubocop hook); the rest only warn.
missing=""
for c in git jq; do
    command -v "$c" >/dev/null 2>&1 || missing="$missing $c"
done
if [ -n "$missing" ]; then
    {
        echo "error: missing required tools:$missing"
        echo "Nothing was linked. Install them, then re-run this script:"
        echo "  Debian/Ubuntu: sudo apt install$missing"
        echo "  macOS:         brew install$missing"
    } >&2
    exit 1
fi
warn() { command -v "$1" >/dev/null 2>&1 || echo "warning: no $1: $2" >&2; }
warn zsh "the shell config goes unused"
warn claude "no Claude Code"
warn rg "Claude agents fall back to slower search"
warn starship "plain prompt"
warn uvx "the Obsidian MCP server won't start"
[ -d "$HOME/.oh-my-zsh" ] || echo "warning: no ~/.oh-my-zsh: zsh starts without it" >&2

cd "$DOTFILES"

# The repo mirrors $HOME, so the tracked path IS the destination path.
# git ls-files keeps this list self-maintaining: track a file, it gets linked.
git ls-files | grep -v -x -e 'README.md' -e 'bootstrap.sh' -e 'install-deps.sh' | while IFS= read -r f; do
    target="$HOME/$f"

    # The private repo's version of a file wins (e.g. work Claude settings); don't undo it.
    case "$(readlink "$target" 2>/dev/null)" in
        "$HOME/.dotfiles_private/"*) echo "kept ~/$f (private override)"; continue ;;
    esac

    if [ -n "$DRY_RUN" ]; then
        echo "would link ~/$f"
        continue
    fi

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        diff -u "$DOTFILES/$f" "$target" || true
        backup="$target.backup.$(date +%Y%m%d%H%M%S)"
        mv "$target" "$backup"
        echo "backed up ~/$f -> $backup"
    fi

    mkdir -p "$(dirname "$target")"
    ln -s "$DOTFILES/$f" "$target"
    echo "linked ~/$f"
done
