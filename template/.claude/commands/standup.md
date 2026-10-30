---
description: Generate a standup summary from recent git activity and open PRs
---

# /standup

Generate a standup summary for today.

## Steps

1. Get the current date and determine the last working day (skip weekends)
2. Run `git log --oneline --since="yesterday 6am" --until="now" --all` to get commits
   - If it is Monday, use `--since="friday 6am"` instead
3. Run `gh pr list --state open --json number,title,author,reviewDecision,url` to get open PRs
4. Run `gh pr list --state merged --search "merged:>yesterday" --json number,title,url` to get recently merged PRs
5. Build the summary in this format:

---

## Standup — [Date]

### Yesterday / Since Last Session
[Group commits by type — feat, fix, chore, etc. Write one plain-English sentence per group, not a raw commit list.]

### Today
[Leave blank — fill in yourself]

### Blockers
[Leave blank — fill in yourself]

### Open PRs
[List open PRs with author and review status]

### Recently Merged
[List PRs merged since last standup]

---

6. If there are no commits, say so clearly — do not invent activity
7. Keep descriptions plain English, not git commit messages verbatim
