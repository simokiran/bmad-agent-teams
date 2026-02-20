# Git Workflow Template (Shared)

**Purpose**: Standard git workflow for all developer agents (reduce repetition)

---

## Git Discipline (All Developers)

### Per Task (1 Task = 1 Commit)

```bash
# After completing a task:
git add -A
git commit -m "[STORY-NNN] task: <task description>"

# Capture SHA:
COMMIT_SHA=$(git rev-parse --short HEAD)
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")

# Update story file's Git Task Tracking table:
# Change: | 1 | Task description | ⬜ | — | — |
# To:     | 1 | Task description | ✅ | `abc123d` | 2025-02-19 14:30 UTC |

# Update Commit Log section in story file
```

### After All Tasks Complete

```bash
# Update story status, Git Summary
git add docs/stories/STORY-NNN.md
git commit -m "[STORY-NNN] complete: <story title>"

# PUSH to remote:
git push origin sprint/sprint-1
```

### Commit Message Format

```bash
# Good commit messages:
[STORY-005] task: Create LoginForm component
[STORY-005] task: Add email validation with Zod
[STORY-005] task: Integrate /api/auth/login endpoint
[STORY-005] update: naming registry with LoginForm component
[STORY-005] complete: User login frontend implementation

# Bad commit messages:
[STORY-005] task: stuff
[STORY-005] task: updates
[STORY-005] task: fixed bug
```

### Git Safety Protocol

- ❌ NEVER run destructive commands without user request (--force, reset --hard, clean -f)
- ❌ NEVER skip hooks (--no-verify)
- ❌ NEVER amend previous commits (always create NEW commits)
- ❌ NEVER use `git add .` or `git add -A` for sensitive files (prefer specific files)
- ✅ ALWAYS create NEW commits (even after pre-commit hook failures)
- ✅ ALWAYS record SHA in story file after each task
- ✅ ALWAYS push on story completion

---

## Story Completion Checklist (All Developers)

- [ ] All tasks committed with SHAs recorded in story file
- [ ] All acceptance criteria from story met
- [ ] Naming registry updated with new entities
- [ ] Tests written and passing
- [ ] No TypeScript/linting errors
- [ ] Story file updated to "Done" status
- [ ] **All commits pushed to sprint branch**
- [ ] Team lead/orchestrator notified

---

**Token Savings**: This template saves ~30 lines per agent × 4 agents = 120 lines (~3k tokens)
