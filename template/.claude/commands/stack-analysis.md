---
description: Phase 2 of planning — analyze the Product Brief and recommend the right frontend, backend, and database for the project's requirements
---

# /stack-analysis

Analyze the Product Brief and recommend the right tech stack.

Read `docs/plans/discovery.md` first. If it does not exist, tell the user to run `/discover` first (or if this is a brand new project, `/prime` — the first-run setup includes the discovery conversation and creates this file automatically).

Also read `docs/adr/` for any prior architecture decisions that must be respected.

---

## Analysis — work through each dimension

Evaluate each category against the actual requirements in the brief. Do not default to your preferred stack — match technology to the specific constraints.

### Dimensions to analyze

**Frontend**
- Is a UI needed at all? (some projects are API-only)
- Does it need to be a web app, mobile app, or both?
- Are there real-time UI requirements? (live updates, websockets)
- What is the team's frontend experience?
- SSR/SSG needed for SEO? Or is SPA fine?
- Evaluate: React (Next.js/Vite), Vue (Nuxt), Svelte (SvelteKit), Angular, plain HTML/JS, mobile-native (React Native/Flutter), or none

**Backend**
- Does it need an API layer, or can a BFF/fullstack framework handle it?
- Are there CPU-intensive operations, streaming, or concurrency requirements?
- Team's backend experience?
- Compliance requirements that affect runtime choices?
- Evaluate: Node.js (Express/Fastify/Hono), Python (FastAPI/Django), Go (Gin/Chi), Rust, Java/Kotlin (Spring), Ruby (Rails), PHP (Laravel), or fullstack (Next.js, Nuxt, SvelteKit)

**Database**
- Is the data relational (structured, joins), document (flexible schema), or time-series/graph?
- Are ACID transactions required?
- What is the read/write ratio and data volume?
- Does compliance require specific database hosting?
- Evaluate: PostgreSQL, MySQL, SQLite (for local/small scale), MongoDB, DynamoDB, Supabase, PlanetScale, Redis (for caching/sessions), a combination

**Infrastructure and Hosting**
- Cloud provider preference or constraint?
- Serverless, containers, or VMs?
- CDN requirements?
- CI/CD requirements?

---

## Output — Stack Decision ADR

Save to `docs/adr/001-stack-decision.md`:

```markdown
# ADR 001 — Tech Stack Decision
Date: [today]
Status: Proposed
Decided by: Claude (stack-analysis) — confirm with team before locking in

## Context
[1–2 sentences from the Product Brief: what we're building and the key constraints that drive this decision]

## Decision

### Frontend: [Chosen technology]
**Why:** [2–3 sentences — specific requirements it satisfies]
**Alternatives considered:**
- [Alt A] — rejected because [specific reason tied to requirements]
- [Alt B] — rejected because [specific reason tied to requirements]

### Backend: [Chosen technology]
**Why:** [2–3 sentences]
**Alternatives considered:**
- [Alt A] — rejected because [reason]
- [Alt B] — rejected because [reason]

### Database: [Chosen technology]
**Why:** [2–3 sentences]
**Alternatives considered:**
- [Alt A] — rejected because [reason]
- [Alt B] — rejected because [reason]

### Infrastructure: [Hosting / deployment model]
**Why:** [1–2 sentences]

## Risks and Open Questions
- [Any assumptions that could change the recommendation]
- [Anything that needs team confirmation before committing]

## Consequences
- [What this stack enables or unlocks]
- [What it constrains or makes harder]

## Next Step
Update `CLAUDE.md` Tech Stack section with the chosen values, then run `/create-plan` to plan the implementation.
```

---

## After saving

Tell the user:

> "Stack Decision saved to `docs/adr/001-stack-decision.md`. Before moving on:
>
> 1. Review the decision and confirm you agree with the choices.
> 2. Update the **Tech Stack** section of `CLAUDE.md` with the chosen language, framework, database, and package manager.
> 3. Once CLAUDE.md is updated, run `/create-plan` to plan the implementation."
