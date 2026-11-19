#!/bin/sh
# Install everything bootstrap.sh needs or warns about. Debian/Ubuntu (apt) or Arch (pacman). Safe to re-run.
# Run it before bootstrap.sh. Open a new terminal afterwards to pick up zsh and the new PATH.
set -eu

if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y git jq curl zsh ripgrep
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu --needed --noconfirm git jq curl zsh ripgrep
else
    echo "error: no apt-get or pacman: install git jq curl zsh ripgrep by hand" >&2
    exit 1
fi

# --keep-zshrc: without it, oh-my-zsh replaces ~/.zshrc, which may already be our symlink.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # Download first: inside sh -c "$(curl ...)", a failed download passes silently.
    omz_installer="$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sh -c "$omz_installer" "" --unattended --keep-zshrc
fi
command -v starship >/dev/null 2>&1 || curl -sS https://starship.rs/install.sh | sh -s -- --yes
command -v uvx >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

case "${SHELL:-}" in
    */zsh) ;;
    *) chsh -s "$(command -v zsh)" ;;
esac
