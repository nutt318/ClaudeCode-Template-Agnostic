---
description: Extract what changed from git history and append a formatted entry to CHANGELOG.md
---

# /add-to-changelog

Generate a changelog entry from recent commits.

## Steps

1. Get commits since the last tag (falls back to all commits if no tags exist):

   **Mac/Linux:**
   ```bash
   git log --oneline --no-merges \
     $(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)..HEAD
   ```

   **Windows (PowerShell):**
   ```powershell
   $base = git describe --tags --abbrev=0 2>$null
   if (-not $base) { $base = git rev-list --max-parents=0 HEAD }
   git log --oneline --no-merges "$base..HEAD"
   ```
2. Group commits by type: feat, fix, refactor, docs, test, chore
3. Write human-readable summaries (not raw commit messages)
4. Prepend to CHANGELOG.md under a new version heading

## Changelog Format

```markdown
## [version] - YYYY-MM-DD

### Added
- [Feature description from feat: commits]

### Fixed
- [Bug fix description from fix: commits]

### Changed
- [Refactor or breaking change from refactor: commits]

### Internal
- [Docs, tests, chores — only if notable]
```

## Notes

- Ask for the version number if $ARGUMENTS is empty
- Skip commits that are trivial (typo fixes, formatting)
- Write for a reader who uses the software, not one who reads the code
