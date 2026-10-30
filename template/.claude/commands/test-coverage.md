---
description: Check test coverage and identify undertested areas
---

# /test-coverage

Check test coverage for: $ARGUMENTS (or the whole project if no argument given)

## Steps

1. Run the coverage command from `CLAUDE.md`:
   ```
   [your coverage command]
   ```

2. Parse the output and report:
   - **Overall coverage %** — pass (≥80%) or fail (<80%)
   - **Files below 80%** — list each with its current coverage %
   - **Uncovered lines** — for files furthest from the threshold, show which lines have no coverage

3. For each file below 80%, identify WHY it is undertested:
   - Missing happy path tests?
   - Missing error/edge case tests?
   - Dead code that should be removed?
   - Code that is difficult to test (side effects, external deps)?

4. Recommend specific tests to add — one concrete test description per gap:
   ```
   Add: "returns 404 when user not found" in src/handlers/user.test.ts
   Add: "throws when database connection fails" in src/lib/db.test.ts
   ```

5. If coverage is already ≥80% everywhere, confirm it and identify any areas that are covered but weakly tested (happy path only, no edge cases).

## Coverage thresholds

| Level | Coverage | Action |
|-------|---------|--------|
| Passing | ≥80% | No action required |
| Warning | 60–79% | Add tests before next PR |
| Failing | <60% | Block — add tests before merging |

## Notes

- Coverage % alone does not mean tests are good — a test that does not assert anything can still count as covered
- Prioritise testing business logic and error paths over boilerplate
- Untested code in `src/` is higher priority than untested code in config or scripts
