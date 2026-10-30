---
description: Phase 1 of planning — interview the user to build a complete Product Brief before any technical decisions are made
---

# /discover

Run a structured discovery interview for: $ARGUMENTS

Gather everything needed to understand the project before any technical decisions are made. Do not suggest technologies, frameworks, or architecture during this phase — the goal is to understand the *problem*, not the solution.

---

## Interview — ask each group in order, wait for answers before moving on

### Group 1 — The Vision

- What are you building? Describe it in plain English as if explaining to a non-technical person.
- What problem does it solve, and for whom?
- Why does this need to exist — what's the trigger or opportunity?
- What does success look like in 6 months?

### Group 2 — Users

- Who are the primary users? (internal team, public consumers, businesses, a mix?)
- What do they currently do instead? (manual process, competitor tool, nothing?)
- How many users do you expect at launch? At one year?
- Are there different user roles with different permissions?

### Group 3 — Core Features

- List the 5 most important things a user needs to be able to do.
- For each: is it a must-have for launch, or a nice-to-have?
- Are there any features that seem obvious but are explicitly out of scope?
- Are there any integrations with external tools or services? (payments, email, third-party APIs, etc.)

### Group 4 — Data and Compliance

- What data will the system store? (user accounts, files, transactions, analytics, etc.)
- Are there compliance or regulatory requirements? (GDPR, HIPAA, SOC 2, financial regulations, etc.)
- Who owns the data — can it be stored in the cloud, or must it stay on-premise?
- Any data residency requirements? (EU only, US only, etc.)

### Group 5 — Scale and Performance

- Roughly how much data will be stored? (MBs, GBs, TBs?)
- Are there real-time requirements? (live updates, chat, streaming?)
- Are there peak load patterns? (all-day steady, burst events, overnight batch?)
- What is the acceptable downtime tolerance? (best-effort, business hours, 24/7?)

### Group 6 — Constraints

- Is there any existing tech stack or infrastructure this must work with or within?
- What is the team size and primary technology experience? (e.g. 2 devs, mostly TypeScript)
- What is the expected timeline to first working version?
- Are there any hard budget or hosting constraints?
- Open source preference, or is commercial software fine?
- Any hard "never use X" rules already decided?

---

## Output — Product Brief

Save to `docs/plans/discovery.md`:

```markdown
# Product Brief — [Project Name]
Date: [today]
Status: Draft

## Vision
[One paragraph — what this is and why it exists]

## Problem Statement
[The specific problem being solved, for whom, and why now]

## Users
| User Type | Description | Volume Estimate |
|-----------|-------------|----------------|
| [type] | [description] | [at launch / at 1yr] |

## User Roles
[List roles and what each can do, or "Single role" if uniform]

## Core Features (Launch)
| # | Feature | Priority |
|---|---------|---------|
| 1 | [feature] | Must-have |
| 2 | [feature] | Must-have |
| 3 | [feature] | Nice-to-have |

## Out of Scope
- [Explicit exclusions]

## External Integrations
- [Service / API / tool — and how it's used, or "None"]

## Data Profile
- Types stored: [list]
- Estimated volume: [rough magnitude]
- Compliance: [GDPR / HIPAA / none / unknown]
- Hosting constraint: [cloud OK / on-premise / specific region]

## Scale and Performance
- Peak load pattern: [description]
- Real-time requirements: [yes/no — details]
- Uptime tolerance: [best-effort / business hours / 24/7]

## Constraints
- Existing tech: [any hard dependencies or "None"]
- Team: [size and primary experience]
- Timeline: [target for first working version]
- Budget/hosting: [any constraints or "Flexible"]
- Preferences: [open source / commercial / no preference]

## Success Criteria (6 months)
- [Observable, measurable outcome]
- [Observable, measurable outcome]
```

---

## After saving

Tell the user:

> "Product Brief saved to `docs/plans/discovery.md`. Run `/stack-analysis` next — I'll read the brief and recommend the right frontend, backend, and database for your requirements."
