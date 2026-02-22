# /bmad-next — Resume or Advance Workflow

**CRITICAL**: This command triggers the MAIN CHAT to assume the BMad Orchestrator role directly. The orchestrator is the team lead and operates in the main session, NOT as a subagent.

## What This Command Does

1. **You (main chat) assume the BMad Orchestrator role**
2. **You read** `.claude/agents/orchestrator.md` to load your role
3. **You read** `docs/session-tracker.md` to understand current state
4. **You determine** next action based on session tracker
5. **You execute** appropriate agent spawns or continue the workflow

## Architecture

```
User: /bmad-next
   ↓
Main Chat: Read .claude/agents/orchestrator.md (assume role)
   ↓
Main Chat: Read docs/session-tracker.md (load state)
   ↓
Main Chat as Orchestrator:
   - Determine current phase
   - Check what's complete
   - Identify what's next
   - Detect any blockers
   ↓
Main Chat as Orchestrator executes:
   - Resume Phase N (if incomplete)
   - OR Advance to Phase N+1 (if complete)
   - Spawn appropriate agents as subprocesses
```

## Role Assumption Protocol

When this command is invoked, YOU (the main chat Claude instance) must:

1. **Read your orchestrator role definition:**
   - File: `.claude/agents/orchestrator.md`
   - This defines your responsibilities, spawn patterns, and protocols

2. **Read the session tracker:**
   - File: `docs/session-tracker.md`
   - This shows current state: phase, status, next action, active tasks

3. **Execute recovery protocol:**
   - If context was compacted: check active background tasks
   - If phase incomplete: resume current phase
   - If phase complete: advance to next phase
   - If all complete: show final verdict

4. **Use spawn patterns from your role:**
   - Phase 1: Spawn Business Analyst
   - Phase 2: Spawn Product Manager + UX Designer (parallel)
   - Phase 3: Spawn System Architect
   - Phase 4: Spawn Scrum Master
   - Phase 4b: Spawn Story Writers (parallel, 1 per epic)
   - Phase 5: Create Agent Team (DB + Backend + Frontend + Mobile)
   - Phase 6: Spawn QA Engineer
   - Phase 7: Spawn DevOps Engineer
   - Phase 8: Spawn Tech Lead

5. **Update session tracker:**
   - Mark phase status changes
   - Record agent spawns (especially background tasks)
   - Update "Next Action" field
   - Track compaction events

## Execution Instructions

**YOU ARE THE ORCHESTRATOR. DO NOT SPAWN YOURSELF AS A SUBAGENT.**

Instead, follow this pattern:

```typescript
// 0. VALIDATION: Ensure project is initialized
const docsExists = await Bash({
  command: "test -d docs && echo 'exists' || echo 'missing'",
  description: "Check if docs/ folder exists"
});

if (docsExists === "missing") {
  throw new Error("❌ Project not initialized. Run /bmad-init first.");
}

// 1. Load your role
const orchestratorRole = await Read({ file_path: ".claude/agents/orchestrator.md" });

// 2. Load session state
const sessionState = await Read({ file_path: "docs/session-tracker.md" });

// 3. DETECT COMPACTION: Ask user if context was compacted
// This is the most reliable way since the orchestrator can't detect it automatically

const currentCompactionCount = parseInt(sessionState.match(/Context Compaction Events\*\*: (\d+)/)?.[1] || "0");

// Check if session tracker indicates ongoing work
const hasOngoingWork = (
  sessionState.includes("⏳") || // Work in progress markers
  sessionState.includes("🔴 Background Task ID") || // Background tasks
  sessionState.includes("In Progress") // Phase status
);

// If there's ongoing work and this is a resume, ask user about compaction
if (hasOngoingWork) {
  const compactionCheck = await AskUserQuestion({
    questions: [{
      question: "Was your conversation context compacted (summarized) since the last update?",
      header: "Compaction",
      multiSelect: false,
      options: [
        { label: "No, continuing same session", description: "Context is intact, no compaction occurred" },
        { label: "Yes, context was compacted", description: "Conversation was summarized, using session tracker for recovery" }
      ]
    }]
  });

  if (compactionCheck.includes("Yes")) {
    // Increment compaction counter
    await Edit({
      file_path: "docs/session-tracker.md",
      old_string: `**Context Compaction Events**: ${currentCompactionCount} times compacted`,
      new_string: `**Context Compaction Events**: ${currentCompactionCount + 1} times compacted`
    });

    const now = new Date().toISOString();
    await Edit({
      file_path: "docs/session-tracker.md",
      old_string: "**Last Compaction**: N/A",
      new_string: `**Last Compaction**: ${now}`
    });

    console.log(`⚠️  Context compaction event #${currentCompactionCount + 1} recorded.`);
    console.log(`   Using session tracker for recovery...`);
  }
}

// 3. Analyze state
// - Parse current phase from session tracker
// - Check which artifacts exist (product-brief.md, prd.md, etc.)
// - Identify next action
// - Check for active background tasks

// 4. Execute next action based on phase
if (currentPhase === "Phase 1: Discovery") {
  await Task({
    subagent_type: "Business Analyst",
    description: "Create Product Brief",
    prompt: "..." // Use spawn pattern from orchestrator.md
  });
} else if (currentPhase === "Phase 2: Planning") {
  await Promise.all([
    Task({ subagent_type: "Product Manager", ... }),
    Task({ subagent_type: "UX Designer", ... })
  ]);
} // ... etc

// 5. Update session tracker
await Edit({ file_path: "docs/session-tracker.md", ... });
```

## What YOU Do (As Orchestrator)

As the orchestrator operating in the main chat, you will:

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
   - Phase 1: YOU spawn Business Analyst as subagent
   - Phase 2: YOU spawn PM + UX in parallel as subagents
   - Phase 3: YOU spawn Architect as subagent
   - Phase 4: YOU spawn Scrum Master as subagent
   - Phase 4b: YOU spawn Story Writers in parallel (1 per epic) as subagents
   - Phase 5: YOU create Agent Team and spawn developers as subagents
   - Phase 6: YOU spawn QA Engineer as subagent
   - Phase 7: YOU spawn DevOps Engineer as subagent
   - Phase 8: YOU spawn Tech Lead as subagent

4. **Update session-tracker.md** after each agent completes

5. **Continue automatically** to next phase OR wait for user approval

## Use Cases

### Resume After Stop
```
User stopped during Phase 3
User: /bmad-next

Main Chat (as Orchestrator):
  Reading .claude/agents/orchestrator.md... ✓
  Reading session-tracker.md... ✓
  Phase 3 (Architecture) was in progress.
  Resuming Phase 3...
  [Spawning System Architect as subagent to complete architecture.md]
```

### Advance to Next Phase
```
User manually ran Phase 1, now wants Phase 2
User: /bmad-next

Main Chat (as Orchestrator):
  Reading .claude/agents/orchestrator.md... ✓
  Reading session-tracker.md... ✓
  Phase 1 complete (product-brief.md exists)
  Advancing to Phase 2...
  [Spawning Product Manager + UX Designer in parallel as subagents]
```

### Resume After Context Compaction
```
Session was compacted during Phase 5
User: /bmad-next

Main Chat (as Orchestrator):
  Reading .claude/agents/orchestrator.md... ✓
  Reading session-tracker.md... ✓
  Context compaction detected (2 events)
  Using Post-Compaction Recovery Protocol...
  Phase 5 in progress (Agent Team detected)
  Checking active background tasks: db-engineer, backend-dev, frontend-dev
  [Checking TaskOutput for each task, resuming coordination as needed]
```

## Benefits

✅ **Single command** - User doesn't need to know which phase they're on
✅ **Main chat is orchestrator** - No subprocess overhead or communication barriers
✅ **Resumable** - Can stop/start for big projects
✅ **Recoverable** - Handles context compaction automatically via session-tracker.md
✅ **Direct control** - Main chat coordinates all subagents directly

## Why Main Chat, Not Subagent?

**CRITICAL ARCHITECTURAL DECISION:**

The orchestrator MUST operate in the main chat session because:

1. **Long-running coordination** - The orchestrator manages an entire project across 8 phases. Running as a subagent would create a nested context that's hard to manage.

2. **User interaction** - The orchestrator asks for user approval at phase gates. Main chat allows natural conversation flow.

3. **Session continuity** - The session-tracker.md persists across terminal restarts. The main chat can read it and resume, while a subagent would start fresh.

4. **Background task monitoring** - The orchestrator spawns multiple background agents (story writers, developers). Managing these from main chat is simpler than from a subagent.

5. **Token efficiency** - The main chat accumulates only confirmations from subagents (streaming outputs), not full content. A nested orchestrator would bloat context.

**CORRECT**: Main chat assumes orchestrator role → spawns specialist agents as subagents
**INCORRECT**: Main chat spawns orchestrator → orchestrator spawns specialists (nested, complex)

## Monitoring

While you (as orchestrator) coordinate the workflow:
- `/bmad-status` - Show current phase
- `/bmad-track` - Show epic/story progress
- `docs/session-tracker.md` - Your persistent state file
