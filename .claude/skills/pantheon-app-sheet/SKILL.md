---
name: pantheon-app-sheet
description: Use to create or update an app's Pantheon app sheet (`~/code/app-pantheon/fichas/<slug>.md`), the deployment record Kevin keeps for every personal app. Triggers on "/pantheon-app-sheet", "actualiza la ficha", "genera la ficha", or when a session changes a repo's stack, external services, env vars or deploy method and the repo's CLAUDE.md has the Pantheon block. Not for generic READMEs or docs.
---

# Pantheon app sheet

Pantheon (`~/code/app-pantheon`) is Kevin's registry of personal apps, and the only place app sheets live: `fichas/<slug>.md`, written in Spanish. App repos don't keep a copy. You run from inside the app repo, read its code, and write the sheet into Pantheon.

## Before editing

- If `~/code/app-pantheon` isn't there (other machine, cloud session), say so and stop: don't rebuild the template or the sheet from memory.
- `git -C ~/code/app-pantheon pull --ff-only`, so you edit the latest sheet from other machines. If it fails, report why and stop.

## Template

The single source is `~/code/app-pantheon/TEMPLATE.md`. Read it every time.

- No `fichas/<slug>.md` yet: create it from the template.
- Existing sheet: keep its values, but match the template's current headings and fields. Add fields the template gained, drop ones it lost.

## Pantheon block

If the app repo's `CLAUDE.md` lacks `PANTHEON:INICIO`, run `~/code/app-pantheon/scripts/instalar-kit.sh <app repo>` and mention the new uncommitted change.

## Where to look

Read whatever the stack has; any stack is possible.

- **Manifests and runtime:** `Gemfile`/`Gemfile.lock`/`.ruby-version`, `package.json` (incl. `engines`)/lockfile/`.nvmrc`, `requirements.txt`/`pyproject.toml`/`runtime.txt`/`.python-version`, `go.mod`, `.tool-versions`.
- **App config:** Rails `config/` (`database.yml`, `environments/production.rb`, `recurring.yml`, `storage.yml`, `cable.yml`), `wsgi.py`/`asgi.py`, `.env.example`.
- **Packaging and platform:** `Procfile`, `Dockerfile`, `docker-compose.yml`, `config/deploy.yml`, `fly.toml`, `render.yaml`, `koyeb.yaml`, `app.json`, `vercel.json`, `netlify.toml`, `wrangler.toml`, `CNAME` (any folder), `.github/workflows/`.
- **Git:** `git remote -v`, and `git log --oneline -30`; commit messages often name the platform or domain.
- **Git state:** `git status -sb`. If there are uncommitted changes or unpushed commits, say so in "Problemas conocidos": the sheet then describes code other machines don't have.

## Outside the repo

Deployment truth lives outside the code. Check it with read-only commands, and skip any that aren't installed or authenticated (say which):

- Each domain found (README, canonical/og tags, `CNAME`, config): `dig +short <domain>` and `curl -sI -m 10 https://<domain>`. Record whether it resolves and the HTTP status.
- GitHub Pages: `gh api repos/<owner>/<repo>/pages`.
- Platform CLIs when the repo points to one: `fly status`, `koyeb service list`, `render services`, etc.

Note what you checked and when, e.g. "no resolvía al AAAA-MM-DD".

## Rules

- `slug` is the app repo's folder name, lowercase with hyphens.
- Replace a "?" only with data you checked in the code, outside the repo, or from Kevin. If you can't determine a value, leave "?": never guess.
- Never write secret values, only variable names.
- Set `actualizado` to today's date whenever the sheet changes.

## Ask Kevin

After writing the sheet, ask Kevin in one round (AskUserQuestion, up to 4 questions) for the "?" only he can answer, most important first: whether and where it's deployed, URL, desired subdomain, expected traffic, origin chat, "creada con". Offer options from your evidence (e.g. "Koyeb, according to a commit"). Write his answers into the sheet. Don't ask about what code or commands could answer.

When done, list briefly which fields changed and which are still "?", and remind him the change is uncommitted in `~/code/app-pantheon`.
