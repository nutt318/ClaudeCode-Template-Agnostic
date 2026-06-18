# CLAUDE.md — ClaudeCode-Template

This repo contains a ready-to-copy scaffold for teams using Claude Code, with optional everything-claude-code (ECC) enhancements.

## What This Repo Is

| Directory | Purpose |
|-----------|---------|
| `template/` | Files that get copied into each new project |
| `README.md` | Maintainer guide — distribution model and how to work on the template (not shipped to consumers) |
| `template/scripts/` | `setup.sh` and `setup.ps1` — interactive first-run setup |
| `template/.claude/commands/` | Slash commands shipped with the template |
| `template/CLAUDE.md` | The template CLAUDE.md — contains `[placeholders]` by design |

## Working on the Template

When editing this repo you are working on **template content**, not a live project. The `CLAUDE.md` inside `template/` is a placeholder document — its `[Replace with...]` text is intentional. Do not treat it as project instructions for this session.

### Common tasks

- **Improving a slash command** — edit `template/.claude/commands/<name>.md`
- **Updating setup logic** — edit `setup.sh` AND `setup.ps1` together; they must stay functionally identical
- **Updating the template CLAUDE.md** — edit `template/CLAUDE.md`; check that any new `[placeholders]` are handled in both setup scripts
- **Updating the README** — edit `README.md` at the repo root

### Key invariants

- `setup.sh` and `setup.ps1` must stay in sync — every placeholder one fills, both must fill
- Placeholders in template files use `[your-thing]` format so sed/PowerShell can target them cleanly
- The `_disabled_` prefix in `.mcp.json` is the disable convention — rename to enable, never delete
- Slash commands are self-contained markdown; no external dependencies beyond `$ARGUMENTS`

## No Git Repo at This Level

The `template/` subdirectory is not a git repository (git lives at the `ClaudeCode-Templates/` root). Running `/prime` from `template/` will skip git steps — that is expected and normal.

## Stack

This is a documentation and scripting project. No build step. No test suite.

- Shell scripts: `setup.sh` (bash), `setup.ps1` (PowerShell)
- Markdown: all template files
- JSON: `.mcp.json`, `.claude/settings.json`
