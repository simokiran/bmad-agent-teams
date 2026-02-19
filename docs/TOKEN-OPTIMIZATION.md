# Token Optimization Strategy: Reducing BMAD Method Token Consumption

**Date**: 2026-02-19
**Problem**: BMAD Method can consume excessive tokens (100k-500k+ per project)
**Goal**: Reduce token usage by 50-70% without sacrificing quality

---

## Current Token Consumption Analysis

### Typical Project (Medium Complexity)

```
Phase 1: Business Analyst
  Input:  5k tokens (user input + agent instructions)
  Output: 10k tokens (product-brief.md)
  Total:  15k tokens

Phase 2: PM + UX (Parallel)
  PM Input:    8k tokens (product-brief + agent instructions)
  PM Output:   20k tokens (PRD)
  UX Input:    8k tokens (product-brief + agent instructions)
  UX Output:   15k tokens (wireframes)
  Total:       51k tokens

Phase 3: Architect
  Input:  30k tokens (PRD + wireframes + agent instructions)
  Output: 25k tokens (architecture.md + ADRs + naming-registry)
  Total:  55k tokens

Phase 4: Scrum Master + Story Writers
  SM Input:   40k tokens (PRD + architecture + agent instructions)
  SM Output:  15k tokens (epics + sprint-plan)
  Story Writers (4 agents in parallel):
    Input per agent:  45k tokens (PRD + arch + epic + instructions)
    Output per agent: 20k tokens (5-10 stories)
    Total: 4 × 65k = 260k tokens
  Total: 275k tokens

Phase 5: 4 Developers
  Database Engineer:
    Input:  50k tokens (all docs + stories + instructions)
    Output: 30k tokens (migrations + code + updates)
  Backend Developer:
    Input:  60k tokens (all docs + DB context + stories)
    Output: 40k tokens (API code + updates)
  Frontend Developer:
    Input:  70k tokens (all docs + API context + stories)
    Output: 40k tokens (UI code + updates)
  Mobile Developer:
    Input:  70k tokens (all docs + API context + stories)
    Output: 40k tokens (mobile code + updates)
  Total: 400k tokens

Phases 6-8: QA + DevOps + Tech Lead
  Total: ~50k tokens

GRAND TOTAL: ~846k tokens per project
At $3/million input + $15/million output: ~$8-10 per project
```

### Problem Areas (Token Hotspots)

1. **Phase 4 Story Writers** (260k tokens) - 31% of total
   - Each agent re-reads PRD + architecture + all docs
   - Redundant context across 4 agents

2. **Phase 5 Developers** (400k tokens) - 47% of total
   - Each agent re-reads all docs, stories, naming registry
   - Massive context duplication

3. **Verbose Agent Instructions** (~100k tokens total)
   - Agent .md files are 150-300 lines each
   - Repeated patterns, examples, checklists

4. **Document Accumulation**
   - Later agents read ALL previous outputs
   - Architect reads PRD + wireframes
   - Developers read PRD + wireframes + architecture + epics + stories

---

## Token Optimization Strategies

### Strategy 1: Lazy Context Loading (50% Reduction)

**Problem**: Agents load ALL docs upfront

**Solution**: Agents request ONLY needed docs via Tool calls

#### Current (Wasteful)
```markdown
# Agent prompt
Read these files:
- docs/product-brief.md
- docs/prd.md
- docs/ux-wireframes.md
- docs/architecture.md
- docs/naming-registry.md
- docs/sprint-plan.md
- docs/epics/EPIC-001.md
- docs/epics/EPIC-002.md
- docs/stories/STORY-001.md
- docs/stories/STORY-002.md
...

Total input: 70k tokens
```

#### Optimized (Lazy Loading)
```markdown
# Agent prompt (lean)
You are Frontend Developer. Implement STORY-005.

Use Read tool to access:
- Story file: docs/stories/STORY-005.md (REQUIRED)
- Naming registry: docs/naming-registry.md (REQUIRED)
- Architecture: docs/architecture.md (IF NEEDED for tech decisions)
- PRD: docs/prd.md (IF NEEDED for acceptance criteria clarification)

Only read what you need. Start with the story file.

Total input: 5k tokens (instructions only)
Agent reads: 15k tokens (story + naming registry)
Total: 20k tokens vs 70k = 71% reduction
```

**Implementation**:
```markdown
# Update all developer agents
Remove: "Input: Read all files..."
Add: "Use Read tool to load files as needed. Start with your assigned story."
```

---

### Strategy 2: Model Selection (30% Cost Reduction)

**Problem**: Using Sonnet for all agents (even simple tasks)

**Solution**: Smart model selection per agent

```yaml
# Agent frontmatter with model hints
---
name: Database Engineer
model: sonnet  # Complex schema design
---

---
name: Tech Writer
model: haiku  # Simple documentation writing
---

---
name: Story Writer
model: haiku  # Formulaic story creation
---

---
name: QA Engineer
model: sonnet  # Complex test planning
---
```

**Cost Comparison** (Claude 3.5 pricing):
```
Haiku:   $0.25/M input,  $1.25/M output
Sonnet:  $3/M input,     $15/M output
Opus:    $15/M input,    $75/M output

Story Writer (4 agents):
  Current (Sonnet): 260k tokens × $3/M = $0.78
  Optimized (Haiku): 260k tokens × $0.25/M = $0.065
  Savings: 92% per story writer phase

Tech Writer:
  Current (Sonnet): 30k tokens × $3/M = $0.09
  Optimized (Haiku): 30k tokens × $0.25/M = $0.0075
  Savings: 92%
```

**Model Selection Matrix**:

| Agent | Complexity | Model | Reasoning |
|-------|-----------|-------|-----------|
| Business Analyst | High | Sonnet | Requires deep analysis of vague input |
| Product Manager | High | Sonnet | Complex PRD with personas, features |
| UX Designer | Medium | Sonnet | Wireframes need UX expertise |
| System Architect | Very High | Opus | Critical tech decisions, ADRs |
| Scrum Master | Medium | Sonnet | Epic/story planning |
| **Story Writer** | Low | **Haiku** | Formulaic story templates |
| Database Engineer | High | Sonnet | Schema design, indexes |
| Backend Developer | High | Sonnet | API design, business logic |
| Frontend Developer | High | Sonnet | UI components, state management |
| Mobile Developer | High | Sonnet | Platform-specific code |
| **Tech Writer** | Low | **Haiku** | Template-based docs |
| QA Engineer | Medium | Sonnet | Test planning |
| DevOps Engineer | Medium | Sonnet | CI/CD, deployment |
| Tech Lead | High | Sonnet | Code review |

**Potential Savings**: 30-40% cost reduction

---

### Strategy 3: Compact Agent Instructions (20% Reduction)

**Problem**: Agent .md files are verbose (150-300 lines)

**Solution**: Extract common patterns to shared templates

#### Current Agent Structure (Wasteful)
```markdown
# backend-developer.md (280 lines)

## Role
You are a Senior Backend Developer...

## CRITICAL: Naming Registry Protocol
(40 lines of naming instructions — SAME across all agents)

## Workflow Per Story
(50 lines — SAME pattern across all developer agents)

## Git Workflow
(30 lines — SAME across all developer agents)

## Implementation Standards
(80 lines of code examples)

## Story Completion Checklist
(30 lines — SAME across all developer agents)
```

#### Optimized (Shared Templates)
```markdown
# backend-developer.md (80 lines)

## Role
Senior Backend Developer implementing API and business logic stories.

## Includes
@include developer-workflow-template.md
@include naming-registry-protocol.md
@include git-sha-tracking.md

## Backend-Specific Standards
(Only backend-specific content — 50 lines)
```

**Shared Templates**:
```bash
templates/
├── developer-workflow-template.md    # Common workflow (all devs)
├── naming-registry-protocol.md       # Naming rules (all agents)
├── git-sha-tracking.md               # Git workflow (all devs)
└── story-completion-checklist.md     # Common checklist (all devs)
```

**Benefits**:
- 150-line agent file → 80-line file
- 47% reduction in agent instruction tokens
- Easier maintenance (change once, applies to all)

**Estimated Savings**: 15-20k tokens per project

---

### Strategy 4: Document Summaries (40% Reduction)

**Problem**: Later agents re-read ENTIRE PRD/architecture

**Solution**: Create summaries for quick reference

```markdown
# docs/PROJECT-SUMMARY.md (Auto-generated)

## Tech Stack
- Frontend: Next.js 14 + React + Tailwind
- Backend: Next.js API Routes + Zod validation
- Database: PostgreSQL + Prisma
- Mobile: React Native + Expo
- Auth: NextAuth.js

## Key Features (from PRD)
1. User registration/login
2. Dashboard with analytics
3. Resource management (CRUD)
4. Mobile app for on-the-go access

## Critical Naming Conventions
- Database: snake_case (users.email)
- API: camelCase ({ email: "..." })
- Types: PascalCase (interface User)
- Routes: kebab-case (/auth/login)

## Architecture Decisions
- ADR-001: Use NextAuth for auth (vs custom JWT)
- ADR-002: Use Prisma ORM (vs raw SQL)
- ADR-003: Monorepo structure (vs separate repos)
```

**Usage**:
```markdown
# Agent prompt
Quick reference: Read docs/PROJECT-SUMMARY.md first (5k tokens)
For details: Read specific docs as needed (PRD = 20k, Architecture = 25k)

Result:
- Agents get 80% of info from summary (5k tokens)
- Only read full docs when needed (20% of agents)
- Average: 5k + (0.2 × 45k) = 14k tokens vs 45k = 69% reduction
```

---

### Strategy 5: Incremental Story Files (30% Reduction)

**Problem**: Story files accumulate massive context

**Current Story File** (After implementation):
```markdown
# STORY-005.md

## Metadata
(10 lines)

## User Story
(5 lines)

## Acceptance Criteria
(20 lines)

## Tasks
(20 lines)

## Technical Notes
(50 lines — includes code examples)

## Naming Registry References
(40 lines)

## Test Requirements
(15 lines)

## Git Task Tracking
(30 lines)

## Developer Notes
(200 lines — agent adds implementation notes, code snippets, debugging logs)

Total: ~390 lines, 15k tokens
```

**Problem**: Developer adds verbose notes, code snippets

**Solution**: Separate implementation log

```markdown
# STORY-005.md (Lean - 150 lines, 5k tokens)

(Keep only: metadata, user story, ACs, tasks, naming refs, git tracking)

## Implementation
See: docs/stories/STORY-005-implementation.md
```

```markdown
# STORY-005-implementation.md (Verbose logs - archived)

(Developer can be as verbose as needed here)
(Other agents DON'T read this file)
```

**Benefits**:
- Story file stays lean (5k tokens)
- Implementation details in separate file
- Later agents don't re-read implementation notes
- Reduction: 15k → 5k = 67%

---

### Strategy 6: Parallel Agent Context Isolation (Massive Reduction)

**Problem**: All 4 story writers read the SAME PRD + Architecture

**Current (Redundant)**:
```
Story Writer 1: Reads PRD (20k) + Arch (25k) + EPIC-001 (5k) = 50k
Story Writer 2: Reads PRD (20k) + Arch (25k) + EPIC-002 (5k) = 50k
Story Writer 3: Reads PRD (20k) + Arch (25k) + EPIC-003 (5k) = 50k
Story Writer 4: Reads PRD (20k) + Arch (25k) + EPIC-004 (5k) = 50k

Total: 200k tokens of REDUNDANT reads (PRD + Arch read 4 times!)
```

**Optimized (Context Isolation)**:
```
Orchestrator:
  1. Reads PRD + Architecture ONCE (45k tokens)
  2. Extracts epic-specific context for each writer
  3. Passes minimal context to each agent

Story Writer 1 Prompt:
  "Create stories for EPIC-001: User Authentication

  Feature Summary (from PRD):
  - Users can register with email/password
  - Users can log in
  - Password reset flow
  - Email verification

  Tech Constraints (from Architecture):
  - Use NextAuth.js for auth
  - Database: users table (see naming-registry.md Section 1)
  - API: POST /api/auth/register, POST /api/auth/login

  Now read:
  - docs/epics/EPIC-001.md
  - docs/naming-registry.md (Sections 1, 2, 3 only)

  Create 3-5 stories."

Story Writer 1 Input: 10k tokens (mini-context + epic + naming registry)
vs 50k tokens = 80% reduction

Total for 4 writers: 40k vs 200k = 80% reduction!
```

**Implementation**: Orchestrator extracts relevant sections from PRD/Arch per epic

---

### Strategy 7: Streaming Outputs (Reduce Orchestrator Memory)

**Problem**: Orchestrator accumulates all agent outputs in memory

**Current**:
```typescript
const pmOutput = await Task({ subagent_type: "Product Manager", ... });
const uxOutput = await Task({ subagent_type: "UX Designer", ... });
const archOutput = await Task({ subagent_type: "System Architect", ... });

// Orchestrator memory: pmOutput (20k) + uxOutput (15k) + archOutput (25k) = 60k tokens
```

**Optimized**:
```typescript
// Agents write to files, orchestrator doesn't accumulate outputs
await Task({
  subagent_type: "Product Manager",
  prompt: "Create PRD. Write to docs/prd.md. Return only: 'PRD created at docs/prd.md'"
});

// Orchestrator memory: "PRD created at docs/prd.md" (10 tokens)
// 60k → 10 tokens = 99.98% reduction in orchestrator memory
```

**Benefits**:
- Orchestrator stays lean
- Can manage longer workflows
- Reduces risk of context overflow

---

### Strategy 8: Skill Invocation (Reduce Repetitive Tasks)

**Problem**: Agents write formulaic code from scratch

**Solution**: Use Claude Code Skills for boilerplate

```markdown
# Without Skills (Token-Heavy)
Agent reads:
- 50k tokens of context (PRD, arch, naming registry, story)
Agent generates:
- 15k tokens of code (WordPress custom post type with 20 fields)

Total: 65k tokens
```

```markdown
# With Skills (Token-Efficient)
Agent invokes: /wordpress "Create custom post type 'project' with fields: title, description, client_name, start_date"
Skill returns: 5k tokens of scaffolded code

Agent customizes:
- 10k tokens (rename fields per naming registry)

Total: 15k tokens (77% reduction)
```

**Already Implemented**: All our agents are skills-aware (v1.0)

---

## Token Optimization Implementation Plan

### Phase 1: Quick Wins (v1.1.0) — 40% Reduction

1. **Lazy Context Loading**
   - Update all agent prompts: "Use Read tool, don't load all docs upfront"
   - Estimated savings: 200k tokens per project

2. **Model Selection**
   - Story Writer: Sonnet → Haiku
   - Tech Writer: Sonnet → Haiku
   - Estimated savings: 30% cost reduction

3. **Document Summaries**
   - Auto-generate docs/PROJECT-SUMMARY.md after Phase 3
   - Agents read summary first, full docs only if needed
   - Estimated savings: 100k tokens per project

**Total Phase 1 Savings**: 300k tokens (~35% reduction)

---

### Phase 2: Architectural Changes (v1.2.0) — 30% Reduction

4. **Compact Agent Instructions**
   - Extract common patterns to templates/
   - Use @include directives
   - Estimated savings: 15k tokens per project

5. **Incremental Story Files**
   - Separate story spec from implementation log
   - Estimated savings: 80k tokens per project

6. **Parallel Agent Context Isolation**
   - Orchestrator extracts epic-specific context
   - Story writers receive minimal context
   - Estimated savings: 160k tokens per project

**Total Phase 2 Savings**: 255k tokens (~30% reduction)

---

### Phase 3: Advanced Optimizations (v1.3.0) — 15% Reduction

7. **Streaming Outputs**
   - Agents write to files, return short confirmations
   - Orchestrator doesn't accumulate outputs
   - Estimated savings: Context overflow prevention

8. **Compression Techniques**
   - Use abbreviations in internal docs
   - Remove examples from agent instructions (link to examples instead)
   - Estimated savings: 50k tokens per project

**Total Phase 3 Savings**: 50k tokens (~15% reduction)

---

## Projected Results

### Before Optimization
```
Total tokens per project: 846k
Cost at $3/M input + $15/M output: ~$8-10
```

### After All Optimizations
```
Total tokens per project: 241k (71% reduction!)
Cost at optimized rates: ~$2-3 (70% cost reduction)

Breakdown:
- Phase 1: 846k → 546k (35% reduction)
- Phase 2: 546k → 291k (30% reduction)
- Phase 3: 291k → 241k (15% reduction)
```

---

## Monitoring Token Usage

### Add Token Tracking to Orchestrator

```typescript
// Track tokens per phase
let tokenLog = {
  phase1: { input: 0, output: 0 },
  phase2: { input: 0, output: 0 },
  // ...
};

async function trackAgentTokens(phase: string, agentType: string, result: any) {
  // Parse token usage from result
  tokenLog[phase].input += result.usage.input_tokens;
  tokenLog[phase].output += result.usage.output_tokens;

  // Write to docs/token-usage.md
  await updateTokenLog(tokenLog);
}

// Generate report
function generateTokenReport() {
  const total = Object.values(tokenLog).reduce((sum, phase) =>
    sum + phase.input + phase.output, 0
  );

  console.log(`
    Total Tokens: ${total.toLocaleString()}
    Total Cost: $${(total / 1_000_000 * 3).toFixed(2)}

    By Phase:
    ${Object.entries(tokenLog).map(([phase, usage]) =>
      `${phase}: ${(usage.input + usage.output).toLocaleString()} tokens`
    ).join('\n')}
  `);
}
```

---

## Best Practices for Token Efficiency

### For Agent Developers

1. **Use Read tool, don't paste docs** in prompts
2. **Minimize examples** in agent instructions
3. **Extract common patterns** to shared templates
4. **Choose smallest model** that can handle the task
5. **Write outputs to files**, don't return full content

### For Orchestrator

1. **Extract minimal context** for parallel agents
2. **Use background agents** for non-critical tasks
3. **Track token usage** per phase
4. **Monitor hotspots** and optimize

### For Users

1. **Use Quick Flow** for simple projects (< 5 features)
2. **Provide concise input** (avoid pasting entire docs)
3. **Review PROJECT-SUMMARY.md** instead of full docs when possible

---

## Token Efficiency Metrics (Target)

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Tokens per project | 846k | 241k | **71% reduction** |
| Cost per project | $8-10 | $2-3 | **70% reduction** |
| Phase 4 (Story Writers) | 260k | 40k | **85% reduction** |
| Phase 5 (Developers) | 400k | 120k | **70% reduction** |
| Agent instructions | 20k | 5k | **75% reduction** |

---

## Conclusion

By implementing these 8 optimization strategies across 3 phases, we can reduce token consumption by **71%** and costs by **70%**, making the BMAD method significantly more efficient while maintaining quality.

**Priority**: Token optimization should be integrated into v1.1.0+ releases alongside new features.

---

**References:**
- Claude Pricing: https://www.anthropic.com/pricing
- Model Comparison: Haiku (fast, cheap) vs Sonnet (balanced) vs Opus (powerful, expensive)
- Token Counting: https://platform.anthropic.com/docs/models/token-counting
