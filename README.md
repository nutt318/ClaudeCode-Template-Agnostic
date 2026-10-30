# ClaudeCode-Template-Agnostic — Maintainer Guide

This repo is the **source** for a per-project Claude Code scaffold. It is not itself a project
you run — it's the thing you copy *into* projects. This README is for whoever **maintains and
hands out** the template. People receiving the template don't need this file (see
[Distribution model](#distribution-model)).

```
ClaudeCode-Template-Agnostic/
├── README.md      <- you are here — maintainer guide (not shipped to consumers)
├── CLAUDE.md      <- how to work on this repo (Claude reads this; humans should too)
└── template/      <- the scaffold — THIS is what gets handed out
```

---

## Distribution model

**Hand out the `template/` folder only — never the repo root.** Everything a consumer needs lives
inside `template/`; this README and the root `CLAUDE.md` stay behind as maintainer docs.

A consumer copies `template/` into their project and is guided from there:

| Reader | Entry point (inside `template/`) | When |
|--------|----------------------------------|------|
| Someone starting a new project | `START-HERE.md` | First run — it covers prerequisites, then says "run `/prime`". Deleted by setup once done. |
| A developer joining an existing project | `docs/onboarding-checklist.md` | Day one — `START-HERE.md` is already gone, so the checklist is self-contained. |

Both entry docs are standalone — they do **not** reference this README. If you add a consumer-facing
instruction, put it in one of those two files, not here.

### What consumers do with the template

By default a project is a **single git repository** (Option B): the Claude config and docs at the
root, and the **application code** in `src/` — all tracked together and pushed to GitHub/Bitbucket.
Secrets in `.env` are git-ignored. (Option A — keeping `src/` as its own separate repo and not
pushing the workspace — is still available; see the `.gitignore` notes.)

```
~/Projects/
├── ClaudeCode-Template-Agnostic/     <- this repo — reference copy, update occasionally
└── your-project/            <- ONE git repo → github.com/org/your-app
    ├── .git/
    ├── CLAUDE.md            <- tracked
    ├── .claude/             <- tracked: agents, commands, settings
    ├── docs/                <- tracked: plans, lessons, ADRs
    └── src/                 <- tracked: application code
```

The setup paths a consumer follows — all start by copying `template/` in, then running `/prime`,
then committing/pushing from the project root:

```bash
# New project from scratch (one combined repo)
mkdir ~/Projects/your-project && cd ~/Projects/your-project
cp -r path/to/ClaudeCode-Template-Agnostic/template/. .
mkdir src                                                  # your code goes here
claude                                                     # then run /prime

# Existing repo — clone into src/ and fold it into the one combined repo
mkdir ~/Projects/your-project && cd ~/Projects/your-project
cp -r path/to/ClaudeCode-Template-Agnostic/template/. .
git clone https://github.com/org/your-repo src && rm -rf src/.git   # drop inner .git to track it here
claude                                                     # then run /prime
# (To keep src/ as its own separate repo, skip the rm and use Option A — see .gitignore.)
```

After `/prime`, the consumer runs `git init` at the project root, then commits and pushes everything.

> Copy only `template/.` (the trailing `/.` copies its *contents*) — not the repo root.

`/prime` collects project name, org, team, and coding standards, configures every file, loads full
project context, then runs a short discovery conversation and saves a Product Brief to
`docs/plans/discovery.md`. After it completes, `/stack-analysis` recommends a tech stack.
`PROJECT_REF.md` and `CONTEXT.md` still need the consumer's domain knowledge and can't be automated.

---

## Working on the template

When you edit this repo you are editing **template content**, not a live project. The `CLAUDE.md`
*inside* `template/` is a placeholder document — its `[Replace with...]` text is intentional.

`CLAUDE.md` at the repo root is the canonical task/invariant reference — read it before changing
anything. The essentials:

| Task | Where |
|------|-------|
| Improve a slash command | `template/.claude/commands/<name>.md` |
| Change setup logic | `setup.sh` **and** `setup.ps1` together (see invariant below) |
| Edit the template CLAUDE.md | `template/CLAUDE.md` — add any new `[placeholders]` to **both** setup scripts |
| Edit consumer onboarding | `template/START-HERE.md` and `template/docs/onboarding-checklist.md` |
| Edit this maintainer guide | this file |

### Invariants — do not break these

- **`setup.sh` and `setup.ps1` must stay functionally identical.** Every placeholder one fills, the
  other must fill the same way. They live in `template/scripts/`. This is the easiest thing to get
  wrong: change one, change both.
- **`setup.sh` must work on macOS.** It runs under the stock bash 3.2 and BSD `sed`, so avoid GNU-only
  constructs: use the `sed_i` helper instead of `sed -i`, no `${var,,}` or `declare -A`, and use `$NL`
  instead of `\n` in sed replacements. Prompts captured with `$(...)` must write to stderr.
- **Placeholders use `[your-thing]` format** so `sed` (bash) and `-replace` (PowerShell) can target
  them cleanly. Keep the bracket convention for anything the scripts substitute.
- **The `_disabled_` prefix in `.mcp.json` is the disable convention** — rename to enable, never
  delete an entry.
- **Slash commands are self-contained markdown** with no external dependencies beyond `$ARGUMENTS`.
- **Consumer-facing instructions never reference this README** — they go in `template/`, which ships
  without it.

### Testing a change to the setup scripts

There is no build or test suite. To verify a setup change, run it against a scratch copy of
`template/` and inspect the result — don't run it in place:

```bash
cp -r template /tmp/scratch && cd /tmp/scratch
mkdir src
bash scripts/setup.sh          # or: pwsh ./scripts/setup.ps1 on Windows
```

Confirm both providers (GitHub / Bitbucket / skip), check that placeholders are filled, and that
`START-HERE.md` is removed at the end. Run the **other** script too — both must produce equivalent
output.

> The `template/` subdirectory is not a git repository (git lives at the `ClaudeCode-Template-Agnostic/`
> root). Running `/prime` from inside `template/` skips the git steps — that is expected.

---

## What ships in the template

Reference for what's in the box. Use this when adding, removing, or auditing shipped files.

```
template/
├── START-HERE.md                      <- consumer entry point (deleted after setup)
├── CLAUDE.md                          <- project briefing (contains [placeholders] by design)
├── PROJECT_REF.md                     <- factual codebase knowledge (consumer fills in)
├── CONTEXT.md                         <- domain glossary
├── CODING_STANDARDS.md                <- project-specific coding standards
├── CONTRIBUTING.md / CHANGELOG.md / SECURITY.md / LICENSE
├── Makefile / .editorconfig / .env.example / .gitignore
│
├── src/                               <- application code lives here
├── outputs/                           <- Claude-generated deliverables (git-ignore optional; see its README)
├── reference/                         <- patterns/specs Claude treats as source of truth
│
├── docs/
│   ├── onboarding-checklist.md        <- day-one checklist (consumer entry for joiners)
│   ├── lessons.md / shell-aliases.md
│   ├── ecc-recommended.md             <- optional ECC install: pinned version + curated skill list
│   ├── ai/                            <- domain.md, issue-tracker.md, triage-labels.md
│   ├── not-doing/                     <- rejected features (prevents re-litigation)
│   ├── plans/                         <- implementation plans from /create-plan
│   └── adr/                           <- Architecture Decision Records
│
├── scripts/
│   ├── setup.sh / setup.ps1           <- interactive first-run setup (keep in sync!)
│   └── check-git-identity.sh          <- pre-commit hook: blocks commits with no git identity
│
├── .claude/
│   ├── settings.json                  <- project permissions
│   ├── context/                       <- architecture.md, decisions.md, gotchas.md, last-session.md
│   ├── rules/project.md               <- project-specific rule overrides
│   ├── agents/                        <- planner, researcher, code-reviewer
│   └── commands/                      <- slash commands (see table below)
│
├── .github/                           <- GitHub CI + config (setup removes for Bitbucket projects)
├── .bitbucket/                        <- Bitbucket CI + config (setup removes for GitHub projects)
├── .mcp.json                          <- MCP server configuration
└── .vscode/                           <- settings.json, extensions.json
```

### Slash commands

| Command | What It Does |
|---------|-------------|
| `/prime` | Load all project context — run at the start of every session |
| `/standup` | Generate standup summary from yesterday's commits and open PRs |
| `/new-branch` | Create a feature branch with the correct naming convention |
| `/discover` | **Phase 1** — interview to capture requirements into a Product Brief |
| `/stack-analysis` | **Phase 2** — recommend frontend, backend, and database from the brief |
| `/create-plan` | **Phase 3** — step-by-step implementation plan |
| `/plan` | Create a plan via the planner agent (reads all project context first) |
| `/create-prp` | Create a Product Requirements Prompt with acceptance criteria |
| `/create-jtbd` | Define a Job To Be Done to clarify user intent |
| `/implement` | **Phase 4** — execute a plan: Understand, Execute, Validate, Close Out |
| `/tdd` | Test-driven development: RED → GREEN → REFACTOR |
| `/fix-issue` | End-to-end issue resolution: read → plan → branch → implement → PR |
| `/test-coverage` | Check coverage, list files below 80%, recommend missing tests |
| `/e2e` | Generate and run E2E tests for critical user flows |
| `/research` | Answer a codebase question via the researcher agent (read-only) |
| `/code-review` | Review changed code via the code-reviewer agent |
| `/ralph` | Run an autonomous iterative loop until a completion promise is output |
| `/security-review` | Security audit: secrets, injection, auth, deps, API security |
| `/create-pr` | Generate a PR description from git history and open with `gh` |
| `/add-to-changelog` | Extract changes from git and write to CHANGELOG.md |
| `/learn` | Extract lessons and append to docs/lessons.md |
| `/update-project-ref` | Diff recent commits against PROJECT_REF.md and patch stale entries |
| `/save-session` | Save session context before closing |

### Agents

Project-scoped agents in `.claude/agents/` run as isolated subagents with their own tools and
system prompts. The `description` field is what Claude reads when deciding to delegate — keep it
specific.

| Agent | Invoked by | Tools | Purpose |
|-------|-----------|-------|---------|
| `planner` | `/plan` or `@"planner (agent)"` | Read, Glob, Grep, Write | Reads all project context, writes structured plans to `docs/plans/` |
| `researcher` | `/research` or `@"researcher (agent)"` | Read, Glob, Grep, WebFetch, WebSearch | Read-only exploration — "where is X", "what calls Y" |
| `code-reviewer` | `/code-review` or `@"code-reviewer (agent)"` | Bash, Read, Glob, Grep | Reviews diffs against CODING_STANDARDS.md, CLAUDE.md, and gotchas |

### Autonomous loops (ralph-loop) — Windows gotcha worth knowing

The optional [ralph-loop plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/ralph-loop)
(`claude plugin install ralph-loop`, or `/plugin` inside Claude Code) drives `/ralph`. Its Stop hook runs a bash script, and on Windows
`bash` may resolve to WSL instead of Git Bash, breaking the hook (the loop exits immediately instead
of iterating). The fix is to point the hook at the full Git Bash path in the plugin's hashed cache:

```
%USERPROFILE%\.claude\plugins\cache\<marketplace>\ralph-*\<hash>\hooks\hooks.json
```

(The plugin folder has been published as both `ralph-loop` and `ralph-wiggum`, so use the `ralph-*`
wildcard.)

```json
"command": "\"C:/Program Files/Git/bin/bash.exe\" ${CLAUDE_PLUGIN_ROOT}/hooks/stop-hook.sh"
```

> Use `Git/bin/bash.exe`, **not** `Git/usr/bin/bash.exe` — the `bin/` wrapper sets up the full PATH;
> the `usr/bin/` binary lacks the utilities the hook needs.

`setup.ps1` detects this cache path automatically (any `ralph-*` folder) and warns if the fix is needed.

---

## Optional: ECC (everything-claude-code)

[ECC](https://github.com/affaan-m/everything-claude-code) is a global toolkit that adds extra
skills, agents, and commands to every Claude Code session on a machine. It is **not required** —
the template works fully standalone.

Don't install all of it: the full library is ~290 skills that overlap and cost context every
session. `template/docs/ecc-recommended.md` is the maintained list — a pinned ECC version, a
minimal baseline, core extras, and a per-stack table. `/prime` walks consumers through it on first
run. When you bump the ECC version or change the skill list, edit that one file (and re-check the
skill names against the new release).

---

## FAQ

**Why doesn't the consumer get this README?**
It's the maintainer's map of how the template is built and distributed. Consumers only need
`template/`, whose `START-HERE.md` and `docs/onboarding-checklist.md` are self-contained.

**Do consumers need ECC?**
No. The template works standalone using native Claude Code agents, commands, and settings.

**A project needs rules that differ from the defaults — where do they go?**
`template/.claude/rules/project.md` overrides global ECC rules. Consumers edit it after setup.

**VS Code vs terminal — same experience?**
Yes. Both read from `~/.claude/`; the extension and CLI share the same config.
