# Issue Tracker — Agent Reference (Bitbucket)

> Exact API commands for every Bitbucket issue and PR operation in this repo.
> Use these verbatim. Do not improvise API syntax.
> Authentication uses a Bitbucket API token (not a password).

## Auth Setup (run once per shell session)

```bash
export BB_USER="[bitbucket-email]"
export BB_TOKEN="[bitbucket-api-token]"
export BB_WORKSPACE="[bitbucket-workspace]"
export BB_REPO="[repo-slug]"
export BB_API="https://api.bitbucket.org/2.0/repositories/$BB_WORKSPACE/$BB_REPO"
```

Generate an API token at: https://id.atlassian.com/manage-profile/security/api-tokens
Use your **email address** with the token — not your username.

---

## Reading Issues

```bash
# List open issues
curl -s -u "$BB_USER:$BB_TOKEN" \
  "$BB_API/issues?q=state=\"open\"" | jq '.values[] | {id, title, state}'

# Read a specific issue
curl -s -u "$BB_USER:$BB_TOKEN" \
  "$BB_API/issues/123" | jq '{id, title, state, content}'

# List issues by component (label equivalent)
curl -s -u "$BB_USER:$BB_TOKEN" \
  "$BB_API/issues?q=component.name=\"bug\"" | jq '.values[] | {id, title}'

# Search issues by title
curl -s -u "$BB_USER:$BB_TOKEN" \
  "$BB_API/issues?q=title~\"authentication\"" | jq '.values[] | {id, title}'
```

## Creating Issues

```bash
# Create a bug report
curl -s -u "$BB_USER:$BB_TOKEN" \
  -X POST "$BB_API/issues" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "fix: <short description>",
    "content": { "raw": "<description>" },
    "kind": "bug",
    "priority": "major"
  }'

# Create a feature request
curl -s -u "$BB_USER:$BB_TOKEN" \
  -X POST "$BB_API/issues" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "feat: <short description>",
    "content": { "raw": "<description>" },
    "kind": "enhancement",
    "priority": "minor"
  }'
```

## Updating Issues

```bash
# Add a comment
curl -s -u "$BB_USER:$BB_TOKEN" \
  -X POST "$BB_API/issues/123/comments" \
  -H "Content-Type: application/json" \
  -d '{ "content": { "raw": "your comment here" } }'

# Close an issue (resolve)
curl -s -u "$BB_USER:$BB_TOKEN" \
  -X PUT "$BB_API/issues/123" \
  -H "Content-Type: application/json" \
  -d '{ "status": "resolved" }'

# Reopen an issue
curl -s -u "$BB_USER:$BB_TOKEN" \
  -X PUT "$BB_API/issues/123" \
  -H "Content-Type: application/json" \
  -d '{ "status": "open" }'
```

## Pull Requests

```bash
# List open PRs
curl -s -u "$BB_USER:$BB_TOKEN" \
  "$BB_API/pullrequests?state=OPEN" | jq '.values[] | {id, title, source}'

# Read a PR
curl -s -u "$BB_USER:$BB_TOKEN" \
  "$BB_API/pullrequests/456" | jq '{id, title, state, description}'

# Create a PR
curl -s -u "$BB_USER:$BB_TOKEN" \
  -X POST "$BB_API/pullrequests" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "<PR title>",
    "description": "<description>",
    "source": { "branch": { "name": "feat/your-branch" } },
    "destination": { "branch": { "name": "main" } },
    "close_source_branch": true
  }'

# Add a comment to a PR
curl -s -u "$BB_USER:$BB_TOKEN" \
  -X POST "$BB_API/pullrequests/456/comments" \
  -H "Content-Type: application/json" \
  -d '{ "content": { "raw": "your comment here" } }'

# Merge a PR (squash)
curl -s -u "$BB_USER:$BB_TOKEN" \
  -X POST "$BB_API/pullrequests/456/merge" \
  -H "Content-Type: application/json" \
  -d '{ "merge_strategy": "squash", "close_source_branch": true }'
```

## Components (Label Equivalent)

```bash
# List all components for this repo
curl -s -u "$BB_USER:$BB_TOKEN" \
  "$BB_API/components" | jq '.values[] | {id, name}'
```

See `triage-labels.md` for this repo's component mapping.
