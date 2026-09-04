#!/bin/bash
# Commit and Push Script for Agent Swarm
# Usage: ./agent_commit_push.sh "<commit-message>" "<branch-name>"

set -euo pipefail

# Configuration
REPO_DIR="${REPO_DIR:-/opt/samdev-wiki}"
BRANCH_NAME="${2:-}"
COMMIT_MESSAGE="${1:-}"
DEFAULT_BRANCH="main"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate arguments
if [ -z "$COMMIT_MESSAGE" ]; then
    log_error "Usage: $0 <commit-message> <branch-name>"
    log_error "Example: $0 'feat: add agent documentation' 'agent/add-docs-20240101120000'"
    exit 1
fi

cd "$REPO_DIR"

# Check if we're in a git repo
if [ ! -d ".git" ]; then
    log_error "Not a git repository"
    exit 1
fi

# Check if gh auth is available
if ! gh auth status &>/dev/null; then
    log_error "GitHub CLI not authenticated"
    log_error "Run: gh auth login"
    exit 1
fi

# Validate branch name format
if [ -z "$BRANCH_NAME" ]; then
    log_error "Branch name required"
    exit 1
fi

# Prevent pushing to default branch without explicit approval
if [ "$BRANCH_NAME" = "$DEFAULT_BRANCH" ] || [ "$BRANCH_NAME" = "master" ]; then
    log_warn "Attempting to push to default branch: $BRANCH_NAME"
    read -p "Are you sure you want to push to default branch? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        log_warn "Aborted push to default branch"
        exit 1
    fi
fi

# Fetch latest changes
log_info "Fetching latest changes..."
git fetch origin

# Check if branch exists
if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    log_warn "Branch $BRANCH_NAME does not exist locally"
    log_info "Creating branch from $DEFAULT_BRANCH..."
    git checkout -b "$BRANCH_NAME" "$DEFAULT_BRANCH"
else
    git checkout "$BRANCH_NAME"
fi

# Pull latest from remote if branch exists
if git ls-remote --heads origin "$BRANCH_NAME" | grep -q "$BRANCH_NAME"; then
    log_info "Pulling latest changes from remote..."
    git pull origin "$BRANCH_NAME" --no-edit || log_warn "Pull had merge conflicts"
fi

# Check git status
log_info "Checking git status..."
STATUS=$(git status --porcelain)

if [ -z "$STATUS" ]; then
    log_warn "No changes to commit"
    exit 0
fi

# Show changes
log_info "Changes detected:"
echo "$STATUS"

# Stage all changes
log_info "Staging changes..."
git add -A

# Run validation before commit
log_info "Running pre-commit validation..."

# Check for package.json (npm project)
if [ -f "package.json" ]; then
    log_info "Running npm lint..."
    if npm run lint --if-present 2>/dev/null; then
        log_info "✓ Lint passed"
    else
        log_warn "Lint check failed or not present"
    fi
    
    log_info "Running npm format..."
    if npm run format --if-present 2>/dev/null; then
        log_info "✓ Format completed"
    else
        log_warn "Format check failed or not present"
    fi
fi

# Check for Makefile
if [ -f "Makefile" ]; then
    log_info "Running make check..."
    if make check 2>/dev/null; then
        log_info "✓ Make check passed"
    else
        log_warn "Make check failed or not present"
    fi
fi

# Check for pyproject.toml (Python project)
if [ -f "pyproject.toml" ]; then
    log_info "Running pytest..."
    if uv run pytest 2>/dev/null || python -m pytest 2>/dev/null; then
        log_info "✓ Tests passed"
    else
        log_warn "Tests failed or not present"
    fi
fi

# Final status check
log_info "Final status before commit:"
git status --porcelain

# Diff for review
log_info "Showing diff:"
git diff --cached

# Confirm commit
read -p "Proceed with commit? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    log_warn "Commit cancelled"
    git reset
    exit 1
fi

# Rewrite commit message with type prefix if not present
BASE_MSG="$COMMIT_MESSAGE"

# Ensure conventional commit format
if [[ ! "$COMMIT_MESSAGE" =~ ^(feat|fix|chore|refactor|test|docs|perf|style|ci|build)(\(.+\))?: ]]; then
    # Try to auto-detect type
    if [[ "$COMMIT_MESSAGE" =~ "fix"|"bug"|"error" ]]; then
        BASE_MSG="fix: $COMMIT_MESSAGE"
    elif [[ "$COMMIT_MESSAGE" =~ "add"|"new"|"create" ]]; then
        BASE_MSG="feat: $COMMIT_MESSAGE"
    else
        BASE_MSG="chore: $COMMIT_MESSAGE"
    fi
fi

# Commit
log_info "Creating commit..."
git commit -m "$BASE_MSG"

# Push
log_info "Pushing to origin..."
git push -u origin "$BRANCH_NAME"

log_info "✓ Successfully committed and pushed to $BRANCH_NAME"
echo ""
echo "Next step: Create PR"
echo "  gh pr create --title \"$(echo $BASE_MSG | sed 's/^feat: /feat: /' | sed 's/^fix: /fix: /')\""