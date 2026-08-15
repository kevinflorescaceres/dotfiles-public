# My public Dotfiles

A repository to centralize my hidden configuration files (dotfiles) through multiple machines.

The repo mirrors `$HOME`: a file tracked at `.config/starship.toml` gets symlinked to
`~/.config/starship.toml`. Nothing here contains secrets — anything machine-specific or
sensitive lives in the private dotfiles repo.

## Available dotfiles

| Path | What |
|---|---|
| `.zshrc` | z shell config |
| `.gitconfig` | git config and aliases |
| `.nanorc` | nano editor |
| `.selected_editor` | default `$EDITOR` |
| `.claude/settings.json` | Claude Code model, plugins, statusline |
| `.config/starship.toml` | shell prompt |
| `.config/git/ignore` | global gitignore |
| `.config/Code/User/settings.json` | VS Code settings |
| `.config/Code/User/keybindings.json` | VS Code keybindings |

## Setup on a new machine

```zsh
git clone git@github.com:kevinflorescaceres/dotfiles-public.git ~/.dotfiles
~/.dotfiles/bootstrap.sh --dry-run   # see what it would link
~/.dotfiles/bootstrap.sh
```

`bootstrap.sh` reads the file list from `git ls-files`, so tracking a new file is all
that's needed for it to be linked — no list to maintain. Existing real files are moved
to `<name>.backup`; existing symlinks are replaced. Safe to re-run.

## Not in this repo

- **RubyMine** — `~/.config/JetBrains/RubyMine<version>/` is version-stamped, so symlinks
  break on every upgrade. Use JetBrains Settings Sync instead.
- **Secrets** — `~/.aws`, `~/.gnupg`, `~/.ssh`, `~/.docker/config.json`, `~/.bundle/config`,
  and anything under `~/.config/niufoods/`.
