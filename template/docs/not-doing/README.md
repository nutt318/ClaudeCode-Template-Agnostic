# Out of Scope

This directory tracks features and approaches that were **explicitly decided against**.

## Why this exists

Without this, the same "should we build X?" question gets raised again — by teammates, by Claude, by new contributors. Each time, someone has to reconstruct the reasoning from memory or old Slack threads. This directory makes rejections durable and searchable.

## How to use it

When the team decides NOT to build something:

1. Copy `_template.md` to a new file: `feature-name.md`
2. Fill in the context, decision, and reasons
3. Commit it — the decision is now part of the repo history

When Claude or a team member proposes something that is out of scope:
- Point them to the relevant file in this directory
- If the situation has changed and the decision should be revisited, update or remove the file

## What belongs here

- Features explicitly discussed and rejected
- Architectural approaches considered and abandoned
- Third-party integrations evaluated and decided against
- Any "why don't we just..." question that has a real answer

## What does NOT belong here

- Vague "maybe someday" ideas — use `docs/plans/` or an issue
- Things that were never seriously considered
- Features on the roadmap but not yet started
