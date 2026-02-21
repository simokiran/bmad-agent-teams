# /bmad-sprint — Execute Sprint with Agent Team + Git Tracking

Spawns 3 parallel developer agents as a Claude Code Agent Team. Includes git branch setup, per-task commits with SHA tracking in story files, and auto-push on story completion.

## Pre-flight Checks

1. `docs/sprint-plan.md` exists
2. `docs/stories/` contains story files (created by Phase 4b parallel writers)
3. `docs/architecture.md` exists
4. Stories have "Git Task Tracking" sections
5. Git repo is initialized and clean
6. User has approved proceeding

## Step 0: Git Sprint Branch Setup

```bash
# Initialize git if needed
git init 2>/dev/null || true

# Create sprint branch
./scripts/bmad-git.sh sprint-start 1

# Commit all planning docs to the sprint branch
git add docs/ .claude/ CLAUDE.md
git commit -m "[SPRINT-1] init: Planning documents and agent definitions"
git push -u origin sprint/sprint-1
```

## Step 1: Create the Agent Team

```
TeamCreate({
  team_name: "sprint-1",
  description: "Sprint 1 — Parallel implementation with git task tracking"
})
```

## Step 2: Create Tasks from Stories (Epic-Aware)

Read each story file and create tasks. Group by epic for visibility:

```
// EPIC-001 Stories
TaskCreate({
  subject: "STORY-001: User DB Schema",
  description: "Epic: EPIC-001. Track: Database. Points: 5. Deps: None. 4 tasks."
})
TaskCreate({
  subject: "STORY-002: Auth API Endpoints",
  description: "Epic: EPIC-001. Track: Backend. Points: 5. Deps: STORY-001. 5 tasks."
})
TaskCreate({
  subject: "STORY-003: Login UI",
  description: "Epic: EPIC-001. Track: Frontend. Points: 3. Deps: STORY-002. 4 tasks."
})

// EPIC-002 Stories
TaskCreate({
  subject: "STORY-100: Dashboard DB Queries",
  description: "Epic: EPIC-002. Track: Database. Points: 3. Deps: STORY-001. 3 tasks."
})
// ... etc

// Set up dependency chains
TaskUpdate({ taskId: "2", addBlockedBy: ["1"] })  // STORY-002 needs STORY-001
TaskUpdate({ taskId: "3", addBlockedBy: ["2"] })  // STORY-003 needs STORY-002
```

## Step 3: Spawn Developer Agents

### Frontend Developer
```
Task({
  team_name: "sprint-1",
  name: "frontend-dev",
  subagent_type: "Frontend Developer",
  prompt: `You are working on Sprint 1 as part of an Agent Team.

COORDINATION:
- Use SendMessage to communicate with backend-dev and db-engineer teammates
- Check shared task list for story dependencies
- Notify team when stories complete: SendMessage to lead

STORIES:
- Claim Frontend-track stories from docs/stories/
- Work in dependency order (check blockedBy)
- Follow all git workflow from your agent file (.claude/agents/frontend-developer.md)

GIT HELPERS:
- ./scripts/bmad-git.sh task-commit STORY-NNN "description" N
- ./scripts/bmad-git.sh story-push STORY-NNN "Story Title"

Your agent file contains full instructions for implementation, git workflow, and naming conventions.`,
  run_in_background: true
})
```

### Backend Developer
```
Task({
  team_name: "sprint-1",
  name: "backend-dev",
  subagent_type: "Backend Developer",
  prompt: `You are working on Sprint 1 as part of an Agent Team.

COORDINATION:
- Use SendMessage to communicate with frontend-dev and db-engineer teammates
- Wait for db-engineer to complete schema stories before starting API stories
- Check shared task list for dependencies
- Notify team when stories complete: SendMessage to lead

STORIES:
- Claim Backend-track stories from docs/stories/
- Work in dependency order (most Backend stories depend on Database stories)
- Follow all git workflow from your agent file (.claude/agents/backend-developer.md)

GIT HELPERS:
- ./scripts/bmad-git.sh task-commit STORY-NNN "description" N
- ./scripts/bmad-git.sh story-push STORY-NNN "Story Title"

Your agent file contains full instructions for implementation, git workflow, and naming conventions.`,
  run_in_background: true
})
```

### Database Engineer
```
Task({
  team_name: "sprint-1",
  name: "db-engineer",
  subagent_type: "Database Engineer",
  prompt: `You are working on Sprint 1 as part of an Agent Team.

PRIORITY: You are the foundation! Backend and Frontend depend on your schema.

COORDINATION:
- After EACH schema story completes, SendMessage to backend-dev: "STORY-NNN complete, schema ready"
- Update naming-registry.md with new table/column names (commit with story)
- Use SendMessage to communicate with backend-dev and frontend-dev teammates
- Notify team lead when stories complete

STORIES:
- Claim Database-track stories from docs/stories/
- Complete schema stories FIRST before moving to queries/migrations
- Follow all git workflow from your agent file (.claude/agents/database-engineer.md)

GIT HELPERS:
- ./scripts/bmad-git.sh task-commit STORY-NNN "description" N
- ./scripts/bmad-git.sh story-push STORY-NNN "Story Title"

Your agent file contains full instructions for implementation, git workflow, and naming conventions.`,
  run_in_background: true
})
```

## Step 4: Monitor Progress

The Orchestrator monitors via:

1. **Git log**: `git log --oneline | head -20` shows recent commits by story
2. **Story files**: Check Git Task Tracking tables for ✅ vs ⬜
3. **SendMessage**: Developers notify on story completion
4. **Project Tracker**: Run `/bmad-track` to update the dashboard

### Progress Display
```
Sprint 1 Progress (Branch: sprint/sprint-1)
═══════════════════════════════════════════

EPIC-001: User Authentication
  STORY-001 (DB Schema)     ✅ Done    [4 commits, pushed]
  STORY-002 (Auth API)      🔄 Active  [3/5 tasks, 3 commits]
  STORY-003 (Login UI)      ⬜ Blocked  [waiting on STORY-002]

EPIC-002: Dashboard
  STORY-100 (DB Queries)    ✅ Done    [3 commits, pushed]
  STORY-101 (Dashboard API) 🔄 Active  [2/4 tasks, 2 commits]
  STORY-102 (Dashboard UI)  ⬜ Pending  [no deps remaining]

Tracks: DB 3/4 ✅ | Backend 2/5 🔄 | Frontend 1/6 ⬜
Git: 15 commits | 3 pushed stories | Branch: sprint/sprint-1
```

## Step 5: Completion

When all developers report done:

```bash
# 1. Verify all story files are "Done"
# 2. Verify all stories have "Pushed: ✅ Yes"
# 3. Run tests: npm test
# 4. Run linting: npx tsc --noEmit && npx eslint src/
# 5. Update project tracker: /bmad-track
# 6. Report to user: "Sprint 1 complete. N stories, M commits, all pushed."
# 7. Suggest Phase 6 (QA)
```

## Step 6: Sprint Merge (after QA passes)

```bash
./scripts/bmad-git.sh sprint-merge 1
# Merges sprint/sprint-1 → develop with tag sprint-1-complete
```

## Error Recovery

**Git conflict between developers:**
```
SendMessage({
  to: "backend-dev",
  message: "CONFLICT: You and frontend-dev both modified src/types/index.ts.
            Pull latest: git pull origin sprint/sprint-1
            Resolve the conflict, then continue."
})
```

**Push fails (remote has new commits):**
```bash
git pull --rebase origin sprint/sprint-1
# Resolve any conflicts
git push origin sprint/sprint-1
```

**Developer commits without [STORY-NNN] prefix:**
```bash
# Amend the last commit message:
git commit --amend -m "[STORY-NNN] task: <correct description>"
```
