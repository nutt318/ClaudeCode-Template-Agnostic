# Makefile — standardised commands across all stacks
# Run from the project root. All commands delegate into src/.

.PHONY: help setup install hooks dev build test lint format clean

# Detect OS for setup command
ifeq ($(OS),Windows_NT)
    SETUP_CMD = powershell -ExecutionPolicy Bypass -File scripts/setup.ps1
else
    SETUP_CMD = bash scripts/setup.sh
endif

# Show available commands
help:
	@echo ""
	@echo "  make setup      First-time project setup — fills all template placeholders"
	@echo "  make install    Install dependencies and git hooks"
	@echo "  make hooks      Install git hooks only"
	@echo "  make dev        Start development server"
	@echo "  make build      Build for production"
	@echo "  make test       Run tests"
	@echo "  make lint       Run linter"
	@echo "  make format     Format code"
	@echo "  make clean      Remove build artifacts"
	@echo ""

# First-time project setup
setup:
	@$(SETUP_CMD)

# Install dependencies and git hooks
install:
	cd src && npm install
	# Python: cd src && pip install -r requirements.txt
	# Go:     cd src && go mod download
	@$(MAKE) hooks

# Install git hooks
hooks:
ifeq ($(OS),Windows_NT)
	@echo "  On Windows, run: .\\scripts\\setup.ps1 (installs hooks automatically)"
else
	@if [ -f scripts/check-git-identity.sh ]; then \
		cp scripts/check-git-identity.sh .git/hooks/pre-commit && \
		chmod +x .git/hooks/pre-commit && \
		echo "  git hook installed: check-git-identity"; \
	fi
endif

# Start development server
dev:
	cd src && npm run dev
	# Python: cd src && uvicorn main:app --reload
	# Go:     cd src && go run ./cmd/server

# Build for production
build:
	cd src && npm run build
	# Python: cd src && python -m build
	# Go:     cd src && go build ./cmd/server

# Run tests
test:
	cd src && npm test
	# Python: cd src && pytest
	# Go:     cd src && go test ./...

# Run linter
lint:
	cd src && npm run lint
	# Python: cd src && ruff check .
	# Go:     cd src && go vet ./...

# Format code
format:
	cd src && npm run format
	# Python: cd src && ruff format .
	# Go:     cd src && gofmt -w .

# Remove build artifacts
clean:
	cd src && rm -rf dist .next out coverage
	# Python: cd src && rm -rf __pycache__ .pytest_cache dist
	# Go:     cd src && go clean
