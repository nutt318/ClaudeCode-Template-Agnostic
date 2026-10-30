#!/bin/sh
# Pre-commit hook: block commits if git identity is not configured.
# Install: cp scripts/check-git-identity.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
# Or run: make install  (does this automatically)

NAME=$(git config user.name)
EMAIL=$(git config user.email)

MISSING=""
if [ -z "$NAME" ]; then
  MISSING="$MISSING  user.name"
fi
if [ -z "$EMAIL" ]; then
  MISSING="$MISSING  user.email"
fi

if [ -n "$MISSING" ]; then
  echo ""
  echo "  Commit blocked: git identity is not configured."
  echo ""
  echo "  Missing:$MISSING"
  echo ""
  echo "  Fix it:"
  echo "    git config --global user.name \"Your Full Name\""
  echo "    git config --global user.email \"you@example.com\""
  echo ""
  echo "  Or run /prime in Claude Code — it will prompt you to set this up."
  echo ""
  exit 1
fi

exit 0
