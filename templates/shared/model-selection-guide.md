# Model Selection Guide (Shared Template)

**Purpose**: Choose the right model for the task to optimize cost and performance

## Model Comparison

| Model | Cost (Input/Output per M tokens) | Speed | Use Case |
|-------|----------------------------------|-------|----------|
| **Haiku** | $0.25 / $1.25 | Fast | Simple, formulaic tasks |
| **Sonnet** | $3 / $15 | Balanced | Complex reasoning, code generation |
| **Opus** | $15 / $75 | Powerful | Critical decisions, architecture |

## Agent Model Matrix

### Use Haiku (Fast & Cheap)

**Agents**:
- ✅ **Story Writer** - Formulaic story creation from epic template
- ✅ **Tech Writer** - Template-based documentation
- ✅ **Document Validator** - Rule-based validation (future)
- ✅ **Diagram Generator** - Structured diagram generation (future)

**Tasks**:
- Template filling (stories, docs)
- Syntax generation (Mermaid diagrams)
- Simple text processing
- Validation against rules

**Cost Savings**: 92% vs Sonnet

---

### Use Sonnet (Balanced - Default)

**Agents**:
- ✅ **Business Analyst** - Complex analysis of vague user input
- ✅ **Product Manager** - PRD with personas, features, ACs
- ✅ **UX Designer** - Wireframes, user flows
- ✅ **Scrum Master** - Epic/story planning
- ✅ **Database Engineer** - Schema design, indexes
- ✅ **Backend Developer** - API design, business logic
- ✅ **Frontend Developer** - UI components, state management
- ✅ **Mobile Developer** - Platform-specific code
- ✅ **QA Engineer** - Test planning, coverage analysis
- ✅ **DevOps Engineer** - CI/CD, deployment configs
- ✅ **Tech Lead** - Code review, quality assessment

**Tasks**:
- Code generation
- Complex reasoning
- Multi-step workflows
- Design decisions

---

### Use Opus (Powerful - Critical Only)

**Agents**:
- ✅ **System Architect** - Critical tech decisions, ADRs, system design

**Tasks**:
- Architecture decisions (tech stack, patterns)
- ADR creation (long-term impact)
- Security architecture
- Performance architecture
- System boundary definitions

**Cost**: 5x Sonnet, 60x Haiku - use sparingly

---

## Decision Tree

```
Is this task critical to project success? (Architecture, tech stack)
  YES → Use Opus
  NO ↓

Does this task require complex reasoning or code generation?
  YES → Use Sonnet
  NO ↓

Is this task formulaic or template-based?
  YES → Use Haiku
  NO → Use Sonnet (safe default)
```

## Implementation

### Agent Frontmatter

```yaml
---
name: Story Writer
description: Creates stories from epics
model: haiku  # ← Add this
---
```

```yaml
---
name: System Architect
description: Designs technical architecture
model: opus  # ← Critical decisions
---
```

```yaml
---
name: Backend Developer
description: Implements backend stories
model: sonnet  # ← Default (complex code)
---
```

## Projected Savings

### Before Optimization
```
4 Story Writers (Sonnet): 260k tokens × $3/M = $0.78
1 Tech Writer (Sonnet): 30k tokens × $3/M = $0.09
Total: $0.87
```

### After Optimization
```
4 Story Writers (Haiku): 260k tokens × $0.25/M = $0.065
1 Tech Writer (Haiku): 30k tokens × $0.25/M = $0.0075
Total: $0.0725

Savings: $0.80 (92% reduction on these agents)
```

## When to Override

Allow users to override model selection:
```bash
# Force Sonnet for story writing (if Haiku quality insufficient)
STORY_WRITER_MODEL=sonnet bmad-sprint

# Force Haiku for everything (maximum cost savings, may reduce quality)
FORCE_HAIKU=true bmad-sprint
```

## Quality Monitoring

After deploying Haiku for Story Writer and Tech Writer:
1. Monitor output quality
2. Compare stories: Haiku vs Sonnet
3. If quality drops → revert to Sonnet
4. If quality acceptable → keep Haiku (92% savings!)

**Hypothesis**: Story Writer and Tech Writer are formulaic enough for Haiku
**Test**: Deploy and monitor for 5-10 projects
