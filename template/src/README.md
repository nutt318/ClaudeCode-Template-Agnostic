# src/

All application code lives here.

## New project

Initialize your stack inside this folder:

```bash
cd src

# Node / Next.js
npm init
npx create-next-app@latest .

# Python
python -m venv .venv
pip install django   # or fastapi, flask, etc.

# Go
go mod init github.com/yourorg/yourproject
```

## Existing project from GitHub

Clone into this folder from the project root:

```bash
git clone https://github.com/yourorg/yourproject src
```

By default this project is **one repo** (Claude config + code together). A freshly cloned `src/`
carries its own `.git`, which can't be tracked inside the project repo — drop it so the code is
tracked here: `rm -rf src/.git` (`Remove-Item -Recurse -Force src\.git` on Windows). To keep `src/`
as its own separate repo with its own remote instead, leave its `.git` and use the Option A note in
`.gitignore`.

## Notes

- `package.json`, `requirements.txt`, `go.mod`, etc. live here — not at the project root
- Run dev commands from this directory: `cd src && npm run dev`
- The `.claude/settings.json` at the project root pre-approves commands run from here
- `CLAUDE.md` at the project root tells Claude that code lives in `src/`
