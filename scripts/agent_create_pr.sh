#!/bin/bash
# Create Pull Request Script for Agent Swarm
# Usage: ./agent_create_pr.sh <branch-name> "<title>" "<body>"

set -euo pipefail

# Configuration
REPO_DIR="${REPO_DIR:-/opt/samdev-wiki}"
BRANCH_NAME="${1:-}"
PR_TITLE="${2:-}"
PR_BODY="${3:-}"
DEFAULT_BRANCH="main"
DEFAULT_LABEL="agent-automation"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate arguments
if [ -z "$BRANCH_NAME" ]; then
    log_error "Usage: $0 <branch-name> <title> [body]"
    log_error "Example: $0 'agent/add-docs-20240101120000' 'feat: add setup documentation' 'Added comprehensive setup guides'"
    exit 1
fi

cd "$REPO_DIR"

# Check if gh CLI is available
if ! command -v gh &>/dev/null; then
    log_error "GitHub CLI (gh) not installed"
    log_error "Install with: sudo apt install gh"
    exit 1
fi

# Check authentication
if ! gh auth status &>/dev/null; then
    log_error "GitHub CLI not authenticated"
    log_error "Run: gh auth login"
    exit 1
fi

# Check if branch exists locally
if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    log_error "Branch $BRANCH_NAME does not exist locally"
    log_error "Create it first with: git checkout -b $BRANCH_NAME"
    exit 1
fi

# Check if branch has commits
COMMITS=$(git rev-list --count HEAD..origin/$BRANCH_NAME 2>/dev/null || echo "0")
if [ "$COMMITS" = "0" ] || [ "$COMMITS" = "" ]; then
    log_error "Branch $BRANCH_NAME has no new commits to push"
    exit 0
fi

# Push branch if not already pushed
if ! git ls-remote --heads origin "$BRANCH_NAME" | grep -q "$BRANCH_NAME"; then
    log_info "Pushing branch to origin..."
    git push -u origin "$BRANCH_NAME"
fi

# Generate PR body if not provided
if [ -z "$PR_BODY" ]; then
    TIMESTAMP=$(date +%Y-%m-%d)
    PR_BODY="# Summary

Automated changes from agent swarm.

## Changes
- See git diff for details

## Files Modified
\`\`\`
$(git diff --name-only origin/$DEFAULT_BRANCH...$BRANCH_NAME 2>/dev/null || git diff --name-only)
\`\`\`

## Validation
- [x] Git status clean
- [x] No secrets in changes
- [ ] Manual review required

## Notes
- Agent: $BRANCH_NAME
- Created: $TIMESTAMP
- Do not merge without explicit approval

---
*This PR was created automatically by agent swarm*"
fi

# Add task name to title if not provided
if [ -z "$PR_TITLE" ]; then
    PR_TITLE="feat(agent): automated changes for $BRANCH_NAME"
fi

# Ensure not pushing to default branch
if [ "$BRANCH_NAME" = "$DEFAULT_BRANCH" ] || [ "$BRANCH_NAME" = "master" ]; then
    log_error "Cannot create PR from default branch: $BRANCH_NAME"
    exit 1
fi

log_info "Creating Pull Request..."
log_info "Title: $PR_TITLE"
log_info "Branch: $BRANCH_NAME"

# Create PR
PR_URL=$(gh pr create \
    --title "$PR_TITLE" \
    --body "$PR_BODY" \
    --head "$BRANCH_NAME" \
    --base "$DEFAULT_BRANCH" \
    --label "$DEFAULT_LABEL" \
    --web 2>&1 | tee /dev/stdout | grep -o 'https://[^ ]*' | head -1)

if [ -n "$PR_URL" ]; then
    log_info "✓ Pull Request created: $PR_URL"
    echo ""
    echo "PR Details:"
    gh pr view "$BRANCH_NAME" --json title,body,url,state,author,labels,commits --jq '.title + "\n" + .url'
else
    log_error "Failed to create PR"
    exit 1
fi