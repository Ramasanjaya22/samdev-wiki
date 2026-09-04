# Hermes Setup Documentation

Welcome to **samdev-wiki** - Documentation repository for Hermes agent setup.

## Overview

This repository documents the complete setup process for:
- GitHub automation with subagent swarm
- Expert coding agents (implementer + reviewer)
- Svelte frontend planning for FE architecture

## Repository Structure

```
/opt/samdev-wiki/
├── docs/                  # Documentation files
├── scripts/               # Automation scripts
│   ├── agent_git_setup.sh
│   ├── agent_commit_push.sh
│   ├── agent_create_pr.sh
│   └── agent_branch.sh
├── config/
│   └── swarm_agents.yaml
├── .env.example
└── README.md
```

## Agents

1. **expert-coding-implementer** - Senior Software Engineer
2. **expert-coding-reviewer** - Principal Code Reviewer / QA Specialist

## Getting Started

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build
npm run build
```

## Development Workflow

1. Create branch: `agent/<task-name>-<timestamp>`
2. Implement changes
3. Run lint/format
4. Commit with conventional commits
5. Push and create PR
6. Submit for review

## License

MIT