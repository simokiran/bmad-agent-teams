# /bmad-help — BMad Method Help & Guidance

Display available commands and context-aware guidance on what to do next.

## Always Display This

```
═══════════════════════════════════════════════════
  BMad Method — 12-Agent AI Development Team
  "Ship production software from a single chat session"
═══════════════════════════════════════════════════

COMMANDS:
  /bmad-init     Initialize project structure and agents
  /bmad-status   Show current phase and document status  
  /bmad-next     Advance to the next phase automatically
  /bmad-gate     Run quality gate check for current phase
  /bmad-sprint   Execute implementation with 3 parallel agents
  /bmad-review   Trigger Tech Lead final review
  /bmad-help     Show this help (you're here!)

PHASES:
  1. Discovery      → Business Analyst → Product Brief
  2. Planning        → PM + UX Designer → PRD + Wireframes
  3. Architecture    → System Architect → Tech Spec + ADRs
  4. Sprint Planning → Scrum Master → Stories + Sprint Plan
  5. Implementation  → 3 Developers (parallel Agent Team!)
  6. Quality         → QA Engineer → Test Results
  7. Deployment      → DevOps Engineer → CI/CD + Config
  8. Final Review    → Tech Lead → Ship/No-Ship Verdict

QUICK START:
  1. Say: /bmad-init
  2. Describe what you want to build
  3. Say: /bmad-next (repeat until done!)

TIPS:
  • Review documents between phases — they're your source of truth
  • Phase 5 (Implementation) uses Agent Teams for parallel work
  • Quality gates prevent bad work from flowing downstream
  • If stuck, say: "Re-run Phase [N] with these changes: ..."
  • All agent definitions live in .claude/agents/
```

## Context-Aware Guidance

After showing the command list, check the current project state and give specific advice:

- If no `docs/` directory exists: "Start with `/bmad-init` to set up the project."
- If brief exists but no PRD: "Phase 1 is complete. Ready for Phase 2 (Planning). Say `/bmad-next`."
- If in the middle of Phase 5: "Sprint is in progress. Check on developers with `/bmad-status`."
- If review says DO NOT SHIP: "There are issues to fix. Read `docs/review-checklist.md` for details."

## Optional Arguments

If the user says `/bmad-help [topic]`, provide focused help:

- `/bmad-help agents` — List all 12 agents with their roles
- `/bmad-help phase5` — Detailed explanation of Agent Teams implementation phase
- `/bmad-help gates` — Explain all quality gate criteria
- `/bmad-help customize` — How to add custom agents or modify the workflow
- `/bmad-help costs` — Token cost estimates per phase
