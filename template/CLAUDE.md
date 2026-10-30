# CLAUDE.md

This file provides guidance to Claude Code when working in this project.
Read this fully at the start of every session, or run /prime.

## Project Overview

[Replace with your project name and a one-paragraph description.]

## Tech Stack

- **Language**: [e.g. TypeScript / Python / Go]
- **Framework**: [e.g. Next.js / FastAPI / Gin]
- **Database**: [e.g. PostgreSQL / MongoDB / SQLite]
- **Package Manager**: [e.g. npm / pnpm / yarn / pip]

## Running the Project

```bash
[your install command]
[your dev command]
[your test command]
[your build command]
```

## Project Structure

```
[your-repo]/
├── src/             - Application source code
├── docs/            - Plans, lessons, ADRs, and AI guides
├── .claude/         - Claude config, context, and commands
├── .github/         - CI workflows and GitHub configuration
├── scripts/         - Setup and utility scripts
└── reference/       - Patterns Claude treats as source of truth
```

---

## Operating Principles

1. **Discover before planning** - for any new feature, run /discover to capture requirements, then /stack-analysis to confirm the right technology, then /create-plan
2. **Verify before done** - prove work is complete before marking finished
3. **Use agents for specialised work** - `/plan` for planning, `/research` for exploration, `/code-review` for review
4. **Fix roots not symptoms** - find the cause when something breaks
5. **Demand elegance** - after a working solution, ask if there is a simpler one
6. **Update lessons** - add non-obvious findings to docs/lessons.md after each session

---

## Operating Rules

> Bias: caution over speed on non-trivial work. Use judgment on trivial tasks.

### Rule 1 — Think Before Coding
State assumptions explicitly. If uncertain, ask rather than guess.
Present multiple interpretations when ambiguity exists.
Push back when a simpler approach exists.
Stop when confused. Name what's unclear.

### Rule 2 — Simplicity First
Minimum code that solves the problem. Nothing speculative.
No features beyond what was asked. No abstractions for single-use code.
Test: would a senior engineer say this is overcomplicated? If yes, simplify.

### Rule 3 — Surgical Changes
Touch only what you must. Clean up only your own mess.
Don't "improve" adjacent code, comments, or formatting.
Don't refactor what isn't broken. Match existing style.

### Rule 4 — Goal-Driven Execution
Define success criteria. Loop until verified.
Don't follow steps blindly. Define success and iterate.
Strong success criteria let you loop independently.

### Rule 5 — Surface Conflicts, Don't Average Them
If two patterns contradict, pick one (more recent / more tested).
Explain why. Flag the other for cleanup.
Don't blend conflicting patterns.

### Rule 6 — Read Before You Write
Before adding code, read exports, immediate callers, shared utilities.
"Looks orthogonal" is dangerous. If unsure why code is structured a way, ask.

### Rule 7 — Tests Verify Intent, Not Just Behaviour
Tests must encode WHY behaviour matters, not just WHAT it does.
A test that can't fail when business logic changes is wrong.

### Rule 8 — Checkpoint After Every Significant Step
Summarise what was done, what's verified, what's left.
Don't continue from a state you can't describe back.
If you lose track, stop and restate.

### Rule 9 — Match the Codebase's Conventions, Even If You Disagree
Conformance > taste inside the codebase.
If you genuinely think a convention is harmful, surface it. Don't fork silently.

### Rule 10 — Fail Loud
"Completed" is wrong if anything was skipped silently.
"Tests pass" is wrong if any were skipped.
Default to surfacing uncertainty, not hiding it.

---

## Critical Rules

### [Add an area — e.g. Database, Auth, Payments]

_Add rules specific to this area. Example:_
- Never run raw queries — always use the repository layer
- Always validate permissions before data access

_Repeat this block for each sensitive or complex area of the codebase._

### Code Style

- No hardcoded secrets - use environment variables
- No console.log or print in production - use a structured logger
- Immutable patterns - never mutate objects or arrays in place
- Validate all inputs at system boundaries

---

## Key Patterns

### API Response Format

```typescript
// Replace with your project's actual pattern
type ApiResponse<T> =
  | { success: true; data: T }
  | { success: false; error: string }
```

### Error Handling

```typescript
try {
  const result = await operation()
  return { success: true, data: result }
} catch (error) {
  logger.error('Operation failed', { error })
  return { success: false, error: 'Something went wrong' }
}
```

---

## Testing Strategy

```bash
[your test command]          # run all tests
[your coverage command]      # with coverage report
[your targeted test command] # run specific suite
```

### Critical flows to always test

1. [Most important user flow]
2. [Auth and access control]
3. [Any payment or data mutation path]

---

## Workflow

> All commands below ship with this template and work standalone. [everything-claude-code (ECC)](https://github.com/affaan-m/everything-claude-code) is an **optional** global add-on (extra skills, agents, and commands; see `docs/ecc-recommended.md`) — `/prime` offers to install it, but nothing in this workflow requires it.

```bash
# Every session — always start here:
/prime                                     # reads last-session.md, CLAUDE.md, PROJECT_REF.md, etc.
/standup                                   # catch up on yesterday's activity

# New feature — run once per feature, not per session:
/new-branch "what you're building"         # create feature branch before any work
/discover "feature or project description" # Phase 1: capture requirements
/stack-analysis                            # Phase 2: recommend frontend/backend/db
/create-plan "feature description"         # Phase 3: plan the implementation
/implement docs/plans/[name].md            # Phase 4: execute the plan

# Per session, during development:
/tdd                                       # write tests first
/code-review                               # before committing
/security-review                           # before committing
/e2e                                       # before release
/test-coverage                             # verify 80%+
/update-project-ref                        # after significant changes

# Every session — always end here:
/save-session                              # writes to last-session.md → /prime reads it next session
```

## Autonomous Loops (ralph-loop)

For well-defined tasks with automated verification, use `/ralph` to hand the full cycle to Claude:

```bash
/ralph "Apply TDD to: <feature>"          # autonomous TDD until all tests green
/ralph "Execute plan at docs/plans/x.md"  # autonomous plan execution until done
```

Ralph-loop uses a Stop hook to intercept session exits and re-feed the same prompt, reading its own git history and file changes each iteration. Always set `--max-iterations` as a safety net.

See `/ralph` for full usage, prompt templates, and safety rules.
Requires the ralph-loop plugin: `claude plugin install ralph-loop` (or run `/plugin` in Claude Code). If it is not found, first run `claude plugin marketplace add anthropics/claude-plugins-official`.

---

## Git Workflow

- **Before starting any task**: pull main and create a feature branch
  ```bash
  git pull origin main
  git checkout -b feat/your-feature-name
  ```
- Never commit directly to main — always work on a branch
- Conventional commits: feat, fix, refactor, docs, test
- PRs require passing CI before merge

### CI Checks

- [ ] Lint
- [ ] Type check
- [ ] Tests
- [ ] Security scan

---

## Environment Variables

```bash
EXAMPLE_VAR=
DEBUG=false
LOG_LEVEL=info
PORT=3000
```

---

## Workspace Directories

| Directory | Purpose |
|-----------|---------|
| .claude/context/ | Shared team context committed to git |
| .claude/agents/ | Project-specific agents — planner, researcher, code-reviewer |
| .claude/commands/ | Custom slash commands for this project |
| .claude/rules/ | Project-specific rule overrides |
| docs/plans/ | Implementation plans from /create-plan |
| docs/adr/ | Architecture Decision Records |
| docs/lessons.md | Living record of lessons learned |
| outputs/ | Claude-generated deliverables |
| reference/ | Templates and patterns Claude can reference |


---

## Development Phases (BMAD)

Use these phases for any non-trivial feature. Each phase produces a specific artifact.

| Phase | Owner | Artifact | Command |
|-------|-------|---------|---------|
| 1. Discovery | You + Claude | Product Brief | /discover |
| 2. Stack Analysis | Claude | Stack Decision ADR | /stack-analysis |
| 3. Planning | Claude | Implementation plan | /create-plan |
| 4. Implementation | Claude | Code + tests | /implement |

**Phase 1** captures what you're building, who uses it, and all constraints before any technical decisions are made.
**Phase 2** reads the Product Brief and recommends the right frontend, backend, and database — with reasoning and alternatives considered.

Do not skip phases for features that touch multiple files or involve design decisions.

---

## Session End — Landing the Plane

Before ending any session where work was done:

- [ ] All changes committed and pushed
- [ ] Open tasks filed in issues or docs/plans/ as Draft plans
- [ ] docs/lessons.md updated if anything non-obvious was learned
- [ ] CHANGELOG.md updated if user-visible changes were made (use /add-to-changelog)
- [ ] PROJECT_REF.md updated if data models, APIs, or key files changed
- [ ] Verify push succeeded: git log --oneline -3

Do not close a session with uncommitted work or undocumented open threads.

