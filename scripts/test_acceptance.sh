#!/bin/bash
# Acceptance Test Script for Agent Swarm

set -euo pipefail

REPO_DIR="/opt/samdev-wiki"
TEST_BRANCH="agent/test-acceptance-$(date +%Y%m%d%H%M%S)"
PASS=0
FAIL=0

echo "=== Agent Swarm Acceptance Tests ==="
echo ""

# Test 1: Git installed
echo "[TEST 1] Git installed..."
if command -v git &>/dev/null; then
    git --version | head -1 && PASS=$((PASS+1)) && echo "  ✓ PASS"
else
    echo "  ✗ FAIL" && FAIL=$((FAIL+1))
fi

# Test 2: GitHub CLI installed
echo "[TEST 2] GitHub CLI installed..."
if command -v gh &>/dev/null; then
    gh --version | head -1 && PASS=$((PASS+1)) && echo "  ✓ PASS"
else
    echo "  ✗ FAIL" && FAIL=$((FAIL+1))
fi

# Test 3: Authentication
echo "[TEST 3] GitHub authentication..."
if gh auth status &>/dev/null; then
    echo "  ✓ PASS - Authenticated"
    PASS=$((PASS+1))
else
    echo "  ✗ FAIL - Not authenticated"
    FAIL=$((FAIL+1))
fi

# Test 4: Repository accessible
echo "[TEST 4] Repository accessible..."
cd "$REPO_DIR"
if git remote -v | grep -q "github.com"; then
    echo "  ✓ PASS - Remote origin set"
    PASS=$((PASS+1))
else
    echo "  ✗ FAIL - No remote origin"
    FAIL=$((FAIL+1))
fi

# Test 5: Git identity configured
echo "[TEST 5] Git identity configured..."
AUTHOR=$(git config --local user.name)
EMAIL=$(git config --local user.email)
if [ -n "$AUTHOR" ] && [ -n "$EMAIL" ]; then
    echo "  ✓ PASS - Name: $AUTHOR, Email: $EMAIL"
    PASS=$((PASS+1))
else
    echo "  ✗ FAIL - Identity not configured"
    FAIL=$((FAIL+1))
fi

# Test 6: Scripts exist and are executable
echo "[TEST 6] Scripts exist and executable..."
SCRIPTS="agent_git_setup.sh agent_commit_push.sh agent_create_pr.sh agent_branch.sh agent_validate.sh"
ALL_SCRIPTS_EXIST=true
for script in $SCRIPTS; do
    if [ ! -x "$REPO_DIR/scripts/$script" ]; then
        echo "  ✗ Missing: $script"
        ALL_SCRIPTS_EXIST=false
    fi
done
if [ "$ALL_SCRIPTS_EXIST" = true ]; then
    echo "  ✓ PASS - All scripts present"
    PASS=$((PASS+1))
else
    echo "  ✗ FAIL - Some scripts missing"
    FAIL=$((FAIL+1))
fi

# Test 7: Config files exist
echo "[TEST 7] Configuration files exist..."
if [ -f "$REPO_DIR/config/swarm_agents.yaml" ]; then
    echo "  ✓ PASS - swarm_agents.yaml exists"
    PASS=$((PASS+1))
else
    echo "  ✗ FAIL - swarm_agents.yaml missing"
    FAIL=$((FAIL+1))
fi

# Test 8: Docs exist
echo "[TEST 8] Documentation files exist..."
DOCS="agent-github-setup.md coding-agents.md"
ALL_DOCS_EXIST=true
for doc in $DOCS; do
    if [ ! -f "$REPO_DIR/docs/$doc" ]; then
        echo "  ✗ Missing: $doc"
        ALL_DOCS_EXIST=false
    fi
done
if [ "$ALL_DOCS_EXIST" = true ]; then
    echo "  ✓ PASS - All docs present"
    PASS=$((PASS+1))
else
    echo "  ✗ FAIL - Some docs missing"
    FAIL=$((FAIL+1))
fi

# Test 9: Branch creation capability
echo "[TEST 9] Branch creation capability..."
git checkout main 2>/dev/null || git checkout master 2>/dev/null
git pull origin main 2>/dev/null || true
git checkout -B "$TEST_BRANCH"
if git branch --show-current | grep -q "$TEST_BRANCH"; then
    echo "  ✓ PASS - Can create branches"
    PASS=$((PASS+1))
else
    echo "  ✗ FAIL - Cannot create branches"
    FAIL=$((FAIL+1))
fi

# Test 10: No secrets exposed
echo "[TEST 10] No secrets exposed..."
if grep -rE "(ghp_|AKIA|sk_)[a-zA-Z0-9]{20,}" "$REPO_DIR/docs/" "$REPO_DIR/scripts/" 2>/dev/null | grep -v "github_token" | grep -v ".env.example" | grep -v "ghp_your_token_here"; then
    echo "  ✗ FAIL - Potential secrets found"
    FAIL=$((FAIL+1))
else
    echo "  ✓ PASS - No secrets exposed"
    PASS=$((PASS+1))
fi

# Test 11: Token stored securely
echo "[TEST 11] Token stored securely..."
if [ -f "/root/.secrets/github_token" ] && [ -s "/root/.secrets/github_token" ]; then
    echo "  ✓ PASS - Token file exists with content"
    PASS=$((PASS+1))
else
    echo "  ✗ FAIL - Token file missing or empty"
    FAIL=$((FAIL+1))
fi

# Cleanup
echo ""
echo "Cleaning up test branch..."
git checkout main 2>/dev/null || git checkout master 2>/dev/null
git branch -D "$TEST_BRANCH" 2>/dev/null || true

# Summary
echo ""
echo "=== Test Summary ==="
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "✓ All tests passed! Agent swarm is ready."
    exit 0
else
    echo "✗ Some tests failed. Please review."
    exit 1
fi