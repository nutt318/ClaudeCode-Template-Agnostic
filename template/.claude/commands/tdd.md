---
description: Write tests first, then implement to make them pass. Supports autonomous looping via ralph-loop.
---

# /tdd

Apply test-driven development to: $ARGUMENTS

## Autonomous mode (recommended for well-defined features)

If you have the ralph-loop plugin installed, hand the full TDD cycle to Claude autonomously:

```
/ralph-loop "Apply TDD to: <feature description>.
Cycle: write a failing test → implement the minimum to pass → refactor → repeat.
Check CODING_STANDARDS.md for the project testing philosophy.
Run tests after every change. Output <promise>ALL_GREEN</promise> only when all tests pass and coverage meets the project minimum." --completion-promise "ALL_GREEN" --max-iterations 30
```

Use autonomous mode when the feature is well-defined and has automated test verification. Use the manual workflow below when the feature needs human judgment at each step.

---

## Manual workflow

### 1. Understand the requirement

Before writing anything:
- State in one sentence what behaviour you are implementing
- Identify the inputs, outputs, and edge cases
- Check `CODING_STANDARDS.md` for the project's testing philosophy

### 2. Write the test first (RED)

Write a failing test that describes the expected behaviour:
- Name it clearly: `it("returns empty array when no results match", ...)`
- Test one behaviour per test
- Use the AAA pattern: Arrange → Act → Assert
- Do NOT write any implementation yet

Run the test and confirm it fails with a meaningful error, not a syntax error.

### 3. Write the minimum implementation (GREEN)

Write the simplest code that makes the test pass:
- No premature abstractions
- No handling of cases not yet tested
- It is okay if the code looks naive at this stage

Run the test and confirm it passes.

### 4. Refactor (IMPROVE)

With the test passing as a safety net:
- Remove duplication
- Improve naming
- Extract helpers if the function is getting long
- Do NOT add new behaviour during refactor

Run the tests again and confirm they still pass.

### 5. Repeat

Add the next test for the next behaviour and repeat from step 2.

## Coverage check

After the feature is complete, verify coverage meets the project minimum:
- Run the coverage command from `CLAUDE.md`
- If below 80%, identify the untested paths and add tests

## When to stop

Stop adding tests when:
- All specified behaviours are covered
- All meaningful edge cases are covered
- Coverage meets the project minimum

Do not add tests for implementation details — only for observable behaviour.
