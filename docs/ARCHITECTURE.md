# BMad Architecture: Orchestrator-Driven Workflow

## Overview

BMad uses a **Hybrid Orchestrator-Driven** architecture where:
1. **Default mode**: Automated (orchestrator runs all phases)
2. **Can stop/resume**: For big projects or interruptions
3. **Orchestrator decides**: Parallel vs sequential vs Agent Teams
4. **Single source of truth**: All workflow logic in orchestrator
5. **Three-level tracking**: Phase status, project progress, session recovery

## Three-Level Tracking System

BMad uses three separate tracking files, each with a distinct purpose:

### 1. Phase Status (YAML)
**File**: `docs/bmm-workflow-status.yaml`
```yaml
phases:
  discovery:
    status: complete
    agent: analyst
    output: docs/product-brief.md
    gate_passed: true
```
- **Format**: YAML (structured, parseable by tools)
- **Tracks**: Official phase status (Phase 1-8), gates, agent assignments
- **Updated by**: Orchestrator after each phase completes
- **Used by**: `/bmad-status` command, `/bmad-gate` validation
- **Purpose**: Formal project phase tracking

### 2. Project Dashboard (Markdown)
**File**: `docs/project-tracker.md`
```markdown
EPIC-001: User Authentication
  ├─ STORY-001: DB Schema ✅ Done (4/4 tasks, pushed)
  ├─ STORY-002: Auth API 🔄 Active (3/5 tasks)
  └─ STORY-003: Login UI ⬜ Pending
Progress: 7/13 tasks (54%)
```
- **Format**: Markdown tables (human-readable)
- **Tracks**: Epics, Stories, Tasks, progress percentages
- **Updated by**: `/bmad-track` command
- **Used by**: User to monitor detailed progress
- **Purpose**: User-facing project dashboard

### 3. Session Recovery (Markdown)
**File**: `docs/session-tracker.md`
```markdown
## Issues and Resolutions
#1 | Phase 3 | Architect gate 85/100 → Re-spawned with feedback → 92/100

## Decisions Made
#1 | Phase 5 | Used Agent Team (not sequential) → Dependencies → Saved 40min

## Important Context
- User: "Mobile-first, desktop secondary"
- Database: PostgreSQL 15+ for JSONB features

## Next Action Queue
1. Wait for backend-dev to complete STORY-002
2. Notify frontend-dev when API ready
```
- **Format**: Markdown (orchestrator working memory)
- **Tracks**: Issues found, decisions made, important context, next actions
- **Updated by**: Orchestrator during execution
- **Used by**: Orchestrator for post-compaction recovery
- **Purpose**: Orchestrator's working memory for context recovery

**Why three files?**
- **Separation of concerns**: Each file serves a distinct purpose
- **Different consumers**: Commands, users, and orchestrator
- **Recovery support**: session-tracker.md enables post-compaction recovery
- **Clarity**: No confusion about which file tracks what

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

### 4. Enhanced Session Tracker

**docs/session-tracker.md** is the orchestrator's **working memory**:

```markdown
# BMad Orchestrator Session Tracker

## Current Orchestrator State

**Current Phase**: Phase 5: Implementation
**Sub-phase/Action**: Coordinating Agent Team (backend-dev on STORY-002)
**Status**: Active

## Active Agent Spawns

| Agent ID | Agent Type | Phase | Status |
|----------|------------|-------|--------|
| orch_001 | BMad Orchestrator | All | Running |
| task_db123 | Database Engineer | Phase 5 | Complete ✅ |
| task_be456 | Backend Developer | Phase 5 | Running ⏳ |
| task_fe789 | Frontend Developer | Phase 5 | Waiting |

## Issues and Resolutions

| # | Timestamp | Phase | Issue | Resolution | Status |
|---|-----------|-------|-------|------------|--------|
| 1 | 2026-02-21 15:30 | Phase 3 | Architect gate 85/100 (below 90) | Re-spawned with feedback: "Add API design details" | Resolved - 92/100 |
| 2 | 2026-02-21 17:15 | Phase 5 | naming-registry.md conflict | Coordinated via SendMessage, backend updated first | Resolved |

## Decisions Made

| # | Timestamp | Phase | Decision | Rationale | Outcome |
|---|-----------|-------|----------|-----------|---------|
| 1 | 2026-02-21 14:00 | Phase 4 | Created 3 epics (not 5) | User stories similar, grouped by journey | 3 epics, 12 stories |
| 2 | 2026-02-21 17:00 | Phase 5 | Used Agent Team | 12 stories with dependencies | Saved ~40 minutes |

## Important Context

**User Preferences:**
- "Mobile-first, desktop is secondary priority"
- Prefer TypeScript over JavaScript
- Using existing PostgreSQL 15 database

**Technical Constraints:**
- Must support PostgreSQL 15+ for JSONB features
- No Docker - deploying to existing server
- Skipped Phase 7 (DevOps) - manual deployment

**Workflow Deviations:**
- Combined EPIC-002 and EPIC-003 into single epic (similar features)

## Next Action Queue

1. Wait for backend-dev to complete STORY-002 task 4/5
2. SendMessage to frontend-dev when API endpoints ready
3. Continue monitoring Agent Team progress
4. Advance to Phase 6 when all 12 stories marked "Done"

## Context Compaction Events

**Count**: 2 times compacted
**Last Compaction**: 2026-02-21 18:45 UTC

**Recovery Checklist:**
- [x] Read session-tracker.md
- [x] Check bmm-workflow-status.yaml (Phase 5: in_progress)
- [x] Review issues (#2: naming conflict resolved)
- [x] Review decisions (#2: Agent Team approach)
- [x] Read important context (mobile-first, PostgreSQL)
- [x] Resume from Next Action Queue
```

**Key Features:**
- **Issues Log**: Problems encountered and how resolved
- **Decisions Log**: Key decisions, rationale, outcomes
- **Important Context**: User preferences, constraints, deviations
- **Recovery Checklist**: Step-by-step post-compaction recovery

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
