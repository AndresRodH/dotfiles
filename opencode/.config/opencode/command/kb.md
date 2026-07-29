---
description: Search or read the private Obsidian knowledge base.
agent: build
---
Load the `knowledge-base` skill and work against my private Obsidian vault only.

Task: $ARGUMENTS

- Prefer `obsidian vault=obsidian-vault search` / `search:context` / `read`.
- Filesystem fallback under ~/Developer/obsidian-vault if CLI fails.
- Summarize relevant notes with paths and wikilink-style titles.
- Do not create notes unless I explicitly ask to save or capture.
