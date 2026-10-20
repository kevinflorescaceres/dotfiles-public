# Personal preferences (all projects)

## About me

Ruby on Rails developer. Treat me as a peer: skip Ruby/Rails/PostgreSQL basics and discuss trade-offs directly. Frontend (TypeScript, React/Next.js) is a secondary area: give me more context there.

## Git commits

- One-line messages in Conventional Commits format: `type(scope): summary`. No body.
- No `Co-Authored-By` or other attribution trailers.
- Never commit unless I ask; don't commit mid-session (plans, docs, specs). Prefer small, focused PRs.
- Never push unless I ask, each time: an earlier "commit and push" is not standing permission. Same for anything else that leaves the machine (PR create/update, card comments).
- Never merge a PR, even when it's green, approved, or I said "ship it". Stop at pushed + PR open.
- A fix to code introduced by an unmerged commit on the current branch gets folded into that commit (`git commit --fixup <sha>`, `GIT_SEQUENCE_EDITOR=true git rebase --autosquash -i <base>`, `git push --force-with-lease`), taking a backup branch first. Once a human has reviewed the PR, add a new commit instead. If it only has bot comments, offer both. New behavior I asked for later is always a separate commit.

## Ruby / Rails

- Prefer early returns and guard clauses over nested conditionals. No `unless` with complex conditions.
- No new service objects for simple logic: use a model method or a plain method unless the complexity warrants it.
- Migration filename prefix comes from `date -u +%Y%m%d%H%M%S`, never a rounded or made-up value. Keep `db/schema.rb`'s `version:` in sync with it.

## Remembering things

When I ask to remember a rule or preference, or you'd save a correction as memory, pick the scope:

- Personal, every project → `~/.claude/CLAUDE.md`
- Every NIU Foods repo → `~/.claude/CLAUDE.niufoods.md`
- One repo only → that repo's `CLAUDE.md`
- A fact about current work (state, TODO, pointer that may go stale) → auto memory

If the scope is unclear, ask.

`~/.claude/CLAUDE*.md`, skills, agents, hooks, `settings.json` and each `~/Work/*/CLAUDE.md` are symlinks into `~/.dotfiles` / `~/.dotfiles_private`. Edit them with the Edit/Write tools or `sed -i --follow-symlinks`, never plain `sed -i`: it replaces the symlink with a real file and the repo copy goes stale.

## Work context

Loaded from the private dotfiles repo when present (skipped silently otherwise):

@~/.claude/CLAUDE.niufoods.md
