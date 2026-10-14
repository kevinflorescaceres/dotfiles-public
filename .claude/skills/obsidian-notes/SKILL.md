---
name: obsidian-notes
description: Use when writing a note, lesson or explanation into Kevin's Obsidian vault (via the obsidian MCP server), or when he asks to learn or document something "as a note" or "in my style".
---

# Obsidian notes in Kevin's style

Kevin learns by writing Obsidian notes. When teaching or documenting for him, write `.md` notes into the vault in exactly this style, not just chat.

## Style

- Foldable callouts are the backbone: `> [!note]+ ## Título`, nested (`> > [!note]+ ###`), with headers living *inside* the callout title line. `[!tip]` / `[!warning]` / `[!danger]` for emphasis.
- Code-first, example-first: real runnable snippets with real IDs/payloads, fenced ```ruby / ```bash. Minimal prose between code.
- Terse fragments and imperatives, not paragraphs.
- Language: Spanish (es-CL) prose + English technical terms.
- Hub-and-spoke wikilinks: MOC/index notes just list `[[...]]` (e.g. `Recursos.md`, `Manuales.md`). Link every new note into the matching index.
- Notes imported from Notion carry `notion-id` frontmatter; new notes don't need it.

## Steps

1. Confirm the destination folder and the language (Spanish by default) before writing.
2. Write the note through the obsidian MCP tools.
3. Add a `[[link]]` to it in the relevant MOC index note.
