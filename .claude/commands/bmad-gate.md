# /bmad-gate — Run Quality Gate Check

Evaluate the current phase's output against its quality criteria. Report pass/fail with specific scores.

## Gate Definitions

### Phase 1 Gate: Product Brief Completeness
Check `docs/product-brief.md` for required sections:

```
Score each 0-10:
[ ] Problem Statement — Is it specific? (not "users need a better tool")
[ ] Target Users — At least 1 persona with pain points?
[ ] Proposed Solution — Clear description of what we're building?
[ ] Success Metrics — SMART metrics with targets?
[ ] MVP Scope — 3-7 features, clearly bounded?
[ ] Constraints — Technical, business, timeline defined?
[ ] Risks — At least 2 risks with mitigations?
[ ] Competitive Landscape — At least 2 alternatives analyzed?

PASS: All sections present and scored ≥ 6/10 each
TOTAL: [score]/80 — PASS requires ≥ 60/80 (75%)
```

### Phase 2 Gate: PRD + UX Quality
Check `docs/prd.md` and `docs/ux-wireframes.md`:

```
PRD Checks:
[ ] Every feature has ≥ 3 acceptance criteria
[ ] Acceptance criteria are testable (not vague)
[ ] Feature dependencies mapped
[ ] Non-functional requirements have numeric targets
[ ] No undefined references

UX Checks:
[ ] Information architecture covers all PRD features
[ ] User flows include happy path + error states
[ ] Screen specs exist for each feature
[ ] Responsive behavior defined
[ ] Accessibility requirements specified

PASS: All checks satisfied
```

### Phase 3 Gate: Solutioning Gate Check (Critical!)
Check `docs/architecture.md`:

```
Score each dimension 0-10, with weights:

| # | Dimension | Weight | Score | Weighted |
|---|-----------|--------|-------|----------|
| 1 | All PRD features have technical approach | 3x | [?] | [?] |
| 2 | Data model covers all entities | 2x | [?] | [?] |
| 3 | API endpoints cover all features | 2x | [?] | [?] |
| 4 | Security model defined | 2x | [?] | [?] |
| 5 | Testing strategy concrete | 1x | [?] | [?] |
| 6 | Performance targets set | 1x | [?] | [?] |
| 7 | Deployment approach defined | 1x | [?] | [?] |
| 8 | Error handling standardized | 1x | [?] | [?] |
| 9 | Tech choices have ADR rationale | 1x | [?] | [?] |
| 10 | Project structure clear | 1x | [?] | [?] |

MAX SCORE: 150 (sum of weights × 10)
PASS THRESHOLD: 135/150 (90%)

⚠️ If score < 135: FAIL
  → Identify the lowest-scoring dimensions
  → Re-spawn Architect with: "The architecture scored [X]/150.
     These areas need improvement: [list]. Please update docs/architecture.md."
```

### Phase 4 Gate: Story Quality
Check `docs/sprint-plan.md` and `docs/stories/STORY-*.md`:

```
Per-Story Checks:
[ ] Has user story format (As a... I want... so that...)
[ ] Has ≥ 3 acceptance criteria
[ ] Has story points (1-8 range)
[ ] Has track assignment (Frontend/Backend/Database)
[ ] Has dependency mapping
[ ] Has file paths to create/modify
[ ] Has test requirements

Sprint Plan Checks:
[ ] Dependency graph is acyclic (no circular deps)
[ ] Each track has at least 1 story
[ ] Total points are reasonable (15-40 for Sprint 1)

PASS: All stories pass all checks, sprint plan is valid
```

### Phase 5 Gate: Implementation Completeness
Check `docs/stories/STORY-*.md` status and `src/` + `tests/`:

```
[ ] All story files have status "Done"
[ ] Source files exist for all stories' "Files to Create" lists
[ ] Test files exist for each story's test requirements
[ ] No TypeScript/lint errors (run: npx tsc --noEmit && npx eslint src/)
[ ] All tests pass (run: npm test)

PASS: All stories done + all tests pass + no build errors
```

### Phase 6 Gate: QA Sign-off
Check `docs/test-plan.md`:

```
[ ] All P0 feature acceptance criteria verified
[ ] Zero Critical severity bugs
[ ] Zero High severity bugs
[ ] Test coverage ≥ 80% (unit tests)
[ ] Security checks passed
[ ] Accessibility audit passed

PASS: QA sign-off is "PASS" (not "FAIL")
```

### Phase 7 Gate: Deployment Readiness
Check `docs/deploy-config.md` and config files:

```
[ ] CI/CD pipeline configuration exists
[ ] Environment variables documented
[ ] .env.example file exists
[ ] Health check endpoints specified
[ ] Rollback procedure documented

PASS: All deployment artifacts present
```

### Phase 8 Gate: Tech Lead Verdict
Check `docs/review-checklist.md`:

```
[ ] Verdict is "SHIP" or "SHIP WITH NOTES"

If "DO NOT SHIP":
  → Read action items from the review
  → Re-spawn the relevant agents to address issues
  → Re-run Tech Lead review after fixes
```

## Output Format

Display the gate results as a clear pass/fail report:

```
═══════════════════════════════════════
  Quality Gate: Phase [N] — [Name]
═══════════════════════════════════════

[Detailed scores/checks]

Result: ✅ PASS (score/max) — Ready for Phase [N+1]
  -OR-
Result: ❌ FAIL (score/max) — Gaps identified:
  1. [Gap description]
  2. [Gap description]
  
  Recommendation: Re-run Phase [N] with focus on [gaps].
═══════════════════════════════════════
```
