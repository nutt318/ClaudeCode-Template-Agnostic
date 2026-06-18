# CONTEXT.md — Domain Glossary

> This file is the canonical vocabulary for this project.
> Claude reads it via `/prime`. Use it to resolve ambiguity before writing code, docs, or agent prompts.
> When you add a new domain concept, add it here first.

---

## Canonical Terms

Define every meaningful term the project uses. For each entry:
- **What it is** — one sentence definition
- **Avoid** — synonyms or phrasings the team should NOT use
- **Related** — other terms in this glossary it connects to

---

### [Term Name]

**Definition:** [One sentence. What is this thing in the context of this system?]

**Avoid:** [List synonyms or vague terms that cause confusion — e.g. "don't call this a 'user', call it a 'member'"]

**Related:** [Other terms in this glossary]

---

### [Term Name]

**Definition:** [...]

**Avoid:** [...]

**Related:** [...]

---

## Relationships

Describe how key concepts relate to each other. Use plain sentences or a simple diagram.

```
[ConceptA] owns many [ConceptB]
[ConceptB] belongs to one [ConceptA]
[ConceptC] is created by [ConceptA] and consumed by [ConceptB]
```

---

## Flagged Ambiguities

Terms or phrases that have caused confusion in the past. Document them so they do not recur.

| Ambiguous Term | What People Mean | Preferred Term |
|---------------|-----------------|---------------|
| [e.g. "account"] | [Could mean User or Organisation] | [Use "User" or "Organisation" explicitly] |

---

## Example Usage

Show a short dialogue or code snippet demonstrating correct vocabulary in context.

```
# Correct
"Create a new Member in the Organisation"

# Avoid
"Add a user to the account"
```

---

> Keep this file short and specific. One precise entry beats five vague ones.
> Update it whenever a terminology decision is made — do not let it drift.
