# Issue Tracker — Agent Reference

> Exact CLI commands for every GitHub issue and PR operation in this repo.
> Use these verbatim. Do not improvise gh syntax.

## Reading Issues

```bash
# List open issues
gh issue list --state open --limit 20

# Read a specific issue
gh issue view 123

# List issues by label
gh issue list --label "bug" --label "high-priority"

# Search issues
gh issue list --search "authentication"
```

## Creating Issues

```bash
# Create a bug report
gh issue create \
  --title "fix: <short description>" \
  --body "<description>" \
  --label "bug"

# Create a feature request
gh issue create \
  --title "feat: <short description>" \
  --body "<description>" \
  --label "enhancement"
```

## Updating Issues

```bash
# Add a comment
gh issue comment 123 --body "your comment here"

# Apply labels
gh issue edit 123 --add-label "in-progress"

# Remove a label
gh issue edit 123 --remove-label "needs-triage"

# Close an issue
gh issue close 123 --comment "Fixed in PR #456"

# Reopen an issue
gh issue reopen 123
```

## Pull Requests

```bash
# List open PRs
gh pr list --state open

# Read a PR
gh pr view 456

# Check CI status
gh pr checks 456

# Merge a PR (squash)
gh pr merge 456 --squash --delete-branch
```

## Labels Used in This Repo

See `triage-labels.md` for the full label mapping.
