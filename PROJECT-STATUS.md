# BMad Agent Teams - Project Status

**Last Updated**: March 2, 2026
**Current Version**: 1.4.0
**Status**: Active Development — Core functional, optimization in progress

---

## Project Overview

This is the **BMad Agent Teams** plugin for Claude Code — a complete implementation of the BMad Method that transforms a single Claude Code session into a 15-agent software development team. The orchestrator runs in the main chat session and spawns specialist agents as subprocesses through an 8-phase workflow.

### Quick Stats

- **Total Commits**: 42
- **Agent Definitions**: 15 (7,634 lines across agents/commands/skills)
- **Development Docs**: 11 files (4,920 lines)
- **Commands**: 8
- **Skills**: 2
- **Phases**: 8 (with parallel execution in Phases 2, 4b, and 5)

---

## File Structure

```
bmad-agent-teams/
│
├── .claude/
│   ├── agents/                        # 15 agent definitions
│   │   ├── orchestrator.md            # ✅ Team lead (main chat role)
│   │   ├── orchestrator-token-optimization.md  # ✅ Token optimization variant
│   │   ├── analyst.md                 # ✅ Phase 1: Business analysis
│   │   ├── product-manager.md         # ✅ Phase 2: PRD creation
│   │   ├── ux-designer.md             # ✅ Phase 2: UX wireframes
│   │   ├── architect.md               # ✅ Phase 3: Technical design
│   │   ├── scrum-master.md            # ✅ Phase 4: Epic & sprint planning
│   │   ├── story-writer.md            # ✅ Phase 4b: Story creation (parallel)
│   │   ├── frontend-developer.md      # ✅ Phase 5: UI implementation
│   │   ├── backend-developer.md       # ✅ Phase 5: API & logic
│   │   ├── database-engineer.md       # ✅ Phase 5: Schema & queries
│   │   ├── mobile-developer.md        # ✅ Phase 5: Mobile app
│   │   ├── qa-engineer.md             # ✅ Phase 6: Testing
│   │   ├── devops-engineer.md         # ✅ Phase 7: Deployment
│   │   └── tech-lead.md               # ✅ Phase 8: Final review
│   │
│   ├── commands/                      # 8 slash commands
│   │   ├── bmad-init.md               # ✅ Initialize project
│   │   ├── bmad-status.md             # ✅ Show current phase
│   │   ├── bmad-next.md               # ✅ Advance to next phase
│   │   ├── bmad-gate.md               # ✅ Run quality gate
│   │   ├── bmad-sprint.md             # ✅ Begin sprint execution
│   │   ├── bmad-track.md              # ✅ Project dashboard
│   │   ├── bmad-review.md             # ✅ Final review
│   │   └── bmad-help.md               # ✅ Contextual help
│   │
│   ├── skills/                        # 2 auto-run skills
│   │   ├── bmad-generate-summary.md   # ✅ Session summary generation
│   │   └── bmad-init-session-tracker.md # ✅ Session tracker initialization
│   │
│   └── settings.json                  # ✅ Agent Teams config
│
├── docs/                              # Plugin development documentation
│   ├── AGENT-TEAMS-ARCHITECTURE.md    # ✅ Agent Teams design + testing findings
│   ├── ARCHITECTURE.md                # ✅ Three-level tracking architecture
│   ├── COMPARISON-WITH-ORIGINAL.md    # ✅ BMad original vs Agent Teams
│   ├── CONTEXT-ISOLATION-STRATEGY.md  # ✅ Context isolation design
│   ├── ENHANCEMENT-ROADMAP.md         # ✅ Enhancement priorities
│   ├── ORCHESTRATOR-OPTIMIZATION-DEPLOYMENT.md # ✅ Deployment guide
│   ├── PHASE-3-OPTIMIZATIONS.md       # ✅ Phase 3 optimization notes
│   ├── README.md                      # ✅ Docs folder index
│   ├── SESSION-TRACKER.md             # ✅ Session tracker template
│   ├── SESSION-TRACKING-IMPLEMENTATION.md # ✅ Session tracking design
│   └── TOKEN-OPTIMIZATION.md          # ✅ Token optimization analysis
│
├── README.md                          # ✅ Main user documentation
├── CLAUDE.md                          # ✅ Project context + meta-instructions
├── PROJECT-STATUS.md                  # ✅ This file
├── package.json                       # ✅ npm package config
├── install.sh                         # ✅ Installation script
├── cli.js                             # ✅ CLI entry point
├── index.js                           # ✅ Module API
└── LICENSE                            # ✅ MIT license
```

---

## Version History

### v1.4.0 — Parallel Spawn Fix (March 2, 2026)

**Fixed**:
- **Critical**: Replaced all `run_in_background: true` agent spawns with `Promise.all` pattern across orchestrator, bmad-next, and session tracker
  - Root cause: Background agents cannot request interactive permissions (Edit, Bash, Write fail silently)
  - Affected: Phase 2 (PM + UX), Phase 4b (Story Writers), Phase 5 (Developers)
  - Fix: `await Promise.all([Task(...), Task(...)])` in foreground mode
- Added explicit Write tool instructions to scrum-master and tech-lead agents

### v1.3.0 — Session Tracking & Compaction Recovery (February 2026)

**Added**:
- Context compaction detection and tracking in session tracker
- Three-level tracking: session-tracker (orchestrator), project-tracker (team), story files (individual)
- Post-compaction recovery protocol in orchestrator
- `bmad-init-session-tracker` skill for automatic initialization

### v1.2.0 — Orchestrator-Driven Architecture (February 2026)

**Changed**:
- Rewrote `bmad-sprint` as executable orchestrator instructions (not subagent spawn)
- Implemented orchestrator-driven `bmad-next` (main chat assumes orchestrator role)
- Implemented orchestrator-driven `bmad-init`
- Rewritten Phase 5 to use Agent Teams with `TeamCreate` for coordination

**Fixed**:
- Critical file-writing bug in spawned agents
- Interactive approval mode for phase gates
- Simplified orchestrator spawn prompts to respect agent autonomy

### v1.1.0 — Agent Expansion (February 2026)

**Added**:
- Story Writer agent (parallel story creation, 1 per epic)
- Mobile Developer agent (13th → 15th agent with token optimization variant)
- Orchestrator token optimization variant
- Hooks for autonomous agent file writes
- Manual approval workaround for spawned agent permissions

### v1.0.0 — Initial Release (February 2026)

- 12 core agents, 8 commands, 4 templates
- Full 8-phase workflow
- npm package structure with CLI
- Comprehensive documentation

---

## Completion Status

### Agents (15/15)

- [x] **Orchestrator** — Main chat team lead coordination
- [x] **Orchestrator (Token Optimized)** — Reduced-token variant
- [x] **Business Analyst** — Phase 1: Requirements discovery
- [x] **Product Manager** — Phase 2: PRD creation
- [x] **UX Designer** — Phase 2: Wireframes & user flows
- [x] **System Architect** — Phase 3: Technical design + ADRs
- [x] **Scrum Master** — Phase 4: Epic & sprint planning
- [x] **Story Writer** — Phase 4b: Story creation (parallel, 1 per epic)
- [x] **Frontend Developer** — Phase 5: UI implementation
- [x] **Backend Developer** — Phase 5: API & business logic
- [x] **Database Engineer** — Phase 5: Schema & migrations
- [x] **Mobile Developer** — Phase 5: Mobile app development
- [x] **QA Engineer** — Phase 6: Testing & validation
- [x] **DevOps Engineer** — Phase 7: Deployment configs
- [x] **Tech Lead** — Phase 8: Final review & ship decision

### Commands (8/8)

- [x] `/bmad-init` — Initialize project structure
- [x] `/bmad-status` — Show current phase
- [x] `/bmad-next` — Advance to next phase (orchestrator-driven)
- [x] `/bmad-gate` — Run quality gate check
- [x] `/bmad-sprint` — Begin implementation sprint (Agent Teams)
- [x] `/bmad-track` — Project tracker dashboard
- [x] `/bmad-review` — Trigger final review
- [x] `/bmad-help` — Contextual help

### Skills (2/2)

- [x] `bmad-generate-summary` — Session summary generation
- [x] `bmad-init-session-tracker` — Auto-initialize session tracker on project start

### Key Capabilities

1. **Orchestrator-Driven Architecture** — Main chat assumes orchestrator role, spawns specialists as subagents. No nested orchestrator subprocess.

2. **Parallel Agent Execution** — Phases 2, 4b, and 5 use `Promise.all` for true parallel agent spawns with interactive permissions intact.

3. **Document-Driven Relay** — Each agent produces artifacts that feed the next agent. Documents ARE the persistent context.

4. **Token Optimization** — 71% reduction (846k → 241k tokens) through lazy loading, context isolation, streaming outputs, and deduplication.

5. **Session Tracking & Recovery** — Persistent `docs/session-tracker.md` survives context compaction. Orchestrator reads it to resume from exact position.

6. **Quality Gates** — Solutioning Gate (90% architecture completeness), QA Gate (all tests pass), Ship/No-Ship Gate (Tech Lead verdict).

7. **Git Integration** — One commit per task, SHA tracking in story files, auto-push on story completion, sprint branch workflow.

---

## Known Limitations

### Active Issues

1. **Worktree + Permissions Pattern** — Testing in progress. The combination `TeamCreate + team_name + isolation: "worktree" + mode: "bypassPermissions"` succeeded in Session 16 (24 stories, 3 parallel agents), but standalone `Task()` with `isolation: "worktree"` fails (Edit/Write denied). Needs further validation before encoding into workflow files. See `docs/AGENT-TEAMS-ARCHITECTURE.md` for test results.

2. **Agent Teams Feature Flag** — Still requires `CLAUDE_AGENT_TEAMS=true` environment variable (experimental feature in Claude Code).

3. **No Automated Tests** — Plugin relies on manual end-to-end testing in real projects.

4. **Single Sprint Scope** — Multi-sprint support not yet implemented.

### By Design (Not Issues)

- Document-driven (agents don't share memory) — intentional for context isolation
- Sequential phases with gates — enforces quality
- Orchestrator in main chat — enables user interaction and session persistence

---

## Testing Status

### Real-World Test Results

| Session | Configuration | Result |
|---------|--------------|--------|
| 13 | Parallel + worktree (standalone Task) | FAILED — Edit/Write denied |
| 14 | Worktree + bypassPermissions (no TeamCreate) | FAILED |
| 16 | TeamCreate + team_name + worktree + bypassPermissions | SUCCESS — 24 stories, 3 parallel agents |

### Needs Testing

- [ ] `Promise.all` pattern across all phases via `/bmad-next`
- [ ] Worktree without `bypassPermissions` (with proper hooks)
- [ ] Multi-epic parallel story writing (Phase 4b)
- [ ] Context compaction recovery across phases
- [ ] Full end-to-end run through all 8 phases

---

## Next Steps

### Immediate

1. [ ] Validate `Promise.all` fixes via `/bmad-next` end-to-end test
2. [ ] Confirm worktree spawn pattern and encode into orchestrator if validated
3. [ ] Test compaction recovery with real session tracker

### Short-Term (Enhancement Roadmap P1)

See `docs/ENHANCEMENT-ROADMAP.md` for full details:

1. [ ] Story dependency ordering in sprint execution
2. [ ] Incremental architecture updates during implementation
3. [ ] Cross-agent conflict detection
4. [ ] Sprint retrospective automation

### Long-Term

1. [ ] Multi-sprint support
2. [ ] Web dashboard for project tracking
3. [ ] Automated test suite for the plugin itself
4. [ ] i18n support

---

## Architecture Decisions

Key design choices documented across the project:

- **Orchestrator as main chat** (not subagent) — Enables user interaction, session persistence, and direct parallel agent coordination
- **`Promise.all` over `run_in_background`** — Background agents lose interactive permissions; foreground parallel preserves them
- **Document-driven relay** — Agents pass context via files, not shared memory, enabling context isolation and token savings
- **Three-level tracking** — Session tracker (orchestrator), project tracker (team), story files (individual tasks)
- **Token optimization via lazy loading** — Agents only read documents they need, not the entire project context

---

**Status**: Active Development — Core workflow functional, parallel execution fixed, testing ongoing.
