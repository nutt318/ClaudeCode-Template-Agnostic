---
description: Create a Product Requirements Prompt — a structured document giving Claude everything needed to implement a feature end-to-end
---

# /create-prp

Create a Product Requirements Prompt for: $ARGUMENTS

A PRP is more implementation-ready than a plan. It captures user intent, acceptance criteria,
technical constraints, and edge cases in one document Claude can execute against directly.

## Steps

1. Clarify the job to be done — what user problem does this solve?
2. Read relevant existing code and context files
3. Check .claude/context/ for constraints
4. Check docs/adr/ for prior decisions

## PRP Format

Save to docs/plans/prp-[feature-name].md:

```
# PRP: [Feature Name]
Status: Draft | Ready | In Progress | Done

## Job To Be Done
As a [user type], I want to [action] so that [outcome].

## Acceptance Criteria
- [ ] [Specific, testable outcome]
- [ ] [Specific, testable outcome]
- [ ] [Edge case handled]

## Technical Context
- Relevant files: [list with paths]
- Constraints: [from .claude/context/gotchas.md or architecture.md]
- Patterns to follow: [from CLAUDE.md Key Patterns]

## Out of Scope
- [What this explicitly does NOT cover]

## Implementation Notes
[Anything non-obvious Claude needs to know before starting]

## Test Cases
- Happy path: [describe]
- Edge cases: [describe]
- Error cases: [describe]
```

A good PRP is specific enough that Claude can implement it without asking clarifying questions.
