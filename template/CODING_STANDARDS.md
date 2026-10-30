# Coding Standards

> Reference this file in agent prompts with @CODING_STANDARDS.md
> to ensure standards are applied regardless of global rule installation.
>
> Keep this file specific to THIS project. Universal standards live in CLAUDE.md.

---

## Core Principles

- [e.g. Prefer pure functions over stateful classes for business logic]
- [e.g. All database access goes through the repository layer — no direct queries in controllers]
- [e.g. Errors are values — use Result types, not thrown exceptions]

---

## Naming Conventions

| Thing | Convention | Example |
|-------|-----------|---------|
| [e.g. API route handlers] | [e.g. verbNoun] | [e.g. `getUser`, `createOrder`] |
| [e.g. Database models] | [e.g. PascalCase singular] | [e.g. `UserRecord`] |
| [e.g. React components] | [e.g. PascalCase] | [e.g. `UserProfileCard`] |
| [e.g. Utility functions] | [e.g. camelCase verb] | [e.g. `formatCurrency`] |

---

## Testing Philosophy

- [e.g. Test behaviour, not implementation — tests should not break on refactors]
- [e.g. One assertion concept per test — split tests rather than stacking expects]
- [e.g. Integration tests use a real database — never mock the DB layer]
- [e.g. E2E tests cover the three critical flows: sign up, core action, checkout]

---

## Anti-Patterns — Never Do These

| Pattern | Why | Do This Instead |
|---------|-----|----------------|
| [e.g. `any` in TypeScript] | [Defeats type safety] | [Use `unknown` and narrow] |
| [e.g. Fetching in components] | [Untestable, no caching] | [Use the data layer / query hooks] |
| [e.g. `console.log` in production] | [Leaks internals] | [Use the structured logger] |

---

## Code Review Checklist (project-specific)

Before marking a PR ready:

- [ ] [e.g. New endpoints have rate limiting]
- [ ] [e.g. Database queries use parameterised inputs]
- [ ] [e.g. Error messages do not expose stack traces to clients]
- [ ] [e.g. New environment variables are added to `.env.example`]

---

> Update this file when the team makes a new standards decision.
> Reference it from agent prompts as: @CODING_STANDARDS.md
