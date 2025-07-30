# My public Dotfiles
A repository to centralize my hidden configuration files (dotfiles) through multiple machines

## Available dotfiles
Up to this point, the following dotfiles are available to clone from this repository:
- z shell config (.zshrc)

More will be added soon

## Steps to import dotfiles to a machine

1. Clone repo into new hidden directory

```zsh
# Execute in home directory
git clone git@github.com:kevinflorescaceres/dotfiles-public.git ~/.dotfiles
```

2. Backup any existing dotfiles before creating symlinks

```zsh
# Rename .zshrc if it exists
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc_backup
```

3. Create symlinks in home directory to the dotfiles in the repository

```zsh
# This step, along with the previous one, can be automated through a script
ln -s ~/.dotfiles/.zshrc ~/.zshrc
```