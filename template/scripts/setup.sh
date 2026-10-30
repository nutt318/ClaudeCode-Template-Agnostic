#!/usr/bin/env bash
# setup.sh — Interactive project setup for team-starter template
# Run once after copying the template: bash scripts/setup.sh  OR  make setup

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

header() { echo -e "\n${BOLD}${CYAN}━━━ $1 ━━━${RESET}"; }
ok()     { echo -e "${GREEN}  ✓ $1${RESET}"; }
warn()   { echo -e "${YELLOW}  ! $1${RESET}"; }
err()    { echo -e "${RED}  ✗ $1${RESET}"; }

# sed -i differs between GNU (Linux, Git Bash) and BSD (macOS): BSD needs an explicit backup suffix.
if sed --version >/dev/null 2>&1; then
  sed_i() { sed -i "$@"; }
else
  sed_i() { sed -i '' "$@"; }
fi
NL=$'\\\n'   # backslash + newline: a portable newline inside a sed replacement (\n is GNU-only)

# Escape a value for use in a sed s|||| replacement: backslash, the | delimiter, and &.
E() { printf '%s' "$1" | sed -e 's/[\\|&]/\\&/g'; }

ask_default() {
  local msg="$1" def="$2"
  echo -e "${YELLOW}${msg} [${def}]:${RESET}" >&2   # prompt to stderr: callers capture stdout with $(...)
  read -r REPLY
  if [ -z "$REPLY" ]; then echo "$def"; else echo "$REPLY"; fi
}

echo ""
echo -e "${BOLD}=== Project Setup ===${RESET}"
echo "Answers all template placeholders in one pass."
echo "Press Enter to accept the default shown in [brackets], or leave blank to skip."
echo ""

# ─── Guard: src/ check ────────────────────────────────────────────────────────
# Project-X/ is the local AI workspace. Application code and git live in src/.

if [ ! -d "src" ]; then
  warn "src/ directory not found."
  echo "  For a new project:      mkdir src"
  echo "  For an existing repo:   git clone https://github.com/org/your-repo src"
  echo "  Then re-run: bash scripts/setup.sh"
  echo ""
fi

# ─── Guard: re-run detection ───────────────────────────────────────────────

if [ -f "CLAUDE.md" ] && ! grep -q "\[Replace with your project name" "CLAUDE.md"; then
  warn "Setup has already been run on this project."
  echo ""
  echo -e "${YELLOW}Continue anyway and overwrite existing values? [y/N]:${RESET}"
  read -r CONFIRM
  if [ "$(echo "$CONFIRM" | tr '[:upper:]' '[:lower:]')" != "y" ]; then
    echo "Aborted. No changes made."
    exit 0
  fi
  echo ""
fi

# ─── 1. Project identity ───────────────────────────────────────────────────

header "1 of 6  Project identity"

PROJECT_NAME=$(ask_default "Project name" "my-app")
echo -e "${YELLOW}One-paragraph description:${RESET}"
read -r PROJECT_DESCRIPTION
PROJECT_DESCRIPTION="${PROJECT_DESCRIPTION:-A new project.}"
ORG_NAME=$(ask_default "Organisation name" "Your Organisation")
COPYRIGHT_YEAR=$(ask_default "Copyright year" "$(date +%Y)")

# ─── 2. Tech stack ─────────────────────────────────────────────────────────

header "2 of 6  Tech stack  (leave any blank to fill in later)"

echo -e "${YELLOW}Primary language (e.g. TypeScript / Python / Go):${RESET}"
read -r PROJECT_LANG
echo -e "${YELLOW}Framework (e.g. Next.js / FastAPI / Gin):${RESET}"
read -r FRAMEWORK
echo -e "${YELLOW}Database (e.g. PostgreSQL / MongoDB):${RESET}"
read -r DATABASE
echo -e "${YELLOW}Package manager (npm / pnpm / yarn / pip / go mod):${RESET}"
read -r PKG_MANAGER
echo -e "${YELLOW}Install command (e.g. npm install):${RESET}"
read -r CMD_INSTALL
echo -e "${YELLOW}Dev command (e.g. npm run dev):${RESET}"
read -r CMD_DEV
echo -e "${YELLOW}Test command (e.g. npm test):${RESET}"
read -r CMD_TEST
echo -e "${YELLOW}Build command (e.g. npm run build):${RESET}"
read -r CMD_BUILD

# ─── 3. External services ──────────────────────────────────────────────────

header "3 of 6  External services"

echo -e "${YELLOW}Services this project depends on — comma-separated (e.g. Stripe,SendGrid):${RESET}"
read -r SERVICES_RAW

# ─── 4. Domain vocabulary ──────────────────────────────────────────────────

header "4 of 6  Domain vocabulary (CONTEXT.md)"

echo -e "${YELLOW}Key domain terms — comma-separated (e.g. Member,Workspace,Campaign):${RESET}"
read -r TERMS_RAW

IFS=',' read -ra TERMS <<< "$TERMS_RAW"
TERM_NAMES=()
TERM_VALUES=()   # parallel arrays: bash 3.2 (macOS default) has no associative arrays
for term in "${TERMS[@]}"; do
  term=$(echo "$term" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [ -z "$term" ] && continue
  echo -e "${YELLOW}Define '${term}' in one sentence:${RESET}"
  read -r def
  TERM_NAMES+=("$term")
  TERM_VALUES+=("${def:-A core concept in this project.}")
done

echo -e "${YELLOW}Any terms to avoid or common confusions (e.g. 'account' vs 'workspace') — or leave blank:${RESET}"
read -r TERM_AVOID

# ─── 5. Coding standards ───────────────────────────────────────────────────

header "5 of 6  Coding standards (CODING_STANDARDS.md)"

echo -e "${YELLOW}One core coding principle (e.g. All DB access goes through the repository layer):${RESET}"
read -r PRINCIPLE_1
PRINCIPLE_1="${PRINCIPLE_1:-Prefer pure functions over stateful classes for business logic.}"
echo -e "${YELLOW}Second principle — or leave blank:${RESET}"
read -r PRINCIPLE_2
echo -e "${YELLOW}One anti-pattern to never do (e.g. Fetching data directly in components):${RESET}"
read -r ANTIPATTERN_1
ANTIPATTERN_1="${ANTIPATTERN_1:-Hardcoding secrets in source files.}"

# ─── 6. Contacts and team ──────────────────────────────────────────────────

header "6 of 6  Contacts, team, and version control"

IT_CONTACT=$(ask_default "IT contact email" "security@example.com")

echo ""
echo -e "${YELLOW}Version control provider:${RESET}"
echo "  [1] GitHub      (default)"
echo "  [2] Bitbucket"
echo "  [3] Skip — configure CI and CODEOWNERS manually"
echo -e "${YELLOW}Choice [1]:${RESET}"
read -r PROVIDER_CHOICE
case "$PROVIDER_CHOICE" in
  "2") PROVIDER="bitbucket" ;;
  "3") PROVIDER="skip" ;;
  *)   PROVIDER="github" ;;
esac

if [ "$PROVIDER" = "github" ]; then
  VC_TEAM=$(ask_default "GitHub org/team for CODEOWNERS (e.g. your-org/engineering)" "your-org/engineering")
elif [ "$PROVIDER" = "bitbucket" ]; then
  VC_TEAM=$(ask_default "Bitbucket workspace/team for CODEOWNERS (e.g. my-workspace/engineering)" "my-workspace/engineering")
else
  VC_TEAM=""
fi

# ─── Apply all changes ─────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}${CYAN}━━━ Writing files... ━━━${RESET}"

PROJECT_LANG="${PROJECT_LANG:-TBD}"
PKG_MANAGER="${PKG_MANAGER:-TBD}"
CMD_INSTALL="${CMD_INSTALL:-TBD}"
CMD_DEV="${CMD_DEV:-TBD}"
CMD_TEST="${CMD_TEST:-TBD}"
CMD_BUILD="${CMD_BUILD:-TBD}"

# --- CLAUDE.md ---
if [ -f "CLAUDE.md" ]; then
  STACK_LINE="- **Language**: $(E "$PROJECT_LANG")"
  [ -n "$FRAMEWORK" ] && STACK_LINE="${STACK_LINE}${NL}- **Framework**: $(E "$FRAMEWORK")"
  [ -n "$DATABASE"  ] && STACK_LINE="${STACK_LINE}${NL}- **Database**: $(E "$DATABASE")"
  STACK_LINE="${STACK_LINE}${NL}- **Package Manager**: $(E "$PKG_MANAGER")"

  sed_i \
    -e "s|\[Replace with your project name and a one-paragraph description.\]|$(E "$PROJECT_NAME") — $(E "$PROJECT_DESCRIPTION")|" \
    -e "s|- \*\*Language\*\*: \[e.g. TypeScript / Python / Go\]|${STACK_LINE}|" \
    -e "/- \*\*Framework\*\*: \[e.g. Next.js \/ FastAPI \/ Gin\]/d" \
    -e "/- \*\*Database\*\*: \[e.g. PostgreSQL \/ MongoDB \/ SQLite\]/d" \
    -e "/- \*\*Package Manager\*\*: \[e.g. npm \/ pnpm \/ yarn \/ pip\]/d" \
    -e "s|\[your install command\]|$(E "$CMD_INSTALL")|" \
    -e "s|\[your dev command\]|$(E "$CMD_DEV")|" \
    -e "s|\[your test command\]|$(E "$CMD_TEST")|" \
    -e "s|\[your build command\]|$(E "$CMD_BUILD")|" \
    -e "s|\[your coverage command\]|$(E "$CMD_TEST") --coverage|" \
    -e "s|\[your targeted test command\]|$(E "$CMD_TEST") --testPathPattern=<suite>|" \
    -e "s|\[your-repo\]|$(E "$PROJECT_NAME")|" \
    "CLAUDE.md"
  ok "CLAUDE.md"
fi

# --- LICENSE ---
if [ -f "LICENSE" ]; then
  sed_i \
    -e "s|\[Year\]|$(E "$COPYRIGHT_YEAR")|g" \
    -e "s|\[Your Name or Organisation\]|$(E "$ORG_NAME")|g" \
    "LICENSE"
  ok "LICENSE"
fi

# --- SECURITY.md ---
if [ -f "SECURITY.md" ]; then
  sed_i "s|security@example\.com|$(E "$IT_CONTACT")|g" "SECURITY.md"
  ok "SECURITY.md"
fi

# --- Version control provider: CI files and CODEOWNERS ---
if [ "$PROVIDER" = "github" ]; then
  if [ -f ".github/CODEOWNERS" ]; then
    sed_i "s|@your-org/team-name|@$(E "$VC_TEAM")|g" ".github/CODEOWNERS"
    ok ".github/CODEOWNERS"
  fi
  if [ -d ".bitbucket" ]; then
    rm -rf .bitbucket
    ok ".bitbucket/ removed (GitHub project)"
  fi
elif [ "$PROVIDER" = "bitbucket" ]; then
  if [ -f ".bitbucket/CODEOWNERS" ]; then
    sed_i "s|@your-workspace/team-name|@$(E "$VC_TEAM")|g" ".bitbucket/CODEOWNERS"
    ok ".bitbucket/CODEOWNERS"
  fi
  [ -f ".bitbucket/pipelines.yml" ] && ok ".bitbucket/pipelines.yml"
  if [ -d ".github" ]; then
    rm -rf .github
    ok ".github/ removed (Bitbucket project)"
  fi
else
  [ -d ".github" ]    && rm -rf .github    && ok ".github/ removed (CI skipped)"
  [ -d ".bitbucket" ] && rm -rf .bitbucket && ok ".bitbucket/ removed (CI skipped)"
fi

# --- PROJECT_REF.md ---
SRC_FILES=()
if [ -d "src" ] && [ -n "$(find src -maxdepth 2 -type f 2>/dev/null)" ]; then
  while IFS= read -r f; do
    SRC_FILES+=("$f")
  done < <(find src -maxdepth 2 -type f | sort)
fi

{
  echo "# PROJECT_REF.md"
  echo ""
  echo "Factual, evolving knowledge about this codebase."
  echo "Update this file as the project changes. Load it at session start via /prime."
  echo ""
  echo "---"
  echo ""
  echo "## Key Files and What They Do"
  echo ""
  echo "| File / Directory | Purpose |"
  echo "|-----------------|---------|"
  if [ ${#SRC_FILES[@]} -gt 0 ]; then
    for f in "${SRC_FILES[@]}"; do
      echo "| \`${f}\` | TODO: describe purpose |"
    done
  else
    echo "| src/ | TODO: add key files as the project grows |"
  fi
  echo ""
  echo "---"
  echo ""
  echo "## Data Models"
  echo ""
  echo "_No models yet — add entries here as you define your data structures._"
  echo ""
  echo "---"
  echo ""
  echo "## API Endpoints"
  echo ""
  echo "| Method | Path | Purpose |"
  echo "|--------|------|---------|"
  echo "| — | — | No endpoints yet |"
  echo ""
  echo "---"
  echo ""
  echo "## External Services and Integrations"
  echo ""
  echo "| Service | How we use it | Config location |"
  echo "|---------|--------------|----------------|"
  if [ -n "$SERVICES_RAW" ]; then
    IFS=',' read -ra SERVICES <<< "$SERVICES_RAW"
    for s in "${SERVICES[@]}"; do
      s=$(echo "$s" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [ -n "$s" ] && echo "| ${s} | TODO: describe usage | .env |"
    done
  else
    echo "| None yet | — | — |"
  fi
  echo ""
  echo "---"
  echo ""
  echo "## Known Technical Debt"
  echo ""
  echo "| Area | Issue | Priority |"
  echo "|------|-------|---------|"
  echo "| — | None yet | — |"
  echo ""
  echo "---"
  echo ""
  echo "## Recent Significant Changes"
  echo ""
  echo "| Date | What changed | Why |"
  echo "|------|-------------|-----|"
  echo "| $(date +%Y-%m-%d) | Initial project setup from team-starter template | New project |"
} > PROJECT_REF.md
ok "PROJECT_REF.md"

# --- CONTEXT.md ---
{
  echo "# CONTEXT.md — Domain Glossary"
  echo ""
  echo "> Canonical vocabulary for this project."
  echo "> Claude reads this via \`/prime\`. Use it to resolve ambiguity before writing code, docs, or agent prompts."
  echo "> Add new domain concepts here first."
  echo ""
  echo "---"
  echo ""
  echo "## Canonical Terms"
  echo ""
  if [ ${#TERM_NAMES[@]} -eq 0 ]; then
    echo "_No terms defined yet — add entries here as your domain vocabulary becomes clear._"
    echo ""
    echo "---"
    echo ""
  else
    for i in "${!TERM_NAMES[@]}"; do
      term="${TERM_NAMES[$i]}"
      echo "### ${term}"
      echo ""
      echo "**Definition:** ${TERM_VALUES[$i]}"
      echo ""
      echo "**Avoid:** TODO — list synonyms or vague phrasings to avoid"
      echo ""
      echo "**Related:** TODO — other terms in this glossary"
      echo ""
      echo "---"
      echo ""
    done
  fi
  echo "## Relationships"
  echo ""
  echo '```'
  echo "TODO — describe how key concepts relate to each other"
  echo '```'
  echo ""
  echo "---"
  echo ""
  echo "## Flagged Ambiguities"
  echo ""
  echo "| Ambiguous Term | What People Mean | Preferred Term |"
  echo "|---------------|-----------------|---------------|"
  if [ -n "$TERM_AVOID" ]; then
    echo "| ${TERM_AVOID} | TODO: clarify | TODO: preferred |"
  else
    echo "| — | — | — |"
  fi
} > CONTEXT.md
ok "CONTEXT.md"

# --- CODING_STANDARDS.md ---
{
  echo "# Coding Standards"
  echo ""
  echo "> Reference with @CODING_STANDARDS.md in agent prompts."
  echo "> Keep this specific to THIS project. Universal standards live in CLAUDE.md."
  echo ""
  echo "---"
  echo ""
  echo "## Core Principles"
  echo ""
  echo "- ${PRINCIPLE_1}"
  [ -n "$PRINCIPLE_2" ] && echo "- ${PRINCIPLE_2}"
  echo "- No hardcoded secrets — use environment variables"
  echo "- Validate all inputs at system boundaries"
  echo ""
  echo "---"
  echo ""
  echo "## Naming Conventions"
  echo ""
  echo "| Thing | Convention | Example |"
  echo "|-------|-----------|---------|"
  case "$PROJECT_LANG" in
    TypeScript*|JavaScript*|typescript*|javascript*)
      echo "| Functions | camelCase verb | \`getUser\`, \`createOrder\` |"
      echo "| Classes / Types | PascalCase | \`UserRecord\`, \`ApiResponse\` |"
      echo "| Constants | UPPER_SNAKE_CASE | \`MAX_RETRY_COUNT\` |"
      echo "| Files | kebab-case | \`user-service.ts\` |"
      ;;
    Python*|python*)
      echo "| Functions | snake_case verb | \`get_user\`, \`create_order\` |"
      echo "| Classes | PascalCase | \`UserRecord\`, \`ApiResponse\` |"
      echo "| Constants | UPPER_SNAKE_CASE | \`MAX_RETRY_COUNT\` |"
      echo "| Files | snake_case | \`user_service.py\` |"
      ;;
    Go*|go*)
      echo "| Exported identifiers | PascalCase | \`GetUser\`, \`UserRecord\` |"
      echo "| Unexported identifiers | camelCase | \`parseToken\` |"
      echo "| Files | snake_case | \`user_service.go\` |"
      ;;
    *)
      echo "| Functions | camelCase verb | \`getUser\`, \`createOrder\` |"
      echo "| Types / Classes | PascalCase | \`UserRecord\` |"
      echo "| Constants | UPPER_SNAKE_CASE | \`MAX_RETRY_COUNT\` |"
      ;;
  esac
  echo ""
  echo "---"
  echo ""
  echo "## Testing Philosophy"
  echo ""
  echo "- Test behaviour, not implementation — tests should survive refactors"
  echo "- One assertion concept per test"
  echo "- 80% coverage minimum"
  echo ""
  echo "---"
  echo ""
  echo "## Anti-Patterns — Never Do These"
  echo ""
  echo "| Pattern | Why | Do This Instead |"
  echo "|---------|-----|----------------|"
  echo "| ${ANTIPATTERN_1} | Causes security or maintenance issues | See core principles above |"
  echo "| \`console.log\` / \`print\` in production | Leaks internals | Use the structured logger |"
  echo ""
  echo "---"
  echo ""
  echo "## Code Review Checklist (project-specific)"
  echo ""
  echo "- [ ] New endpoints have rate limiting"
  echo "- [ ] Database queries use parameterised inputs"
  echo "- [ ] Error messages do not expose stack traces to clients"
  echo "- [ ] New environment variables are added to \`.env.example\`"
} > CODING_STANDARDS.md
ok "CODING_STANDARDS.md"

# --- docs/ai/domain.md ---
if [ -f "docs/ai/domain.md" ]; then
  sed_i "1s|# Agent Domain Guide|# Agent Domain Guide — $(E "$PROJECT_NAME")|" "docs/ai/domain.md"
  ok "docs/ai/domain.md"
fi

# --- .claude/rules/project.md ---
if [ -f ".claude/rules/project.md" ]; then
  sed_i "s|\[Project Name\]|$(E "$PROJECT_NAME")|g" ".claude/rules/project.md"
  [ "$PROJECT_LANG" != "TBD" ] && sed_i "s|\[e\.g\. TypeScript / Python\]|$(E "$PROJECT_LANG")|" ".claude/rules/project.md"
  [ -n "$FRAMEWORK" ] && sed_i "s|\[e\.g\. Next\.js / FastAPI\]|$(E "$FRAMEWORK")|" ".claude/rules/project.md"
  [ -n "$PKG_MANAGER" ] && sed_i "s|\[e\.g\. npm / pnpm / pip\]|$(E "$PKG_MANAGER")|" ".claude/rules/project.md"
  ok ".claude/rules/project.md"
fi

# --- docs/ai/triage-labels.md ---
if [ -f "docs/ai/triage-labels.md" ]; then
  sed_i "s|\[Add your areas here\]|Add area labels once feature areas are defined (e.g. area: auth, area: api)|" \
    "docs/ai/triage-labels.md"
  ok "docs/ai/triage-labels.md"
fi

# --- docs/ai/issue-tracker.md ---
if [ "$PROVIDER" = "bitbucket" ] && [ -f "docs/ai/issue-tracker-bitbucket.md" ]; then
  # Extract workspace from VC_TEAM (e.g. "my-workspace/engineering" -> "my-workspace")
  BB_WORKSPACE="${VC_TEAM%%/*}"
  sed_i \
    -e "s|\[bitbucket-workspace\]|$(E "$BB_WORKSPACE")|g" \
    -e "s|\[repo-slug\]|$(E "$PROJECT_NAME")|g" \
    "docs/ai/issue-tracker-bitbucket.md"
  cp "docs/ai/issue-tracker-bitbucket.md" "docs/ai/issue-tracker.md"
  rm "docs/ai/issue-tracker-bitbucket.md"
  ok "docs/ai/issue-tracker.md (Bitbucket)"
else
  [ -f "docs/ai/issue-tracker-bitbucket.md" ] && rm "docs/ai/issue-tracker-bitbucket.md"
fi

# --- .claude/context/last-session.md ---
LAST_SESSION_FILE=".claude/context/last-session.md"
if [ -f "$LAST_SESSION_FILE" ]; then
  cat > "$LAST_SESSION_FILE" << EOF
# Last Session

> This file is written by \`/save-session\` and read by \`/prime\`.
> It is committed to git so the whole team benefits from session continuity.

## Date
$(date +%Y-%m-%d) — initial setup

## Branch
main

## What was done
- Project initialised from team-starter template
- CLAUDE.md, LICENSE, SECURITY.md, CODEOWNERS filled in
- PROJECT_REF.md, CONTEXT.md, CODING_STANDARDS.md generated
- Git identity hook installed

## Files changed
- CLAUDE.md
- LICENSE
- SECURITY.md
- PROJECT_REF.md
- CONTEXT.md
- CODING_STANDARDS.md
- $([ "$PROVIDER" = "bitbucket" ] && echo ".bitbucket/CODEOWNERS" || echo ".github/CODEOWNERS")

## Open threads
- None

## Next steps
- Fill in PROJECT_REF.md data models as you build
- Fill in CONTEXT.md Avoid/Related fields and Relationships
- Fill in .env secrets
- Run \`/prime\` to load project context
- Run \`/create-plan\` before starting your first feature
EOF
  ok ".claude/context/last-session.md"
fi

# --- .env ---
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
  cp .env.example .env
  ok ".env created from .env.example (add your secrets)"
fi

# --- Git hooks ---
# Hook goes into the project-root .git/hooks/ — Option B: one repo for config + code
if [ -f "scripts/check-git-identity.sh" ]; then
  if [ -d ".git" ]; then
    mkdir -p .git/hooks
    cp scripts/check-git-identity.sh .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    ok "git identity pre-commit hook installed in .git/hooks/"
  else
    warn ".git not found -- git identity hook not installed."
    echo "  Run 'git init' at the project root, then re-run setup to install it."
  fi
fi

# --- Cleanup ---
if [ -f "START-HERE.md" ]; then
  rm START-HERE.md
  ok "START-HERE.md removed"
fi

# ─── Done ──────────────────────────────────────────────────────────────────

EXISTING_REPO=false
[ ${#SRC_FILES[@]} -gt 0 ] && EXISTING_REPO=true

echo ""
echo -e "${BOLD}${GREEN}Setup complete.${RESET}"
echo ""

if [ "$EXISTING_REPO" = true ]; then
  echo "Existing source files detected in src/ — listed in PROJECT_REF.md."
  echo "Run /update-project-ref in Claude Code to have Claude fill in descriptions."
  echo ""
fi

echo "Still needs your attention:"
echo "  PROJECT_REF.md    — add data models and API endpoints as you build"
echo "  CONTEXT.md        — add Avoid/Related for each term; fill Relationships"
echo "  .env              — fill in real secrets"
echo "  docs/ai/triage-labels.md — run 'gh label list' and confirm label strings"
echo ""

# ─── ralph-loop plugin note ───────────────────────────────────────────────────
if command -v claude >/dev/null 2>&1 && claude plugin list 2>/dev/null | grep -q "ralph"; then
  : # plugin installed, no action needed on Mac/Linux
else
  echo "Optional: install the ralph-loop plugin for autonomous iteration loops."
  echo "  Run: claude plugin install ralph-loop   (or /plugin inside Claude Code)"
  echo "  Then see /ralph for usage and prompt templates."
  echo ""
fi

echo "Open Claude Code and run:  /prime"
echo ""
echo "When ready:"
echo "  git add -A && git commit -m \"chore: initialise project from team-starter template\""
echo ""
