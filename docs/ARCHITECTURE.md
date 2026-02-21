# BMad Architecture: Orchestrator-Driven Workflow

## Overview

BMad uses a **Hybrid Orchestrator-Driven** architecture where:
1. **Default mode**: Automated (orchestrator runs all phases)
2. **Can stop/resume**: For big projects or interruptions
3. **Orchestrator decides**: Parallel vs sequential vs Agent Teams
4. **Single source of truth**: All workflow logic in orchestrator

## Core Principles

### 1. Entry Point: /bmad-init

**User runs:** `/bmad-init`

**What happens:**
```typescript
// 1. Create project structure
mkdir -p docs/ src/ tests/ .claude/

// 2. Create session tracker
Write({ file_path: "docs/session-tracker.md", content: template });

// 3. Spawn BMad Orchestrator in Automated Mode
Task({
  subagent_type: "BMad Orchestrator",
  description: "Start BMad workflow",
  prompt: `You are the BMad Orchestrator.

  User wants to start a new project.
  Ask them to describe their project idea.
  Then begin Phase 1: Discovery (spawn Business Analyst).

  Run phases automatically. Update session-tracker.md after each phase.`
});
```

**Result:** Orchestrator running, beginning Phase 1

### 2. Automated Workflow

Orchestrator runs phases automatically:

```
Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 4b → Phase 5 → Phase 6 → Phase 7 → Phase 8
```

**Orchestrator decides spawn strategy per phase:**

| Phase | Pattern | Agents | Why |
|-------|---------|--------|-----|
| 1 | Single subagent | Business Analyst | Sequential discovery |
| 2 | Parallel subagents | PM + UX Designer | Independent, no coordination |
| 3 | Single subagent | System Architect | Needs full context |
| 4 | Single subagent | Scrum Master | Holistic epic creation |
| 4b | Parallel subagents | Story Writers (1 per epic) | Epics independent |
| 5 | **Agent Team** | DB + Backend + Frontend | **Coordination required** |
| 6 | Single subagent | QA Engineer | Validates all ACs |
| 7 | Single subagent | DevOps Engineer | Deploy config |
| 8 | Single subagent | Tech Lead | Final review |

### 3. Stop/Resume Pattern

**When orchestrator stops:**
- Context window full (needs compaction)
- User manually stops (Ctrl+C)
- Error/blocker requiring user input
- Large project (Phase 5 takes hours)
- Session expires

**User resumes with:** `/bmad-next`

**What /bmad-next does:**
```typescript
Task({
  subagent_type: "BMad Orchestrator",
  description: "Resume BMad workflow",
  prompt: `Resume the BMad workflow.

RECOVERY PROTOCOL:
1. Read docs/session-tracker.md
2. Determine current phase and status
3. Check for any blockers or incomplete work
4. Resume from where you left off

If context was compacted, use Post-Compaction Recovery Protocol
from your agent file.`
});
```

**Orchestrator recovery logic:**
1. Reads `session-tracker.md`
2. Sees: "Phase: Phase 5, Status: In Progress, Next Action: Continue Agent Team"
3. Resumes Phase 5 Agent Team or advances to Phase 6

### 4. Session Tracker Format

**docs/session-tracker.md** (created by /bmad-init):
```markdown
# BMad Session Tracker

**Project**: [Project Name]
**Started**: 2026-02-21
**Last Updated**: 2026-02-21 18:30 UTC

## Current State

**Phase**: Phase 5: Implementation
**Status**: In Progress
**Next Action**: Monitor Agent Team progress (db-engineer, backend-dev, frontend-dev)

## Phase Progress

- [x] Phase 1: Discovery (Business Analyst)
- [x] Phase 2: Planning (PM + UX parallel)
- [x] Phase 3: Architecture (System Architect)
- [x] Phase 4: Epics (Scrum Master)
- [x] Phase 4b: Stories (Story Writers parallel)
- [ ] Phase 5: Implementation (Agent Team: DB, Backend, Frontend)
- [ ] Phase 6: QA
- [ ] Phase 7: Deployment
- [ ] Phase 8: Final Review

## Artifacts Created

- `docs/product-brief.md` - [✅ Exists]
- `docs/prd.md` - [✅ Exists]
- `docs/ux-wireframes.md` - [✅ Exists]
- `docs/architecture.md` - [✅ Exists]
- `docs/epics/` - [✅ 3 epics]
- `docs/stories/` - [✅ 12 stories]
- `src/` - [🔄 In Progress]

## Active Background Tasks

| Task ID | Agent | Phase | Started | Status |
|---------|-------|-------|---------|--------|
| task_db123 | Database Engineer | Phase 5 | 18:15 UTC | Running ⏳ |
| task_be456 | Backend Developer | Phase 5 | 18:15 UTC | Running ⏳ |
| task_fe789 | Frontend Developer | Phase 5 | 18:15 UTC | Running ⏳ |

## Blockers and Issues

[None | List any blockers]

## Context Compaction Events

**Count**: 0 times compacted
**Last Compaction**: [Never | YYYY-MM-DD HH:MM]
```

### 5. Command Responsibilities

| Command | Purpose | Spawns Orchestrator? | Details |
|---------|---------|---------------------|---------|
| `/bmad-init` | Start new project | ✅ Yes (automated) | Creates structure + spawns orchestrator |
| `/bmad-next` | Resume/advance | ✅ Yes (resume) | Spawns orchestrator with recovery protocol |
| `/bmad-status` | Show progress | ❌ No | Reads session-tracker.md and displays |
| `/bmad-sprint` | Force Phase 5 | ✅ Yes (if needed) | Spawns orchestrator to run Phase 5 specifically |
| `/bmad-gate` | Quality check | ❌ No | Reads docs and validates against rubric |
| `/bmad-track` | Show dashboard | ❌ No | Reads stories/epics and displays progress |
| `/bmad-review` | Final review | ✅ Yes | Spawns orchestrator to run Phase 8 |

### 6. Why Phase 5 Uses Agent Teams

**Phase 5 is special** because developers need to:
- **Coordinate** on shared files (naming-registry.md)
- **Avoid conflicts** (multiple agents editing same types)
- **Handle dependencies** (Frontend needs Backend API)
- **Message each other** ("Schema ready for API implementation")

**Sequential spawn would be slow:**
```typescript
// ❌ Slow (60+ minutes for 12 stories)
await Database Engineer (20 min)
await Backend Developer (25 min)
await Frontend Developer (20 min)
// Total: 65 minutes
```

**Agent Team is parallel + coordinated:**
```typescript
// ✅ Fast (25 minutes for 12 stories)
TeamCreate({ team_name: "sprint-1" });
await Promise.all([
  Database Engineer (runs in background, notifies when done),
  Backend Developer (waits for DB messages, then starts),
  Frontend Developer (waits for Backend messages, then starts)
]);
// Total: ~25 minutes (overlap + coordination)
```

### 7. Benefits of This Architecture

✅ **Automatic by default** - User describes project, orchestrator does the rest
✅ **Resumable** - Can stop/start for big projects or context limits
✅ **Intelligent** - Orchestrator decides best spawn strategy per phase
✅ **Single source of truth** - All logic in orchestrator.md, commands just invoke it
✅ **Token optimized** - Orchestrator implements streaming outputs, context extraction
✅ **No duplication** - Commands don't duplicate logic, they delegate to orchestrator
✅ **Recoverable** - Session tracker enables post-compaction recovery

### 8. Implementation Checklist

To implement this architecture:

- [ ] **Update /bmad-init:**
  - Creates session-tracker.md
  - Spawns orchestrator in automated mode
  - Orchestrator asks for project description

- [ ] **Update /bmad-next:**
  - Always spawns orchestrator
  - Orchestrator reads session-tracker.md
  - Orchestrator resumes from current phase

- [ ] **Update orchestrator.md:**
  - Add session-tracker.md update logic after each phase
  - Add recovery protocol (already exists, verify completeness)
  - Add automated mode instructions

- [ ] **Update other commands:**
  - /bmad-status reads session-tracker.md (no spawning)
  - /bmad-sprint spawns orchestrator if not running
  - /bmad-gate validates without spawning

- [ ] **Test flow:**
  1. /bmad-init → orchestrator spawns → Phase 1 begins
  2. Stop after Phase 3
  3. /bmad-next → orchestrator resumes → Phase 4 begins
  4. Complete to Phase 8

## Diagram

See [architecture-diagram.mermaid](./architecture-diagram.mermaid) for visual workflow.
