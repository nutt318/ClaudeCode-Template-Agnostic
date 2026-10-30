---
description: Run a dedicated security audit on the current codebase or a specific area
---

# /security-review

Run a security audit on: $ARGUMENTS (or the full codebase if no argument given)

## Checks to perform

### Secrets and credentials
- Search for hardcoded API keys, passwords, tokens, private keys
- Verify `.gitignore` covers all `.env` and secret files
- Check that `.env.example` contains no real values

### Input validation
- All user inputs validated at system boundaries (API routes, form handlers, file uploads)
- No unsanitised data passed to database queries, shell commands, or file paths
- SQL injection: parameterised queries used everywhere

### Authentication and authorisation
- All protected routes check authentication
- Authorisation checks exist for object-level access (not just route-level)
- Tokens expire and are invalidated on logout

### Dependencies
- Check for known vulnerabilities: `npm audit` / `pip-audit` / `go vuln`
- Flag any packages with critical CVEs

### API security
- Rate limiting on public endpoints
- Error messages do not leak internal details or stack traces
- CORS configured correctly

## Output format

Report findings grouped by severity:
- CRITICAL — must fix before merge
- HIGH — should fix before merge
- MEDIUM — fix in follow-up
- LOW — note for awareness
