# Lessons

A living record of what works and what does not in this project.
Claude updates this after sessions where something notable was learned via `/learn`.

---

## Format

```
## YYYY-MM-DD — Short title

**Context:** What were you trying to do?
**What happened:** What was surprising or non-obvious?
**Lesson:** What should the next person know?
```

---

## Examples

## 2026-01-15 — Environment variables not loaded in test runner

**Context:** Running integration tests locally after adding a new required env var.
**What happened:** Tests silently passed but produced wrong results. The env var was missing from `.env.test` but the code was falling back to `undefined` without throwing. Only caught when comparing output to production.
**Lesson:** Always add new required env vars to `.env.example`, `.env.test`, and the CI secrets in the same PR. Check that startup validation throws on missing values rather than defaulting to `undefined`.

---

<!-- Claude appends new lessons below this line via /learn -->
