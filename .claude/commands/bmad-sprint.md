# /bmad-sprint — Execute Sprint with Agent Team + Git Tracking

**CRITICAL**: This command triggers YOU (the main chat orchestrator) to execute Phase 5 implementation by creating an Agent Team and spawning parallel developer agents.

## What This Command Does

1. **YOU (main chat) assume the implementation coordinator role**
2. **YOU create** an Agent Team for coordinated parallel development
3. **YOU spawn** 3 developer agents as teammates (Database, Backend, Frontend)
4. **YOU monitor** progress via git commits and SendMessage updates
5. **YOU coordinate** dependencies (DB → Backend → Frontend)
6. **YOU update** project tracker and report completion

## Architecture

```
User: /bmad-sprint
   ↓
Main Chat (Orchestrator): Execute Phase 5 Implementation
   ↓
Step 1: Pre-flight checks (stories exist, git ready, user approved)
   ↓
Step 2: Create git sprint branch
   ↓
Step 3: Create Agent Team "sprint-1"
   ↓
Step 4: Spawn 3 developers as teammates (DB, Backend, Frontend)
   ↓
Step 5: Monitor progress (git log, SendMessage, task updates)
   ↓
Step 6: Update project tracker periodically
   ↓
Step 7: Report completion when all stories done
```

---

## Execution Instructions

**YOU ARE THE ORCHESTRATOR COORDINATING SPRINT IMPLEMENTATION. DO NOT SPAWN YOURSELF AS A SUBAGENT.**

Instead, follow this pattern:

### Step 0: Pre-flight Checks

```typescript
// 1. Verify required files exist
const checks = {
  sprintPlan: await Bash({ command: "test -f docs/sprint-plan.md && echo 'exists' || echo 'missing'" }),
  stories: await Bash({ command: "test -d docs/stories && ls docs/stories/STORY-*.md 2>/dev/null | wc -l" }),
  architecture: await Bash({ command: "test -f docs/architecture.md && echo 'exists' || echo 'missing'" }),
  gitRepo: await Bash({ command: "git rev-parse --git-dir 2>/dev/null && echo 'exists' || echo 'missing'" })
};

// 2. Verify all checks pass
if (checks.sprintPlan === 'missing' || checks.architecture === 'missing' || checks.gitRepo === 'missing') {
  throw new Error("❌ Pre-flight check failed. Ensure docs/sprint-plan.md, docs/architecture.md exist and git is initialized.");
}

if (parseInt(checks.stories) === 0) {
  throw new Error("❌ No stories found in docs/stories/. Run Phase 4b (Story Creation) first.");
}

console.log(`✅ Pre-flight checks passed. ${checks.stories} stories ready for implementation.`);
```

### Step 1: Git Sprint Branch Setup

```typescript
// Create sprint branch and commit planning docs
await Bash({
  command: `
    # Initialize git if needed
    git init 2>/dev/null || true

    # Check if sprint branch already exists
    if git rev-parse --verify sprint/sprint-1 2>/dev/null; then
      echo "Branch sprint/sprint-1 already exists, checking out"
      git checkout sprint/sprint-1
    else
      # Create new sprint branch
      git checkout -b sprint/sprint-1

      # Commit all planning docs to the sprint branch
      git add docs/ .claude/
      git commit -m "[SPRINT-1] init: Planning documents and agent definitions" || echo "Nothing to commit"

      # Push to remote (if configured)
      git push -u origin sprint/sprint-1 2>/dev/null || echo "No remote configured, continuing locally"
    fi
  `,
  description: "Create sprint branch and commit planning docs"
});

console.log("✅ Sprint branch setup complete: sprint/sprint-1");
```

### Step 2: Create Agent Team

```typescript
// Create the Agent Team for coordinated development
await TeamCreate({
  team_name: "sprint-1",
  description: "Sprint 1 — Parallel implementation with git task tracking and dependency coordination"
});

console.log("✅ Agent Team 'sprint-1' created");
```

### Step 3: Create Tasks from Stories

```typescript
// Read all story files and create tasks
const storyFiles = await Bash({
  command: "ls -1 docs/stories/STORY-*.md | sort",
  description: "List all story files"
});

const stories = storyFiles.trim().split('\n');

// Create a task for each story
for (const storyFile of stories) {
  const storyContent = await Read({ file_path: storyFile });

  // Parse story metadata (title, epic, track, points, dependencies)
  // Example: STORY-001, Epic: EPIC-001, Track: Database, Points: 5, Deps: None
  const storyId = storyFile.match(/STORY-\d+/)[0];

  await TaskCreate({
    subject: `${storyId}: [Parse title from story]`,
    description: `Epic: [epic]. Track: [track]. Points: [points]. Deps: [deps]. File: ${storyFile}`,
    metadata: {
      storyId: storyId,
      storyFile: storyFile,
      track: "[parse from story]",
      epic: "[parse from story]"
    }
  });
}

// Set up dependency chains between tasks
// Parse "Depends On" from each story file and use TaskUpdate to set blockedBy
// Example: TaskUpdate({ taskId: "2", addBlockedBy: ["1"] }) if STORY-002 depends on STORY-001

console.log(`✅ Created ${stories.length} tasks from stories`);
```

### Step 4: Spawn Developer Agents as Teammates (Parallel)

**IMPORTANT**: Spawn all 3 developers in PARALLEL using Promise.all. This allows:
- ✅ True parallel execution (all 3 run simultaneously)
- ✅ Interactive permission requests (Edit, Bash, Write tools work)
- ✅ Agents coordinate via SendMessage and task dependencies

```typescript
// Spawn all 3 agents in parallel (concurrent foreground mode)
await Promise.all([
  // Database Engineer (Foundation)
  Task({
    team_name: "sprint-1",
    name: "db-engineer",
    subagent_type: "Database Engineer",
    description: "Implement Database stories",
    prompt: `You are working on Sprint 1 as part of an Agent Team.

**ROLE**: Database Engineer

**PRIORITY**: You are the FOUNDATION! Backend and Frontend depend on your schema.

**COORDINATION**:
- After EACH schema story completes, use SendMessage to backend-dev: "STORY-NNN complete, schema ready"
- Update docs/naming-registry.md with new table/column names (commit with story)
- Check shared task list for your Database-track stories
- Notify team lead when all your stories complete

**STORIES TO IMPLEMENT**:
- Claim all Database-track stories from docs/stories/
- Read each story file for requirements and acceptance criteria
- Complete schema stories FIRST before moving to queries/migrations
- Follow dependency order (check "Depends On" in story files)

**GIT WORKFLOW** (from your agent file):
- Every task complete → git commit with [STORY-NNN] prefix
- Record commit SHA in story file's Git Task Tracking table
- All story tasks complete → git push

**CONTEXT DOCUMENTS**:
- docs/PROJECT-SUMMARY.md (tech stack, naming conventions)
- docs/naming-registry.md (database naming section)
- docs/architecture.md (database design section)

**OUTPUT PROTOCOL**:
After completing all your stories, return ONLY:
"✅ Database stories complete. Stories: [list]. Commits: [N]. All pushed: Yes/No."

DO NOT return full code in your response. Files are the deliverable.`
  }),

  // Backend Developer (Coordinates with Database)
  Task({
    team_name: "sprint-1",
    name: "backend-dev",
    subagent_type: "Backend Developer",
    description: "Implement Backend stories",
    prompt: `You are working on Sprint 1 as part of an Agent Team.

**ROLE**: Backend Developer

**COORDINATION**:
- Use SendMessage to communicate with db-engineer and frontend-dev teammates
- Wait for db-engineer SendMessage confirmations before starting stories that depend on schema
- Check shared task list for dependencies (blockedBy)
- Notify team when stories complete: SendMessage to lead

**STORIES TO IMPLEMENT**:
- Claim all Backend-track stories from docs/stories/
- Read each story file for requirements and acceptance criteria
- Work in dependency order (most Backend stories depend on Database stories)
- Follow dependency chains in "Depends On" sections

**GIT WORKFLOW** (from your agent file):
- Every task complete → git commit with [STORY-NNN] prefix
- Record commit SHA in story file's Git Task Tracking table
- All story tasks complete → git push

**CONTEXT DOCUMENTS**:
- docs/PROJECT-SUMMARY.md (tech stack, API patterns)
- docs/naming-registry.md (API naming section)
- docs/architecture.md (API design section)

**OUTPUT PROTOCOL**:
After completing all your stories, return ONLY:
"✅ Backend stories complete. Stories: [list]. Endpoints: [N]. Tests: [M]. All pushed: Yes/No."

DO NOT return full code in your response. Files are the deliverable.`
  }),

  // Frontend Developer (Coordinates with Backend)
  Task({
    team_name: "sprint-1",
    name: "frontend-dev",
    subagent_type: "Frontend Developer",
    description: "Implement Frontend stories",
    prompt: `You are working on Sprint 1 as part of an Agent Team.

**ROLE**: Frontend Developer

**COORDINATION**:
- Use SendMessage to communicate with backend-dev and db-engineer teammates
- Wait for backend-dev SendMessage confirmations when API endpoints are needed
- Check shared task list for dependencies (blockedBy)
- Notify team when stories complete: SendMessage to lead

**STORIES TO IMPLEMENT**:
- Claim all Frontend-track stories from docs/stories/
- Read each story file for requirements and acceptance criteria
- Work in dependency order (Frontend stories often depend on Backend API stories)
- Follow dependency chains in "Depends On" sections

**GIT WORKFLOW** (from your agent file):
- Every task complete → git commit with [STORY-NNN] prefix
- Record commit SHA in story file's Git Task Tracking table
- All story tasks complete → git push

**CONTEXT DOCUMENTS**:
- docs/PROJECT-SUMMARY.md (tech stack, component patterns)
- docs/naming-registry.md (component naming section)
- docs/ux-wireframes.md (screen specifications)
- docs/architecture.md (frontend architecture section)

**OUTPUT PROTOCOL**:
After completing all your stories, return ONLY:
"✅ Frontend stories complete. Stories: [list]. Components: [N]. Tests: [M]. All pushed: Yes/No."

DO NOT return full code in your response. Files are the deliverable.`
  })
]);

console.log("✅ Spawned 3 developer agents in PARALLEL as teammates");
console.log("   - All agents running concurrently (not background)");
console.log("   - Agents can request Edit/Bash/Write permissions interactively");
console.log("   - Coordination via SendMessage and task dependencies");
```

### Step 5: Monitor Progress

**YOU monitor the team's progress** while developers work:

```typescript
// Periodic monitoring loop (check every 5 minutes)
const monitorProgress = async () => {
  // 1. Check git log for recent commits
  const recentCommits = await Bash({
    command: "git log --oneline -20 | grep '\\[STORY-'",
    description: "Check recent story commits"
  });

  // 2. Check SendMessage updates from developers
  // (Developers send messages like "STORY-001 complete, schema ready")

  // 3. Check story files for completion status
  const storyStatuses = await Bash({
    command: `
      for story in docs/stories/STORY-*.md; do
        if grep -q "Status: Done" "$story"; then
          echo "$(basename $story): ✅ Done"
        elif grep -q "Status: In Progress" "$story"; then
          echo "$(basename $story): 🔄 Active"
        else
          echo "$(basename $story): ⬜ Pending"
        fi
      done
    `,
    description: "Check story completion statuses"
  });

  // 4. Display progress summary
  console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 SPRINT 1 PROGRESS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Recent Commits:
${recentCommits}

Story Status:
${storyStatuses}

Branch: sprint/sprint-1
  `);
};

// Run initial progress check
await monitorProgress();

// Continue monitoring until all developers complete
// (You'll be notified when background tasks finish)
```

### Step 6: Update Project Tracker

```typescript
// Periodically update the project tracker dashboard
await Bash({
  command: "claude /bmad-track",
  description: "Update project tracker dashboard"
});
```

### Step 7: Completion Check

**When all developer agents complete**, verify and report:

```typescript
// 1. Verify all story files are "Done"
const incompletestories = await Bash({
  command: `grep -L "Status: Done" docs/stories/STORY-*.md || echo "All complete"`,
  description: "Check for incomplete stories"
});

if (incompletestories !== "All complete") {
  console.log(`⚠️  Some stories incomplete: ${incompletestories}`);
  console.log("Review and complete remaining stories before proceeding.");
} else {
  // 2. Verify all stories have been pushed
  const unpushedStories = await Bash({
    command: `grep "Pushed: ❌ No" docs/stories/STORY-*.md || echo "All pushed"`,
    description: "Check for unpushed stories"
  });

  if (unpushedStories !== "All pushed") {
    console.log(`⚠️  Some stories not pushed: ${unpushedStories}`);
    console.log("Push remaining stories before proceeding.");
  } else {
    // 3. Run tests
    const testResults = await Bash({
      command: "npm test 2>&1",
      description: "Run test suite",
      timeout: 300000 // 5 minutes
    });

    // 4. Update final project tracker
    await Bash({
      command: "claude /bmad-track",
      description: "Update project tracker dashboard"
    });

    // 5. Report completion to user
    const storyCount = await Bash({
      command: "ls -1 docs/stories/STORY-*.md | wc -l",
      description: "Count total stories"
    });

    const commitCount = await Bash({
      command: "git log --oneline | grep '\\[STORY-' | wc -l",
      description: "Count story commits"
    });

    console.log(`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SPRINT 1 COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Stories Implemented: ${storyCount.trim()}
Commits Made: ${commitCount.trim()}
Branch: sprint/sprint-1
All Stories Pushed: ✅ Yes

Test Results:
${testResults}

Next Steps:
- Review code in sprint/sprint-1 branch
- Run /bmad-next to proceed to Phase 6 (QA)
- QA Engineer will validate all acceptance criteria
    `);
  }
}
```

---

## Use Cases

### Fresh Sprint Start
```
User: /bmad-sprint

Main Chat (as Orchestrator):
  ✅ Pre-flight checks passed. 19 stories ready.
  ✅ Sprint branch created: sprint/sprint-1
  ✅ Agent Team 'sprint-1' created
  ✅ Created 19 tasks from stories
  ✅ Spawned 3 developer agents (DB, Backend, Frontend)

  📊 Monitoring progress...

  [5 minutes later]
  Recent commits:
  - [STORY-001] task: Create users table schema
  - [STORY-001] task: Add indexes to users table
  - [STORY-002] task: Implement register endpoint

  [30 minutes later]
  ✅ SPRINT 1 COMPLETE
  Stories: 19, Commits: 87, All pushed: Yes
```

### Resume After Interruption
```
User stopped mid-sprint, then runs: /bmad-sprint

Main Chat (as Orchestrator):
  ✅ Pre-flight checks passed
  ✅ Found existing sprint/sprint-1 branch, checking out
  ✅ Agent Team 'sprint-1' created
  ✅ Detected 7/19 stories complete
  ✅ Spawned developers to continue from STORY-008

  📊 Resuming progress monitoring...
```

---

## Benefits

✅ **Fully Automated** - Spawn agents, they work in parallel, auto-coordinate via SendMessage
✅ **Git Tracked** - Every task committed with SHA, every story pushed
✅ **Dependency Aware** - DB completes before Backend, Backend before Frontend
✅ **Resumable** - Can stop/resume mid-sprint
✅ **Monitored** - Orchestrator tracks progress via git log and story files
✅ **Agent Team** - True parallel coordination via Claude Code Agent Teams

---

## Error Recovery

**Git conflict between developers:**
```typescript
// Developers will receive git conflict errors
// They should pull, resolve, and continue
// Orchestrator monitors for SendMessage alerts about conflicts
```

**Push fails (remote has new commits):**
```typescript
// Developers auto-retry with: git pull --rebase && git push
```

**Developer stuck on story:**
```typescript
// Orchestrator detects no progress after 15 minutes
// SendMessage to developer: "Status check: STORY-NNN progress?"
// If no response, spawn replacement developer agent
```

---

## Monitoring Commands

While sprint runs, you can:
- `/bmad-status` - Show current phase and sprint progress
- `/bmad-track` - Show epic/story progress dashboard
- `git log --oneline -20` - See recent commits
- `ls -lh docs/stories/` - Check story file timestamps

---

**Status**: Phase 5 execution command - spawns Agent Team with 3 coordinated developers
