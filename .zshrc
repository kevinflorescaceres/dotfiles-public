# Optional PATH additions
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="dd/mm/yyyy"

plugins=()

# Prefer p10k, fall back to starship
if [[ -f ~/.p10k.zsh ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
else
  ZSH_THEME=""
fi

source "$ZSH/oh-my-zsh.sh"

if [[ -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
elif command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Personal aliases
alias gs='git status'
alias gss='git status --short'
alias ga='git add'
alias gb='git branch'
alias gbd='git branch -D'
alias gc='git commit'
alias gca='gc --amend'
alias gcane='gca --no-edit'
alias gcm='git commit -m'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gu='git pull'
alias gl='git log'
alias glo='git log --oneline'
alias glp='git log --all --graph --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gi='git init'
alias gcl='git clone'
alias gd='git diff'
alias gds='git diff --staged'
alias gst='git stash --include-untracked'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsta='git stash apply'
alias gcp='git cherry-pick'
alias gm='git merge'
alias gn='git checkout -b'
alias gr='git reset'

alias gco='git checkout'
alias gcod='git checkout development'
alias gcor='git checkout release'
alias gcot='git checkout test'
alias grb='git rebase'
alias grbd='git rebase development'
alias grbr='git rebase release'
alias grbt='git rebase test'

alias rc='rails c'
alias rdbm='rails db:migrate'
alias rdbr='rails db:rollback'
alias rs='rails s'

alias ..='cd ..'
alias ...='cd ../..'
alias home='cd ~'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias update='sudo apt update && sudo apt upgrade'

# Source extra configs and aliases from private repository
[ -f "$HOME/.zshrc_private" ] && source "$HOME/.zshrc_private"
