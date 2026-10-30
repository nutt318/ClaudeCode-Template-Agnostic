---
description: Initialize session - loads all project context before work starts. Runs first-time setup interactively if the project has not been configured yet.
---

# /prime

Load all project context for this session.

---

## First-run detection

Before anything else, read `CLAUDE.md` and check whether it still contains the placeholder text `[Replace with your project name`.

- If the placeholder **is present**: the project has not been set up yet. Run the **First-run setup** section below before proceeding to the normal steps.
- If the placeholder **is absent**: skip to **Step 0** directly.

---

## First-run setup

Announce to the user:

> "Welcome! Let's get this project set up. I'll ask a few quick questions first, then load your project context — and once that's done we'll talk through what you want to build."

### Setup questions

Ask these together in one go:

- What would you like to call this project? (short slug, e.g. `my-app`)
- One-paragraph description of what this project does? (can be rough — you'll expand on it shortly)
- Is this a **new project**, or an **existing repository** you've already cloned into `src/`? (this controls how `PROJECT_REF.md` is populated below)
- Organisation name? (default: Your Organisation)
- Copyright year? (default: current year)
- IT contact email? (default: security@example.com)
- Version control: GitHub, Bitbucket, or skip?
  - If GitHub: GitHub org/team for CODEOWNERS? (e.g. `your-org/engineering`)
  - If Bitbucket: Bitbucket workspace/team? (e.g. `my-workspace/engineering`)
- One core coding principle? (e.g. `All DB access goes through the repository layer` — or skip)
- One anti-pattern to never do? (e.g. `Fetching data directly in components` — or skip)

### Apply all changes

Once answers are collected, apply them in this order. Confirm each file as you complete it.

**`CLAUDE.md`**
- Replace `[Replace with your project name and a one-paragraph description.]` with `{project name} — {description}`
- Replace `[your-repo]` with the project name
- Leave the Tech Stack section and command placeholders as-is — these are filled in after `/stack-analysis`

**`LICENSE`** — replace `[Year]` and `[Your Name or Organisation]`

**`SECURITY.md`** — replace `security@example.com` with the IT contact email

**CODEOWNERS**
- GitHub: replace `@your-org/team-name` in `.github/CODEOWNERS`; delete `.bitbucket/`
- Bitbucket: replace `@your-workspace/team-name` in `.bitbucket/CODEOWNERS`; delete `.github/`; swap `docs/ai/issue-tracker-bitbucket.md` content (filling `[bitbucket-workspace]` and `[repo-slug]`) into `docs/ai/issue-tracker.md` and delete the source file
- Skip: delete both `.github/` and `.bitbucket/`

**`PROJECT_REF.md`** — generate fresh using the template below. Populate the **Key Files** table based on the new-vs-existing answer:
- **Existing repo:** scan `src/` and list each file up to two levels deep (e.g. `src/app/page.tsx`), one per row, each with `TODO: describe purpose`. Skip `.git/`, `node_modules/`, `dist/`, `build/`, `.next/`, `target/`, and similar dependency/build directories. If `src/` is empty or missing, the repo likely isn't cloned yet — fall back to the placeholder row and mention it. After context is loaded, offer to fill in these descriptions now or suggest running `/update-project-ref`.
- **New project:** use the single placeholder row shown below.
```
# PROJECT_REF.md
Factual, evolving knowledge about this codebase.
Update this file as the project changes. Load it at session start via /prime.

## Key Files and What They Do
| File / Directory | Purpose |
|-----------------|---------|
| src/ | TODO: add key files as the project grows |

## Data Models
_No models yet — add entries here as you define your data structures._

## API Endpoints
| Method | Path | Purpose |
|--------|------|---------|
| — | — | No endpoints yet |

## External Services and Integrations
| Service | How we use it | Config location |
|---------|--------------|----------------|
| None yet | — | — |

## Known Technical Debt
| Area | Issue | Priority |
|------|-------|---------|
| — | None yet | — |

## Recent Significant Changes
| Date | What changed | Why |
|------|-------------|-----|
| {today} | Initial project setup from team-starter template | New project |
```

**`CONTEXT.md`** — generate with any terms and definitions collected, or a blank template if none

**`CODING_STANDARDS.md`** — generate using the provided principle and anti-pattern; leave naming conventions as generic placeholders (update after stack is decided)

**`docs/ai/domain.md`** — prefix the title with the project name: `# Agent Domain Guide — {project name}`

**`.claude/rules/project.md`** — replace `[Project Name]` with the project name

**`docs/ai/triage-labels.md`** — replace `[Add your areas here]` with `Add area labels once feature areas are defined (e.g. area: auth, area: api)`

**`.claude/context/last-session.md`** — write an initial entry recording today's date and that setup was completed

**`.env`** — copy from `.env.example` if `.env` does not already exist

**Git hook** — if `.git/` exists at the project root, copy `scripts/check-git-identity.sh` to `.git/hooks/pre-commit` and make it executable (one combined repo — config + code). If there's no `.git/` yet, note that it installs when the user re-runs setup after `git init`

**`START-HERE.md`** — delete it

### Check user-level tools (first run only)

Check these quickly and report one short line per item. None of them blocks setup — if something is missing, say how to fix it and continue.

| Check | How | If missing |
|-------|-----|-----------|
| GitHub CLI authenticated | `gh auth status` | "`/standup`, `/create-pr` and `/fix-issue` need `gh`. Install it from https://cli.github.com and run `gh auth login`." |
| `GITHUB_TOKEN` set | Is the `GITHUB_TOKEN` env var non-empty? (check only that it is set — never print its value) | "The GitHub MCP server in `.mcp.json` needs a `GITHUB_TOKEN` (a GitHub personal access token). Without it that one server fails to connect; everything else works." |
| ralph-loop plugin | `claude plugin list` contains `ralph-loop` | "`/ralph` and autonomous mode in `/implement` and `/tdd` need the ralph-loop plugin. Install: `claude plugin install ralph-loop` (or `/plugin`)." |

### Check for ECC (first run only)

Check whether everything-claude-code (ECC) is installed by looking for `~/.claude/skills/tdd-workflow/SKILL.md` or the directory `~/.claude/rules/ecc/` (Mac/Linux), or the same paths under `%USERPROFILE%\.claude\` (Windows).

- If **either exists**: confirm "everything-claude-code detected — looks good." and continue.
- If **neither exists**: say:

  > "I don't see everything-claude-code (ECC) installed. ECC adds extra skills, agents, and commands to every Claude Code session on your machine — it's optional, but it enhances what this template can do. I'd add a small recommended set of skills, not the whole library. Want me to walk you through it? (yes / skip for now)"

  If **yes**: read `docs/ecc-recommended.md` and walk the user through it. Follow that file for the exact commands, pinned version and skill list — do not improvise installer flags from memory. In short:

  1. Clone ECC at the pinned tag to a stable location outside any project.
  2. Copy the baseline and core skills listed in the doc into `~/.claude/skills/` (the doc has the exact commands). **Do not run ECC's installer for this** — its `minimal` profile writes ~400 files, including rules for every language that load into every session.
  3. Ask which stack(s) this project uses and add only the matching skills from the doc's stack table.
  4. Hooks are off by default. Mention they exist and are covered in the doc; do not enable them unless the user asks.
  5. Confirm: "ECC installed. Restart Claude Code to pick up the new skills, agents, and commands."

  If **skip**: note that ECC is optional and can be installed any time by following `docs/ecc-recommended.md` — and continue.

Announce when done:

> "Project files set up. Now let me load your project context."

Then continue to **Step 0** below. After completing Steps 0–3, continue to **Step 4** (discovery — first run only).

---

## Step 0 — Verify git identity

Run `git -C src config user.name` and `git -C src config user.email`.

- If **both are set**: confirm — "Git identity: Name <email> — looks good." — and continue.
- If **either is missing**: ask:
  > "Your git identity is not configured. What is your full name and work email address?"
  Then run:
  ```
  git config --global user.name "Their Name"
  git config --global user.email "their@email.com"
  ```
  Confirm: "Git identity set. All commits will be attributed to Name <email>."
- If `src/` has no `.git`: note "src/ not yet initialised as a git repo — git checks skipped." and continue.

### Step 0b — Check branch state

Run `git -C src branch --show-current` and `git -C src status`.

- If on **main** or **master** with no feature branch:
  > "You are on the main branch. Before making any changes, create a feature branch:
  > ```
  > cd src
  > git pull origin main
  > git checkout -b feat/your-feature-name
  > ```
  > What are you working on today? I can suggest a branch name."
- If on a **feature branch**: confirm — "Branch: `<name>` — looks good." — and continue.
- If there are **uncommitted changes on main**: flag it before proceeding.

---

## Step 1 — Load project structure

List files in the project root and in `src/` using Glob or `ls`.

---

## Step 2 — Read project context

Read each of these files if they exist:

- `CLAUDE.md` — project rules, stack, and operating principles
- `CONTEXT.md` — canonical domain vocabulary; use its terms in all output this session
- `CODING_STANDARDS.md` — project-specific coding standards
- `docs/ai/domain.md` — where to look and how to communicate in this project
- `PROJECT_REF.md` — key files, data models, API endpoints
- All files in `.claude/context/`
- `docs/lessons.md` — lessons from prior sessions

---

## Step 3 — Summarise

Report what you now know:

- Project overview and stack
- Current branch and any open changes
- What lives in `src/` and how it is organised
- Key files and data models from `PROJECT_REF.md`
- Current priorities or active work from `last-session.md`
- Any constraints or gotchas
- Relevant lessons from prior sessions

---

## Step 4 — Discovery (first run only)

**Skip this step if `docs/plans/discovery.md` already exists.**

Now that the project is fully loaded and you have complete context, have a natural conversation to understand what the user wants to build. Ask one question at a time. Follow up when an answer is vague or interesting. This is a consultation — not a form.

Open with:

> "Now that everything is set up — tell me about what you want to build. Don't worry about being technical, just describe it."

Then work through these naturally, in whatever order fits the conversation:

1. **What does it do?** — What are the main things users will be able to do?
2. **Who uses it?** — Just you, a small team, or the public?
3. **Multiple users and roles?** — Will different people log in? Different permission levels (e.g. admin vs regular user)?
4. **Interface and layout** — Web app, mobile, desktop, dashboard, API only? Any ideas about how it should look or feel?
5. **Integrations** — Does it need to connect to anything? (payments, email, maps, third-party APIs, existing internal systems?)
6. **Data** — What will it store? (accounts, files, products, bookings, transactions, etc.)
7. **Scale** — Handful of users, hundreds, thousands?
8. **Timeline and constraints** — Any deadline? Technologies already committed to, or things to avoid?

Once you have a clear picture, play it back:

> "So from what you've described: [2–3 sentence summary]. Does that sound right?"

Wait for confirmation or corrections.

**Domain terms** — based on the conversation, identify any project-specific terms the user used consistently (e.g. names for the main entities, UI concepts, roles). Present them back:

> "I noticed you used these terms: [X, Y, Z]. Should I add them to `CONTEXT.md` so I always use them the same way? For any you want to keep, give me a one-sentence definition — or just confirm and I'll write a draft definition you can refine later."

Update `CONTEXT.md` with confirmed terms before saving the brief.

Then save `docs/plans/discovery.md` using the format below and tell the user:

> "Saved. Run `/stack-analysis` next — I'll read your brief and, with everything I now know about your project, recommend the right frontend, backend, and database for what you're building."

### Product Brief format

```markdown
# Product Brief — [Project Name]
Date: [today]
Status: Draft

## What We're Building
[2–3 sentences from the discovery conversation]

## Users
| User Type | Description | Volume Estimate |
|-----------|-------------|----------------|
| [type] | [description] | [rough count] |

## User Roles
[List roles and permissions, or "Single role — no permissions needed"]

## Core Features
| # | Feature | Notes |
|---|---------|-------|
| 1 | [feature] | [any detail] |
| 2 | [feature] | [any detail] |

## Interface
[Web app / mobile / dashboard / API only — and any layout ideas mentioned]

## Integrations
[External services, APIs, or systems — or "None identified yet"]

## Data
[What the system will store and work with]

## Scale
[Expected user volume and any performance notes]

## Constraints
[Timeline, tech commitments, things to avoid — or "None stated"]
```

---

Do not start any task until Steps 0–4 are complete.
