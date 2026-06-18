# Triage Labels — Agent Reference

> Maps generic concept names to the actual label strings used in this GitHub repo.
> Use the "GitHub Label" column exactly when calling `gh issue edit --add-label`.
> Update this file whenever labels are added, renamed, or removed in GitHub.

## Type Labels

| Concept | GitHub Label | When to Apply |
|---------|-------------|---------------|
| Bug | `bug` | Something is broken or behaving incorrectly |
| New feature | `enhancement` | New capability requested |
| Documentation | `documentation` | Docs need to be added or updated |
| Maintenance | `chore` | Refactor, dependency update, cleanup |
| Performance | `performance` | Speed or resource usage concern |
| Security | `security` | Vulnerability or security concern |

## Priority Labels

| Concept | GitHub Label | When to Apply |
|---------|-------------|---------------|
| Critical — blocks release | `priority: critical` | Data loss, security breach, outage |
| High — fix soon | `priority: high` | Major user-facing issue |
| Normal | `priority: medium` | Standard work item |
| Low — nice to have | `priority: low` | Minor or cosmetic |

## Status Labels

| Concept | GitHub Label | When to Apply |
|---------|-------------|---------------|
| Needs review | `needs-triage` | Newly opened, not yet assessed |
| In progress | `in-progress` | Someone is actively working on it |
| Blocked | `blocked` | Cannot proceed — add a comment explaining why |
| Needs more info | `needs-info` | Insufficient detail to act on |
| Won't fix | `wontfix` | Acknowledged but will not be addressed |
| Duplicate | `duplicate` | Another issue covers this |

## Area Labels

> Add area labels specific to your project below.
> Example: `area: auth`, `area: billing`, `area: api`

| Concept | GitHub Label | When to Apply |
|---------|-------------|---------------|
| [Add your areas here] | | |

---

> Keep this in sync with the actual labels in GitHub Settings > Labels.
> Run `gh label list` to see current labels.
