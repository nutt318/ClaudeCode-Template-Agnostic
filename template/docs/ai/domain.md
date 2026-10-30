# Agent Domain Guide

> Read this before exploring the codebase. It tells you where to look and how to communicate.

## Before You Start Any Task

Always read these files first, in order:

1. `CLAUDE.md` — project rules, stack, and operating principles
2. `CONTEXT.md` — canonical vocabulary; use these terms in all output
3. `PROJECT_REF.md` — key files, data models, API endpoints
4. `.claude/context/gotchas.md` — known traps; check here before touching anything unfamiliar

## Vocabulary Rules

- Use the terms defined in `CONTEXT.md` exactly as written
- If a term is not in `CONTEXT.md`, flag it rather than inventing a synonym
- Never use the "avoid" synonyms listed in `CONTEXT.md`, even if they seem natural

## Where Things Live

| What you are looking for | Where to look |
|--------------------------|---------------|
| Business logic | `src/` — see `PROJECT_REF.md` for key files |
| Data models / types | Listed in `PROJECT_REF.md` under Data Models |
| API contracts | Listed in `PROJECT_REF.md` under API Endpoints |
| Architecture decisions | `docs/adr/` and `.claude/context/decisions.md` |
| Known issues / workarounds | `.claude/context/gotchas.md` |
| Rejected ideas | `docs/not-doing/` |
| In-progress plans | `docs/plans/` |

## How to Ask Clarifying Questions

If something is ambiguous, ask one specific question before proceeding.
Do not assume; do not invent. Reference `CONTEXT.md` terms in your question.
