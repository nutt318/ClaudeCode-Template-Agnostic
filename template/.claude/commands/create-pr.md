---
description: Create a pull request for the current branch with a generated description
---

# /create-pr

Create a pull request for the current branch.

## Steps

1. Check the current branch: `git branch --show-current`
2. Confirm there is no existing PR for this branch: `gh pr list --head $(git branch --show-current)`
3. Review all commits since branching from main: `git log --oneline main..HEAD`
4. Review the full diff: `git diff main..HEAD`
5. Draft a PR title and description using the PR template format from `.github/pull_request_template.md`
6. Link any related plan from `docs/plans/` if one exists for this work
7. Create the PR: `gh pr create --title "..." --body "..."`

## PR Title Format

Follow conventional commits format:
- `feat: add user authentication`
- `fix: handle null response from payment API`
- `refactor: extract validation into shared util`

## Notes

- Push the branch first if not already pushed: `git push -u origin $(git branch --show-current)`
- Default target branch is `main` — specify `--base` if different
- Add `--draft` flag if the work is not ready for review
