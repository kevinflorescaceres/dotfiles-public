#!/bin/sh
# Install everything bootstrap.sh needs or warns about. Debian/Ubuntu only. Safe to re-run.
# Run it before bootstrap.sh. Open a new terminal afterwards to pick up zsh and the new PATH.
set -eu

sudo apt update
sudo apt install -y git jq curl zsh ripgrep

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
