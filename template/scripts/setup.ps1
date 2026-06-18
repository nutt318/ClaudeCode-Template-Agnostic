# setup.ps1 — Interactive project setup for team-starter template (Windows)
# Run once after copying the template: .\scripts\setup.ps1  OR  make setup

$ErrorActionPreference = "Stop"

function Header { param($text) Write-Host "`n=== $text ===" -ForegroundColor Cyan }
function Ok     { param($text) Write-Host "  v $text" -ForegroundColor Green }
function Warn   { param($text) Write-Host "  ! $text" -ForegroundColor Yellow }
function Err    { param($text) Write-Host "  x $text" -ForegroundColor Red }

function Read-WithDefault {
  param($promptText, $default)
  Write-Host "$promptText [$default]: " -ForegroundColor Yellow -NoNewline
  $val = Read-Host
  if ([string]::IsNullOrWhiteSpace($val)) { return $default }
  return $val.Trim()
}

function Read-Optional {
  param($promptText)
  Write-Host "$promptText (leave blank to skip): " -ForegroundColor Yellow -NoNewline
  return (Read-Host).Trim()
}

Write-Host ""
Write-Host "=== Project Setup ===" -ForegroundColor White
Write-Host "Answers all template placeholders in one pass."
Write-Host "Press Enter to accept the default shown in [brackets], or leave blank to skip."
Write-Host ""

# ─── Guard: src/ check ────────────────────────────────────────────────────────
# Project-X/ is the local AI workspace. Application code and git live in src/.

if (-not (Test-Path "src")) {
  Warn "src/ directory not found."
  Write-Host "  For a new project:      mkdir src"
  Write-Host "  For an existing repo:   git clone https://github.com/org/your-repo src"
  Write-Host "  Then re-run: .\scripts\setup.ps1"
  Write-Host ""
}

# ─── Guard: re-run detection ───────────────────────────────────────────────

if ((Test-Path "CLAUDE.md") -and -not (Select-String -Path "CLAUDE.md" -Pattern "\[Replace with your project name" -Quiet)) {
  Warn "Setup has already been run on this project."
  Write-Host ""
  Write-Host "Continue anyway and overwrite existing values? [y/N]: " -ForegroundColor Yellow -NoNewline
  $confirm = (Read-Host).Trim()
  if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Aborted. No changes made."
    exit 0
  }
  Write-Host ""
}

# ─── 1. Project identity ───────────────────────────────────────────────────

Header "1 of 6  Project identity"

$projectName   = Read-WithDefault "Project name" "my-app"
Write-Host "One-paragraph description: " -ForegroundColor Yellow -NoNewline
$projectDesc   = Read-Host
if ([string]::IsNullOrWhiteSpace($projectDesc)) { $projectDesc = "A new project." }
$orgName       = Read-WithDefault "Organisation name" "Your Organisation"
$copyrightYear = Read-WithDefault "Copyright year" (Get-Date).Year.ToString()

# ─── 2. Tech stack ─────────────────────────────────────────────────────────

Header "2 of 6  Tech stack  (leave any blank to fill in later)"

$lang       = Read-Optional "Primary language (e.g. TypeScript / Python / Go)"
$framework  = Read-Optional "Framework (e.g. Next.js / FastAPI / Gin)"
$database   = Read-Optional "Database (e.g. PostgreSQL / MongoDB)"
$pkgManager = Read-Optional "Package manager (npm / pnpm / yarn / pip / go mod)"
$cmdInstall = Read-Optional "Install command (e.g. npm install)"
$cmdDev     = Read-Optional "Dev command (e.g. npm run dev)"
$cmdTest    = Read-Optional "Test command (e.g. npm test)"
$cmdBuild   = Read-Optional "Build command (e.g. npm run build)"

# ─── 3. External services ──────────────────────────────────────────────────

Header "3 of 6  External services"

$servicesRaw = Read-Optional "Services this project depends on -- comma-separated (e.g. Stripe,SendGrid)"

# ─── 4. Domain vocabulary ──────────────────────────────────────────────────

Header "4 of 6  Domain vocabulary (CONTEXT.md)"

Write-Host "Key domain terms -- comma-separated (e.g. Member,Workspace,Campaign): " -ForegroundColor Yellow -NoNewline
$termsRaw = (Read-Host).Trim()

$termDefs = @{}
if ($termsRaw) {
  $terms = $termsRaw -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
  foreach ($term in $terms) {
    Write-Host "Define '$term' in one sentence: " -ForegroundColor Yellow -NoNewline
    $def = (Read-Host).Trim()
    if ([string]::IsNullOrWhiteSpace($def)) { $def = "A core concept in this project." }
    $termDefs[$term] = $def
  }
}

$termAvoid = Read-Optional "Any terms to avoid or common confusions (e.g. 'account' vs 'workspace')"

# ─── 5. Coding standards ───────────────────────────────────────────────────

Header "5 of 6  Coding standards (CODING_STANDARDS.md)"

Write-Host "One core coding principle (e.g. All DB access goes through the repository layer): " -ForegroundColor Yellow -NoNewline
$principle1 = (Read-Host).Trim()
if ([string]::IsNullOrWhiteSpace($principle1)) { $principle1 = "Prefer pure functions over stateful classes for business logic." }
$principle2   = Read-Optional "Second principle"
Write-Host "One anti-pattern to never do (e.g. Fetching data directly in components): " -ForegroundColor Yellow -NoNewline
$antipattern1 = (Read-Host).Trim()
if ([string]::IsNullOrWhiteSpace($antipattern1)) { $antipattern1 = "Hardcoding secrets in source files." }

# ─── 6. Contacts and team ──────────────────────────────────────────────────

Header "6 of 6  Contacts, team, and version control"

$itContact = Read-WithDefault "IT contact email" "security@example.com"

Write-Host ""
Write-Host "Version control provider:" -ForegroundColor Yellow
Write-Host "  [1] GitHub      (default)"
Write-Host "  [2] Bitbucket"
Write-Host "  [3] Skip — configure CI and CODEOWNERS manually"
Write-Host "Choice [1]: " -ForegroundColor Yellow -NoNewline
$providerChoice = (Read-Host).Trim()
$provider = switch ($providerChoice) {
  "2"     { "bitbucket" }
  "3"     { "skip" }
  default { "github" }
}

if ($provider -eq "github") {
  $vcTeam = Read-WithDefault "GitHub org/team for CODEOWNERS (e.g. your-org/engineering)" "your-org/engineering"
} elseif ($provider -eq "bitbucket") {
  $vcTeam = Read-WithDefault "Bitbucket workspace/team for CODEOWNERS (e.g. my-workspace/engineering)" "my-workspace/engineering"
} else {
  $vcTeam = ""
}

# ─── Apply all changes ─────────────────────────────────────────────────────

Write-Host "`n=== Writing files... ===" -ForegroundColor Cyan

if (-not $lang)       { $lang = "TBD" }
if (-not $pkgManager) { $pkgManager = "TBD" }
if (-not $cmdInstall) { $cmdInstall = "TBD" }
if (-not $cmdDev)     { $cmdDev = "TBD" }
if (-not $cmdTest)    { $cmdTest = "TBD" }
if (-not $cmdBuild)   { $cmdBuild = "TBD" }

# --- CLAUDE.md ---
if (Test-Path "CLAUDE.md") {
  $stackLines = "- **Language**: $lang"
  if ($framework) { $stackLines += "`n- **Framework**: $framework" }
  if ($database)  { $stackLines += "`n- **Database**: $database" }
  $stackLines += "`n- **Package Manager**: $pkgManager"

  $c = Get-Content "CLAUDE.md" -Raw -Encoding utf8
  $c = $c -replace '\[Replace with your project name and a one-paragraph description\.\]', "$projectName -- $projectDesc"
  $c = $c -replace '- \*\*Language\*\*: \[e\.g\. TypeScript / Python / Go\]\r?\n- \*\*Framework\*\*: \[e\.g\. Next\.js / FastAPI / Gin\]\r?\n- \*\*Database\*\*: \[e\.g\. PostgreSQL / MongoDB / SQLite\]\r?\n- \*\*Package Manager\*\*: \[e\.g\. npm / pnpm / yarn / pip\]', $stackLines
  $c = $c -replace '\[your install command\]', $cmdInstall
  $c = $c -replace '\[your dev command\]', $cmdDev
  $c = $c -replace '\[your test command\]', $cmdTest
  $c = $c -replace '\[your build command\]', $cmdBuild
  $c = $c -replace '\[your coverage command\]', "$cmdTest --coverage"
  $c = $c -replace '\[your targeted test command\]', "$cmdTest --testPathPattern=<suite>"
  $c = $c -replace '\[your-repo\]', $projectName
  Set-Content "CLAUDE.md" -Value $c -Encoding utf8 -NoNewline
  Ok "CLAUDE.md"
}

# --- LICENSE ---
if (Test-Path "LICENSE") {
  $c = Get-Content "LICENSE" -Raw -Encoding utf8
  $c = $c -replace '\[Year\]', $copyrightYear
  $c = $c -replace '\[Your Name or Organisation\]', $orgName
  Set-Content "LICENSE" -Value $c -Encoding utf8 -NoNewline
  Ok "LICENSE"
}

# --- SECURITY.md ---
if (Test-Path "SECURITY.md") {
  $c = Get-Content "SECURITY.md" -Raw -Encoding utf8
  $c = $c -replace 'security@example\.com', $itContact
  Set-Content "SECURITY.md" -Value $c -Encoding utf8 -NoNewline
  Ok "SECURITY.md"
}

# --- Version control provider: CI files and CODEOWNERS ---
if ($provider -eq "github") {
  if (Test-Path ".github\CODEOWNERS") {
    $c = Get-Content ".github\CODEOWNERS" -Raw -Encoding utf8
    $c = $c -replace '@your-org/team-name', "@$vcTeam"
    Set-Content ".github\CODEOWNERS" -Value $c -Encoding utf8 -NoNewline
    Ok ".github/CODEOWNERS"
  }
  if (Test-Path ".bitbucket") {
    Remove-Item ".bitbucket" -Recurse -Force
    Ok ".bitbucket/ removed (GitHub project)"
  }
} elseif ($provider -eq "bitbucket") {
  if (Test-Path ".bitbucket\CODEOWNERS") {
    $c = Get-Content ".bitbucket\CODEOWNERS" -Raw -Encoding utf8
    $c = $c -replace '@your-workspace/team-name', "@$vcTeam"
    Set-Content ".bitbucket\CODEOWNERS" -Value $c -Encoding utf8 -NoNewline
    Ok ".bitbucket/CODEOWNERS"
  }
  if (Test-Path ".bitbucket\pipelines.yml") { Ok ".bitbucket/pipelines.yml" }
  if (Test-Path ".github") {
    Remove-Item ".github" -Recurse -Force
    Ok ".github/ removed (Bitbucket project)"
  }
} else {
  if (Test-Path ".github")    { Remove-Item ".github"    -Recurse -Force; Ok ".github/ removed (CI skipped)" }
  if (Test-Path ".bitbucket") { Remove-Item ".bitbucket" -Recurse -Force; Ok ".bitbucket/ removed (CI skipped)" }
}

# --- PROJECT_REF.md ---
$srcFiles = @()
if (Test-Path "src") {
  $srcFiles = Get-ChildItem "src" -Recurse -Depth 1 -File |
    ForEach-Object { $_.FullName.Replace((Get-Location).Path + "\", "").Replace("\", "/") } |
    Sort-Object
}

$today    = (Get-Date).ToString("yyyy-MM-dd")
$services = if ($servicesRaw) { $servicesRaw -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' } } else { @() }

$refLines = @(
  "# PROJECT_REF.md", "",
  "Factual, evolving knowledge about this codebase.",
  "Update this file as the project changes. Load it at session start via /prime.",
  "", "---", "",
  "## Key Files and What They Do", "",
  "| File / Directory | Purpose |",
  "|-----------------|---------|"
)
if ($srcFiles.Count -gt 0) {
  foreach ($f in $srcFiles) { $refLines += "| ``$f`` | TODO: describe purpose |" }
} else {
  $refLines += "| src/ | TODO: add key files as the project grows |"
}
$refLines += @(
  "", "---", "", "## Data Models", "",
  "_No models yet -- add entries here as you define your data structures._",
  "", "---", "", "## API Endpoints", "",
  "| Method | Path | Purpose |", "|--------|------|---------|",
  "| -- | -- | No endpoints yet |",
  "", "---", "", "## External Services and Integrations", "",
  "| Service | How we use it | Config location |",
  "|---------|--------------|----------------|"
)
if ($services.Count -gt 0) {
  foreach ($s in $services) { $refLines += "| $s | TODO: describe usage | .env |" }
} else { $refLines += "| None yet | -- | -- |" }
$refLines += @(
  "", "---", "", "## Known Technical Debt", "",
  "| Area | Issue | Priority |", "|------|-------|---------|", "| -- | None yet | -- |",
  "", "---", "", "## Recent Significant Changes", "",
  "| Date | What changed | Why |", "|------|-------------|-----|",
  "| $today | Initial project setup from team-starter template | New project |"
)
Set-Content "PROJECT_REF.md" -Value ($refLines -join "`n") -Encoding utf8
Ok "PROJECT_REF.md"

# --- CONTEXT.md ---
$ctxLines = @(
  "# CONTEXT.md -- Domain Glossary", "",
  "> Canonical vocabulary for this project.",
  "> Claude reads this via ``/prime``. Use it to resolve ambiguity before writing code, docs, or agent prompts.",
  "", "---", "", "## Canonical Terms", ""
)
if ($termDefs.Count -eq 0) {
  $ctxLines += @("_No terms defined yet -- add entries here as your domain vocabulary becomes clear._", "", "---", "")
} else {
  foreach ($term in $termDefs.Keys) {
    $ctxLines += @(
      "### $term", "",
      "**Definition:** $($termDefs[$term])", "",
      "**Avoid:** TODO -- list synonyms or vague phrasings to avoid", "",
      "**Related:** TODO -- other terms in this glossary", "", "---", ""
    )
  }
}
$ctxLines += @(
  "## Relationships", "", '```',
  "TODO -- describe how key concepts relate to each other", '```',
  "", "---", "", "## Flagged Ambiguities", "",
  "| Ambiguous Term | What People Mean | Preferred Term |",
  "|---------------|-----------------|---------------|"
)
if ($termAvoid) { $ctxLines += "| $termAvoid | TODO: clarify | TODO: preferred |" }
else            { $ctxLines += "| -- | -- | -- |" }
Set-Content "CONTEXT.md" -Value ($ctxLines -join "`n") -Encoding utf8
Ok "CONTEXT.md"

# --- CODING_STANDARDS.md ---
$namingRows = switch -Wildcard ($lang) {
  "TypeScript*" { @(
    "| Functions | camelCase verb | ``getUser``, ``createOrder`` |",
    "| Classes / Types | PascalCase | ``UserRecord``, ``ApiResponse`` |",
    "| Constants | UPPER_SNAKE_CASE | ``MAX_RETRY_COUNT`` |",
    "| Files | kebab-case | ``user-service.ts`` |"
  )}
  "Python*" { @(
    "| Functions | snake_case verb | ``get_user``, ``create_order`` |",
    "| Classes | PascalCase | ``UserRecord``, ``ApiResponse`` |",
    "| Constants | UPPER_SNAKE_CASE | ``MAX_RETRY_COUNT`` |",
    "| Files | snake_case | ``user_service.py`` |"
  )}
  "Go*" { @(
    "| Exported | PascalCase | ``GetUser``, ``UserRecord`` |",
    "| Unexported | camelCase | ``parseToken`` |",
    "| Files | snake_case | ``user_service.go`` |"
  )}
  default { @(
    "| Functions | camelCase verb | ``getUser``, ``createOrder`` |",
    "| Types / Classes | PascalCase | ``UserRecord`` |",
    "| Constants | UPPER_SNAKE_CASE | ``MAX_RETRY_COUNT`` |"
  )}
}
$stdLines = @(
  "# Coding Standards", "",
  "> Reference with @CODING_STANDARDS.md in agent prompts.",
  "> Keep this specific to THIS project. Universal standards live in CLAUDE.md.",
  "", "---", "", "## Core Principles", "", "- $principle1"
)
if ($principle2) { $stdLines += "- $principle2" }
$stdLines += @(
  "- No hardcoded secrets -- use environment variables",
  "- Validate all inputs at system boundaries",
  "", "---", "", "## Naming Conventions", "",
  "| Thing | Convention | Example |", "|-------|-----------|---------|"
)
$stdLines += $namingRows
$stdLines += @(
  "", "---", "", "## Testing Philosophy", "",
  "- Test behaviour, not implementation -- tests should survive refactors",
  "- One assertion concept per test", "- 80% coverage minimum",
  "", "---", "", "## Anti-Patterns -- Never Do These", "",
  "| Pattern | Why | Do This Instead |", "|---------|-----|----------------|",
  "| $antipattern1 | Causes security or maintenance issues | See core principles above |",
  "| ``console.log`` / ``print`` in production | Leaks internals | Use the structured logger |",
  "", "---", "", "## Code Review Checklist (project-specific)", "",
  "- [ ] New endpoints have rate limiting",
  "- [ ] Database queries use parameterised inputs",
  "- [ ] Error messages do not expose stack traces to clients",
  "- [ ] New environment variables are added to ``.env.example``"
)
Set-Content "CODING_STANDARDS.md" -Value ($stdLines -join "`n") -Encoding utf8
Ok "CODING_STANDARDS.md"

# --- docs/ai/domain.md ---
if (Test-Path "docs\ai\domain.md") {
  $c = Get-Content "docs\ai\domain.md" -Raw -Encoding utf8
  $c = $c -replace '^# Agent Domain Guide', "# Agent Domain Guide -- $projectName"
  Set-Content "docs\ai\domain.md" -Value $c -Encoding utf8 -NoNewline
  Ok "docs/ai/domain.md"
}

# --- .claude/rules/project.md ---
if (Test-Path ".claude\rules\project.md") {
  $c = Get-Content ".claude\rules\project.md" -Raw -Encoding utf8
  $c = $c -replace '\[Project Name\]', $projectName
  Set-Content ".claude\rules\project.md" -Value $c -Encoding utf8 -NoNewline
  Ok ".claude/rules/project.md"
}

# --- docs/ai/triage-labels.md ---
if (Test-Path "docs\ai\triage-labels.md") {
  $c = Get-Content "docs\ai\triage-labels.md" -Raw -Encoding utf8
  $c = $c -replace '\[Add your areas here\]', "Add area labels once feature areas are defined (e.g. area: auth, area: api)"
  Set-Content "docs\ai\triage-labels.md" -Value $c -Encoding utf8 -NoNewline
  Ok "docs/ai/triage-labels.md"
}

# --- docs/ai/issue-tracker.md ---
if ($provider -eq "bitbucket" -and (Test-Path "docs\ai\issue-tracker-bitbucket.md")) {
  # Extract workspace from vcTeam (e.g. "my-workspace/engineering" -> "my-workspace")
  $bbWorkspace = $vcTeam -replace '/.*', ''
  $c = Get-Content "docs\ai\issue-tracker-bitbucket.md" -Raw -Encoding utf8
  $c = $c -replace '\[bitbucket-workspace\]', $bbWorkspace
  $c = $c -replace '\[repo-slug\]', $projectName
  Set-Content "docs\ai\issue-tracker.md" -Value $c -Encoding utf8 -NoNewline
  Remove-Item "docs\ai\issue-tracker-bitbucket.md" -Force
  Ok "docs/ai/issue-tracker.md (Bitbucket)"
} else {
  if (Test-Path "docs\ai\issue-tracker-bitbucket.md") {
    Remove-Item "docs\ai\issue-tracker-bitbucket.md" -Force
  }
}

# --- .claude/context/last-session.md ---
$lastSessionFile = ".claude\context\last-session.md"
if (Test-Path $lastSessionFile) {
  $ls = @(
    "# Last Session",
    "",
    "> This file is written by ``/save-session`` and read by ``/prime``.",
    "> It is committed to git so the whole team benefits from session continuity.",
    "",
    "## Date",
    "$today -- initial setup",
    "",
    "## Branch",
    "main",
    "",
    "## What was done",
    "- Project initialised from team-starter template",
    "- CLAUDE.md, LICENSE, SECURITY.md, CODEOWNERS filled in",
    "- PROJECT_REF.md, CONTEXT.md, CODING_STANDARDS.md generated",
    "- Git identity hook installed",
    "",
    "## Files changed",
    "- CLAUDE.md",
    "- LICENSE",
    "- SECURITY.md",
    "- PROJECT_REF.md",
    "- CONTEXT.md",
    "- CODING_STANDARDS.md",
    "- $(if ($provider -eq 'bitbucket') { '.bitbucket/CODEOWNERS' } else { '.github/CODEOWNERS' })",
    "",
    "## Open threads",
    "- None",
    "",
    "## Next steps",
    "- Fill in PROJECT_REF.md data models as you build",
    "- Fill in CONTEXT.md Avoid/Related fields and Relationships",
    "- Fill in .env secrets",
    "- Run ``/prime`` to load project context",
    "- Run ``/create-plan`` before starting your first feature"
  )
  Set-Content $lastSessionFile -Value ($ls -join "`n") -Encoding utf8
  Ok ".claude/context/last-session.md"
}

# --- .env ---
if ((Test-Path ".env.example") -and -not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
  Ok ".env created from .env.example (add your secrets)"
}

# --- Git hooks ---
# Hook goes into the project-root .git/hooks/ — Option B: one repo for config + code
if (Test-Path "scripts\check-git-identity.sh") {
  if (Test-Path ".git") {
    if (-not (Test-Path ".git\hooks")) { New-Item -ItemType Directory -Path ".git\hooks" -Force | Out-Null }
    Copy-Item "scripts\check-git-identity.sh" ".git\hooks\pre-commit" -Force
    Ok "git identity pre-commit hook installed in .git/hooks/"
  } else {
    Warn ".git not found -- git identity hook not installed."
    Write-Host "  Run 'git init' at the project root, then re-run setup to install it."
  }
}

# --- Cleanup ---
if (Test-Path "START-HERE.md") {
  Remove-Item "START-HERE.md" -Force
  Ok "START-HERE.md removed"
}

# ─── Done ──────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Setup complete." -ForegroundColor Green
Write-Host ""

if ($srcFiles.Count -gt 0) {
  Write-Host "Existing source files detected in src/ -- listed in PROJECT_REF.md."
  Write-Host "Run /update-project-ref in Claude Code to have Claude fill in descriptions."
  Write-Host ""
}

Write-Host "Still needs your attention:"
Write-Host "  PROJECT_REF.md    -- add data models and API endpoints as you build"
Write-Host "  CONTEXT.md        -- add Avoid/Related for each term; fill Relationships"
Write-Host "  .env              -- fill in real secrets"
Write-Host "  docs/ai/triage-labels.md -- run 'gh label list' and confirm label strings"
Write-Host ""

# ─── Windows: ralph-loop hook path warning ────────────────────────────────────
# The plugin installs to a hashed cache path; use a wildcard to locate hooks.json
$gitBashPath = "C:/Program Files/Git/bin/bash.exe"
$ralphCacheBase = "$env:USERPROFILE\.claude\plugins\cache\claude-plugins-official\ralph-wiggum"
$ralphHooksPath = Get-ChildItem "$ralphCacheBase\*\hooks\hooks.json" -ErrorAction SilentlyContinue |
                  Select-Object -First 1 -ExpandProperty FullName

if ($ralphHooksPath) {
  $hooksContent = Get-Content $ralphHooksPath -Raw
  if ($hooksContent -notmatch [regex]::Escape($gitBashPath)) {
    Warn "ralph-loop detected: Stop hook may use WSL bash instead of Git Bash."
    Write-Host "  Fix: open $ralphHooksPath"
    Write-Host "  Set the bash command to: `"$gitBashPath`""
    Write-Host "  Use Git/bin/bash.exe (not Git/usr/bin/bash.exe -- that lacks PATH utilities)."
    Write-Host "  See README -- Autonomous Loops -- Windows note for details."
    Write-Host ""
  }
} elseif (-not (Test-Path $ralphCacheBase)) {
  Write-Host "Optional: install the ralph-loop plugin for autonomous iteration loops."
  Write-Host "  In Claude Code run: /install-plugin ralph-loop"
  Write-Host "  Then see /ralph for usage and prompt templates."
  Write-Host ""
}

Write-Host "Open Claude Code and run:  /prime"
Write-Host ""
Write-Host "When ready:"
Write-Host "  git add -A && git commit -m `"chore: initialise project from team-starter template`""
Write-Host ""
