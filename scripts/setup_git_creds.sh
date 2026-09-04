#!/bin/bash
# Setup Git Credentials for Agent
# Configures git to use the stored GH_TOKEN for push operations

set -euo pipefail

REPO_DIR="${REPO_DIR:-/opt/samdev-wiki}"
GH_TOKEN_PATH="${GH_TOKEN_PATH:-/root/.secrets/github_token}"

echo "=== Setting up Git credentials ==="

# Read token from secure location
if [ -f "$GH_TOKEN_PATH" ]; then
    GH_TOKEN=$(cat "$GH_TOKEN_PATH")
else
    echo "Warning: Token file not found at $GH_TOKEN_PATH"
    echo "Using GH_TOKEN environment variable..."
fi

cd "$REPO_DIR"

# Configure git to use token from environment or stored file
if [ -n "${GH_TOKEN:-}" ] || [ -f "$GH_TOKEN_PATH" ]; then
    # Use credential helper with token
    cat > ~/.git-credentials << EOF
https://x-access-token:${GH_TOKEN:-$(cat $GH_TOKEN_PATH 2>/dev/null)}@github.com
EOF
    chmod 600 ~/.git-credentials
    git config --local credential.helper store
    echo "✓ Git credentials configured"
    echo ""
    echo "To push: git push -u origin <branch>"
    echo "To clear: git config --local --unset credential.helper"
else
    echo "Warning: No GH_TOKEN found"
    echo "Set GH_TOKEN environment variable or create $GH_TOKEN_PATH"
fi