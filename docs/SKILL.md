---
name: agent-devops-github-swarm
description: "GitHub automation for subagent swarms with safe credentials."
version: 1.1.0
author: Hermes Agent
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [github, git, automation, agent, swarm]
    category: devops
    related_skills: [github]
---

# Agent DevOps GitHub Swarm

This skill provides infrastructure for **subagent swarms** to perform automated GitHub operations safely.

## Core Principles

1. **No token exposure** - Credentials via env vars or secure files
2. **Safe defaults** - No force push, no delete branch, no direct main push
3. **Approval required** - PR merge needs explicit approval
4. **Verification gates** - Status/diff checks before commit/push

## Swarm Agent Architecture

### Two Specialist Agents

**Agent 1: `expert-coding-implementer`**
- Senior Software Engineer role
- Implements features, bug fixes, unit tests
- Follows existing architecture
- **Handoff**: Complete → review by Agent 2

**Agent 2: `expert-coding-reviewer`**
- Principal Code Reviewer / QA Specialist
- Reviews code quality, runs tests/lint
- Approves or requests changes
- **Handoff**: Approved → Create PR, Manual Merge

### Branch Naming Convention

```
agent/<task-name>-<timestamp>
# Example: agent/user-auth-fix-20260904123045
```

### Commit Format

Use [Conventional Commits](https://www.conventionalcommits.org/) - feat:, fix:, chore:, refactor:, test:, docs:

## Available Scripts

| Script | Purpose | Safety |
|---|---|---|
| `scripts/agent_git_setup.sh` | Setup git identity locally | Validates identity |
| `scripts/agent_branch.sh` | Create agent branch | Requires task name |
| `scripts/agent_commit_push.sh` | Commit + push | Pre-commit validation |
| `scripts/agent_create_pr.sh` | Create PR via gh CLI | Validates branch |
| `scripts/agent_validate.sh` | Pre-commit checks | Safety gate |
| `scripts/test_acceptance.sh` | Full setup verification | Non-destructive |
| `scripts/setup_git_creds.sh` | Configure credentials | Token from file |
| `scripts/run_swarm_demo.sh` | Workflow demonstration | End-to-end demo |

## Security Rules

- Never print token, password, PAT, SSH key, or secret
- Use `GH_TOKEN` or `GITHUB_TOKEN` env var
- Token scope: contents:read/write, pull_requests:read/write, metadata:read
- Never force push, never delete branches
- Never push to default branch without approval
- Run `git status` and `git diff` before commit

## Token Security Best Practices

### ⚠️ CRITICAL: Push Protection Rule

GitHub actively scans for token patterns. If detected:

```
GH013: Repository rule violations found for refs/heads/main
GH013: Push cannot contain secrets
```

**Solution if blocked:**
1. Reset to clean commit: `git reset --hard <safe-commit-hash>`
2. Remove all token patterns: `grep -r 'ghp_' . --include='*.sh' --include='*.py'`
3. Use environment variables or credential files
4. Create new clean commit

### ✓ Secure Token Handling Patterns

```bash
# GOOD: Token from secure file (never in commit history)
TOKEN=$(cat /root/.secrets/github_token)
git remote set-url push "https://x-access-token:${TOKEN}@github.com/org/repo.git"

# BETTER: Use gh CLI which manages auth internally
git push -u origin <branch>

# EXAMPLE: .env.example shows format without real values
# GH_TOKEN=your_ghp_token_here
```

### ✗ Patterns That Trigger Secret Scanning

```bash
# NEVER hardcode in scripts - will block push!
git remote set-url origin "https://ghp_actualtoken123@github.com/org/repo.git"
echo "GH_TOKEN=ghp_xxx"  # in any file
```

### Token Security Practices

1. **Never** hardcode in scripts
2. **Never** print token to logs
3. **Use** environment variables or secure files
4. **Minimize** scope when possible (fine-grained token)
5. **Rotate** regularly

### Environment Variables

| Variable | Required | Purpose |
|---|---|---|
| `GH_TOKEN` | Yes | GitHub Personal Access Token |
| `GIT_AUTHOR_NAME` | Yes | Name for agent commits |
| `GIT_AUTHOR_EMAIL` | Yes | Email for agent commits |
| `REPO_DIR` | Yes | Repository path |
| `DEFAULT_BRANCH` | Recommended | Default branch name |
| `WORK_DIR` | Recommended | Working directory |
| `TASK_NAME` | For branch | Task name for branch |

### Example Usage

```bash
# Set required environment (via .env or directly)
export GH_TOKEN=$(cat /root/.secrets/github_token)
export GIT_AUTHOR_NAME="Agent Swarm"
export GIT_AUTHOR_EMAIL="agent@footygraph.com"
export REPO_DIR="/opt/samdev-wiki"
export DEFAULT_BRANCH="main"

# Verify setup
/opt/samdev-wiki/scripts/test_acceptance.sh

# Create branch
/opt/samdev-wiki/scripts/agent_branch.sh "user-auth-fix"

# Make changes, then commit & push
/opt/samdev-wiki/scripts/agent_commit_push.sh "feat: implement auth" --auto

# Create PR
/opt/samdev-wiki/scripts/agent_create_pr.sh "agent/user-auth-fix-20260904" "feat: implement user auth"
```

## Verification Script

### test_acceptance.sh - Pre-deployment checks

```bash
#!/bin/bash
# 11 automated tests:
# 1. Git installed
# 2. GitHub CLI installed  
# 3. Authentication verified
# 4. Repository accessible
# 5. Git identity configured
# 6. Scripts executable
# 7. Config files present
# 8. Docs files present
# 9. Branch creation works
# 10. No secrets exposed
# 11. Token stored securely
```

## Common Errors

### 'permission denied' or 'bad execution'

```bash
# Token may be invalid or expired
# Check at: https://github.com/settings/tokens
# Generate new token with required scopes
```

### 'API rate limit exceeded'

```bash
# Token may have low priority
# Wait 1 hour or regenerate token
```

### 'Resource not accessible by integration'

```bash
# Token missing required scopes
# Re-auth with proper permissions
gh auth refresh -s repo,workflow,read:org
```

### GH013 Push Protection

```bash
# Token pattern detected in commits
# Solution: Reset to clean commit, remove token refs, use env vars
git reset --hard <clean-commit>
# Use scripts/run_swarm_demo.sh to start fresh
```

## Related Workflows

- `github` skill for single-developer workflows
- `omh-codebase-onboarding` for full codebase onboarding
- `ulw-work` for agent orchestration