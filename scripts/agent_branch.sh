#!/bin/bash
# Branch Creation Script for Agent Swarm
# Usage: ./agent_branch.sh <task-name> [branch-prefix]

set -euo pipefail

# Configuration
REPO_DIR="${REPO_DIR:-/opt/samdev-wiki}"
TASK_NAME="${1:-manual-changes}"
BRANCH_PREFIX="${2:-agent}"
DEFAULT_BRANCH="main"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Validate task name
if [ -z "$TASK_NAME" ]; then
    log_error "Usage: $0 <task-name>"
    log_error "Example: $0 'add-hermes-docs'"
    exit 1
fi

# Clean task name (remove spaces, special chars)
CLEAN_TASK_NAME=$(echo "$TASK_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')

# Generate timestamp
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Create branch name
BRANCH_NAME="${BRANCH_PREFIX}/${CLEAN_TASK_NAME}-${TIMESTAMP}"

log_info "Creating branch: $BRANCH_NAME"

cd "$REPO_DIR"

# Check if we're in a git repo
if [ ! -d ".git" ]; then
    log_error "Not a git repository"
    exit 1
fi

# Fetch latest
log_info "Fetching latest changes..."
git fetch origin

# Checkout default branch and pull
log_info "Updating to latest $DEFAULT_BRANCH..."
git checkout "$DEFAULT_BRANCH" 2>/dev/null || git checkout master 2>/dev/null || { log_error "Default branch not found"; exit 1; }
git pull origin "$DEFAULT_BRANCH" 2>/dev/null || git pull origin master 2>/dev/null || log_warn "Could not pull latest"

# Create new branch
log_info "Creating new branch..."
git checkout -b "$BRANCH_NAME"

# Set branch name for other scripts
export AGENT_BRANCH_NAME="$BRANCH_NAME"

log_info "✓ Branch created and checked out: $BRANCH_NAME"
echo ""
echo "Ready to make changes!"
echo "Current branch: $(git branch --show-current)"
echo ""
echo "To make changes:"
echo "  1. Edit files..."
echo "  2. Run: ../scripts/agent_commit_push.sh \"<message>\" \"$BRANCH_NAME\""
echo "  3. Run: ../scripts/agent_create_pr.sh \"$BRANCH_NAME\" \"<title>\" \"<body>\""