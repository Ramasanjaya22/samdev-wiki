# Hermes Agent Swarm Setup Documentation

Welcome to **samdev-wiki** - Documentation for GitHub automation with subagent swarm and expert coding agents.

## 🚀 Quick Start

```bash
# 1. Setup environment
source ./scripts/setup_env.sh

# 2. Create branch for task
./scripts/agent_branch.sh "task-name"

# 3. Make changes
# (edit files as needed)

# 4. Commit & push
./scripts/agent_commit_push.sh "feat: description" "agent/task-timestamp" --auto

# 5. Create PR
./scripts/agent_create_pr.sh "agent/task-timestamp" "Title" "Body..."
```

## 📁 Project Structure

```
/opt/samdev-wiki/
├── docs/                           # Documentation
│   ├── agent-github-setup.md       # GitHub setup guide
│   └── coding-agents.md            # Agent workflow docs
├── scripts/                        # Automation scripts
│   ├── agent_branch.sh             # Create agent branch
│   ├── agent_git_setup.sh          # Setup git identity
│   ├── agent_commit_push.sh        # Commit & push workflow
│   ├── agent_create_pr.sh          # Create PR via gh CLI
│   ├── agent_validate.sh           # Pre-commit validation
│   ├── test_acceptance.sh          # Acceptance test suite
│   ├── setup_git_creds.sh          # Configure git credentials
│   └── git-askpass.sh              # Credential helper
├── config/
│   └── swarm_agents.yaml           # Agent definitions
├── public/                         # Static website
│   └── index.html                  # Landing page
├── .env.example                    # Environment template
└── package.json                    # Project config
```

## 🤖 Agent Swarm

### 1. expert-coding-implementer
**Role**: Senior Software Engineer  
Implements features, fixes bugs, writes clean code.

### 2. expert-coding-reviewer  
**Role**: Principal Code Reviewer / QA Specialist  
Reviews code, runs tests, ensures quality.

## 💻 Development Workflow

1. Create branch: `agent/<task-name>-<timestamp>`
2. Implement changes
3. Run validation: `./scripts/agent_validate.sh`
4. Commit with conventional commits: `feat:`, `fix:`, `chore:`
5. Push: `./scripts/agent_commit_push.sh "feat: ..." "agent/..."`
6. Create PR: `./scripts/agent_create_pr.sh "agent/..." "Title"`

## 🌐 Public Website

**URL**: https://agents.footygraph.com

Served via:
- Static site server: Python HTTP server on port 8000
- Cloudflared tunnel: `agents.footygraph.com` → localhost:8000
- Directory: `/opt/samdev-wiki/public/`

## 🔐 GitHub Authentication

### Required Token Scopes
- `contents: read/write` - Git operations
- `pull_requests: read/write` - PR management
- `metadata: read` - Repository info

### Setup Token
```bash
# Store token securely
echo "ghp_your_token" > /root/.secrets/github_token
chmod 600 /root/.secrets/github_token

# Authenticate gh CLI
cat /root/.secrets/github_token | gh auth login --with-token
```

### Verify Setup
```bash
./scripts/test_acceptance.sh
```

## 🛡️ Security Rules

| Rule | Status |
|------|--------|
| No force push | ✅ Enforced |
| No delete branch | ✅ Enforced |
| No direct to main | ✅ Enforced |
| No hardcoded secrets | ✅ Verified |
| Secret scanning | ✅ Enabled |

## 📚 Documentation

- **Agent Setup**: [docs/agent-github-setup.md](docs/agent-github-setup.md)
- **Agent Workflow**: [docs/coding-agents.md](docs/coding-agents.md)
- **Acceptance Tests**: `./scripts/test_acceptance.sh`

## 🔄 Repository Access

| Service | URL | Port |
|---------|-----|------|
| API Docs | http://localhost:8080 | 8080 |
| Agent Wiki | https://agents.footygraph.com | 8000 |
| OmniRoute | https://omniroute.footygraph.com | 20129 |

## 📄 License

MIT