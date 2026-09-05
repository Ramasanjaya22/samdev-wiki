export const homeContent = {
  title: 'SamDev Wiki',
  subtitle: 'Agent Swarm Documentation',
  description: 'Documentation for GitHub automation with subagent swarm and expert coding agents.',
  status: { label: 'All Systems Operational', ok: true },
  features: [
    {
      icon: '🤖',
      title: 'Dual Agent Architecture',
      desc: 'Implementer writes code, Reviewer ensures quality. Two specialist agents working in tandem.'
    },
    {
      icon: '🔄',
      title: 'Autonomous CI/CD',
      desc: 'Push → CI → auto-PR → merge on green. Fully automated loop with safety gates.'
    },
    {
      icon: '🛡️',
      title: 'Security First',
      desc: 'No force push, no secret leaks, no direct-to-main. Every gate enforced by script and CI.'
    },
    {
      icon: '📜',
      title: 'Convention Commits',
      desc: 'feat:, fix:, chore:, refactor:, test:, docs: — enforced by CI on every PR.'
    }
  ],
  stats: [
    { label: 'Scripts', value: '10' },
    { label: 'CI Checks', value: '5' },
    { label: 'Security Rules', value: '6' },
    { label: 'Agents', value: '2' }
  ]
};

export const quickStartContent = `# Quick Start

Get the agent swarm running in under 5 minutes.

## Prerequisites

- **Git** 2.30+
- **GitHub CLI** 2.0+
- **GitHub Token** with scopes: \`contents:read/write\`, \`pull_requests:read/write\`, \`metadata:read\`

## Setup

\`\`\`bash
# 1. Clone the repo
gh repo clone Ramasanjaya22/samdev-wiki && cd samdev-wiki

# 2. Setup environment
source ./scripts/setup_env.sh

# 3. Verify setup
./scripts/test_acceptance.sh
\`\`\`

## Workflow

\`\`\`bash
# 1. Create branch for task
./scripts/agent_branch.sh "task-name"

# 2. Make changes
# (edit files as needed)

# 3. Commit & push
./scripts/agent_commit_push.sh "feat: description" "agent/task-timestamp" --auto

# 4. Create PR
./scripts/agent_create_pr.sh "agent/task-timestamp" "Title" "Body..."

# 5. Or use autonomous loop
./scripts/agent_auto_pr.sh "task-name" "feat: description" --auto-merge
\`\`\`

## Project Structure

\`\`\`
samdev-wiki/
├── docs/           # Documentation (4 markdown files)
├── scripts/        # Automation scripts (10 bash scripts)
├── config/         # Agent definitions (swarm_agents.yaml)
├── src/            # Svelte frontend
├── public/         # Static assets
├── .github/        # CI workflow
├── Caddyfile       # Reverse proxy config
└── .env.example    # Environment template
\`\`\`
`;

export const agentSetupContent = `# GitHub Authentication & Agent Setup

## Step 1: Generate GitHub Token

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **Generate new token** → **Fine-grained token** or **Classic PAT**
3. Set expiration (recommended: 30 days)
4. Add scopes:
   - \`contents: read/write\`
   - \`pull_requests: read/write\`
   - \`metadata: read\`

## Step 2: Authenticate

\`\`\`bash
# Interactive (manual)
gh auth login

# Non-interactive (automation)
export GH_TOKEN=ghp_your_token
echo "$GH_TOKEN" | gh auth login --with-token

# From stored token
source /opt/samdev-wiki/scripts/agent_git_setup.sh
\`\`\`

## Step 3: Verify

\`\`\`bash
gh auth status      # ✓ Logged in to github.com
gh api /user --silent  # Returns user info
\`\`\`

## Step 4: Git Identity

\`\`\`bash
cd your-repo
git config --local user.name "Agent Swarm"
git config --local user.email "agent@footygraph.com"
\`\`\`

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| \`GH_TOKEN\` | Yes | GitHub Personal Access Token |
| \`GIT_AUTHOR_NAME\` | Yes | Author name for commits |
| \`GIT_AUTHOR_EMAIL\` | Yes | Author email for commits |
| \`REPO_DIR\` | Yes | Repository directory path |
| \`DEFAULT_BRANCH\` | No | Default branch (default: main) |
| \`BRANCH_PREFIX\` | No | Branch name prefix (default: agent) |

## Security Best Practices

1. **Never commit tokens** — Add \`.env\` to \`.gitignore\`
2. **Use fine-grained tokens** when possible
3. **Set token expiration** (30–90 days)
4. **Minimal scopes** — only what's needed
5. **Rotate tokens regularly**
`;

export const agentsContent = `# Coding Agents

## Agent 1: expert-coding-implementer

**Role:** Senior Software Engineer / Implementation Specialist

### Mission
- Implement features from requirement specs
- Fix existing bugs
- Write clean, modular, safe production code
- Create basic unit tests
- Follow existing repo architecture

### Capabilities
- \`read_file\` — Read existing code
- \`write_file\` — Create new files
- \`edit_file\` — Edit existing files
- \`run_command\` — Run shell commands
- \`git_add/commit/push\` — Git operations
- \`create_pull_request\` — Open PR

### Constraints
- No force push
- No branch deletion
- No direct push to default branch
- Strict typing (Python)
- No new deps unless required
- Small, focused commits

---

## Agent 2: expert-coding-reviewer

**Role:** Principal Code Reviewer / QA Specialist

### Mission
- Review code from Implementer
- Ensure code safety, consistency, architecture
- Run tests, lint, checks
- Find bugs, edge cases, security issues
- Approve or request changes

### Review Checklist
- [ ] Code linter/formatter run
- [ ] All tests present
- [ ] Tests passing
- [ ] No secrets or credentials
- [ ] Conventional commits
- [ ] Not default branch
- [ ] Changes match requirement
- [ ] No irrelevant changes

---

## End-to-End Workflow

\`\`\`
User task → Branch → Implement → Review → PR → Merge
   1.        2.        3.          4.      5.     6.
\`\`\`

1. **Task**: User describes what's needed
2. **Branch**: \`agent/<task>-<timestamp>\`
3. **Implement**: Code changes + validation
4. **Review**: Lint, test, security check
5. **PR**: Created via \`gh pr create\`
6. **Merge**: User reviews and merges manually
`;

export const cicdContent = `# Autonomous CI/CD

This repo runs a fully autonomous loop: **push → CI → auto-PR → auto-merge on green**.

## Loop Overview

\`\`\`
agent edits files
       ↓
scripts/agent_auto_pr.sh "<task>" "<msg>" [--auto-merge]
       ↓
branch agent/<task>-<timestamp> → secret scan → commit → push → PR opened
       ↓
GitHub Actions \`agent-swarm-ci\` runs on the PR
       ↓
green CI + --auto-merge  →  GitHub squash-merges automatically
green CI, no flag        →  human merges manually
\`\`\`

## CI Checks (agent-swarm-ci)

Triggers on pushes to \`agent/**\` and PRs to \`main\`. No secrets required.

1. **Bash syntax** — \`bash -n\` on every \`scripts/*.sh\`
2. **Secret scan** — Fails on real \`ghp_\`/\`gho_\`/\`AKIA\`/\`sk-\` patterns
3. **Required files** — All swarm files present
4. **Executable scripts** — All \`scripts/*.sh\` have +x
5. **Conventional commits** — PR title / HEAD message format

## Usage

\`\`\`bash
# Standard (manual merge)
./scripts/agent_auto_pr.sh "update-docs" "docs: refresh guide"

# With auto-merge (squash, green-CI-gated)
./scripts/agent_auto_pr.sh "fix-typo" "fix: correct link" --auto-merge
\`\`\`

## Policy

| Setting | Value |
|---------|-------|
| Auto-create PR | ✅ via \`agent_auto_pr.sh\` |
| Auto-merge | Opt-in per PR (\`--auto-merge\`) |
| Direct push to main | ❌ Forbidden |
| Merge strategy | Squash (linear history) |
`;

export const scriptsContent = `# Scripts Reference

## Agent Scripts

| Script | Purpose |
|--------|---------|
| \`agent_branch.sh\` | Create agent branch with prefix |
| \`agent_git_setup.sh\` | Setup git identity locally |
| \`agent_commit_push.sh\` | Commit + push with validation |
| \`agent_create_pr.sh\` | Create PR via gh CLI |
| \`agent_auto_pr.sh\` | Autonomous branch→commit→PR→merge loop |
| \`agent_validate.sh\` | Pre-commit safety checks |
| \`test_acceptance.sh\` | Full setup verification (11 tests) |
| \`setup_git_creds.sh\` | Configure git credentials |
| \`git-askpass.sh\` | Credential helper for automation |
| \`run_swarm_demo.sh\` | End-to-end workflow demo |

## Usage Examples

\`\`\`bash
# Create a branch
./scripts/agent_branch.sh "user-auth-fix"

# Implement changes, then commit
./scripts/agent_commit_push.sh "feat: implement auth" "agent/user-auth-fix-20260904"

# Validate before commit
./scripts/agent_validate.sh

# Create PR
./scripts/agent_create_pr.sh "agent/user-auth-fix-20260904" "feat: implement auth"

# Full autonomous loop
./scripts/agent_auto_pr.sh "user-auth-fix" "feat: implement auth" --auto-merge

# Run acceptance tests
./scripts/test_acceptance.sh

# Demo the workflow
./scripts/run_swarm_demo.sh
\`\`\`

## Branch Naming

\`\`\`
agent/<task-name>-<timestamp>
# Example: agent/user-auth-fix-20260904123045
\`\`\`

## Commit Format

Use [Conventional Commits](https://www.conventionalcommits.org/):

- \`feat:\` — New feature
- \`fix:\` — Bug fix
- \`chore:\` — Maintenance
- \`refactor:\` — Code restructure
- \`test:\` — Tests
- \`docs:\` — Documentation
`;

export const securityContent = `# Security Rules

## Enforced Rules

| Rule | Status | Enforced By |
|------|--------|-------------|
| No force push | ✅ | Scripts + CI |
| No delete branch | ✅ | Scripts + CI |
| No direct to main | ✅ | Scripts + CI |
| No hardcoded secrets | ✅ | CI secret scan |
| Secret scanning | ✅ | GitHub push protection |
| Minimum token scopes | ✅ | Validation script |

## Token Security

### Patterns That Trigger Secret Scanning

\`\`\`bash
# NEVER hardcode — will block push!
git remote set-url origin "https://ghp_xxx@github.com/org/repo.git"
echo "GH_TOKEN=ghp_xxx"  # in any file
\`\`\`

### Secure Patterns

\`\`\`bash
# GOOD: Token from secure file
TOKEN=$(cat /root/.secrets/github_token)

# BETTER: Use gh CLI (manages auth internally)
git push -u origin <branch>
\`\`\`

### If Push Blocked by GH013

1. Reset to clean commit: \`git reset --hard <safe-commit-hash>\`
2. Remove token patterns: \`grep -r 'ghp_' . --include='*.sh'\`
3. Use environment variables or credential files
4. Create new clean commit

## Best Practices

1. **Never** hardcode tokens in scripts
2. **Never** print tokens to logs
3. **Use** env vars or secure files
4. **Minimize** scope (fine-grained tokens)
5. **Rotate** regularly (30–90 days)
`;

export const troubleshootingContent = `# Troubleshooting

## Authentication Failed

\`\`\`bash
# Check token validity
gh auth status

# Re-authenticate
gh auth login
\`\`\`

## Permission Denied

\`\`\`bash
# Check token scopes
gh auth refresh -s repo,workflow,read:org
\`\`\`

## Credential Helper Issues

\`\`\`bash
# Clear cached credentials
git config --local --unset credential.helper

# Reset
git config --local credential.helper "cache --timeout=3600"
\`\`\`

## API Rate Limit

\`\`\`bash
# Wait 1 hour or regenerate token
# Check: https://github.com/settings/tokens
\`\`\`

## GH013 Push Protection

Token pattern detected in commits:

\`\`\`bash
# 1. Reset to clean commit
git reset --hard <clean-commit-hash>

# 2. Find token patterns
grep -r 'ghp_' . --include='*.sh' --include='*.py'

# 3. Use env vars instead
export GH_TOKEN=$(cat /root/.secrets/github_token)

# 4. Fresh commit
./scripts/agent_auto_pr.sh "fix-secrets" "chore: remove token patterns"
\`\`\`

## Resource Not Accessible

\`\`\`bash
# Token missing scopes — re-auth with proper permissions
gh auth refresh -s repo,workflow,read:org
\`\`\`

## DNS / Cloudflared Issues

\`\`\`bash
# Check tunnel status
cloudflared tunnel info <tunnel-name>

# Fix DNS
./scripts/fix_dns.sh
./scripts/fix_cf_1003.sh
\`\`\`
`;

export const pageContentMap = {
  'home': homeContent,
  'quick-start': quickStartContent,
  'agent-setup': agentSetupContent,
  'agents': agentsContent,
  'cicd': cicdContent,
  'scripts': scriptsContent,
  'security': securityContent,
  'troubleshooting': troubleshootingContent,
};
