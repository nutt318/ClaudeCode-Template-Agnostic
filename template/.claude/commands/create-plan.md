---
description: Create a detailed implementation plan before writing any code
---

# /create-plan

Create a thorough implementation plan for: $ARGUMENTS

## Instructions

Research and plan only - do not implement.

## Research Phase

1. Read all relevant existing code and context files
2. Identify what exists vs what needs to be built
3. Check .claude/context/ for architectural constraints and gotchas
4. Check docs/adr/ for prior decisions affecting this work

## Plan Format

Save to docs/plans/[feature-name].md with these sections:

- Status: Draft or Ready or In Progress or Implemented
- Overview: what this achieves and why
- Current State: what exists today, what is missing
- Proposed Changes: new files, modified files
- Design Decisions: choices made, alternatives considered
- Step-by-Step Tasks: ordered, concrete, unambiguous steps
- Validation Checklist: tests, review, docs
- Success Criteria: how we know it is done
