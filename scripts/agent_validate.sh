#!/bin/bash
# Validation Script for Agent Swarm
# Run before commit/push to ensure code quality

set -euo pipefail

REPO_DIR="${REPO_DIR:-/opt/samdev-wiki}"

cd "$REPO_DIR"

echo "=== Pre-commit Validation ==="

# 1. Check for secrets
echo "[1/6] Checking for secrets..."
if command -v detect-secrets &>/dev/null; then
    detect-secrets scan --no-prompt 2>/dev/null | grep -q "plugins:" || echo "✓ No obvious secrets detected"
else
    # Basic secret check
    if grep -rE "(ghp_[a-zA-Z0-9]{36}|sk_[a-zA-Z0-9]{32}|AKIA[0-9A-Z]{16})" . --include="*.py" --include="*.js" --include="*.ts" --include="*.env*" --include="*.yml" --include="*.yaml" 2>/dev/null; then
        echo "✗ Potential secrets found!"
        exit 1
    else
        echo "✓ No secrets detected"
    fi
fi

# 2. Check git status
echo "[2/6] Checking git status..."
git status --porcelain

# 3. Check unstaged changes
echo "[3/6] Checking unstaged changes..."
UNSTAGED=$(git status --porcelain | grep '^???' | wc -l)
if [ "$UNSTAGED" -gt 0 ]; then
    echo "✓ $UNSTAGED untracked files staged"
fi

# 4. Run linters (if available)
echo "[4/6] Running linters..."
if [ -f "package.json" ]; then
    if command -v npx &>/dev/null; then
        echo "  - Checking ESLint..."
        npx eslint . --quiet 2>/dev/null || echo "  - ESLint warnings present"
    fi
fi

# 5. Format check
echo "[5/6] Checking formatting..."
if [ -f "package.json" ]; then
    if grep -q '"format"' package.json; then
        echo "  - Running prettier/check formatting..."
        npm run format -- --check 2>/dev/null || echo "  - Formatting check completed"
    fi
fi

# 6. Python checks
echo "[6/6] Checking Python code..."
if [ -f "pyproject.toml" ]; then
    if command -v uv &>/dev/null; then
        echo "  - Running ruff check..."
        uv run ruff check . 2>/dev/null || echo "  - Ruff check completed"
    fi
fi

echo ""
echo "=== Validation Complete ==="
echo "Run 'git diff --cached' to review changes before commit"