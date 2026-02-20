---
name: bmad-init-session-tracker
description: Initialize session tracker for BMad orchestration with post-compaction recovery support
run: auto
---

# Initialize BMad Session Tracker

**Purpose**: Set up persistent session state tracking for orchestrator recovery after context compaction

**When to run**: Automatically during project initialization (Phase 1 start)

---

## What This Skill Does

1. Copies SESSION-TRACKER.md template to `docs/session-tracker.md`
2. Initializes with project metadata
3. Sets up phase tracking structure
4. Prepares for background task monitoring

---

## Implementation

```typescript
// 1. Check if session tracker already exists
const exists = await Bash({
  command: 'test -f docs/session-tracker.md && echo "exists" || echo "missing"',
  description: "Check if session tracker exists"
});

if (exists.trim() === "exists") {
  // Already initialized, just read and continue
  const tracker = await Read({ file_path: "docs/session-tracker.md" });

  return `✅ Session tracker already initialized.

Current State:
${extractCurrentState(tracker)}

Use this tracker to resume if session is compacted.`;
}

// 2. Read the template from BMad internal templates
const template = await Read({
  file_path: ".claude/templates/SESSION-TRACKER.md"
});

// 3. Initialize with project metadata
const projectName = await AskUserQuestion({
  questions: [{
    question: "What is the project name?",
    header: "Project Name",
    multiSelect: false,
    options: [
      {
        label: "Use current directory name",
        description: "Auto-detect from current working directory"
      },
      {
        label: "Custom name",
        description: "I'll type a custom project name"
      }
    ]
  }]
});

let name = projectName;
if (projectName === "Use current directory name") {
  const dirName = await Bash({
    command: "basename $(pwd)",
    description: "Get current directory name"
  });
  name = dirName.trim();
}

// 4. Create session tracker with metadata
const now = new Date().toISOString();
const initialized = template
  .replace("[Project Name]", name)
  .replace("[YYYY-MM-DD HH:MM]", now)
  .replace("**Last Updated**: [YYYY-MM-DD HH:MM]", `**Last Updated**: ${now}`)
  .replace("**Phase**: [Phase N: Name]", "**Phase**: Phase 1: Discovery")
  .replace("**Status**: [In Progress | Blocked | Complete]", "**Status**: Not Started")
  .replace("**Next Action**: [What needs to happen next]", "**Next Action**: Spawn Business Analyst to create Product Brief")
  .replace("**Context Compaction Events**: [N times compacted]", "**Context Compaction Events**: 0 times compacted")
  .replace("**Last Compaction**: [YYYY-MM-DD HH:MM]", "**Last Compaction**: Never");

// 5. Write initialized tracker
await Write({
  file_path: "docs/session-tracker.md",
  content: initialized
});

// 6. Confirm initialization
return `✅ Session tracker initialized.

File: docs/session-tracker.md
Project: ${name}
Started: ${now}
Current Phase: Phase 1: Discovery

The orchestrator will update this tracker after every:
- Phase transition
- Agent spawn (especially background tasks)
- Agent completion
- File creation
- Git commit

If session is compacted, orchestrator will:
1. Read docs/session-tracker.md
2. Check active background tasks
3. Verify phase outputs
4. Resume from "Next Action"

Session tracking ensures seamless recovery! 🔄`;
```

---

## Usage

**Automatic** (during bmad-init):
```bash
# Session tracker is initialized automatically when project starts
Skill("bmad-init")
# → Creates docs/session-tracker.md
```

**Manual** (if needed):
```bash
# Initialize session tracker separately
Skill("bmad-init-session-tracker")
```

---

## What Gets Created

**File**: `docs/session-tracker.md`

**Contents**:
- Project metadata (name, start time, session ID)
- Current state (phase, status, next action)
- Phase progress checklist (all 8 phases)
- Active background tasks table (Task IDs, agents, status)
- Token optimization tracking
- Git tracking (branch, commits)
- Blockers and issues
- Post-compaction recovery protocol

---

## Orchestrator Instructions

**After initialization, the orchestrator MUST:**

1. **Update tracker after every agent spawn**:
   ```typescript
   const task = await Task({ ..., run_in_background: true });

   // Record Task ID immediately
   await Edit({
     file_path: "docs/session-tracker.md",
     old_string: "Backend Developer: [🔴 Background Task ID: task_xxx]",
     new_string: `Backend Developer: [🔴 Background Task ID: ${task.task_id}]`
   });
   ```

2. **Update tracker when agent completes**:
   ```typescript
   await Edit({
     file_path: "docs/session-tracker.md",
     old_string: `Backend Developer: [🔴 Background Task ID: ${task_id}]`,
     new_string: "Backend Developer: [✅ Complete]"
   });
   ```

3. **Update "Next Action" before each step**:
   ```typescript
   await Edit({
     file_path: "docs/session-tracker.md",
     old_string: "**Next Action**: [What needs to happen next]",
     new_string: "**Next Action**: Spawn Frontend + Mobile in parallel"
   });
   ```

4. **After compaction, read tracker first**:
   ```typescript
   const tracker = await Read({ file_path: "docs/session-tracker.md" });
   // Parse current state, check active tasks, resume
   ```

---

## Benefits

✅ **Seamless Recovery** — Resume exactly where you left off after compaction
✅ **Background Task Tracking** — Never lose track of running agents
✅ **Clear Next Steps** — Always know what to do next
✅ **Audit Trail** — Full history of phases, agents, and outputs
✅ **Error Recovery** — Document blockers and resolutions

---

## Example Session Tracker Entry

```markdown
## Current State

**Phase**: Phase 5: Implementation
**Status**: In Progress
**Next Action**: Check Frontend + Mobile developers, then proceed to QA

**Context Compaction Events**: 2 times compacted
**Last Compaction**: 2026-02-20 14:30:00

---

## Active Background Tasks

| Task ID | Agent Type | Epic/Phase | Started | Status | Output File |
|---------|------------|------------|---------|--------|-------------|
| task_abc123 | Frontend Developer | Phase 5 | 2026-02-20 13:00 | Running ⏳ | /tmp/frontend-output.txt |
| task_def456 | Mobile Developer | Phase 5 | 2026-02-20 13:00 | Running ⏳ | /tmp/mobile-output.txt |

**Recovery Command**:
```bash
TaskOutput(task_id="task_abc123", block=false)
TaskOutput(task_id="task_def456", block=false)
```
```

---

**Status**: Ready for use
**Usage**: Auto-invoked during bmad-init, or run manually if needed
