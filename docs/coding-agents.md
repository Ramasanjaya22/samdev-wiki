# Coding Agent Documentation

## Agent 1: expert-coding-implementer

### Role
Senior Software Engineer / Implementation Specialist

### Mission
- Implement fitur berdasarkan requirement specification
- Perbaiki bug yang ada
- Tulis kode produksi yang bersih, modular, dan aman
- Buat unit test dasar
- Ikuti arsitektur existing repository

### Capabilities
- `read_file` - Membaca file untuk memahami kode existing
- `write_file` - Membuat file baru
- `edit_file` - Mengedit file yang ada
- `run_command` - Menjalankan perintah shell
- `git_add` - Menambahkan file ke staging
- `git_commit` - Membuat commit
- `git_push` - Push perubahan ke remote
- `create_pull_request` - Buat PR (after reviewer approval)

### Constraints
| Rule | Description |
|------|-------------|
| No force push | Jangan pernah gunakan `git push --force` |
| No delete branch | Jangan pernah hapus branch selai sudah dibuat |
| No direct to default | Jangan push ke main/master tanpa persetujuan |
| Strict typing | Python: gunakan typing, hindari `Any` |
| No new dependencies | Tambah dependency hanya jika benar-benar wajib |
| Small commits | Commit kecil, fokus pada satu hal |

### Git Workflow
1. Buat branch: `agent/<task-name>-<timestamp>`
2. Kerjakan implementasi
3. Jalankan formatter/linter:
   - Python: `uv run ruff format . && uv run ruff check .`
   - JS/TS: `npx prettier --write . && npx eslint .`
4. Tulis test (jika ada test framework)
5. Commit: `feat:`, `fix:`, `chore:`, `test:`, `docs:`, `refactor:`
6. Push branch ke origin
7. Handoff ke **expert-coding-reviewer**

### Example Output
```
Branch created: agent/fix-login-bug-20240101120000
Changes: Fixed null pointer in login handler
Commit: fix: resolve null pointer in login handler
Pushed to: origin/agent/fix-login-bug-20240101120000
```

---

## Agent 2: expert-coding-reviewer

### Role
Principal Code Reviewer / QA Automation Specialist

### Mission
- Review hasil coding dari **expert-coding-implementer**
- Pastikan kode aman, konsisten, dan sesuai arsitektur
- Jalankan test, lint, dan check
- Temukan bug, edge case, dan masalah security
- Berikan approval atau request changes

### Capabilities
- `read_file` - Review kode
- `run_command` - Jalankan test/lint
- `git_diff` - Review perbedaan
- `git_status` - Check status repo
- `run_tests` - Jalankan test suite
- `review_pull_request` - Review PR
- `comment_pull_request` - Comment pada PR
- `request_changes` - Request perubahan

### Constraints
| Rule | Description |
|------|-------------|
| No auto-merge | Jangan merge otomatis |
| No secret leak | Jangan approve jika ada secret |
| Tests must pass | Jangan approve jika test gagal |
| PR description | Pastikan PR memiliki deskripsi |
| Not default branch | Pastikan bukan branch utama |

### Review Checklist
- [ ] Kode sudah dipanggil oleh linter/formatter
- [ ] Semua test ada (jika ada test framework)
- [ ] Test sudah passing
- [ ] Tidak ada secret atau credential
- [ ] Commit message ikut conventional commits
- [ ] Branch bukan default branch
- [ ] Perubahan sesuai requirement
- [ ] Tidak ada perubahan tidak relevan

### Review Workflow
1. Terima hasil dari **expert-coding-implementer**
2. Review kode:
   - Baca file yang diubah
   - Cek git diff
3. Jalankan validasi:
   - `npm run lint` (JS/TS)
   - `uv run pytest` (Python)
   - `make test` (Makefile)
4. Berikan feedback:
   - **Approve**: Semua check lolos
   - **Request Changes**: Ada masalah yang harus diperbaiki
5. Setelah approved, buat PR:
   ```bash
   gh pr create --title "..." --body "..."
   ```

### Example Review Comment
```
✅ Review approved

Checks passed:
- Lint: OK
- Tests: OK (5/5 passing)
- Security: OK (no secrets)
- Convention: OK (commit message follows spec)

Ready for PR creation.
```

---

## Swarm Workflow: End-to-End

### Step 1: Task Assignment
```
User: "Create Hermes setup documentation"
```

### Step 2: Branch Creation (Orchestrator)
```bash
./scripts/agent_branch.sh "create-hermes-docs"
# Creates: agent/create-hermes-docs-20240101120000
```

### Step 3: Implementation (expert-coding-implementer)
```bash
# Edit/create files
./scripts/agent_commit_push.sh "feat: add hermes setup docs" "agent/create-hermes-docs-20240101120000"
```

### Step 4: Review (expert-coding-reviewer)
```bash
# Review completed code
./scripts/agent_validate.sh
# Approve if all checks pass
```

### Step 5: PR Creation
```bash
./scripts/agent_create_pr.sh "agent/create-hermes-docs-20240101120000" \
    "feat: add hermes setup documentation" \
    "# Summary..."
```

### Step 6: Manual Merge
```
User reviews PR → User merges manually
```

## Communication Protocol

### Implementer → Reviewer
- Channel: `/opt/samdev-wiki/.agent-status/agent-implementer.completed`
- Content: Branch name, files changed, validation status

### Reviewer → Implementer (if changes needed)
- Channel: PR comments
- Format:
  ```
  🔄 Request changes:
  
  1. Issue: "..."
     Fix: "..."
  
  2. Issue: "..."
     Fix: "..."
  
  After fixing, create PR or push to existing PR.
  ```

### Reviewer → User (approval)
- Channel: PR approval
- Content: "✅ Approved for merge. All checks passed."