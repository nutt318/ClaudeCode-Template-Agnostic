---
description: Execute a plan created by /create-plan. Supports autonomous looping via ralph-loop.
---

# /implement

Execute the plan at: $ARGUMENTS

## Autonomous mode (recommended for plans with clear success criteria)

If you have the ralph-loop plugin installed, execute the plan autonomously:

```
/ralph-loop "Execute the plan at: <path to plan>.
Read the plan fully first. Work through each step in order.
Run tests and validate success criteria after each phase.
Do not skip steps or improvise around blockers — stop and report instead.
Output <promise>IMPLEMENTED</promise> only when all steps are complete, all success criteria are met, and tests pass." --completion-promise "IMPLEMENTED" --max-iterations 40
```

Use autonomous mode for plans marked Ready with automated verification. Use the manual phases below when the plan requires human review between phases or has external dependencies.

---

## Phase 1 - Understand

1. Read the plan file fully
2. Confirm status is Ready - if Draft, stop and flag for review
3. Verify all prerequisites exist
4. Check .claude/context/gotchas.md for anything relevant

## Phase 2 - Execute

Follow step-by-step tasks in order.
Complete each step fully before moving to the next.
If blocked, stop and report - do not improvise around it.

## Phase 3 - Validate

Run the validation checklist from the plan.
Confirm all success criteria are met and tests pass.

## Phase 4 - Close Out

1. Update plan status to Implemented
2. Add notes on anything that differed from the plan
3. Update docs/lessons.md if something notable was learned
4. Run /code-review before marking done
