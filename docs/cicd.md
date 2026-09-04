# Autonomous CI/CD

This repo runs a fully autonomous loop: **push → CI → auto-PR → auto-merge on green**.

## Loop overview

```
agent edits files
       ↓
scripts/agent_auto_pr.sh "<task>" "<conventional-commit-msg>" [--auto-merge]
       ↓
branch agent/<task>-<timestamp> → secret scan → commit → push → PR opened
       ↓
GitHub Actions `agent-swarm-ci` runs on the PR
       ↓
green CI + --auto-merge  →  GitHub squash-merges automatically
green CI, no flag        →  human merges manually
```

## CI (`agent-swarm-ci`, `.github/workflows/ci.yml`)

Triggers on pushes to `agent/**` and PRs to `main`. No secrets required. Checks:

1. `bash -n` syntax on every `scripts/*.sh`
2. Secret scan — fails on real `ghp_`/`gho_`/`AKIA`/`sk-` literals
   (placeholders like `ghp_your_token_here` / `ghp_xxx` don't match)
3. All required swarm files present
4. All `scripts/*.sh` executable
5. Conventional Commits format on PR title / HEAD message

## Autonomous PR script

```bash
# Make your edits first, then:
./scripts/agent_auto_pr.sh "update-docs" "docs: refresh setup guide"

# Or arm auto-merge (squash, only fires on green CI):
./scripts/agent_auto_pr.sh "fix-typo" "fix: correct README link" --auto-merge
```

Guarantees (same as the rest of the swarm):

- never `--force`, never deletes branches, never touches `main` directly
- aborts if the secret scan hits
- aborts if there's nothing to commit (cleans up the empty branch)

## Policy

| Setting | Value |
|---|---|
| Auto-create PR | ✅ true (`agent_auto_pr.sh`) |
| Auto-merge | opt-in per PR via `--auto-merge` (squash, green-CI-gated) |
| Direct push to `main` | ❌ forbidden |
| Merge strategy | squash (keeps `main` linear) |

`--auto-merge` uses `gh pr merge --auto --squash`: GitHub merges the moment
all required checks pass. Without the flag, merging stays manual.
