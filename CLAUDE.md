# BMad Method — 12-Agent Team Orchestration via Claude Code

## Project Overview
This project implements the **BMad Method (Breakthrough Method for Agile AI-Driven Development)** using Claude Code's **Agent Teams** and **subagent spawn** capabilities. A single chat session orchestrates 12 specialized AI agents through a structured, document-driven Agile workflow.

## Architecture: Document-Driven Relay
Each agent produces artifacts (PRD, Architecture, Epics, Stories, Code) that feed the next agent. Documents ARE the persistent context — no shared memory needed.

```
Phase 1: Discovery     → Analyst → Product Brief
Phase 2: Planning      → PM → PRD, UX Designer → Wireframes  (PARALLEL)
Phase 3: Architecture  → Architect → Tech Spec + ADRs
Phase 4: Epic Creation → Scrum Master → Epics + Sprint Plan
Phase 4b: Stories      → Story Writers (1 per epic)            (PARALLEL)
Phase 5: Implementation→ Frontend Dev + Backend Dev + DB Eng   (PARALLEL)
Phase 6: Quality       → QA Engineer → Test Results
Phase 7: Deployment    → DevOps Engineer → Deploy Config
Phase 8: Review        → Tech Lead → Final Review
```

## Agent Definitions
All agents are defined in `.claude/agents/` as Markdown files with YAML frontmatter.

## Workflow Rules
1. **Never skip phases** — each phase gate must pass before proceeding
2. **Documents are the baton** — agents read from `docs/` and write to `docs/`
3. **Parallel work in Phase 2, 4b, and 5** — maximize throughput
4. **Quality gates** — Architect gate (90%+ completeness), QA gate (all tests pass)
5. **Epics group stories** — PRD features → Epics → Stories (hierarchical breakdown)
6. **Stories are atomic** — one task per story, clear acceptance criteria
7. **Git-tracked progress** — every task commit is recorded in the story file, stories auto-push on complete

## File Conventions
- `docs/product-brief.md` — Phase 1 output
- `docs/prd.md` — Phase 2 output (Product Requirements Document)
- `docs/ux-wireframes.md` — Phase 2 output (UX specifications)
- `docs/architecture.md` — Phase 3 output
- `docs/adrs/` — Architecture Decision Records
- `docs/epics/` — Epic files (EPIC-001.md, etc.)
- `docs/sprint-plan.md` — Phase 4 output
- `docs/stories/` — Individual story files (STORY-001.md, etc.)
- `docs/project-tracker.md` — Live project tracking dashboard
- `docs/test-plan.md` — Phase 6 output
- `docs/deploy-config.md` — Phase 7 output
- `docs/review-checklist.md` — Phase 8 output
- `src/` — All implementation code
- `tests/` — All test code

## Git Workflow
- **Every completed task** within a story → `git add . && git commit` with message `[STORY-NNN] task: <description>`
- **Commit SHA recorded** in the story file next to the checked task
- **Story complete** → `git push` to remote with all story commits
- **Branch strategy**: Each sprint works on a branch `sprint/sprint-N`, merged to `develop` on sprint completion

## Commands
- `/bmad-init` — Initialize project structure and agent team
- `/bmad-status` — Show current phase and progress
- `/bmad-next` — Advance to next phase
- `/bmad-gate` — Run quality gate check for current phase
- `/bmad-sprint` — Begin sprint execution (Phase 5)
- `/bmad-review` — Trigger final review cycle
- `/bmad-track` — Show project tracker (epics → stories → tasks progress)
