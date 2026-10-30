---
description: Save session context so work can resume in the next session
---

# /save-session

Save the current session state before closing.

## Steps

1. Run `git status` and `git log --oneline -5` to capture the current branch and recent commits
2. Read `docs/lessons.md` to avoid duplicating entries
3. Write a session summary to `.claude/context/last-session.md` with:
   - **Date** — today's date
   - **Branch** — current git branch
   - **What was done** — 3-5 bullet points on completed work
   - **Files changed** — list of modified files
   - **Open threads** — anything unfinished or deferred
   - **Next steps** — concrete first action for the next session
4. If anything non-obvious was learned, append it to `docs/lessons.md`
5. If user-visible changes were made, remind the user to run `/add-to-changelog`
6. Confirm: "Session saved. Next session, run `/prime` to reload context."

## Output

The summary written to `.claude/context/last-session.md` is automatically loaded by `/prime` at the start of the next session.
