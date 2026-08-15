#!/bin/sh
# Symlink every tracked dotfile into $HOME, mirroring this repo's layout.
# Existing real files are moved aside to <name>.backup; existing symlinks are replaced.
# Usage: ./bootstrap.sh [--dry-run]
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=""
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

cd "$DOTFILES"

# The repo mirrors $HOME, so the tracked path IS the destination path.
# git ls-files keeps this list self-maintaining: track a file, it gets linked.
git ls-files | grep -v -x -e 'README.md' -e 'bootstrap.sh' | while IFS= read -r f; do
    target="$HOME/$f"

    if [ -n "$DRY_RUN" ]; then
        echo "would link ~/$f"
        continue
    fi

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        mv "$target" "$target.backup"
        echo "backed up ~/$f -> ~/$f.backup"
    fi

    mkdir -p "$(dirname "$target")"
    ln -s "$DOTFILES/$f" "$target"
    echo "linked ~/$f"
done
