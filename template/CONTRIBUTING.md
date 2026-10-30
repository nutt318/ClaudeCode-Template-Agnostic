# Contributing

## Getting Started

1. **Configure your git identity** — required before your first commit:
   ```bash
   git config --global user.name "Your Full Name"
   git config --global user.email "you@yourcompany.com"
   ```
2. Work through `docs/onboarding-checklist.md` — covers environment setup, Claude Code setup, and your first small change
3. Check open issues for something to work on, or open a new one first

## Workflow

1. **Discuss first** — for anything non-trivial, open an issue before writing code
2. **Branch** — pull latest then create a feature branch:
   ```bash
   git pull origin main
   git checkout -b feat/your-feature
   ```
   Or run `/new-branch` in Claude Code — it handles both steps and suggests a name.
3. **Plan** — run `/create-jtbd` then `/create-prp` for any feature with design decisions
4. **Implement** — use `/implement` to execute your plan
5. **Review** — run `/code-review` and `/security-review` before opening a PR
6. **PR** — open a pull request using the PR template; link the plan doc if one was created

## Commit Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add user authentication
fix: handle null response from payment API
refactor: extract validation logic into shared util
docs: update API endpoint reference in PROJECT_REF.md
test: add coverage for edge cases in billing module
```

## Code Standards

All standards are documented in `CLAUDE.md`. Key points:
- No hardcoded secrets — environment variables only
- Tests required for new features — 80% coverage minimum
- Follow the Key Patterns section in `CLAUDE.md` for this project
- Update `PROJECT_REF.md` if you change data models, APIs, or key files
- Update `CHANGELOG.md` for any user-visible changes

## Questions

Open a discussion or issue — we prefer async communication.

---

## Optional: Pre-commit Formatting (JS/TS projects)

For JavaScript and TypeScript projects, add Husky + lint-staged to enforce formatting on staged files at commit time:

```bash
cd src
npm install --save-dev husky lint-staged
npx husky init
echo "npx lint-staged" > .husky/pre-commit
```

Add to `src/package.json`:
```json
"lint-staged": {
  "*.{ts,tsx,js,jsx}": ["prettier --write", "eslint --fix"],
  "*.{json,md,css}": ["prettier --write"]
}
```

This runs alongside the git identity check already installed by `make install`.

---

## Optional: Versioned Releases (published packages only)

If this project publishes to npm, use Changesets for changelog and version management:

```bash
cd src
npm install --save-dev @changesets/cli
npx changeset init
```

Workflow:
1. Run `npx changeset` after each PR to describe the change
2. CI opens a "Version Packages" PR that batches all pending changesets
3. Merging that PR publishes to npm automatically

For application projects that do not publish to npm, stick with `CHANGELOG.md` and `/add-to-changelog`.