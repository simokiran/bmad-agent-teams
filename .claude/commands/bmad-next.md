# /bmad-next — Advance to Next Phase

Automatically determine the current phase and advance by spawning appropriate agent(s).

## Phase Detection Logic

```
IF docs/product-brief.md does NOT exist:
  → Phase 1: Spawn Business Analyst (single subagent)

ELSE IF docs/prd.md OR docs/ux-wireframes.md does NOT exist:
  → Phase 2: Spawn PM + UX Designer (parallel subagents)

ELSE IF docs/architecture.md does NOT exist:
  → Phase 3: Spawn System Architect (single subagent)
  → Must pass 90% Solutioning Gate before proceeding

ELSE IF docs/epics/ is empty (no EPIC-*.md files):
  → Phase 4: Spawn Scrum Master (single subagent)
  → Creates Epics + Sprint Plan
  → Does NOT create stories (that's Phase 4b)

ELSE IF docs/stories/ is empty (no STORY-*.md files):
  → Phase 4b: PARALLEL Story Creation
  → Spawn one story-writer subagent PER epic file
  → Each writer creates stories for its assigned epic
  → Story numbering uses epic-based ranges to avoid conflicts

ELSE IF any story file does NOT have "[x] Done" status:
  → Phase 5: Create Agent Team with 3 developers
  → Set up sprint git branch first
  → IMPORTANT: Ask user approval (expensive phase)

ELSE IF docs/test-plan.md does NOT exist:
  → Phase 6: Spawn QA Engineer

ELSE IF docs/deploy-config.md does NOT exist:
  → Phase 7: Spawn DevOps Engineer

ELSE IF docs/review-checklist.md does NOT exist:
  → Phase 8: Spawn Tech Lead

ELSE:
  → All phases complete! Show final verdict.
```

## Phase 4b: Parallel Story Creation (Detail)

This is the key new phase. After the Scrum Master creates epics:

```
# Count epic files
EPIC_COUNT=$(ls docs/epics/EPIC-*.md 2>/dev/null | wc -l)

echo "Found $EPIC_COUNT epics. Spawning $EPIC_COUNT parallel story writers..."

# For EPIC-001:
Task({
  name: "story-writer-epic-001",
  prompt: `You are a Story Writer. Your ONLY job: create stories for EPIC-001.

READ FIRST:
1. .claude/agents/scrum-master.md — Story format, rules, and Git Task Tracking section
2. docs/epics/EPIC-001.md — This epic's scope, ACs, and track guidance
3. docs/architecture.md — Technical approach
4. docs/prd.md — Feature acceptance criteria

CREATE stories in docs/stories/ using the number range from the epic file.
EVERY story MUST include:
- Metadata (points, track, epic, dependencies)
- User Story (As a... I want... so that...)
- Acceptance Criteria (3+ testable criteria)
- Tasks (individual committable units of work)
- Git Task Tracking table (with task rows, status ⬜, SHA placeholder)
- Story Git Summary section
- Status checkboxes including "Pushed"

Use templates/story.md as reference for the exact format.`,
  subagent_type: "general-purpose",
  run_in_background: true
})

# For EPIC-002:
Task({
  name: "story-writer-epic-002",
  prompt: `...same but for EPIC-002...`,
  subagent_type: "general-purpose",
  run_in_background: true
})

# Repeat for each epic...
```

After all story writers complete, run the Phase 4b gate:
- All stories have ACs, points, track, dependencies
- All stories have Git Task Tracking section
- Story numbers don't overlap between epics
- Cross-epic dependencies are mapped

## User Approval Checkpoints

Ask for confirmation before:
- **Phase 3** → "PRD and UX spec ready. Proceed to Architecture?"
- **Phase 4b** → "Scrum Master created [N] epics. Spawn [N] parallel story writers?"
- **Phase 5** → "Sprint has [N] stories across [N] epics. Spawn 3 developers + git branch?"
- **Phase 8** → "QA and deployment ready. Proceed to final review?"

## After Each Phase

1. Run `/bmad-gate` to verify phase output quality
2. Update `docs/project-tracker.md` via `/bmad-track`
3. If gate fails → re-spawn the agent with specific feedback
4. If gate passes → show the user what was produced and suggest next phase
