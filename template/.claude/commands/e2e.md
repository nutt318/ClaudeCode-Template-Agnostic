---
description: Generate and run end-to-end tests for critical user flows
---

# /e2e

Generate and run E2E tests for: $ARGUMENTS (or all critical flows if no argument given)

## Critical flows to always cover

Before generating tests, read `CLAUDE.md` for the project's defined critical flows.
If none are defined, default to:
1. The primary user onboarding or sign-up flow
2. The core action a user takes (the thing the app exists to do)
3. Any payment, data submission, or destructive action

## Workflow

### 1. Identify flows to test

List the flows you will cover. For each:
- What is the entry point? (URL, screen, trigger)
- What actions does the user take?
- What is the expected outcome?

### 2. Generate test files

Write tests using the project's E2E framework (check `CLAUDE.md` or `src/` for the configured tool — Playwright, Cypress, etc.).

Follow this structure per test:
```
describe("[Flow name]", () => {
  it("[specific behaviour]", async () => {
    // Navigate to entry point
    // Perform user actions
    // Assert expected outcome
  })
})
```

Rules:
- No `sleep()` or arbitrary waits — use deterministic waits (waitForSelector, waitForURL, etc.)
- Assert end state, not intermediate steps
- Each test must be runnable independently (no shared state between tests)

### 3. Run the tests

Run the E2E suite:
```
[your e2e command from CLAUDE.md]
```

### 4. Report results

For each test:
- PASS — note it
- FAIL — show the error, the failing assertion, and a screenshot path if available

For any failures, identify whether the issue is:
- A bug in the application (file a bug)
- A flaky test (fix the wait strategy)
- A test against wrong expected behaviour (update the test)

### 5. On success

Confirm all critical flows pass and the E2E suite is green.
If this is a pre-release check, confirm the flows in `CLAUDE.md` are all covered.
