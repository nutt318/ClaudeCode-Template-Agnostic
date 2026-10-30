# Recommended ECC Setup (optional)

[everything-claude-code (ECC)](https://github.com/affaan-m/everything-claude-code) is an optional,
machine-wide add-on that gives every Claude Code session extra skills, agents, commands and rules.
This template works without it. This page lists a small, consistent set so every project on every
machine gets the same tools, instead of installing everything.

> **Tested against ECC v2.2.3.** The commands below pin that version. To upgrade, change the tag,
> re-read ECC's `CHANGELOG.md`, and re-run the install steps. Skill names and installer flags have
> changed between releases.

## Why not install everything?

ECC ships ~290 skills. Every installed skill's name and description is loaded into context at the
start of each session, so a full install costs context on every task, and many skills overlap or
target niche domains. Install a baseline, add what your stack needs, and skip the rest.

## 1. Install the baseline

Clone ECC at the pinned tag, outside any project, and install the `minimal` profile (rules, agents,
commands, and ~47 workflow skills — **no hooks**):

```bash
# Mac/Linux
git clone --branch v2.2.3 https://github.com/affaan-m/everything-claude-code.git ~/Projects/everything-claude-code
cd ~/Projects/everything-claude-code
./install.sh --profile minimal --target claude --dry-run   # preview what will be written
./install.sh --profile minimal --target claude
```

```powershell
# Windows
git clone --branch v2.2.3 https://github.com/affaan-m/everything-claude-code.git "$env:USERPROFILE\Projects\everything-claude-code"
cd "$env:USERPROFILE\Projects\everything-claude-code"
.\install.ps1 --profile minimal --target claude --dry-run
.\install.ps1 --profile minimal --target claude
```

Skills must end up directly under `~/.claude/skills/<skill-name>/SKILL.md` for Claude Code to find
them. A nested `skills/ecc/<name>/` layout (from older ECC installs) is not discovered — re-running
the installer migrates it.

### Already in the baseline

`tdd-workflow`, `verification-loop`, `e2e-testing`, `strategic-compact`, `git-workflow`,
`architecture-decision-records`, `error-handling`, `skill-stocktake`, `skill-scout`,
`config-gc`, `context-budget`, `codebase-onboarding`, plus others. Skip `continuous-learning`
(deprecated — `continuous-learning-v2` replaces it).

## 2. Add the core extras

These are useful on almost any project and are **not** in the baseline:

| Skill | Use it for |
|-------|-----------|
| `security-review` | Auth, input handling, secrets, API endpoints |
| `coding-standards` | Cross-project naming/readability baseline |
| `api-design` | REST resource naming, status codes, pagination, versioning |
| `database-migrations` | Safe schema changes and rollbacks |
| `deployment-patterns` | CI/CD, health checks, rollbacks |
| `docker-patterns` | Containers, Compose, container security |
| `search-first` | Look for existing libraries before writing custom code |
| `documentation-lookup` | Current library docs via the Context7 MCP (enabled in `.mcp.json`) |

```bash
./install.sh --target claude --skills security-review,coding-standards,api-design,database-migrations,deployment-patterns,docker-patterns,search-first,documentation-lookup
```

```powershell
.\install.ps1 --target claude --skills security-review,coding-standards,api-design,database-migrations,deployment-patterns,docker-patterns,search-first,documentation-lookup
```

Run with `--dry-run` first if you want to see the file plan.

## 3. Add only your stack

Pick the rows that match the project. Each language/framework has layered skills — a baseline
(`tdd-workflow`, `verification-loop`) plus stack-specific ones. Install the stack ones only for
stacks you actually use.

| Stack | Skills |
|-------|--------|
| React / Next.js | `react-patterns`, `react-performance`, `frontend-patterns`, `nextjs-turbopack` |
| Vue / Nuxt | `vue-patterns`, `nuxt4-patterns`, `vite-patterns` |
| Node backend | `backend-patterns`, `nestjs-patterns`, `prisma-patterns` |
| Python | `python-patterns`, `python-testing` |
| FastAPI | `fastapi-patterns` |
| Django | `django-patterns`, `django-security`, `django-tdd`, `django-verification` |
| Go | `golang-patterns`, `golang-testing` |
| Rust | `rust-patterns`, `rust-testing` |
| Java / Spring Boot | `springboot-patterns`, `springboot-security`, `springboot-tdd`, `springboot-verification`, `java-coding-standards`, `jpa-patterns` |
| Kotlin | `kotlin-patterns`, `kotlin-testing` |
| .NET | `dotnet-patterns`, `csharp-testing` |
| Swift / iOS | `swiftui-patterns`, `swift-concurrency-6-2`, `swift-protocol-di-testing` |
| Flutter / React Native | `dart-flutter-patterns`, `react-native-patterns` |
| PHP / Laravel | `laravel-patterns`, `laravel-security`, `laravel-tdd`, `laravel-verification` |
| Ruby on Rails | `rails-patterns` |
| PostgreSQL / MySQL / Redis | `postgres-patterns`, `mysql-patterns`, `redis-patterns` |
| Kubernetes | `kubernetes-patterns` |
| Building MCP servers | `mcp-server-patterns` |

Language **rules** (coding style, testing, security) install separately from skills. Start with
`rules/common` plus the one language you use, copied into `~/.claude/rules/ecc/` — see ECC's README
("Choose only the components you need").

## 4. Skip these

- **Deprecated:** `continuous-learning` (use `continuous-learning-v2`) and `autonomous-loops`
  (kept for compatibility only — use `continuous-agent-loop`).
- **Overlapping orchestration skills** — `ralphinho-rfc-pipeline`, `dmux-workflows`, `team-builder`,
  `team-agent-orchestration`, `parallel-execution-optimizer`, `agentic-os`,
  `autonomous-agent-harness`. This template's `/ralph` and `/implement` already cover the common
  case; if you need more, start from `continuous-agent-loop`.
- **Research skills that need extra MCP servers** — ECC's `deep-research` needs firecrawl and exa
  MCPs and shares its name with Anthropic's own `deep-research` skill. Prefer Anthropic's, plus
  `search-first` and `documentation-lookup`.
- **Domain-specific skills** you have no use for: industry operations (logistics, customs, energy,
  billing), crypto/DeFi, prediction markets (`ito-*`), scientific databases, content/social
  marketing, and homelab/network skills. Install them per-project if a project needs them.
- **Per-framework skills for stacks you don't use** — the four-skill sets for Django, Spring Boot,
  Laravel and Quarkus are large.

## 5. Hooks (optional, off by default)

The baseline installs **no hooks**. ECC's hook runtime can add automatic checks, but it prompts more
and can slow sessions. Enable it only if you want it:

```bash
./install.sh --target claude --modules hooks-runtime --enable-hooks
export ECC_HOOK_PROFILE=standard                        # the default "strict" prompts aggressively
export ECC_DISABLED_HOOKS=pre:edit-write:gateguard-fact-force
```

```powershell
.\install.ps1 --target claude --modules hooks-runtime --enable-hooks
$env:ECC_HOOK_PROFILE = "standard"                      # add to $PROFILE to persist
$env:ECC_DISABLED_HOOKS = "pre:edit-write:gateguard-fact-force"
```

## Name collisions

ECC also installs user-level commands (`/plan`, `/code-review`, `/learn`, `/save-session`,
`/test-coverage`) that share names with this template's project commands. A project's
`.claude/commands/` takes precedence over the user-level ones, so inside a project created from this
template, the template's versions run.

## Keeping it current

Check ECC's releases every few months. To upgrade, `git fetch --tags`, check out the new tag,
review the changelog, and re-run the commands above. After upgrading, run the `skill-stocktake` skill to
audit for overlap and the `config-gc` skill to find stale config.
