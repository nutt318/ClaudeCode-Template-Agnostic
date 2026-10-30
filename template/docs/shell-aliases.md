# Shell Aliases

Add these to `~/.zshrc` or `~/.bashrc` (Mac/Linux) or your PowerShell profile (Windows) to launch Claude Code sessions faster.

```bash
# Mac/Linux — add to ~/.zshrc or ~/.bashrc
alias cs='claude'
alias csp='claude --add-dir . "/prime"'
```

```powershell
# Windows — add to $PROFILE
function cs { claude @args }
function csp { claude --add-dir . "/prime" }
```

| Alias | What it does |
|-------|-------------|
| `cs` | Opens Claude Code in the current directory |
| `csp` | Opens Claude Code and immediately runs /prime to load project context |

**`csp` is the recommended default** for starting a work session — it loads CLAUDE.md, project context, and lessons before you type your first message.

Reload your shell after adding: `source ~/.zshrc` (Mac/Linux) or restart your terminal (Windows).
