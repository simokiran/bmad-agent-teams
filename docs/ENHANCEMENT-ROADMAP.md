# Enhancement Roadmap: BMad Agent Teams

**Last Updated**: 2026-03-03
**Source**: https://github.com/bmad-code-org/BMAD-METHOD
**Current Version**: v1.0.3

---

## Overview

This document tracks planned features, completed enhancements, and future priorities for the BMad Agent Teams Claude Code plugin.

---

## Completed Features

### v1.0 — Core Workflow

- 14 specialized agent definitions (analyst, PM, UX, architect, scrum master, story writer, frontend dev, backend dev, database engineer, mobile dev, QA, devops, tech lead, orchestrator)
- 8-phase document-driven workflow (Discovery → Final Review)
- Parallel agent execution (Phase 2, 4b, 5) via `Promise.all`
- Agent Team coordination for Phase 5 (SendMessage, shared task list)
- Token optimization (71% reduction — lazy loading, context isolation, streaming outputs)
- Quality gates (architect 90%+ score, QA all-pass, tech lead ship/no-ship)
- Interactive approval gates (Phase 3→4, 4b→5, 7→8)
- Sprint git workflow (branch per sprint, commit per task, push per story)
- 8 slash commands (`/bmad-init`, `/bmad-next`, `/bmad-status`, `/bmad-gate`, `/bmad-sprint`, `/bmad-track`, `/bmad-review`, `/bmad-help`)
- Session tracker for orchestrator state persistence
- PROJECT-SUMMARY generation for downstream agent context
- Naming registry for cross-layer consistency

### v1.0.1 — Reliability & DX (2026-03-03)

- **Auto-Recovery After Context Compaction** — 3-layer system:
  - Layer 1: `CLAUDE.md` in user project with orchestrator role assignment
  - Layer 2: `PreCompact` hook saves transcript context to session-tracker.md
  - Layer 3: `SessionStart(compact)` hook injects role + state after compaction
- **Centralized Git Helper** (`bmad-git.sh`) — DRY git workflow:
  - `task-commit` — stage, commit, capture SHA, update story file automatically
  - `story-push` — mark done, commit, push to sprint branch
  - `sprint-start` / `sprint-merge` — branch lifecycle
  - `status` / `update-tracker` — git status helpers
  - Wired into all 4 developer agents (frontend, backend, database, mobile)
- **Installer Update Mode** — `./install.sh --update` or `npx @bmad-code/agent-teams update`:
  - Refreshes agents, commands, scripts, skills, templates
  - Preserves project state (docs/, CLAUDE.md, workflow status, session tracker)
  - Warns about outdated config files (settings.json, hooks.json)
- **CLAUDE.md Deployment** — Created by both installer and `/bmad-init`
- **Installer fixes** — Correct source paths for `.claude/scripts/`, accurate counts, safe project state handling

### v1.0.2 — Design Prototyping & Mid-Impl Flexibility (2026-03-03)

- **Frontend Design Prototyper Agent** (agent #15) — On-demand HTML/CSS/JS demo creation:
  - Creates self-contained HTML prototypes in `docs/design-prototypes/`
  - Maintains `docs/visual-identity-guide.md` with design tokens (colors, typography, spacing, component patterns)
  - Reads UX wireframes for design consistency
  - Spawned on-demand via `/bmad-design` command or orchestrator
  - Uses sonnet model for cost-effective design work
- **`/bmad-design` Slash Command** — Invoke the prototyper from any phase:
  - Asks what to prototype if not specified
  - Spawns prototyper agent, returns file path for browser preview
- **Mid-Implementation Flexibility** — Orchestrator now handles ad-hoc changes during Phase 5:
  - Ad-hoc tasks: Create and assign new tasks not in original stories
  - Feature extensions: Expand existing stories with new tasks mid-sprint
  - Design prototype requests: Spawn prototyper on-demand during implementation
  - New architecture decisions: Create mid-implementation ADRs and notify developers
- **Frontend Developer Visual Identity Integration** — Frontend dev now reads `docs/visual-identity-guide.md` for design token consistency

### v1.0.3 — Story Fix Cycles & Session Optimization (2026-03-03)

- **Session Tracker Token Optimization** — Post-compaction injection reduced from ~76KB to ~25KB (67% reduction):
  - Smart selective extraction in `bmad-post-compact.sh` — only injects recovery-essential sections
  - Skips completed phase checklists, token tracking, duplicated recovery protocols, old session logs
  - Keeps only last 2 session entries (older sessions readable on demand)
  - New `## User Notes` section in session tracker — always preserved across compaction, never archived
  - Sprint Archival protocol — orchestrator moves old session logs to `docs/archives/session-history/sprint-N.md` on sprint close
  - Removed duplicated Recovery Protocol and Recovery Example from template (already in orchestrator.md)
- **Per-Story Code Review (Level 1)** — Optional Tech Lead lightweight review after each story completes during Phase 5:
  - Orchestrator asks user at Phase 5 start whether to enable per-story reviews
  - Tech Lead reviews only the story's files and commits (not full codebase)
  - Returns Approved or Changes Requested, developer fixes, max 2 rounds
- **User-Reported Bug Fixes (Level 2)** — Mid-sprint bug fix flow:
  - User reports issue → orchestrator identifies story/track → spawns developer
  - Logged in session tracker Decision Log
- **QA Bug Fix Loop (Level 3)** — After Phase 6, bugs routed back to developers:
  - Bugs grouped by Track field → one developer per track spawned in parallel
  - QA re-tests fixed bugs only (not full test suite), max 2 rounds
- **Tech Lead Fix Loop (Level 4)** — After Phase 8, action items routed to developers:
  - P0/P1 action items extracted → developers fix → Tech Lead re-reviews
  - Max 2 rounds, escalate to user if still failing
- **Story Template Review & QA Section** — Stories now track review feedback and QA bugs inline:
  - Review Feedback table (Round, Reviewer, Result, Issues, Fix Commit)
  - QA Bugs table (Bug ID, Description, Severity, Fix Commit, Verified)
  - New statuses: In Review, Changes Requested, QA Passed
- **Developer Fix Request Handling** — All 4 developer agents (frontend, backend, database, mobile) can now handle fix requests from Tech Lead reviews and QA bug reports
- **QA Re-Test Cycle** — QA engineer supports targeted re-testing of specific bugs without re-running full test plan
- **Pending Fixes Detection on Resume** — `/bmad-next` now checks `## Blockers and Issues` for 🟡/⏳ items before offering phase advancement:
  - Presents active blockers/pending fixes to user on resume
  - Offers: fix now (spawn developer), defer to next sprint, or proceed anyway
  - Status legend (🟡 ⏳ ✅ ❌ 📋) added to session tracker template
  - Orchestrator Compaction Checklist updated to ensure pending fixes are documented with details
- **`/bmad-fix` Slash Command** — On-demand story creation (fixes, features, extensions):
  - Supports 3 story types: bug fixes from staging, new features, and extending existing stories
  - Spawns Story Writer to create structured story (STORY-NNN) with tasks and acceptance criteria
  - User approves story before implementation ("Story only" option to defer implementation)
  - Spawns appropriate Developer agent to implement
  - Git-tracked with `bmad-git.sh task-commit` per task, `story-push` on completion
  - Replaces the old Ad-Hoc Task and Feature Extension inline orchestrator flows
- **Orchestrator Full Delegation Enforcement** — Expanded "never implement" rule to cover ALL specialist artifacts:
  - Stories → Story Writer, Test plans → QA Engineer, Architecture → Architect, etc.
  - Agent-to-Artifact ownership table added to orchestrator definition
  - CLAUDE.md template and post-compact hook updated with broader delegation rule
- **Ad-Hoc Git Commit Protocol** — `bmad-git.sh ad-hoc-commit` for fixes without a story reference:
  - Stages, commits with `[AD-HOC] fix:` prefix, pushes, outputs SHA
  - All 4 developer agents updated with Ad-Hoc Fixes section

---

## Planned Features

### v1.1 — Quick Flow & Documentation

| # | Feature | Impact | Effort | Status |
|---|---------|--------|--------|--------|
| 1 | Quick Flow Workflows | High | Medium | Not started |
| 2 | Tech Writer Agent | Medium | Low | Not started |
| 3 | Adaptive Complexity Scaling | High | High | Not started |

#### Quick Flow Workflows

Fast-track for small projects (< 5 stories). Skip heavy planning phases.

```
/bmad-quick-spec  — PRD + Architecture in one step
/bmad-quick-dev   — Solo dev agent handles all tracks
```

New agent: `quick-flow-solo-dev.md` combining Frontend + Backend + Database roles.

**Value**: 80% faster for MVPs, prototypes, small features.

#### Tech Writer Agent

Dedicated documentation agent for user-facing docs.

```
New agent: .claude/agents/tech-writer.md
Outputs: README.md, docs/api-reference.md, docs/user-guide.md

Triggered:
  - Phase 2: Initial README from product brief
  - Phase 6 (after QA): User guides, API reference
  - Phase 8: Deployment docs, troubleshooting
```

#### Adaptive Complexity Scaling

Auto-detect project size from product brief and adjust workflow depth.

```
SIMPLE  (< 5 features, < 2 integrations) → Quick Flow (2 phases)
MEDIUM  (< 15 features)                  → Standard Flow (8 phases)
COMPLEX (15+ features, enterprise)        → Enterprise Flow (+ research, tech writer)
```

---

### v1.2 — Agility & Quality

| # | Feature | Impact | Effort | Status |
|---|---------|--------|--------|--------|
| 4 | Mid-Project Course Correction | High | High | Not started |
| 5 | Per-Story Code Review | High | Medium | **Done (v1.0.3)** |
| 6 | Research Modules | Medium | Medium | Not started |

#### Mid-Project Course Correction (`/bmad-correct-course`)

Allow pivots mid-project: analyze impact on existing stories/epics, propose options (update PRD, create new epic, deprecate stories), re-run affected phases.

#### Per-Story Code Review — Completed in v1.0.3

Moved to v1.0.3 as part of the Story Fix Cycles feature. Includes 4 levels of fix cycles: per-story review, user-reported bugs, QA bug loops, and Tech Lead fix loops.

#### Research Modules

Add research capabilities to Phase 1:
- `/bmad-research-market` — Competitor analysis via WebSearch
- `/bmad-research-domain` — Industry standards, terminology
- `/bmad-research-technical` — Framework comparisons, best practices

---

### v1.3 — Validation & Visualization

| # | Feature | Impact | Effort | Status |
|---|---------|--------|--------|--------|
| 7 | Document Validation | Medium | Low | Not started |
| 8 | Mermaid Diagram Generation | Low | Low | Not started |
| 9 | Project Context Export | Medium | Low | Not started |

#### Document Validation (`/bmad-validate-doc`)

Validate PRD, architecture, and stories against quality standards: required sections present, acceptance criteria testable, no ambiguous language, dependencies valid.

#### Mermaid Diagrams (`/bmad-mermaid`)

Generate visual diagrams: system architecture (C4), database ERD, API flows, user flows, sprint workflow, git branching.

#### Project Context Export (`/bmad-context`)

Generate single-file project context for onboarding or sharing: tech stack, key decisions, naming conventions, current sprint status, environment setup.

---

### v1.4 — Developer Experience

| # | Feature | Impact | Effort | Status |
|---|---------|--------|--------|--------|
| 10 | Explain Concept | Low | Low | Not started |
| 11 | Diataxis Documentation | Medium | High | Not started |

---

### v2.0 — Plugin/Module System

| # | Feature | Impact | Effort | Status |
|---|---------|--------|--------|--------|
| 12 | Plugin/Module System | High | Very High | Not started |

Pluggable modules for specialized workflows:
- `@bmad-code/test-architect` — Advanced testing strategies
- `@bmad-code/game-dev-studio` — Game development agents
- `@bmad-code/creative-suite` — Design-focused workflows

---

## Implementation Priority Matrix

| Feature | Impact | Effort | Version | Status |
|---------|--------|--------|---------|--------|
| Interactive Help | High | Medium | v1.0 | **Done** |
| Auto-Recovery (hooks) | High | Medium | v1.0.1 | **Done** |
| Centralized Git Helper | Medium | Medium | v1.0.1 | **Done** |
| Installer Update Mode | Medium | Medium | v1.0.1 | **Done** |
| Design Prototyper Agent | Medium | Medium | v1.0.2 | **Done** |
| Mid-Impl Flexibility | High | Medium | v1.0.2 | **Done** |
| Story Fix Cycles | High | Medium | v1.0.3 | **Done** |
| Session Tracker Optimization | Medium | Low | v1.0.3 | **Done** |
| Pending Fixes Detection | Medium | Low | v1.0.3 | **Done** |
| `/bmad-fix` On-Demand Stories | Medium | Low | v1.0.3 | **Done** |
| Full Delegation Enforcement | Medium | Low | v1.0.3 | **Done** |
| Ad-Hoc Git Commit Protocol | Low | Low | v1.0.3 | **Done** |
| Quick Flow Workflows | High | Medium | v1.1 | Planned |
| Tech Writer Agent | Medium | Low | v1.1 | Planned |
| Adaptive Complexity | High | High | v1.1 | Planned |
| Course Correction | High | High | v1.2 | Planned |
| Per-Story Code Review | High | Medium | v1.0.3 | **Done** |
| Research Modules | Medium | Medium | v1.2 | Planned |
| Document Validation | Medium | Low | v1.3 | Planned |
| Mermaid Diagrams | Low | Low | v1.3 | Planned |
| Project Context | Medium | Low | v1.3 | Planned |
| Explain Concept | Low | Low | v1.4 | Planned |
| Diataxis Docs | Medium | High | v1.4 | Planned |
| Module System | High | Very High | v2.0 | Planned |

---

## References

- Original BMAD-METHOD: https://github.com/bmad-code-org/BMAD-METHOD
- Diataxis Framework: https://diataxis.fr/
