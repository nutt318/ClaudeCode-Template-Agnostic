# New Developer Onboarding Checklist

Work through this on your first day. Each section should take 15–30 minutes.

---

## 1. Environment Setup

- [ ] **Windows only:** confirm Git Bash is installed (comes with Git for Windows — https://git-scm.com/downloads)
  - Set it as your default VS Code terminal: `Terminal > Integrated > Default Profile: Windows` → **Git Bash**
  - All bash-based slash commands and scripts depend on this
- [ ] Install the GitHub CLI if not already installed: https://cli.github.com — then run `gh auth login`
- [ ] Set up your git identity (required before your first commit):
  ```bash
  git config --global user.name "Your Full Name"
  git config --global user.email "you@[your-domain]"
  ```
- [ ] Get the application code into `src/` (the workspace's own git repo):
  ```bash
  git clone https://github.com/org/your-repo src   # first clone
  # already cloned elsewhere? move it in so it becomes src/:
  mv ~/code/your-repo src                           # (Move-Item on Windows)
  ```
  Then open the workspace folder (the one containing `src/`) in your IDE.
- [ ] Run first-time setup from the project root:
  ```bash
  make setup        # Mac/Linux
  .\scripts\setup.ps1  # Windows
  ```
- [ ] Copy `.env.example` to `.env` and fill in required values (ask your team lead for secrets)
- [ ] Install dependencies and git hooks:
  ```bash
  make install
  ```
- [ ] Run the project locally (`make dev`) and confirm it starts without errors

---

## 2. Claude Code Setup

- [ ] Install Claude Code — CLI (`npm install -g @anthropic-ai/claude-code`), the VS Code extension, or the desktop app (https://claude.ai/download)
- [ ] **Optional:** install the recommended ECC (everything-claude-code) skill set for extra skills, agents, and commands — not required to use this project. Follow `docs/ecc-recommended.md` (or let `/prime` walk you through it)
- [ ] **Optional:** set the `GITHUB_TOKEN` env var so the GitHub MCP server can connect (create a fine-grained token at https://github.com/settings/personal-access-tokens and export it in your shell profile; without it the GitHub MCP server fails to connect). Fully quit and reopen your IDE afterwards
- [ ] **Optional:** install the ralph-loop plugin for /ralph and autonomous mode: `claude plugin install ralph-loop`
- [ ] Open this project in Claude Code and run `/prime`
- [ ] Confirm Claude summarises the project correctly and your branch state is shown

---

## 3. Understand the Project

- [ ] Read `CLAUDE.md` — stack, structure, and rules
- [ ] Read `PROJECT_REF.md` — key files and data models
- [ ] Read `.claude/context/architecture.md` — how the system fits together
- [ ] Read `.claude/context/gotchas.md` — traps to know before touching the code
- [ ] Read `docs/lessons.md` — what the team has already learned

---

## 4. Make a Small Change

- [ ] Pull latest and create your first branch — run `/new-branch` in Claude Code, or:
  ```bash
  git pull origin main
  git checkout -b onboarding/your-name
  ```
- [ ] Make a trivial change (fix a typo, update a comment)
- [ ] Run tests: `make test`
- [ ] Run `/code-review` in Claude Code and read the output
- [ ] Commit with a conventional commit message:
  ```bash
  git commit -m "docs: onboarding change by Your Name"
  ```
- [ ] Open a draft PR to confirm GitHub Actions CI passes

---

## 5. Team Access

- [ ] Added to the GitHub repo with correct permissions
- [ ] Added to team Slack/Teams channels
- [ ] Have the `ANTHROPIC_API_KEY` secret set (ask your team lead) and the Claude GitHub App installed on the repo (`/install-github-app`) if the Claude PR-review workflow is used
- [ ] CI checks pass on your draft PR

---

## Done

If all boxes are checked, you are set up. Close the draft PR and ask your team lead for your first real task.

If anything in this checklist is wrong, out of date, or unclear — fix it and commit the update. The checklist should reflect reality.
