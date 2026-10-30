# Start Here

You have copied this template into your project. Open Claude Code in this folder and run `/prime` — it handles everything interactively.

## Before you begin

Install these once if you don't have them:

- **Node.js ≥ 18** — https://nodejs.org (LTS release)
- **Git** — https://git-scm.com/downloads
  - **Windows:** the installer includes **Git Bash**, which the bash scripts and slash commands need. Set it as your default VS Code terminal: `Terminal > Integrated > Default Profile: Windows` → **Git Bash**.
- **Claude Code** — install **both** of these:
  - The **CLI**: `npm install -g @anthropic-ai/claude-code` — required for the `claude /prime` command in step 3
  - The **IDE extension**: search *Claude Code* in the VS Code Extensions marketplace, or in JetBrains via *Settings → Plugins → Marketplace*
  - (The desktop app at https://claude.ai/download is an optional alternative if you'd rather not use an IDE.)
- **GitHub CLI (`gh`)** — https://cli.github.com, then run `gh auth login` (used by `/standup`, `/create-pr`, `/fix-issue`)

## Optional setup (once per machine)

None of this blocks `/prime`. Set up what you need; `/prime` will tell you what's missing.

| Item | Needed for | How |
|------|-----------|-----|
| **`GITHUB_TOKEN`** env var | The GitHub MCP server in `.mcp.json` (PRs, issues, code search from Claude) | Create a fine-grained token at https://github.com/settings/personal-access-tokens, then set it in your shell profile: `export GITHUB_TOKEN=...` (Windows: `setx GITHUB_TOKEN "..."`). Without it the GitHub MCP server fails to connect; the rest of the template is unaffected. Fully quit and reopen your IDE afterwards. |
| **ralph-loop plugin** | `/ralph`, and autonomous mode in `/implement` and `/tdd` | `claude plugin install ralph-loop` (or run `/plugin` inside Claude Code). If it isn't found, run `claude plugin marketplace add anthropics/claude-plugins-official` first. |
| **ECC skills** | Extra skills, agents and commands | `/prime` offers it, or follow `docs/ecc-recommended.md` |
| **`ANTHROPIC_API_KEY`** repo secret + **Claude GitHub App** | The Claude PR-review and issue-triage workflows in `.github/workflows/` | Add the secret under the repo's *Settings → Secrets and variables → Actions*, and run `/install-github-app` in Claude Code. Skip if you don't use those workflows. |

## Get your code into `src/`

Your application code lives in `src/`. With this template the **whole project — Claude config and your code — is one git repository**, pushed to GitHub/Bitbucket together (you'll connect it at the end). Set `src/` up **before** running `/prime`:

**New project** — create the folder; initialise your stack inside it later:
```bash
mkdir src
```

**Existing repository** — clone it into `src/`, then drop its inner `.git` so the code is tracked by this one combined repo:
```bash
git clone https://github.com/org/your-repo src
rm -rf src/.git                               # Mac/Linux
```
```powershell
git clone https://github.com/org/your-repo src
Remove-Item -Recurse -Force src\.git           # Windows
```
Removing `src/.git` folds the code into this project's history (you lose the link to its old remote). Prefer to keep `src/` as its **own separate repo** with its own remote? Skip the removal and follow the Option A note in `.gitignore` instead.

## Run setup

Open **this project folder in your IDE** and run Claude Code from there, so it works alongside your files. **VS Code is recommended**; JetBrains IDEs (IntelliJ, PyCharm, etc.) also work.

**VS Code (recommended)**
1. Install the Claude Code extension if you haven't (see *Before you begin* above)
2. Open this folder — `code .` from the terminal, or *File → Open Folder*
3. Launch Claude Code straight into setup — open the integrated terminal (`` Ctrl+` ``) and run `claude /prime`. (Or open the Claude panel with `Ctrl+Shift+P` → *Claude: Open Chat* and type `/prime`.)

**JetBrains IDE** — install the Claude Code plugin, open this folder as a project, then run `claude /prime` in the IDE terminal (or use the Claude Code tool window and type `/prime`).

Prefer not to use an IDE? You can also run Claude Code from the **terminal** (`cd` into this folder, then `claude /prime`) or the **desktop app** (*File → Open Folder* → this project directory, then type `/prime`).

`claude /prime` launches Claude Code and runs setup in one step. If you opened the Claude panel or desktop app instead, just type `/prime` once it's open.

Claude will ask a few quick setup questions (project name, org, team, coding standards), configure all your files, load the project context — and then, once it knows your project fully, ask what you want to build. Takes about 10 minutes.

> **Optional — ECC:** During `/prime`, Claude offers to install [everything-claude-code (ECC)](https://github.com/affaan-m/everything-claude-code), a global toolkit of extra skills, agents, and commands. It's optional — the template works fully without it. Accept the offer to install a small recommended set now, or follow `docs/ecc-recommended.md` any time later.
>
> If you install ECC or set any environment variables, **fully quit and reopen your IDE afterwards** (not just the Claude panel) — the IDE only picks up new environment variables when it restarts.

After `/prime` completes, run `/stack-analysis` — Claude will read what you described and, with full project context loaded, recommend the right frontend, backend, and database.

---

## After first-run setup

Two things still need your attention after `/prime` completes:

**`PROJECT_REF.md`** — fill in:
- Descriptions for each key file in `src/`
- Full data model fields as you define your data structures

**`CONTEXT.md`** — fill in:
- `Avoid:` — synonyms that cause confusion
- `Related:` — how terms connect to each other
- The `Relationships` block

---

## Commit and push

This project is **one git repository** — Claude config and your `src/` code together. Run these from the **project root** (not `src/`):

```bash
git init
git add -A
git commit -m "chore: initialise project from team-starter template"
git branch -M main
git remote add origin https://github.com/org/your-repo.git
git push -u origin main
```

`.env` and other secrets are git-ignored, so they are never pushed.
