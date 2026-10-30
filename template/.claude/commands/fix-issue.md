---
description: Implement a fix for a GitHub issue end-to-end
---

# /fix-issue

Fix GitHub issue: $ARGUMENTS

## Steps

1. Read the issue: `gh issue view $ARGUMENTS`
2. Run `/create-jtbd` to clarify the job to be done from the issue description
3. Check for related code: search the codebase for relevant files
4. Check `.claude/context/gotchas.md` for anything relevant
5. Run `/create-plan` or `/create-prp` to plan the fix
6. Create a branch: `git checkout -b fix/issue-$ARGUMENTS-[short-description]`
7. Run `/implement docs/plans/[plan-file].md` to execute the fix
8. Run `/code-review` and address any issues found
9. Run `/create-pr` to open a PR that closes the issue

## Notes

- The PR description should include `Closes #$ARGUMENTS`
- If the issue is unclear, comment on it asking for clarification before implementing
- For security-related issues, run `/security-review` as well
