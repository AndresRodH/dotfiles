---
name: knowledge-base
description: Read and write the user's private Obsidian knowledge base (ideas, plans, session debriefs, living docs). Use when the user mentions Obsidian, knowledge base, vault, ideas, private plans, capture, debrief, /capture, /kb, or brainstorms work ideas that should stay off shared repos. Prefer the vault over repo markdown for private thinking. Use ONLY for private KB ops — not for team-shared repo docs the user wants committed.
---

# Knowledge base (Obsidian)

Private vault path: `/Users/xish/Developer/obsidian-vault`  
Also available as OpenCode reference `@kb`.  
Vault rules: `@kb/AGENTS.md` (read it when starting KB work).

## When to use the vault (proactive)

Default to the vault — **not** the git worktree — for:

- Personal ideas and product/tech directions for work
- Private plans, strategy, and half-baked thoughts
- Session learnings the user may want later
- Anything that should not be visible to teammates

Do **not** put private content in repo files like `PLAN.md`, `history/`, `NOTES.md`, or root markdown unless the user explicitly wants a **shared** artifact.

Still use the repo for normal engineering work (code, tests, committed docs the team needs).

## Workflow

1. **Classify** — private vs shareable. Private → vault.
2. **Read conventions** — `AGENTS.md` in the vault if not already loaded.
3. **Search first** (living docs):
   - CLI: `obsidian vault=obsidian-vault search query="…" format=json`
   - Then `search:context` or `read path="…"` on hits
   - Fallback: Grep/Glob under the vault path
4. **Update if match** — `append` / `prepend` / `property:set`, or edit the file. Prefer dated `## YYYY-MM-DD` sections when appending.
5. **Create if no match** — PARA placement (`Projects/<Name>/`, `Areas/`, `Resources/`, else `Inbox/`). Include frontmatter from `AGENTS.md`.
6. **Confirm briefly** — path written and whether created vs updated.

## CLI vs filesystem

Prefer Obsidian CLI when `obsidian` works (app running, installer 1.12+ with CLI enabled).

```bash
obsidian vault=obsidian-vault search query="monorepo" format=json
obsidian vault=obsidian-vault read path="Projects/Curate/Notes on process.md"
obsidian vault=obsidian-vault append path="…" content="## 2026-07-29\n\n…"
obsidian vault=obsidian-vault create path="Inbox/Capture - title.md" content="…"
```

If CLI is unavailable, read/write `.md` files under the vault path directly. Same structure and frontmatter.

Never use destructive CLI ops (`delete`, `permanent`) unless the user explicitly asks.

## Known projects

- `Projects/Curate`
- `Projects/CFS`

Map work topics to those folders when obvious; otherwise `Inbox/`.
