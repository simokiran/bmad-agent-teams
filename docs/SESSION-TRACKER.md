# Session Tracker Template

**Purpose**: Persistent state tracking for orchestrator across context compaction events

**Location**: `docs/session-tracker.md` (created at project start, updated throughout)

**When to Update**: After every phase transition, agent spawn, and agent completion

---

## Project Metadata

**Project Name**: [Project Name]
**Started**: [YYYY-MM-DD HH:MM]
**Last Updated**: [YYYY-MM-DD HH:MM]
**Session ID**: [Current session ID if available]

---

## Current State

**Phase**: [Phase N: Name]
**Status**: [In Progress | Blocked | Complete]
**Next Action**: [What needs to happen next]

**Context Compaction Events**: [N times compacted]
**Last Compaction**: [YYYY-MM-DD HH:MM]

---

## Phase Progress Checklist

### Phase 1: Discovery ✅ | ⏳ | ❌
- [ ] Business Analyst spawned
- [ ] Product Brief created (`docs/product-brief.md`)
- [ ] Quality gate passed
- [ ] User approval received

**Output Files**:
- `docs/product-brief.md` - [✅ Exists | ❌ Missing]

**Status**: [Complete | In Progress | Not Started]
**Completed**: [YYYY-MM-DD HH:MM]

---

### Phase 2: Planning (Parallel) ✅ | ⏳ | ❌
- [ ] Product Manager spawned
- [ ] UX Designer spawned (parallel)
- [ ] PRD created (`docs/prd.md`)
- [ ] Wireframes created (`docs/ux-wireframes.md`)
- [ ] Quality gate passed
- [ ] User approval received

**Output Files**:
- `docs/prd.md` - [✅ Exists | ❌ Missing]
- `docs/ux-wireframes.md` - [✅ Exists | ❌ Missing]

**Active Subagents**:
- Product Manager: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]
- UX Designer: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]

**Status**: [Complete | In Progress | Not Started]
**Completed**: [YYYY-MM-DD HH:MM]

---

### Phase 3: Architecture ✅ | ⏳ | ❌
- [ ] System Architect spawned
- [ ] Architecture created (`docs/architecture.md`)
- [ ] ADRs created (`docs/adrs/*.md`)
- [ ] Naming Registry created (`docs/naming-registry.md`)
- [ ] Skills Required created (`docs/skills-required.md`)
- [ ] PROJECT-SUMMARY generated (`docs/PROJECT-SUMMARY.md`)
- [ ] Quality gate passed (≥90% completeness)
- [ ] User approval received

**Output Files**:
- `docs/architecture.md` - [✅ Exists | ❌ Missing]
- `docs/adrs/` - [N ADRs]
- `docs/naming-registry.md` - [✅ Exists | ❌ Missing]
- `docs/skills-required.md` - [✅ Exists | ❌ Missing]
- `docs/PROJECT-SUMMARY.md` - [✅ Exists | ❌ Missing]

**Active Subagents**:
- System Architect: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]

**Status**: [Complete | In Progress | Not Started]
**Completed**: [YYYY-MM-DD HH:MM]

---

### Phase 4: Epic Creation ✅ | ⏳ | ❌
- [ ] Scrum Master spawned
- [ ] Epics created (`docs/epics/EPIC-*.md`)
- [ ] Sprint Plan created (`docs/sprint-plan.md`)
- [ ] All PRD features mapped to epics
- [ ] Quality gate passed
- [ ] User approval received

**Output Files**:
- `docs/epics/` - [N epics: EPIC-001, EPIC-002, ...]
- `docs/sprint-plan.md` - [✅ Exists | ❌ Missing]

**Epic List**:
| Epic | Title | Track | Features | Stories Expected | Status |
|------|-------|-------|----------|------------------|--------|
| EPIC-001 | [Title] | Backend | F-001, F-002 | STORY-001 to STORY-099 | [✅ ⏳ ❌] |
| EPIC-002 | [Title] | Frontend | F-003, F-004 | STORY-100 to STORY-199 | [✅ ⏳ ❌] |

**Active Subagents**:
- Scrum Master: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]

**Status**: [Complete | In Progress | Not Started]
**Completed**: [YYYY-MM-DD HH:MM]

---

### Phase 4b: Story Creation (Parallel) ✅ | ⏳ | ❌

**Story Writers Spawned**: [N writers, 1 per epic]

**Epic Breakdown**:

#### EPIC-001: [Title]
- [ ] Story Writer spawned (Background Task ID: task_xxx)
- [ ] Context extracted by orchestrator
- [ ] Stories created: STORY-001 to STORY-099
- [ ] Story Writer completed

**Active Subagents**:
- Story Writer (EPIC-001): [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]
- Output File: [Path to background output if running]

**Stories Created**: [N stories]
**Total Story Points**: [M points]

#### EPIC-002: [Title]
- [ ] Story Writer spawned (Background Task ID: task_xxx)
- [ ] Context extracted by orchestrator
- [ ] Stories created: STORY-100 to STORY-199
- [ ] Story Writer completed

**Active Subagents**:
- Story Writer (EPIC-002): [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]
- Output File: [Path to background output if running]

**Stories Created**: [N stories]
**Total Story Points**: [M points]

---

**Phase 4b Summary**:
- Total Stories: [N]
- Total Points: [M]
- Status: [Complete | In Progress | Not Started]
- Completed: [YYYY-MM-DD HH:MM]

---

### Phase 5: Implementation (Parallel + Sequential) ✅ | ⏳ | ❌

**Git Branch**: `sprint/sprint-1`
**Branch Created**: [Yes | No]

**Implementation Order**:
1. Database Engineer (sequential)
2. Backend Developer (sequential after DB)
3. Frontend Developer + Mobile Developer (parallel after Backend)

#### Database Engineer
- [ ] Agent spawned (Background Task ID: task_xxx)
- [ ] Stories assigned: STORY-001 to STORY-005
- [ ] All stories complete
- [ ] All commits pushed
- [ ] Agent completed

**Active Subagents**:
- Database Engineer: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]
- Output File: [Path to background output if running]

**Stories Status**:
| Story | Title | Status | Commits | Last SHA | Pushed |
|-------|-------|--------|---------|----------|--------|
| STORY-001 | [Title] | [✅ ⏳ ❌] | 4 | `a1b2c3d` | [✅ ❌] |

**Completed**: [YYYY-MM-DD HH:MM]

#### Backend Developer
- [ ] Agent spawned (Background Task ID: task_xxx)
- [ ] Stories assigned: STORY-006 to STORY-012
- [ ] All stories complete
- [ ] All commits pushed
- [ ] Agent completed

**Active Subagents**:
- Backend Developer: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]
- Output File: [Path to background output if running]

**Stories Status**:
| Story | Title | Status | Commits | Last SHA | Pushed |
|-------|-------|--------|---------|----------|--------|
| STORY-006 | [Title] | [✅ ⏳ ❌] | 3 | `e4f5g6h` | [✅ ❌] |

**Completed**: [YYYY-MM-DD HH:MM]

#### Frontend Developer (Parallel with Mobile)
- [ ] Agent spawned (Background Task ID: task_xxx)
- [ ] Stories assigned: STORY-013 to STORY-020
- [ ] All stories complete
- [ ] All commits pushed
- [ ] Agent completed

**Active Subagents**:
- Frontend Developer: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]
- Output File: [Path to background output if running]

**Completed**: [YYYY-MM-DD HH:MM]

#### Mobile Developer (Parallel with Frontend)
- [ ] Agent spawned (Background Task ID: task_xxx)
- [ ] Stories assigned: STORY-021 to STORY-025
- [ ] All stories complete
- [ ] All commits pushed
- [ ] Agent completed

**Active Subagents**:
- Mobile Developer: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]
- Output File: [Path to background output if running]

**Completed**: [YYYY-MM-DD HH:MM]

---

**Phase 5 Summary**:
- Total Stories Implemented: [N / M]
- Total Commits: [X commits]
- All Pushed: [Yes | No]
- Status: [Complete | In Progress | Not Started]
- Completed: [YYYY-MM-DD HH:MM]

---

### Phase 6: Quality Assurance ✅ | ⏳ | ❌
- [ ] QA Engineer spawned
- [ ] Test Plan created (`docs/test-plan.md`)
- [ ] All acceptance criteria verified
- [ ] No critical bugs
- [ ] Quality gate passed
- [ ] User approval received

**Output Files**:
- `docs/test-plan.md` - [✅ Exists | ❌ Missing]

**Active Subagents**:
- QA Engineer: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]

**Status**: [Complete | In Progress | Not Started]
**Completed**: [YYYY-MM-DD HH:MM]

---

### Phase 7: Deployment ✅ | ⏳ | ❌
- [ ] DevOps Engineer spawned
- [ ] Deploy Config created (`docs/deploy-config.md`)
- [ ] CI/CD pipeline defined
- [ ] Quality gate passed
- [ ] User approval received

**Output Files**:
- `docs/deploy-config.md` - [✅ Exists | ❌ Missing]

**Active Subagents**:
- DevOps Engineer: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]

**Status**: [Complete | In Progress | Not Started]
**Completed**: [YYYY-MM-DD HH:MM]

---

### Phase 8: Final Review ✅ | ⏳ | ❌
- [ ] Tech Lead spawned
- [ ] Review Checklist created (`docs/review-checklist.md`)
- [ ] Final verdict: [Ship | Ship with Notes | Do Not Ship]
- [ ] User approval received

**Output Files**:
- `docs/review-checklist.md` - [✅ Exists | ❌ Missing]

**Active Subagents**:
- Tech Lead: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]

**Verdict**: [Ship | Ship with Notes | Do Not Ship | Pending]

**Status**: [Complete | In Progress | Not Started]
**Completed**: [YYYY-MM-DD HH:MM]

---

## Active Background Tasks

**CRITICAL**: Check these tasks when resuming after compaction

| Task ID | Agent Type | Epic/Phase | Started | Status | Output File |
|---------|------------|------------|---------|--------|-------------|
| task_abc123 | Story Writer | EPIC-001 | [timestamp] | [Running ⏳ | Complete ✅] | /path/to/output |
| task_def456 | Backend Developer | Phase 5 | [timestamp] | [Running ⏳ | Complete ✅] | /path/to/output |

**Recovery Command**:
```bash
# Check task status
TaskOutput(task_id="task_abc123", block=false)

# Read background output
Read({ file_path: "/path/to/output" })
```

---

## Token Optimization Tracking

**Orchestrator Memory**: [Current tokens]
**Expected for Phase**: [Expected tokens]
**Status**: [✅ Within budget | ⚠️ Approaching limit | 🔴 Exceeded]

**Optimizations Applied**:
- [x] Lazy loading (Phase 1)
- [x] PROJECT-SUMMARY generated (Phase 3)
- [x] Context isolation (Phase 4b)
- [x] Streaming outputs (all phases)
- [x] Deduplication (Phase 5)

---

## Git Tracking

**Current Branch**: `sprint/sprint-1`
**Base Branch**: `develop`

**Recent Activity**:
| Time | SHA | Story | Agent | Message |
|------|-----|-------|-------|---------|
| [timestamp] | `a1b2c3d` | STORY-001 | Database Engineer | [STORY-001] task: Create users table |
| [timestamp] | `e4f5g6h` | STORY-006 | Backend Developer | [STORY-006] task: Implement auth endpoint |

**Sprint Status**:
- Stories committed: [N / M]
- Stories pushed: [N / M]
- Ready for merge: [Yes | No]

---

## Blockers and Issues

**Status Legend:**
- `🟡` = Active blocker — needs attention on resume
- `⏳` = Pending fix — awaiting user input or developer action
- `✅` = Resolved
- `❌` = Won't fix / deferred permanently
- `📋` = Deferred to next sprint

**Current Blockers**: [None | List blockers]

**Example**:
- 🟡 Phase 5: Slider not rendering on mobile (STORY-018, Frontend track)
  - Resolution: Spawn Frontend Developer with fix context
  - Status: Active
- ⏳ Phase 7: User to provide reproduction steps for checkout timeout
  - Resolution: Awaiting user input
  - Status: Pending
- ✅ Phase 4b: Story Writer for EPIC-003 failed (missing context)
  - Resolution: Re-extracted context, re-spawned agent
  - Resolved: 2026-03-03

---

## User Notes

**Purpose**: Persistent notes requested by the user. Always preserved across compaction.

<!-- Add user-requested notes below. These are never archived or trimmed. -->

---

## Session Log

<!-- Session entries are appended below. The post-compact hook injects only the last 2 entries. -->
<!-- When a sprint closes, the orchestrator moves old entries to docs/session-history.md. -->

---

## Orchestrator Instructions for Session Tracking

**CRITICAL**: Update this file after EVERY significant action:

### When to Update
1. **Phase Start**: Mark phase as "In Progress", set "Next Action"
2. **Agent Spawn**: Add to "Active Subagents" with Task ID
3. **Agent Complete**: Mark as "✅ Complete", update timestamp
4. **Background Task**: Record Task ID and output file path
5. **Phase Complete**: Mark phase status, update progress checklist
6. **File Created**: Update "Output Files" section
7. **Git Commit**: Add to "Recent Activity"
8. **Blocker Encountered**: Add to "Blockers and Issues"

### Update Pattern
```typescript
// After spawning agent
await Task({ subagent_type: "Backend Developer", run_in_background: true });

// IMMEDIATELY update session tracker
await Edit({
  file_path: "docs/session-tracker.md",
  old_string: "Backend Developer: [✅ Complete | ⏳ Running | 🔴 Background Task ID: task_xxx]",
  new_string: "Backend Developer: [🔴 Background Task ID: task_abc123]"
});
```

---

**Status**: Template for project initialization
**Usage**: Copy to `docs/session-tracker.md` at project start, update throughout

## Pre-Compaction Checkpoint

**Checkpoint Time**: 2026-03-03 17:46 UTC
**Trigger**: Context about to be compacted

**Recent Tool Activity**:
```
No tool activity captured
```

**Recent Agent Spawns**:
None captured

**Recently Modified Files**:
None captured
