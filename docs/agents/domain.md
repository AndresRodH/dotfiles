# Domain Docs

How engineering skills should consume this repo's domain documentation.

## Before exploring, read these

- `CONTEXT.md` at the repository root.
- `CONTEXT-MAP.md`, if present, and each context relevant to the task.
- Relevant ADRs under `docs/adr/` and context-specific ADR directories.

If these files do not exist, proceed silently. Domain-modeling skills create them lazily when terminology or decisions are resolved.

## File structure

This repository uses the single-context layout:

```
/
├── CONTEXT.md
├── docs/adr/
└── application and configuration directories
```

## Use the glossary's vocabulary

Use terms as defined in `CONTEXT.md`. Avoid synonyms the glossary explicitly rejects. If a needed concept is absent, reconsider whether it belongs or flag the gap for domain modeling.

## Flag ADR conflicts

Surface any conflict with an existing ADR explicitly rather than silently overriding it.
