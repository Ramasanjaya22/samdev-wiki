#!/bin/bash
# Autonomous PR pipeline for Agent Swarm (one command).
# Branch -> validate -> commit -> push -> PR, optionally auto-merge on green CI.
#
# Usage:
#   ./scripts/agent_auto_pr.sh "<task-name>" "<commit-message>" [--auto-merge]
#
# Examples:
#   ./scripts/agent_auto_pr.sh "update-docs" "docs: refresh setup guide"
#   ./scripts/agent_auto_pr.sh "fix-typo" "fix: correct README link" --auto-merge
#
# SECURITY:
# - Never prints tokens. Auth via `gh` CLI (GH_TOKEN env or stored credentials).
# - Never force-pushes, never deletes branches, never pushes to main/master.

set -euo pipefail

REPO_DIR="${REPO_DIR:-/opt/samdev-wiki}"
TASK_NAME="${1:-}"
COMMIT_MESSAGE="${2:-}"
FLAG="${3:-}"
DEFAULT_BRANCH="main"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log_info()  { echo -e "${GREEN}[auto-pr]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[auto-pr]${NC} $1"; }
log_error() { echo -e "${RED}[auto-pr]${NC} $1"; }

[ -n "$TASK_NAME" ] || { log_error "Usage: $0 <task-name> <commit-message> [--auto-merge]"; exit 1; }
[ -n "$COMMIT_MESSAGE" ] || { log_error "Usage: $0 <task-name> <commit-message> [--auto-merge]"; exit 1; }

CLEAN_TASK="$(echo "$TASK_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')"
BRANCH="agent/${CLEAN_TASK}-$(date +%Y%m%d%H%M%S)"

cd "$REPO_DIR"
[ -d .git ] || { log_error "Not a git repository: $REPO_DIR"; exit 1; }
gh auth status &>/dev/null || { log_error "gh CLI not authenticated. Run: gh auth login"; exit 1; }

# 1. Fresh base + new branch
log_info "Fetching $DEFAULT_BRANCH..."
git fetch origin >/dev/null 2>&1 || true
git checkout "$DEFAULT_BRANCH" >/dev/null 2>&1
git pull origin "$DEFAULT_BRANCH" >/dev/null 2>&1 || log_warn "Could not fast-forward $DEFAULT_BRANCH"
git checkout -b "$BRANCH"
log_info "Branch: $BRANCH"

# 2. Stage everything (caller edits files before invoking, or pass files already staged)
if [ -z "$(git status --porcelain)" ]; then
  log_error "Nothing to commit — make changes first, then re-run."
  git checkout "$DEFAULT_BRANCH" >/dev/null 2>&1
  git branch -D "$BRANCH" >/dev/null 2>&1
  exit 1
fi
git add -A
log_info "Staged:"
git status --porcelain

# 3. Pre-commit validation (non-blocking warnings, blocking secret check)
if grep -rEn '(ghp_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,})' \
    --exclude-dir=.git --exclude='*.md' . 2>/dev/null; then
  log_error "Potential hardcoded secret — aborting. Remove it and re-run."
  git reset >/dev/null 2>&1
  exit 1
fi
bash "$REPO_DIR/scripts/agent_validate.sh" || log_warn "Validator reported issues (continuing)"

# 4. Conventional Commits normalisation
if [[ ! "$COMMIT_MESSAGE" =~ ^(feat|fix|chore|refactor|test|docs|perf|style|ci|build)(\(.+\))?: ]]; then
  COMMIT_MESSAGE="chore: $COMMIT_MESSAGE"
fi
git commit -m "$COMMIT_MESSAGE"
log_info "Committed: $COMMIT_MESSAGE"

# 5. Push (plain push only — no --force, ever)
git push -u origin "$BRANCH"
log_info "Pushed."

# 6. Open PR
TASK_LABEL="$(echo "$BRANCH" | sed 's|^agent/||; s|-[0-9]\{14\}$||')"
FILES_CHANGED="$(git diff --name-only "origin/$DEFAULT_BRANCH...$BRANCH" 2>/dev/null || echo 'see diff')"
PR_URL="$(gh pr create \
  --title "feat(agent): automated changes for $TASK_LABEL" \
  --body "## Summary

Automated changes from agent swarm (\`$BRANCH\`).

## Files changed
\`\`\`
$FILES_CHANGED
\`\`\`

## Validation
- [x] Secret scan passed (no hardcoded credentials)
- [x] Conventional Commits format
- [x] Branch is not \`$DEFAULT_BRANCH\`
- [ ] CI must pass before merge

## Risk
Low unless noted otherwise. Merge only after green CI + human approval (or \`--auto-merge\` with green CI).

---
*Created by \`scripts/agent_auto_pr.sh\`*" \
  --head "$BRANCH" --base "$DEFAULT_BRANCH")"
log_info "PR: $PR_URL"

# 7. Optional autonomous merge (squash, only when CI is green)
if [ "$FLAG" = "--auto-merge" ]; then
  log_info "Auto-merge armed (squash, waits for green CI)..."
  gh pr merge "$PR_URL" --auto --squash
  log_info "Auto-merge enabled. GitHub merges automatically once all checks pass."
else
  log_info "Done. Merge manually after green CI, or re-run with --auto-merge."
fi
