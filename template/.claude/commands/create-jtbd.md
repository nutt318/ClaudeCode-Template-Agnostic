---
description: Define the Job To Be Done before starting any feature work — forces clarity on user intent
---

# /create-jtbd

Define the Job To Be Done for: $ARGUMENTS

Before writing any code or plan, answer these questions to ensure the feature solves the right problem.

## Steps

1. Interview the request — ask what the user is trying to accomplish, not what they are asking to build
2. Identify the functional, emotional, and social jobs
3. Define success from the user's perspective
4. Surface assumptions that need validation

## JTBD Format

Output a structured JTBD statement:

```
## Job Statement
When [situation/trigger],
I want to [motivation/goal],
So I can [expected outcome].

## Success Looks Like
- [Observable user outcome 1]
- [Observable user outcome 2]

## Assumptions to Validate
- [Thing we are assuming that could be wrong]

## Anti-Goals (what we are NOT solving)
- [Out of scope user need]
```

## Why this matters

Features built from JTBD statements are harder to gold-plate and easier to scope correctly.
Run this before /create-prp or /create-plan on any non-trivial feature.
