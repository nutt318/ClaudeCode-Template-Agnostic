---
description: Update PROJECT_REF.md to reflect the current state of the codebase
---

# /update-project-ref

Keep PROJECT_REF.md accurate by comparing it against recent code changes.

## Steps

1. Read `PROJECT_REF.md` fully
2. Run `git log --oneline -20` to see recent commits
3. For each significant change in the commit history, check whether PROJECT_REF.md reflects it:

### Key files table
- Are all key files still at the paths listed?
- Have any new key files been added that should be listed?
- Have any listed files been renamed, moved, or deleted?

### Data models
- Have any models, schemas, or types changed significantly?
- Have fields been added, removed, or renamed?

### API endpoints
- Have any endpoints been added, removed, or changed?
- Have any response shapes changed?

### External services
- Have any new third-party services been integrated?
- Have any services been removed or swapped?

### Technical debt
- Have any known issues been fixed? Remove them.
- Have any new known issues been introduced? Add them.

4. Update PROJECT_REF.md with accurate information for anything that has drifted
5. Do not remove sections — replace stale content with current content
6. Report what was updated with a one-line summary per change

## When to run

- After completing a significant feature
- After any data model or API change
- At the end of a sprint or milestone
- When `/prime` produces a summary that feels out of date
