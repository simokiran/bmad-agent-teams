# BMad Method — Practical Usage Guide

## How to Actually Run This (Step by Step)

### Step 0: Setup (one-time)

```bash
# 1. Copy .claude/ directory into your project root
cp -r path/to/bmad-agent-teams/.claude ./

# 2. Copy CLAUDE.md and scripts
cp path/to/bmad-agent-teams/CLAUDE.md ./
cp -r path/to/bmad-agent-teams/scripts ./

# 3. Enable Agent Teams in your environment
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# 4. Optional: Use tmux for split-pane view during Phase 5
tmux new-session -s bmad

# 5. Start Claude Code
claude
```

### Step 1: Initialize and Describe Your Project

Tell Claude Code:

```
/bmad-init

Build me a project management tool for small teams. It should have:
- Task boards with drag-and-drop
- Team member assignment
- Due dates and reminders  
- Simple time tracking
- Weekly progress reports
```

The Orchestrator activates and spawns the **Business Analyst** as a subagent.

### Step 2: Review the Product Brief

The Analyst creates `docs/product-brief.md`. Review it:

```
Show me the product brief. Does it capture my vision correctly?
```

If changes needed: "Update the brief to also include Slack integration for notifications."

If good: "Looks great. Proceed to Phase 2."

### Step 3: Planning Phase (PM + UX run in parallel)

```
Start Phase 2 — planning.
```

The Orchestrator spawns **Product Manager** and **UX Designer** simultaneously. They both read the Product Brief and produce:
- `docs/prd.md` — Detailed feature specs with acceptance criteria
- `docs/ux-wireframes.md` — Screen layouts, user flows, component library

Review both documents before proceeding.

### Step 4: Architecture Phase

```
Start Phase 3 — architecture.
```

The **System Architect** reads the PRD and UX spec, then produces:
- `docs/architecture.md` — Full technical design
- `docs/adrs/ADR-001-tech-stack.md` — Why we chose Next.js + PostgreSQL (etc.)

**Critical**: The architect runs the **Solutioning Gate Check** and must score ≥90/100. If it fails, the orchestrator re-spawns the architect with specific gaps to fill.

### Step 5: Sprint Planning

```
Start Phase 4 — sprint planning.
```

The **Scrum Master** creates:
- `docs/sprint-plan.md` — Overview with dependency graph
- `docs/stories/STORY-001.md` through `STORY-NNN.md` — Individual atomic stories

Each story is assigned to a **track**: Frontend, Backend, or Database.

**This is your last checkpoint before coding starts.** Review the stories:

```
Show me the sprint plan. How many stories per track?
Are there any dependency bottlenecks?
```

### Step 6: Implementation (THE BIG ONE — Agent Team!)

```
Start Phase 5 — implementation.
```

The Orchestrator creates an **Agent Team** called "sprint-1" and spawns 3 developers:

```
┌─────────────────────────────────────────────────────┐
│ Terminal (tmux)                                       │
│                                                       │
│ ┌─────────────┬───────────────┬─────────────────┐   │
│ │ Orchestrator │ Frontend Dev  │ Backend Dev      │   │
│ │ (your pane)  │ Building UI   │ Building APIs    │   │
│ │              │ components... │ and logic...     │   │
│ │              │               │                  │   │
│ ├─────────────┴───────────────┴─────────────────┤   │
│ │ Database Engineer                              │   │
│ │ Creating schemas, migrations, seed data...     │   │
│ └────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

**Key interactions during Phase 5:**

```
# Check on a specific developer
(Shift+Down to cycle to frontend-dev pane)
How's STORY-003 going?

# Ask the orchestrator to check overall progress
(Shift+Down back to lead)
What's the status of all three tracks?

# If a developer gets stuck
Tell the backend developer to check the architecture doc 
for the API response format convention.
```

### Step 7: Quality Assurance

```
Start Phase 6 — QA.
```

The **QA Engineer** reviews all code, runs tests, verifies every acceptance criterion, and hunts for bugs. Produces `docs/test-plan.md`.

If bugs are found: The orchestrator re-spawns the relevant developer to fix them.

### Step 8: Deployment Config

```
Start Phase 7 — deployment.
```

The **DevOps Engineer** creates CI/CD pipelines, Docker configs, and environment templates.

### Step 9: Final Review

```
Start Phase 8 — final review.
```

The **Tech Lead** audits everything and gives one of three verdicts:

- ✅ **SHIP** — Everything passes, ready for production
- ⚠️ **SHIP WITH NOTES** — Minor issues, can deploy with known items
- ❌ **DO NOT SHIP** — Critical issues that must be fixed first

---

## Common Patterns

### "I want to skip ahead"
```
Jump to Phase 5 — I already have my PRD and architecture written.
```
The orchestrator checks if the required documents exist before proceeding.

### "I want to re-run a phase"
```
Re-run Phase 3. The architecture needs to include WebSocket support 
for real-time updates.
```

### "I want a different tech stack"
```
In the architecture phase, use Python/FastAPI for the backend 
instead of Node.js. Use Vue instead of React.
```

### "I want more developers in Phase 5"
```
Add a fourth developer focused on the authentication system.
Spawn them in the sprint-1 team.
```

### "I want to see all documents"
```
/bmad-status

Show me the full document chain: brief → PRD → architecture → stories
```

---

## Cost Expectations

| Phase | Agents | Estimated Tokens | Model |
|-------|--------|-----------------|-------|
| 1: Discovery | 1 (Analyst) | ~5K | Sonnet |
| 2: Planning | 2 (PM + UX) | ~15K | Sonnet |
| 3: Architecture | 1 (Architect) | ~10K | Opus |
| 4: Sprint Planning | 1 (SM) | ~10K | Sonnet |
| 5: Implementation | 3 (Devs) | ~50-100K | Sonnet |
| 6: QA | 1 (QA) | ~15K | Sonnet |
| 7: Deployment | 1 (DevOps) | ~8K | Sonnet |
| 8: Review | 1 (Tech Lead) | ~10K | Opus |
| **Total** | **12 agents** | **~120-175K** | Mixed |

Phase 5 is by far the most expensive because three agents work in parallel, each with their own context window. Using Sonnet for implementation agents keeps costs reasonable.

---

## Troubleshooting

**Agent Teams not working?**
```bash
# Verify the env var is set
echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS
# Should output: 1
```

**Phase 5 agents conflicting on files?**
- The Scrum Master assigns stories to tracks specifically to avoid file conflicts
- If it happens anyway, the orchestrator halts and re-assigns stories

**Quality gate failing repeatedly?**
- Lower the threshold temporarily: edit the orchestrator agent to accept 80/100
- Or ask the orchestrator to identify specific gaps and address them

**Too many stories for one sprint?**
- Tell the Scrum Master to create Sprint 1 (MVP) and Sprint 2 (enhancement)
- Only implement Sprint 1 in Phase 5, then loop back for Sprint 2
