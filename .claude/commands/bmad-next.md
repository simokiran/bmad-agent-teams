# /bmad-next — Resume or Advance Workflow

Spawns the BMad Orchestrator to resume the workflow from where it left off or advance to the next phase.

## What This Command Does

1. **Spawns BMad Orchestrator** in resume mode
2. **Orchestrator reads** `docs/session-tracker.md`
3. **Orchestrator determines** current phase and status
4. **Orchestrator decides** next action:
   - Resume incomplete phase
   - Advance to next phase
   - Complete the project

## Architecture

```
User: /bmad-next
   ↓
Spawn: BMad Orchestrator (resume mode)
   ↓
Orchestrator reads: docs/session-tracker.md
   ↓
Orchestrator detects:
   - Current phase
   - What's complete
   - What's next
   - Any blockers
   ↓
Orchestrator executes:
   - Resume Phase N (if incomplete)
   - OR Advance to Phase N+1 (if complete)
```

## Execution

```typescript
Task({
  subagent_type: "BMad Orchestrator",
  description: "Resume or advance BMad workflow",
  model: "opus",
  prompt: `Resume the BMad workflow.

RECOVERY PROTOCOL:
1. Read docs/session-tracker.md to determine:
   - Current phase
   - What artifacts exist
   - What's incomplete
   - Next action
   - Any blockers

2. Check for context compaction:
   - If "Context Compaction Events" > 0, use Post-Compaction Recovery
   - Read your agent file for full recovery protocol

3. Determine next action:
   - If current phase incomplete → Resume current phase
   - If current phase complete → Advance to next phase
   - If all phases complete → Show final verdict

4. Execute using spawn patterns from your agent file

5. Update session-tracker.md with progress

CONTEXT:
- You are the BMad Orchestrator
- Your complete role is in .claude/agents/orchestrator.md
- All spawn patterns are in your agent file
- Use token optimization strategies
- Update session tracker after each phase

Begin by reading session-tracker.md and determining next action.`
});
```

## What Orchestrator Does

The orchestrator will:

1. **Read session-tracker.md** to see current state
2. **Determine phase** based on artifacts:
   - No product-brief.md? → Phase 1
   - No prd.md or ux-wireframes.md? → Phase 2
   - No architecture.md? → Phase 3
   - No epics? → Phase 4
   - No stories? → Phase 4b
   - Stories not done? → Phase 5
   - No test-plan.md? → Phase 6
   - No deploy-config.md? → Phase 7
   - No review-checklist.md? → Phase 8
   - All complete? → Show final verdict

3. **Execute appropriate spawn pattern:**
   - Phase 1: Spawn Business Analyst
   - Phase 2: Spawn PM + UX (parallel)
   - Phase 3: Spawn Architect
   - Phase 4: Spawn Scrum Master
   - Phase 4b: Spawn Story Writers (parallel, 1 per epic)
   - Phase 5: Create Agent Team (DB + Backend + Frontend)
   - Phase 6: Spawn QA Engineer
   - Phase 7: Spawn DevOps Engineer
   - Phase 8: Spawn Tech Lead

4. **Update session-tracker.md** after phase completes

5. **Continue automatically** to next phase OR wait for user

## Use Cases

### Resume After Stop
```
User stopped during Phase 3
User: /bmad-next

Orchestrator: Reading session-tracker.md...
              Phase 3 (Architecture) was in progress.
              Resuming Phase 3...
              [Spawns Architect to complete architecture.md]
```

### Advance to Next Phase
```
User manually ran Phase 1, now wants Phase 2
User: /bmad-next

Orchestrator: Reading session-tracker.md...
              Phase 1 complete (product-brief.md exists)
              Advancing to Phase 2...
              [Spawns PM + UX in parallel]
```

### Resume After Context Compaction
```
Session was compacted during Phase 5
User: /bmad-next

Orchestrator: Reading session-tracker.md...
              Context compaction detected (2 events)
              Using Post-Compaction Recovery Protocol...
              Phase 5 in progress (Agent Team running)
              Checking active tasks: db-engineer, backend-dev, frontend-dev
              [Checks task outputs and resumes coordination]
```

## Benefits

✅ **Single command** - User doesn't need to know which phase they're on
✅ **Orchestrator decides** - All intelligence in orchestrator, not command
✅ **Resumable** - Can stop/start for big projects
✅ **Recoverable** - Handles context compaction automatically
✅ **No duplication** - Command delegates to orchestrator

## Monitoring

While orchestrator runs:
- `/bmad-status` - Show current phase
- `/bmad-track` - Show epic/story progress
- `docs/session-tracker.md` - Live tracker
