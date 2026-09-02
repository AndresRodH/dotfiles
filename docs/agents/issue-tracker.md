# Issue tracker: GitHub

Issues and specs for this repo live as GitHub issues. Use the `gh` CLI for all operations.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments`, filtering comments by `jq` and also fetching labels.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` and `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v`; `gh` does this automatically inside a clone.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats external PRs as feature requests; `/triage` reads this flag.)_

When set to `yes`, PRs run through the same labels and states as issues, using the `gh pr` equivalents:

- **Read a PR**: `gh pr view <number> --comments` and `gh pr diff <number>`.
- **List external PRs for triage**: `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`, retaining external contributor associations.
- **Comment / label / close**: `gh pr comment`, `gh pr edit`, and `gh pr close`.

GitHub shares one number space across issues and PRs, so resolve an ambiguous number with `gh pr view` and fall back to `gh issue view`.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.

## Wayfinding operations

Used by `/wayfinder`. The map is a single issue with child issues as tickets.

- **Map**: create one issue labelled `wayfinder:map`, containing Notes, Decisions-so-far, and Fog.
- **Child ticket**: link an issue to the map using GitHub sub-issues through `gh api`. If unavailable, add it to a task list in the map and put `Part of #<map>` in the child body. Apply one `wayfinder:<type>` label: `research`, `prototype`, `grilling`, or `task`.
- **Blocking**: use GitHub native issue dependencies through `gh api`. The blocker must be referenced by numeric database ID, not issue number or node ID. If dependencies are unavailable, use a `Blocked by: #<n>` line.
- **Frontier query**: list the map's open children and exclude assigned tickets and tickets with open blockers. The first remaining ticket in map order wins.
- **Claim**: `gh issue edit <n> --add-assignee @me`; this is the session's first write.
- **Resolve**: comment with the answer, close the ticket, then append a gist and link to the map's Decisions-so-far.
