# /bmad-review — Trigger Final Tech Lead Review

Spawn the Tech Lead agent to perform a comprehensive review of the entire project.

## Pre-flight Checks

Verify these documents exist before starting the review:
- `docs/product-brief.md` — Phase 1 output
- `docs/prd.md` — Phase 2 output
- `docs/architecture.md` — Phase 3 output  
- `docs/sprint-plan.md` — Phase 4 output
- `docs/test-plan.md` — Phase 6 output
- `docs/deploy-config.md` — Phase 7 output
- Source code in `src/`
- Tests in `tests/`

If any are missing, tell the user which phases are incomplete.

## Spawn Tech Lead

```
Task({
  name: "tech-lead",
  subagent_type: "general-purpose",
  prompt: `You are the Tech Lead performing the FINAL review before shipping.

READ YOUR INSTRUCTIONS: .claude/agents/tech-lead.md

REVIEW THESE DOCUMENTS (in order):
1. docs/product-brief.md — Original vision
2. docs/prd.md — Feature requirements and acceptance criteria  
3. docs/architecture.md — Technical design
4. docs/sprint-plan.md — Implementation plan
5. docs/test-plan.md — QA results
6. docs/deploy-config.md — Deployment configuration

REVIEW THIS CODE:
- All files in src/ — Implementation quality
- All files in tests/ — Test coverage and quality

CREATE: docs/review-checklist.md following the template in your agent instructions.

YOUR VERDICT must be one of:
- ✅ SHIP — Production ready
- ⚠️ SHIP WITH NOTES — Minor issues, document them
- ❌ DO NOT SHIP — Critical issues that must be fixed

Be thorough. Check for:
- Architecture compliance
- Code quality (no dead code, proper error handling, type safety)
- Security (auth, validation, injection prevention)  
- Performance (N+1 queries, bundle size, indexing)
- Test coverage (≥80% target)
- PRD feature completeness (all P0 features implemented)
- Documentation accuracy`
})
```

## Handling the Verdict

### ✅ SHIP
```
🎉 Tech Lead Verdict: SHIP

The project has passed all quality gates and is ready for production deployment.

Summary:
- [X] features implemented
- [X]% test coverage
- [X] stories completed
- Architecture compliance: [X]%

Next steps:
1. Run `npm run build` to create production build
2. Deploy using the config in docs/deploy-config.md
3. Monitor health checks after deployment
```

### ⚠️ SHIP WITH NOTES
```
⚠️ Tech Lead Verdict: SHIP WITH NOTES

The project is deployable but has minor issues to address:

Known Issues:
1. [Issue from review]
2. [Issue from review]

These are logged in docs/review-checklist.md and should be addressed in the next sprint.
```

### ❌ DO NOT SHIP
```
❌ Tech Lead Verdict: DO NOT SHIP

Critical issues found that must be resolved:

Blockers:
1. [Critical issue]
2. [Critical issue]

Action Plan:
- Re-spawn [agent] to fix [issue]
- Re-run Phase [N] after fixes
- Then re-run /bmad-review

Shall I start fixing these issues?
```

If DO NOT SHIP:
1. Read the action items from `docs/review-checklist.md`
2. Identify which agent(s) need to be re-spawned
3. Re-spawn them with specific instructions about what to fix
4. After fixes, re-run `/bmad-review`
