# GitHub Authentication & Agent Setup Guide

## Prerequisites

1. **Git installed**: `git --version` (should be 2.30+)
2. **GitHub CLI installed**: `gh --version` (should be 2.0+)
3. **GitHub Token with scopes**:
   - `repo` (contents: read/write)
   - `workflow` (actions: read/write)
   - `write:org` (if applicable)
   - `public_repo` (for public repos)

## Step 1: Generate GitHub Token

1. Go to https://github.com/settings/tokens
2. Click "Generate new token" → "Fine-grained token" or "Classic PAT"
3. Set expiration (recommended: 30 days)
4. Add scopes:
   - Repository: `contents: read/write`, `pull_requests: read/write`
   - Metadata: `read`
5. Generate and copy the token

## Step 2: Authenticating with GitHub CLI

### Method 1: Interactive Login (Recommended for manual use)
```bash
gh auth login
# Select: GitHub.com → HTTPS → Paste token
```

### Method 2: Non-interactive (for automation)
```bash
export GH_TOKEN=ghp_your_token_here
echo "$GH_TOKEN" | gh auth login --with-token
```

### Method 3: Using stored token
```bash
# Token stored in /root/.secrets/github_token
source /opt/samdev-wiki/scripts/agent_git_setup.sh
```

## Step 3: Verify Authentication

```bash
gh auth status
# Should show: ✓ Logged in to github.com

gh api /user --silent
# Should return user info
```

## Step 4: Clone Repository

```bash
gh repo clone your-org/your-repo
# or
git clone https://github.com/your-org/your-repo.git
```

## Step 5: Setup Git Identity (Local)

```bash
cd your-repo
git config --local user.name "Agent Swarm"
git config --local user.email "agent@footygraph.com"
```

## Step 6: Verify Credential Helper

```bash
git config --local credential.helper
# Should show: cache --timeout=3600
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GH_TOKEN` | Yes | GitHub Personal Access Token |
| `GIT_AUTHOR_NAME` | Yes | Author name for commits |
| `GIT_AUTHOR_EMAIL` | Yes | Author email for commits |
| `REPO_DIR` | Yes | Repository directory path |
| `DEFAULT_BRANCH` | No | Default branch (default: main) |
| `BRANCH_PREFIX` | No | Branch name prefix (default: agent) |

## Security Best Practices

1. **Never commit tokens** - Add `.env` to `.gitignore`
2. **Use fine-grained tokens** when possible
3. **Set token expiration** (30-90 days)
4. **Minimal scopes** - only what's needed
5. **Rotate tokens regularly**

## Troubleshooting

### Authentication failed
```bash
# Check token validity
gh auth status
# Re-authenticate
gh auth login
```

### Permission denied
```bash
# Check token scopes
echo $GH_TOKEN | cut -d. -f3 | base64 -d | jq .
```

### Credential helper issues
```bash
# Clear cached credentials
git config --local --unset credential.helper
# Or reset
git config --local credential.helper "cache --timeout=3600"
```