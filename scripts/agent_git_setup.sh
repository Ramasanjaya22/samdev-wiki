#!/bin/bash
# Git Setup Script for Agent Swarm
# Setup git identity and credential helper locally (not global)

set -euo pipefail

# Configuration
REPO_DIR="${REPO_DIR:-/opt/samdev-wiki}"
BRANCH_PREFIX="${BRANCH_PREFIX:-agent}"
GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-Agent Swarm}"
GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-agent@footygraph.com}"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Default branch (can be overridden)
DEFAULT_BRANCH="main"

echo "=== Git Setup for Agent Swarm ==="
echo "Repository: $REPO_DIR"
echo "Author: $GIT_AUTHOR_NAME <$GIT_AUTHOR_EMAIL>"

# Check if we're in a git repository
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Error: $REPO_DIR is not a git repository"
    exit 1
fi

cd "$REPO_DIR"

# Setup git identity (local config, not global)
echo ""
echo "Setting up git identity..."
git config --local user.name "$GIT_AUTHOR_NAME"
git config --local user.email "$GIT_AUTHOR_EMAIL"

# Setup credential helper (cache for 1 hour)
git config --local credential.helper "cache --timeout=3600"

# Verify git config
echo ""
echo "Git configuration:"
git config --local user.name
git config --local user.email
git config --local credential.helper

# Check remote origin
echo ""
echo "Remote origin:"
git remote -v

# Verify GH_TOKEN is available
if [ -n "${GH_TOKEN:-}" ]; then
    echo ""
    echo "✓ GH_TOKEN is set"
else
    echo ""
    echo "Warning: GH_TOKEN not set in environment"
    echo "Set it before using agent scripts: export GH_TOKEN=your_token"
fi

# Verify gh CLI auth
echo ""
echo "GitHub CLI auth:"
if gh auth status 2>/dev/null; then
    echo "✓ gh CLI authenticated"
else
    echo "✗ gh CLI not authenticated"
    exit 1
fi

echo ""
echo "=== Git Setup Complete ==="