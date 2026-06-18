# Reference

Patterns, examples, and specs that Claude treats as the source of truth for this project.
When Claude generates code, it checks here first to match established conventions.

## What to put here

Commit things here when you want Claude to replicate a pattern exactly — not interpret or approximate it.

### Good candidates

| Type | Example filename | What it contains |
|------|-----------------|-----------------|
| Canonical code pattern | `api-response-pattern.ts` | The exact shape of your API response envelope |
| Example data structure | `user-record-example.json` | A real (or realistic) instance of a key data model |
| Third-party API spec | `stripe-webhook-payload.json` | The exact payload shape you receive from an external service |
| SQL conventions | `query-conventions.sql` | Example queries showing your preferred JOIN style, naming, etc. |
| Component pattern | `form-component-pattern.tsx` | A complete example of how forms are built in this codebase |
| Error format | `error-response-example.json` | What your error responses look like |

### What does NOT belong here

- Documentation about the project — that goes in `docs/` or `CONTEXT.md`
- Implementation plans — those go in `docs/plans/`
- Generated outputs — those go in `outputs/`
- Anything with real credentials or production data

## How Claude uses this

When you ask Claude to implement something similar to a file in `reference/`, it will read the relevant file and match the pattern. Reference this explicitly in prompts:

```
Implement a new endpoint following the pattern in reference/api-response-pattern.ts
```

Or Claude will discover it automatically via `/prime` if it scans the project root.
