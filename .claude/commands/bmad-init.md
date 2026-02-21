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

# Create session tracker
cat > docs/session-tracker.md << 'EOF'
# BMad Session Tracker

**Project**: [To be determined]
**Started**: $(date -u +"%Y-%m-%d %H:%M UTC")
**Last Updated**: $(date -u +"%Y-%m-%d %H:%M UTC")

## Current State

**Phase**: Phase 1: Discovery
**Status**: Not Started
**Next Action**: Spawn BMad Orchestrator to begin workflow

## Phase Progress

- [ ] Phase 1: Discovery (Business Analyst)
- [ ] Phase 2: Planning (PM + UX Designer parallel)
- [ ] Phase 3: Architecture (System Architect)
- [ ] Phase 4: Epic Creation (Scrum Master)
- [ ] Phase 4b: Story Creation (Story Writers parallel)
- [ ] Phase 5: Implementation (Agent Team: DB, Backend, Frontend)
- [ ] Phase 6: Quality Assurance (QA Engineer)
- [ ] Phase 7: Deployment (DevOps Engineer)
- [ ] Phase 8: Final Review (Tech Lead)

## Artifacts Created

- `docs/product-brief.md` - [❌ Missing]
- `docs/prd.md` - [❌ Missing]
- `docs/ux-wireframes.md` - [❌ Missing]
- `docs/architecture.md` - [❌ Missing]
- `docs/epics/` - [❌ Missing]
- `docs/stories/` - [❌ Missing]
- `docs/test-plan.md` - [❌ Missing]
- `docs/deploy-config.md` - [❌ Missing]
- `docs/review-checklist.md` - [❌ Missing]

## Active Background Tasks

| Task ID | Agent | Phase | Started | Status |
|---------|-------|-------|---------|--------|
| — | — | — | — | — |

## Blockers and Issues

[None]

## Context Compaction Events

**Count**: 0 times compacted
**Last Compaction**: Never
EOF

# Remove old workflow status if exists
rm -f docs/bmm-workflow-status.yaml

echo "✅ Project structure created"
echo "✅ Session tracker initialized: docs/session-tracker.md"
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
