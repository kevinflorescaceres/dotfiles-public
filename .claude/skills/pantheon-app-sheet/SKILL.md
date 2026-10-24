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

## Rules

- `slug` is the app repo's folder name, lowercase with hyphens.
- Fill it by reading the app repo, for example `Gemfile`, `Gemfile.lock`, `.ruby-version`, `package.json`, `config/database.yml`, `config/application.rb`, `config/environments/production.rb`, `Procfile`, `Dockerfile`, `config/deploy.yml`, `.env.example`, `config/recurring.yml` or `config/schedule.rb`, `config/storage.yml`, `config/cable.yml`, and `git remote -v`.
- Replace a "?" only with data you can check in the code. If you can't determine a value, leave "?": never guess.
- Never write secret values, only variable names.
- Set `actualizado` to today's date whenever the sheet changes.
- When done, list briefly which fields changed and which are still "?" so Kevin can fill them in, and remind him the change is uncommitted in `~/code/app-pantheon`.
