# Comparison: Our Implementation vs Original BMAD-METHOD

**Date**: 2026-02-19
**Our Repo**: https://github.com/simokiran/bmad-agent-teams
**Original**: https://github.com/bmad-code-org/BMAD-METHOD

---

## What We Have That Original BMAD-METHOD Doesn't

### ✅ Advanced Features (Our Advantages)

| Feature | Our Implementation | Original BMAD |
|---------|-------------------|---------------|
| **Naming Registry System** | ✅ Unified naming across DB/API/Types/Frontend/Mobile with cross-reference mapping | ❌ No centralized naming system |
| **Mobile Development** | ✅ Dedicated Mobile Developer agent (React Native, Flutter, SwiftUI, Kotlin) | ❌ Not explicitly supported |
| **Claude Code Skills Integration** | ✅ All agents skill-aware, Architect uses WebSearch to find skills | ❌ No skills integration documented |
| **Git Task Tracking** | ✅ Every task = 1 commit, SHA tracked in story file, auto-push on completion | ⚠️ Git support exists but less granular |
| **Parallel Developer Coordination** | ✅ 4 developers work in parallel (DB → Backend → Frontend + Mobile) with naming registry preventing conflicts | ⚠️ Less emphasis on parallel work |
| **Story-Level Git Management** | ✅ Each story = atomic unit with commit log, SHA table, git summary | ⚠️ Not as detailed |
| **NPM Package Structure** | ✅ Installable via `npx @bmad-code/agent-teams install` | ✅ Installable via `npx bmad-method install` |
| **Template System** | ✅ Rich templates for all docs (naming-registry, skills-required, stories, epics) | ✅ Has templates |

---

## What Original BMAD-METHOD Has That We Don't

### ❌ Missing Features (Opportunities for Enhancement)

| Feature | Original BMAD | Our Implementation | Priority |
|---------|---------------|-------------------|----------|
| **Interactive Help System** | ✅ `/bmad-help` with contextual guidance | ❌ Missing | **P1 - High** |
| **Quick Flow Workflows** | ✅ `/quick-spec`, `/quick-dev` for simple projects | ❌ Full workflow only | **P1 - High** |
| **Adaptive Complexity Scaling** | ✅ Auto-adjusts planning depth by project size | ❌ Same depth for all | **P1 - High** |
| **Course Correction** | ✅ Mid-project pivot support | ❌ Linear workflow | **P2 - Medium** |
| **Research Modules** | ✅ Market/Domain/Technical research in Phase 1 | ❌ No research phase | **P2 - Medium** |
| **Tech Writer Agent** | ✅ Dedicated documentation agent | ❌ No tech writer | **P1 - High** |
| **Code Review Workflow** | ✅ Per-story code reviews | ⚠️ Only final review | **P2 - Medium** |
| **Document Validation** | ✅ Validate docs against standards | ❌ No validation | **P3 - Low** |
| **Mermaid Diagrams** | ✅ Visual diagram generation | ❌ ASCII only | **P3 - Low** |
| **Project Context Generation** | ✅ Generate context summary | ❌ No context gen | **P3 - Low** |
| **Explain Concept** | ✅ On-demand explanations | ❌ No explain feature | **P4 - Low** |
| **Diátaxis Documentation** | ✅ Organized docs (tutorials/how-to/reference/explanation) | ⚠️ Flat structure | **P4 - Low** |
| **Module System** | ✅ Pluggable modules (Test Architect, Game Dev Studio) | ❌ Monolithic | **P5 - Future** |
| **Party Mode** | ✅ Multiple agents in one session | ⚠️ Agents work sequentially | **P5 - Future** |

---

## Side-by-Side Workflow Comparison

### Phase Structure

| Phase | Original BMAD-METHOD | Our Implementation |
|-------|---------------------|-------------------|
| **Phase 1** | Analysis (Analyst agent) | Discovery (Business Analyst) |
| | - Market Research | - Product Brief creation |
| | - Domain Research | |
| | - Technical Research | |
| **Phase 2** | Planning | Planning (Parallel) |
| | - PM creates PRD | - PM creates PRD |
| | - UX creates wireframes | - UX creates wireframes |
| **Phase 3** | Solutioning | Architecture |
| | - Architect creates tech spec | - Architect creates architecture.md |
| | - Architect writes ADRs | - Architect writes ADRs |
| | | **+ Creates naming-registry.md** |
| | | **+ Creates skills-required.md** |
| **Phase 4** | Sprint Planning | Sprint Planning |
| | - Scrum Master creates sprint plan | - Scrum Master creates epics |
| | | **+ Story Writers (parallel per epic)** |
| **Phase 5** | Implementation | Implementation (Parallel) |
| | - Dev agent implements | - **4 agents in parallel:** |
| | | - Database Engineer |
| | | - Backend Developer |
| | | - Frontend Developer |
| | | **- Mobile Developer** |
| | | **+ Skills-aware (invoke /wordpress, /react, etc.)** |
| | | **+ Git SHA tracking per task** |
| **Phase 6** | QA | QA |
| | - QA agent tests | - QA Engineer validates |
| | - Automated test generation | - Test plan creation |
| **Phase 7** | Deployment | Deployment |
| | - DevOps setup | - DevOps Engineer creates config |
| **Phase 8** | Review | Review |
| | - Final review | - Tech Lead final review |

---

## Agent Comparison

| Role | Original BMAD | Our Implementation | Notes |
|------|---------------|-------------------|-------|
| Business Analyst | ✅ `analyst.agent.yaml` | ✅ `business-analyst.md` | Similar |
| Product Manager | ✅ `pm.agent.yaml` | ✅ `product-manager.md` | Similar |
| UX Designer | ✅ `ux-designer.agent.yaml` | ✅ `ux-designer.md` | Similar |
| System Architect | ✅ `architect.agent.yaml` | ✅ `architect.md` | **Ours adds naming registry + skills discovery** |
| Scrum Master | ✅ `sm.agent.yaml` | ✅ `scrum-master.md` | Similar |
| Developer | ✅ `dev.agent.yaml` (single) | ✅ **4 specialized developers:** | **We split by track** |
| | | - `backend-developer.md` | |
| | | - `frontend-developer.md` | |
| | | - `database-engineer.md` | |
| | | **- `mobile-developer.md`** | **Our addition** |
| QA Engineer | ✅ `qa.agent.yaml` | ✅ `qa-engineer.md` | Similar |
| DevOps Engineer | ❌ (part of dev) | ✅ `devops-engineer.md` | **Our addition** |
| Tech Writer | ✅ `tech-writer` subdirectory | ❌ **Missing** | **Should add** |
| Tech Lead | ❌ | ✅ `tech-lead.md` | **Our addition** |
| Quick Flow Solo Dev | ✅ `quick-flow-solo-dev.agent.yaml` | ❌ **Missing** | **Should add** |

**Total Agents:**
- Original: 8 core agents + quick-flow variant
- Ours: **13 agents** (more specialized)

---

## Skill/Command Comparison

### Our Commands

```bash
/bmad-init         # Initialize project structure
/bmad-status       # Show current phase
/bmad-next         # Advance to next phase
/bmad-gate         # Run quality gate
/bmad-sprint       # Execute sprint
/bmad-track        # Show tracker dashboard
/bmad-review       # Final review
/bmad-help         # Help & guidance
```

### Original BMAD Commands (Not in Our Implementation)

```bash
# Quick Flows
/quick-spec        # Fast specification
/quick-dev         # Fast development

# Research
/market-research   # Market analysis
/domain-research   # Domain analysis
/technical-research # Tech analysis

# Utilities
/correct-course    # Mid-project pivot
/generate-context  # Project context
/mermaid-generate  # Diagram generation
/explain-concept   # Concept explanation
/validate-document # Doc validation
/code-review       # Per-story review
/write-document    # Write docs
```

---

## Documentation Structure Comparison

### Original BMAD (Diátaxis Framework)

```
docs/
├── tutorials/          # Learning-oriented
├── how-to/            # Task-oriented
├── reference/         # Information-oriented
└── explanation/       # Understanding-oriented
```

### Our Implementation

```
docs/
├── product-brief.md
├── prd.md
├── architecture.md
├── naming-registry.md      # Our innovation
├── skills-required.md      # Our innovation
├── sprint-plan.md
├── project-tracker.md      # Our innovation
├── test-plan.md
├── deploy-config.md
├── review-checklist.md
├── epics/
├── stories/
└── adrs/
```

**Difference**: Ours is workflow-centric, theirs is user-intent-centric

---

## Strengths & Weaknesses

### Our Strengths 💪

1. **More specialized agents** (13 vs 8) = Better separation of concerns
2. **Naming Registry** = No conflicts between DB/API/Frontend/Mobile
3. **Skills Integration** = Leverage WordPress, React, PostgreSQL expertise
4. **Mobile Development** = First-class citizen
5. **Git SHA Tracking** = Granular audit trail per task
6. **Parallel Coordination** = 4 developers work simultaneously

### Our Weaknesses 😓

1. **No Quick Flow** = Overkill for simple projects
2. **No Research Phase** = Product brief based on user input only
3. **No Tech Writer** = Missing user-facing documentation
4. **No Course Correction** = Can't pivot mid-project
5. **No Document Validation** = Quality depends on agent discipline
6. **No Module System** = Monolithic (not extensible)

### Original BMAD Strengths 💪

1. **Adaptive Workflows** = Quick Flow for simple, full flow for complex
2. **Research-Driven** = Data-backed product brief
3. **Interactive Help** = Users can ask "what next?"
4. **Course Correction** = Supports agile pivots
5. **Modular Extensions** = Test Architect, Game Dev Studio plugins
6. **Diátaxis Docs** = Better organized for different user needs

### Original BMAD Weaknesses 😓

1. **No Naming Registry** = Potential naming conflicts
2. **No Mobile Agent** = Mobile not first-class
3. **Single Dev Agent** = Less parallelization
4. **No Skills Integration** = Doesn't leverage Claude Code skills
5. **Less Git Granularity** = No per-task SHA tracking

---

## Recommendations

### Short-Term (v1.1 - Next 2 Months)

1. ✅ **Add `/bmad-help` skill** (high ROI, low effort)
2. ✅ **Add Tech Writer agent** (fill critical gap)
3. ✅ **Add Quick Flow workflows** (`/quick-spec`, `/quick-dev`)
4. ✅ **Add Research modules** to Business Analyst

### Medium-Term (v1.2 - 3-6 Months)

1. ✅ **Adaptive Complexity Scaling** (auto-detect project size)
2. ✅ **Course Correction** workflow (`/bmad-correct-course`)
3. ✅ **Code Review** per story (not just final)
4. ✅ **Document Validation** gates

### Long-Term (v2.0 - 6-12 Months)

1. ✅ **Module System** for extensions
2. ✅ **Party Mode** (multi-agent collaboration)
3. ✅ **Diátaxis Documentation** restructure
4. ✅ **Mermaid Diagrams** generation

---

## Conclusion

**Our implementation excels at:**
- Parallel coordination with naming consistency
- Mobile development
- Skills integration
- Granular git tracking

**Original BMAD excels at:**
- Workflow flexibility (quick flows, adaptive complexity)
- Research-driven planning
- Interactive guidance
- Modularity

**Best of both worlds**: Merge our innovations (naming registry, skills, mobile, parallel coordination) with their flexibility features (quick flows, research, help system, course correction).

**Next Action**: Implement P1 features from ENHANCEMENT-ROADMAP.md

---

## References

- Our Implementation: https://github.com/simokiran/bmad-agent-teams
- Original BMAD-METHOD: https://github.com/bmad-code-org/BMAD-METHOD
- BMAD Docs: https://docs.bmad-method.org
- Enhancement Roadmap: [ENHANCEMENT-ROADMAP.md](./ENHANCEMENT-ROADMAP.md)
