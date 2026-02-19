# Enhancement Roadmap: Features from Original BMAD-METHOD

**Date**: 2026-02-19
**Source**: https://github.com/bmad-code-org/BMAD-METHOD
**Status**: Proposal for v1.1+ releases

---

## Overview

This document outlines features from the original BMAD-METHOD that we can integrate into our Claude Code Agent Teams implementation to enhance functionality and user experience.

---

## Priority 1: Essential Missing Features

### 1. Interactive Help System (`/bmad-help`)

**Current State**: We have `/bmad-status`, `/bmad-next`, `/bmad-gate` commands
**Enhancement**: Add contextual help command

**Implementation**:
```markdown
# New skill: bmad-help.md
When user types /bmad-help:
- Show current phase context
- Suggest next actions based on project state
- Allow follow-up questions: "What do I do after architecture?"
- Provide workflow guidance
```

**Value**: Users can ask "what next?" at any time without reading full docs

---

### 2. Quick Flow Workflows (Lightweight Projects)

**Current State**: Full 8-phase workflow only
**Enhancement**: Add fast-track workflows for simple projects

**Implementation**:
```bash
# New commands:
/bmad-quick-spec — Quick specification (PRD + Architecture in one step)
/bmad-quick-dev — Quick development (Solo dev agent handles all tracks)

# New agent:
.claude/agents/quick-flow-solo-dev.md
  - Combines Frontend + Backend + Database roles
  - Minimal documentation overhead
  - For MVPs, prototypes, small features
```

**Value**: 80% faster for small projects (< 5 stories)

---

### 3. Adaptive Complexity Scaling

**Current State**: Same workflow depth for all projects
**Enhancement**: Auto-adjust planning depth based on project size

**Implementation**:
```javascript
// In bmad-init or orchestrator
function determineComplexity(productBrief) {
  const signals = {
    userCount: productBrief.includes("million users") ? 3 : 1,
    integrations: (productBrief.match(/integrate|API|third-party/gi) || []).length,
    features: (productBrief.match(/feature|module|system/gi) || []).length
  };

  if (signals.features < 5 && signals.integrations < 2) return "SIMPLE";
  if (signals.features < 15) return "MEDIUM";
  return "COMPLEX";
}

// Use to determine:
// SIMPLE → Quick Flow (2 phases: spec + dev)
// MEDIUM → Standard Flow (8 phases)
// COMPLEX → Enterprise Flow (+ research, tech writer, formal reviews)
```

**Value**: Don't over-engineer simple projects, don't under-plan complex ones

---

### 4. Mid-Project Course Correction (`/bmad-correct-course`)

**Current State**: Once started, workflow is linear
**Enhancement**: Allow users to pivot mid-project

**Implementation**:
```markdown
# New skill: bmad-correct-course.md
When invoked:
1. Read current project state (docs/project-tracker.md)
2. Ask: "What changed?" (new requirements, scope reduction, pivot)
3. Analyze impact on existing stories/epics
4. Generate impact report
5. Propose options:
   - Update PRD and re-plan affected stories
   - Create new epic for pivot
   - Deprecate stories, mark as "Won't Do"
6. Re-run affected phases (e.g., re-architect, re-sprint-plan)
```

**Value**: Real projects change — support agile adaptation

---

### 5. Tech Writer Agent

**Current State**: No dedicated documentation agent
**Enhancement**: Add Tech Writer for user-facing docs

**Implementation**:
```markdown
# New agent: .claude/agents/tech-writer.md
Role: Creates end-user documentation (README, API docs, user guides)

Workflow:
- Phase 2: Create initial README from product-brief
- Phase 6 (after QA): Write user guides, API reference
- Phase 8: Generate deployment docs, troubleshooting guides

Documents Created:
- README.md (user-facing)
- docs/api-reference.md
- docs/user-guide.md
- docs/troubleshooting.md
```

**Value**: Professional documentation without developer overhead

---

## Priority 2: Research & Discovery Enhancements

### 6. Research Modules (Phase 1)

**Current State**: Business Analyst creates product brief from user input
**Enhancement**: Add research capabilities

**Implementation**:
```markdown
# Extend Business Analyst agent with research workflows:

/bmad-research-market
  - WebSearch for competitor analysis
  - Identify market trends
  - Find existing solutions (learn from them)

/bmad-research-domain
  - WebSearch for domain terminology
  - Understand industry standards (e.g., HIPAA for healthcare)
  - Find domain-specific libraries/tools

/bmad-research-technical
  - WebSearch for tech stack options
  - Compare frameworks (React vs Vue, Postgres vs MySQL)
  - Find best practices, anti-patterns
```

**Value**: Data-driven product brief instead of assumptions

---

### 7. Generate Project Context (`/bmad-context`)

**Current State**: Context is implicit in docs/
**Enhancement**: Generate structured context for AI assistants

**Implementation**:
```markdown
# New skill: bmad-context.md
Output: docs/PROJECT-CONTEXT.md

Contains:
- Tech stack summary
- Key architecture decisions (from ADRs)
- Naming conventions (from naming-registry.md)
- Current sprint status
- Active branches
- Environment setup instructions

Use Case:
- Onboarding new developers
- Resuming after context loss
- Sharing with external AI assistants
```

**Value**: One file explains entire project state

---

## Priority 3: Quality & Validation

### 8. Formal Code Review Workflow

**Current State**: Tech Lead does final review (Phase 8)
**Enhancement**: Add per-story code reviews

**Implementation**:
```markdown
# New workflow: After dev completes story
1. Developer marks story "Ready for Review"
2. /bmad-code-review invokes Tech Lead agent
3. Tech Lead reviews:
   - All commits in story
   - Naming registry compliance
   - Security checklist
   - Test coverage
   - Architecture alignment
4. Tech Lead comments in story file:
   - ✅ Approved OR
   - ⚠️ Changes Requested (with specific feedback)
5. If changes requested, dev fixes and re-submits
```

**Value**: Catch issues early, not at final review

---

### 9. Document Validation Workflow

**Current State**: No formal doc validation
**Enhancement**: Validate documents against standards

**Implementation**:
```markdown
# New skill: bmad-validate-doc.md

/bmad-validate-doc docs/prd.md
  Checks:
  - All PRD sections present
  - Each feature has acceptance criteria
  - No ambiguous language ("might", "could", "maybe")
  - Personas are concrete (not generic)

/bmad-validate-doc docs/architecture.md
  Checks:
  - Tech stack table complete
  - All ADRs referenced
  - Security section present
  - Performance targets quantified (not "fast")

/bmad-validate-doc docs/stories/STORY-NNN.md
  Checks:
  - User story format correct
  - Acceptance criteria testable
  - Dependencies valid (referenced stories exist)
  - Tasks are atomic (1 commit each)
```

**Value**: Document quality gates prevent downstream issues

---

## Priority 4: Developer Experience

### 10. Mermaid Diagram Generation

**Current State**: ASCII diagrams in architecture.md
**Enhancement**: Generate Mermaid diagrams

**Implementation**:
```markdown
# New skill: bmad-mermaid.md

/bmad-mermaid architecture
  Generates:
  - System architecture diagram (C4 model)
  - Database ERD
  - API flow diagrams

/bmad-mermaid workflow
  Generates:
  - User flow diagrams from ux-wireframes.md
  - Sprint workflow visualization
  - Git branching strategy diagram

Output: docs/diagrams/*.mmd files
```

**Value**: Visual diagrams improve comprehension

---

### 11. Explain Concept Workflow

**Current State**: No concept explanation capability
**Enhancement**: Add on-demand explanations

**Implementation**:
```markdown
# New skill: bmad-explain.md

/bmad-explain "dependency injection"
  - Provides simple explanation
  - Shows code example from project
  - Links to architecture.md if relevant

/bmad-explain "why we use Zod for validation"
  - Reads ADRs for context
  - Explains decision rationale
  - Shows usage example from codebase
```

**Value**: Self-documenting project for new team members

---

## Priority 5: Documentation System

### 12. Diátaxis Documentation Framework

**Current State**: Flat docs/ structure
**Enhancement**: Organize docs by user intent

**Implementation**:
```bash
docs/
├── tutorials/          # Learning-oriented
│   ├── getting-started.md
│   ├── first-feature.md
│   └── deploying.md
├── how-to/            # Task-oriented
│   ├── add-new-agent.md
│   ├── customize-workflow.md
│   └── integrate-mcp.md
├── reference/         # Information-oriented
│   ├── api-reference.md
│   ├── agent-reference.md
│   └── command-reference.md
└── explanation/       # Understanding-oriented
    ├── why-bmad.md
    ├── architecture-decisions.md
    └── workflow-philosophy.md
```

**Value**: Users find docs faster based on their need

---

## Priority 6: Modularity & Extensions

### 13. Plugin/Module System

**Current State**: Monolithic agent system
**Enhancement**: Pluggable modules

**Implementation**:
```yaml
# package.json extensions
{
  "name": "@bmad-code/agent-teams",
  "peerDependencies": {
    "@bmad-code/test-architect": "^1.0.0",  # Optional module
    "@bmad-code/game-dev-studio": "^1.0.0", # Optional module
    "@bmad-code/creative-suite": "^1.0.0"   # Optional module
  }
}

# Module registration: bmad-modules.yaml
modules:
  - name: test-architect
    agents: [test-architect]
    skills: [test-generation, coverage-analysis]
    phase: 6
    enabled: false

  - name: game-dev-studio
    agents: [game-designer, level-designer]
    skills: [unity, unreal, godot]
    phase: 5
    enabled: false
```

**Value**: Users install only what they need

---

## Implementation Priority Matrix

| Feature | Impact | Effort | Priority | Target Version |
|---------|--------|--------|----------|----------------|
| Interactive Help System | High | Medium | P1 | v1.1 |
| Quick Flow Workflows | High | Medium | P1 | v1.1 |
| Tech Writer Agent | Medium | Low | P1 | v1.1 |
| Adaptive Complexity Scaling | High | High | P2 | v1.2 |
| Course Correction | High | High | P2 | v1.2 |
| Research Modules | Medium | Medium | P2 | v1.2 |
| Code Review Workflow | High | Medium | P2 | v1.2 |
| Document Validation | Medium | Low | P3 | v1.3 |
| Mermaid Diagrams | Low | Low | P3 | v1.3 |
| Project Context | Medium | Low | P3 | v1.3 |
| Explain Concept | Low | Low | P4 | v1.4 |
| Diátaxis Docs | Medium | High | P4 | v1.4 |
| Module System | High | Very High | P5 | v2.0 |

---

## Next Steps

1. **Review this proposal** with stakeholders
2. **Create GitHub issues** for P1 features
3. **Prototype Quick Flow** first (highest ROI)
4. **Update ROADMAP.md** with approved features
5. **Create feature branches** for parallel development

---

## References

- Original BMAD-METHOD: https://github.com/bmad-code-org/BMAD-METHOD
- BMAD Docs: https://docs.bmad-method.org
- Diátaxis Framework: https://diataxis.fr/
