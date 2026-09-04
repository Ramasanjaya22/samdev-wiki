# GitHub Authentication Setup for Agent Swarm

## Prerequisites

```bash
# Check git installed
git --version

# Check gh CLI installed
gh --version

# Verify token exists (should show value, not env var name)
if [ -f "/root/.secrets/github_token" ]; then
    echo "Token file exists"
else
    echo "GH_TOKEN env var: ${GH_TOKEN:-\"not set\"}"
fi
```

## Authentication Methods

### Option 1: Environment Variable (Recommended)

```bash
# From secure file
export GH_TOKEN=$(cat /root/.secrets/github_token)

# Or set directly (not in scripts!)
export GH_TOKEN="ghp_your_token_here"
```

### Option 2: gh CLI Auth

```bash
# Login via CLI (token read from stdin, not history)
echo "$GH_TOKEN" | gh auth login --with-token

# Verify
gh auth status
```

### Option 3: Credential Store

```bash
# For git operations, store credentials
git config --global credential.helper "cache --timeout=3600"
gh auth refresh -s repo,workflow,read:org
```

## Token Permissions Required

| Scope | Permission | Reason |
|---|---|---|
| contents | read/write | Read/write files, create branches |
| pull_requests | read/write | Create, view, comment on PRs |
| metadata | read | Get repo info, labels, defaults |

## Token Security Practices

1. **Never** hardcode in scripts
2. **Never** print token to logs
3. **Use** environment variables or secure files (`/root/.secrets/`)
4. **Minimize** scope when possible (fine-grained token preferred)
5. **Rotate** regularly

**⚠️ PUSH PROTECTION WARNING**: GitHub scans all commits for token patterns. If found:
- Push will be rejected with `GH013: Repository rule violations`
- Solution: Reset to clean commit, remove token refs, use env vars

## Common Errors

### Permission Denied or Bad Execution

```bash
# Token may be invalid or expired
# Check at: https://github.com/settings/tokens
# Generate new token with required scopes:
# - contents: read/write
# - pull_requests: read/write
# - metadata: read
```

### API Rate Limit Exceeded

```bash
# Token may have low priority (free tier)
# Wait 1 hour or regenerate token
```

### Resource Not Accessible

```bash
# Token missing required scopes
# Re-auth with proper permissions
gh auth refresh -s repo,workflow,read:org
```

### GH013 Push Protection

```bash
# Token pattern detected in commits
# Solution:
# 1. git reset --hard <clean-commit>
# 2. Remove all 'ghp_' patterns: grep -r 'ghp_' .
# 3. Recreate commits using environment variables
# 4. Use scripts/run_swarm_demo.sh for clean workflow
```

## Verification Script

```bash
#!/bin/bash
# verify-github-auth.sh
set -euo pipefail

echo "Checking GitHub authentication..."

# Check gh installed
if ! command -v gh &> /dev/null; then
    echo "ERROR: gh CLI not installed"
    exit 1
fi

# Check auth status
if ! gh auth status 2>/dev/null; then
    echo "ERROR: Not authenticated with GitHub"
    echo "Run: gh auth login"
    exit 1
fi

# Test API access
if gh api /user --silent 2>/dev/null; then
    echo "✓ API access OK"
else
    echo "ERROR: API access failed"
    exit 1
fi

echo "✓ GitHub auth verified"
```

## Local Development Override

For local dev, sync with main before creating agent branch:

```bash
git fetch origin
git checkout main
git pull origin main
```

## On CI/CD Systems

```yaml
# GitHub Actions example
env:
  GH_TOKEN: ${{ secrets.GH_TOKEN }}
  GIT_AUTHOR_NAME: "agent"
  GIT_AUTHOR_EMAIL: "agent@footygraph.com"
  DEFAULT_BRANCH: "main"
```

## Windows Note

On Windows PowerShell:
```powershell
$env:GH_TOKEN = "ghp_your_token_here"
```

On Windows CMD:
```cmd
set GH_TOKEN=ghp_your_token_here
```

## Quick Setup Script

```bash
# One-time setup
cat /root/.secrets/github_token > ~/.netrc
git config --global credential.helper store
```