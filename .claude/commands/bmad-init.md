# /bmad-init — Initialize BMad 12-Agent Team

Initialize the BMad Method project structure and spawn the BMad Orchestrator in automated mode.

## What This Command Does

1. Creates the full project directory structure
2. Initializes the session tracker (docs/session-tracker.md)
3. Validates all agent definitions are present
4. **Spawns BMad Orchestrator** in automated mode
5. Orchestrator asks user to describe project
6. Orchestrator begins Phase 1 (Discovery)

## Step 1: Create Project Structure

```bash
# Create project directories
mkdir -p docs/stories docs/adrs docs/epics src tests scripts

# Initialize git if not already
git init 2>/dev/null || true
echo "node_modules/" >> .gitignore 2>/dev/null || true
echo ".env" >> .gitignore 2>/dev/null || true

# Create BMad workflow status (YAML - phase tracking)
cat > docs/bmm-workflow-status.yaml << 'EOF'
project:
  name: ""
  level: 2  # Enterprise level (full workflow)
  initialized: true

phases:
  discovery:
    status: pending  # pending | in_progress | complete | failed
    agent: analyst
    output: docs/product-brief.md
    gate_passed: false

  planning:
    status: pending
    agents: [product-manager, ux-designer]
    outputs: [docs/prd.md, docs/ux-wireframes.md]
    gate_passed: false

  architecture:
    status: pending
    agent: architect
    outputs: [docs/architecture.md, docs/adrs/]
    gate_score: 0
    gate_passed: false  # Requires >= 90/100

  sprint_planning:
    status: pending
    agent: scrum-master
    outputs: [docs/sprint-plan.md, docs/epics/]
    gate_passed: false

  story_creation:
    status: pending
    agents: [story-writer]  # Parallel (1 per epic)
    outputs: [docs/stories/]
    gate_passed: false

  implementation:
    status: pending
    agents: [frontend-developer, backend-developer, database-engineer]
    mode: agent-team  # Uses Agent Team coordination
    tracks:
      frontend: { stories: [], status: pending }
      backend: { stories: [], status: pending }
      database: { stories: [], status: pending }
    gate_passed: false

  quality_assurance:
    status: pending
    agent: qa-engineer
    output: docs/test-plan.md
    gate_passed: false

  deployment:
    status: pending
    agent: devops-engineer
    output: docs/deploy-config.md
    gate_passed: false

  final_review:
    status: pending
    agent: tech-lead
    output: docs/review-checklist.md
    verdict: null  # ship | ship_with_notes | do_not_ship
EOF

# Create orchestrator session tracker (for recovery)
cat > docs/session-tracker.md << 'EOF'
# BMad Orchestrator Session Tracker

**Purpose**: Orchestrator working memory for context compaction recovery

**Session Started**: [Timestamp will be set by orchestrator]
**Last Updated**: [Timestamp]

## Current Orchestrator State

**Current Phase**: Not started
**Sub-phase/Action**: Waiting for /bmad-init to spawn orchestrator
**Status**: Idle

## Active Agent Spawns

| Agent ID | Agent Type | Phase | Spawn Time | Status |
|----------|------------|-------|------------|--------|
| — | — | — | — | — |

## Background Tasks (Agent Team)

| Task ID | Agent Name | Story | Started | Last Update | Status |
|---------|-----------|--------|---------|-------------|--------|
| — | — | — | — | — | — |

## Issues and Resolutions

### Issue Log
| # | Timestamp | Phase | Issue | Resolution | Status |
|---|-----------|-------|-------|------------|--------|
| — | — | — | — | — | — |

**Example entries:**
- `#1 | 2026-02-21 15:30 | Phase 3 | Architect gate score 85/100 (below 90) | Re-spawned architect with feedback: "Add more details to API design section" | Resolved - Score: 92/100`
- `#2 | 2026-02-21 16:45 | Phase 5 | Frontend dev: naming-registry.md conflict with backend | Coordinated via SendMessage, backend updated first, frontend pulled changes | Resolved`

## Decisions Made

### Decision Log
| # | Timestamp | Phase | Decision | Rationale | Outcome |
|---|-----------|-------|----------|-----------|---------|
| — | — | — | — | — | — |

**Example entries:**
- `#1 | 2026-02-21 14:00 | Phase 4 | Created 3 epics instead of 5 | User stories were similar, grouped by user journey | Sprint plan: 3 epics, 12 stories`
- `#2 | 2026-02-21 17:00 | Phase 5 | Used Agent Team (not sequential) | 12 stories with dependencies, coordination needed | Saved ~40 minutes`

## Important Context

### Context Notes (for post-compaction recovery)
- [Critical information orchestrator needs to remember]
- [User preferences mentioned during session]
- [Deviations from standard workflow]
- [Special requirements or constraints]

**Example entries:**
- `User emphasized: "Must support mobile devices first, desktop is secondary"`
- `Database: Using PostgreSQL 15+ for JSONB features (mentioned in Phase 1)`
- `Skipped Phase 7 (DevOps) - user will deploy manually to existing infrastructure`

## Next Action Queue

1. [Action that orchestrator should take next]
2. [Following action if automatic mode]

## Session Variables

- **Sprint Branch**: [Not created]
- **Team Name**: [Not created]
- **Stories Assigned**: [0]
- **User Availability**: [Full-time | Part-time | Async]
- **Target Deadline**: [None | Date]

## Blockers and Issues (Current)

**Active Blockers:**
- [None | Description of blocker and what's needed to unblock]

**Waiting On:**
- [User approval | Agent completion | External dependency]

## Context Recovery Information

**Compaction Events**: 0
**Last Compaction**: Never

**Recovery Checklist (post-compaction):**
- [ ] Read this session-tracker.md
- [ ] Check bmm-workflow-status.yaml for phase status
- [ ] Check for active background tasks
- [ ] Review recent issues and decisions
- [ ] Read important context notes
- [ ] Resume from "Next Action Queue"

---
**Note**: This is the orchestrator's working memory.
- **For project progress**: See `docs/project-tracker.md`
- **For phase status**: See `docs/bmm-workflow-status.yaml`
EOF

echo "✅ Project structure created"
echo "✅ Phase tracking initialized: docs/bmm-workflow-status.yaml"
echo "✅ Session tracker initialized: docs/session-tracker.md"
echo ""
echo "Three-level tracking:"
echo "  1. docs/bmm-workflow-status.yaml — Phase gates (used by /bmad-status, /bmad-gate)"
echo "  2. docs/project-tracker.md — Epic/Story dashboard (created by /bmad-track)"
echo "  3. docs/session-tracker.md — Orchestrator session state (for recovery)"
```

## Step 2: Spawn BMad Orchestrator

```typescript
Task({
  subagent_type: "BMad Orchestrator",
  description: "Initialize BMad workflow",
  model: "opus",
  prompt: `You are the BMad Orchestrator starting a new project.

INITIALIZATION:
1. Greet the user
2. Ask them to describe their project idea in 2-3 sentences
3. Ask about their target users and main problem being solved
4. Begin Phase 1: Discovery (spawn Business Analyst)

WORKFLOW:
- Update docs/session-tracker.md after each phase
- Run phases automatically (Phase 1 → 8)
- Use spawn patterns from your agent file (.claude/agents/orchestrator.md)
- Implement token optimization strategies

PROJECT STRUCTURE:
- docs/session-tracker.md exists (tracks progress)
- All directories created (docs/, src/, tests/, etc.)
- Git initialized

Begin by asking the user about their project.`
});
```

**Result:** Orchestrator spawned and begins automated workflow

## Step 3: Remove Old Workflow File

The old `bmm-workflow-status.yaml` is replaced by `session-tracker.md` which is:
- Human-readable markdown (not YAML)
- Used by orchestrator for recovery
- Tracks artifacts, tasks, blockers
- Updated after each phase
## What Happens Next

After /bmad-init completes:

1. **Orchestrator greets you** and asks about your project
2. **You describe** your project idea (2-3 sentences)
3. **Orchestrator spawns Business Analyst** (Phase 1: Discovery)
4. **Business Analyst creates** `docs/product-brief.md`
5. **Orchestrator automatically advances** to Phase 2, 3, 4...
6. **You can stop anytime** with Ctrl+C
7. **Resume anytime** with `/bmad-next`

The orchestrator runs in **automated mode** - you describe your project once, then it orchestrates all 12 agents through the complete workflow.

## Monitoring Progress

While orchestrator runs:
- `/bmad-status` - Show current phase and progress
- `/bmad-track` - Show epic/story dashboard
- `docs/session-tracker.md` - Live progress tracker

## Agent Team Environment Setup

To enable parallel agent teams for Phase 5 (Implementation), ensure this is in your settings:

```json
// .claude/settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "allow": ["Read", "Write", "Execute"]
  }
}
```
