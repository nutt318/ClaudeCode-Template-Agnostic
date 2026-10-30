---
description: Extract lessons learned from this session and append them to docs/lessons.md
---

# /learn

Extract non-obvious lessons from this session and record them for the team.

## Steps

1. Read `docs/lessons.md` to see what is already recorded
2. Review what happened in this session:
   - What broke and why
   - What approach worked that was not obvious
   - Any gotchas, surprises, or hidden constraints discovered
   - Any tool or library behaviour that differed from documentation
   - Any patterns that should be reused or avoided
3. For each lesson worth keeping, check it is not already in `docs/lessons.md`
4. Append new lessons in this format:

```
## YYYY-MM-DD — <short title>

**Context:** What were you trying to do?
**What happened:** What was surprising or non-obvious?
**Lesson:** What should the next person know?
```

5. Skip anything obvious or already documented
6. Report how many lessons were added and their titles

## Good lessons to capture

- Workarounds for specific environment bugs
- Hidden constraints or invariants in the codebase
- Config or env var behaviour that is not documented
- Patterns that look wrong but are intentional
- Dependencies that behave differently than expected
- Sequences that must happen in a specific order
