---
description: Run an autonomous iterative loop using the ralph-loop plugin. Claude works on the task repeatedly until the completion promise is output or the iteration limit is reached.
---

# /ralph

Run an autonomous loop on: $ARGUMENTS

Requires the ralph-loop plugin. Install via: `claude plugin install ralph-loop` in a terminal (or run `/plugin` inside Claude Code and choose `ralph-loop`)

---

## Usage

```
/ralph-loop "<your prompt>" --completion-promise "<SIGNAL>" --max-iterations <n>
```

To cancel: stop the session (Ctrl+C in the terminal, or close the Claude panel / Claude Code). The ralph-loop plugin may also provide its own cancel command — run `/help` after install to see what the plugin ships.

---

## Writing a good ralph-loop prompt

A well-structured prompt has four parts:

**1. The task** — what to build or fix, stated clearly
**2. The context** — which files or standards to consult (`CLAUDE.md`, `CODING_STANDARDS.md`, plan file, etc.)
**3. The loop instruction** — what to check and repeat each iteration
**4. The completion promise** — the exact string to output when truly done

### Template

```
/ralph-loop "<Task description>.

Context: read <relevant files> before starting.
Each iteration: <what to check/run/verify>.
Do not output the completion promise until <final condition>.
Output <promise>SIGNAL</promise> when done." --completion-promise "SIGNAL" --max-iterations 25
```

---

## Common patterns

### TDD loop
```
/ralph-loop "Apply TDD to: <feature>.
Read CODING_STANDARDS.md first.
Each iteration: write the next failing test, implement minimum code to pass, refactor.
Run all tests after each change.
Output <promise>ALL_GREEN</promise> only when all tests pass and coverage meets the project minimum." --completion-promise "ALL_GREEN" --max-iterations 30
```

### Plan execution
```
/ralph-loop "Execute the plan at docs/plans/<name>.md.
Work through each step in order. Run tests and validate success criteria after each phase.
Stop and report if blocked rather than improvising.
Output <promise>IMPLEMENTED</promise> only when all steps are complete and all success criteria pass." --completion-promise "IMPLEMENTED" --max-iterations 40
```

### Bug fix loop
```
/ralph-loop "Fix the failing tests in <file or suite>.
Each iteration: read the failure output, identify the root cause, apply the minimal fix, re-run tests.
Do not suppress or skip tests.
Output <promise>FIXED</promise> only when the full suite is green." --completion-promise "FIXED" --max-iterations 20
```

---

## Safety rules

- Always set `--max-iterations` — prevents runaway loops
- The completion promise must be specific and unlikely to appear accidentally
- Include "stop and report if blocked" in the prompt — prevents Claude from improvising past a real obstacle
- Review the git diff after the loop completes before committing
