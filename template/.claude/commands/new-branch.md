---
description: Pull latest from main and create a feature branch before starting work
---

# /new-branch

Create a properly-named feature branch before starting any task.

## Steps

### 1. Ask what we are working on

Ask the user:
> "What are you working on? Give me a short description and I will suggest a branch name."

Wait for their answer.

### 2. Suggest a branch name

Based on their description, suggest a branch name following this convention:

| Type of work | Prefix | Example |
|-------------|--------|---------|
| New feature | `feat/` | `feat/user-authentication` |
| Bug fix | `fix/` | `fix/null-response-payment` |
| Refactor | `refactor/` | `refactor/extract-validation` |
| Documentation | `docs/` | `docs/update-api-reference` |
| Tests | `test/` | `test/billing-edge-cases` |

Rules for the name:
- lowercase with hyphens only — no spaces, no slashes beyond the prefix
- 3–5 words maximum
- describes the work, not the ticket number

Present the suggestion and ask:
> "Suggested branch: `feat/your-feature-name` — use this, or tell me a different name."

### 3. Pull latest and create the branch

Once the name is confirmed, run:

```bash
git pull origin main
git checkout -b <confirmed-branch-name>
```

Confirm:
> "Branch `<name>` created from latest main. You are ready to start work."

### 4. Remind about the workflow

After branching, remind the user:
> "When your work is ready: run `/code-review`, then `/create-pr` to open a pull request."
