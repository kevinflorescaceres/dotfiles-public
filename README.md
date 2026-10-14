# My public Dotfiles

A repository to centralize my hidden configuration files (dotfiles) through multiple machines.

The repo mirrors `$HOME`: a file tracked at `.config/starship.toml` gets symlinked to
`~/.config/starship.toml`. Nothing here contains secrets — anything machine-specific or
sensitive lives in the private dotfiles repo.

## Available dotfiles

| Path | What |
|---|---|
| `.zshrc` | z shell config |
| `.gitconfig` | git config (work identity only for repos with a `bitbucket.org/niusushi` remote) |
| `.nanorc` | nano editor |
| `.selected_editor` | default `$EDITOR` |
| `.claude/CLAUDE.md` | Global Claude Code instructions (personal rules). Imports `~/.claude/CLAUDE.niufoods.md` from the private repo when present |
| `.claude/agents/rails-locator.md` | Claude Code subagent: read-only "where does X live" locator for Rails repos. Project specifics come from CLAUDE.md |
| `.claude/agents/cross-repo-consumer.md` | Claude Code subagent: read-only "who consumes X" finder across sibling repos. Repo map comes from CLAUDE.md |
| `.claude/agents/error-triage.md` | Claude Code subagent: read-only Rails log triage, root cause + file:line. Extra log locations come from CLAUDE.md |
| `.claude/settings.example.json` | Claude Code model, plugins, statusline, `autoMode` template (not linked; the real file lives in the private repo) |
| `.config/starship.toml` | shell prompt |
| `.config/git/ignore` | global gitignore |
| `.config/obsidian/mcp.env.example` | template for the Obsidian MCP server credentials |
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

## Claude Code MCP servers

User-scoped MCP servers live in `~/.claude.json`, which can't be tracked, so register them once per machine.
Obsidian (needs the Local REST API plugin and `uv`):

```zsh
cp ~/.config/obsidian/mcp.env.example ~/.config/obsidian/mcp.env
chmod 600 ~/.config/obsidian/mcp.env   # then fill in OBSIDIAN_API_KEY from the plugin settings
claude mcp add --scope user obsidian -- sh -c 'set -a; . "$HOME/.config/obsidian/mcp.env"; exec uvx mcp-obsidian'
claude mcp get obsidian                # expect: Connected
```

The key stays in the env file, out of `~/.claude.json`.

## Not in this repo

- **RubyMine** — `~/.config/JetBrains/RubyMine<version>/` is version-stamped, so symlinks
  break on every upgrade. Use JetBrains Settings Sync instead.
- **Secrets** — `~/.aws`, `~/.gnupg`, `~/.ssh`, `~/.docker/config.json`, `~/.bundle/config`,
  and anything under `~/.config/niufoods/`.
- **Claude Code `settings.json`** — it holds work-only `autoMode` config and Claude Code
  writes into it (`/model`, `/permissions`, auto mode setup), so it lives in the private
  repo. Settings have no include mechanism, so a public/private split would leak on the
  next write. `.claude/settings.example.json` is a sanitized copy for reference; when you
  change the real file, update the example without the `autoMode` details.
- **Claude Code local state** — `~/.claude.json` (project history, MCP config) and
  `~/.claude/.credentials.json` (auth token) must never be tracked.
