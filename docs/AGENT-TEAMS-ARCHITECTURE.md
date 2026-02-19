# Agent Teams Architecture: How We Use Claude Code Agent Teams & Subagents

**Date**: 2026-02-19
**Core Principle**: All features leverage Claude Code's agent teams and subagent spawning for parallel execution and context management

---

## Overview: Why Agent Teams Matter

### Traditional Approach (Original BMAD-METHOD)
```
Single Claude session → Sequential execution → Context limits → Manual handoffs
```

### Our Approach (Agent Teams + Subagents)
```
BMad Orchestrator (master agent)
  ├─ Spawns Phase Agents (parallel when possible)
  │   ├─ Business Analyst (subagent)
  │   ├─ Product Manager (subagent) + UX Designer (subagent) — PARALLEL
  │   ├─ System Architect (subagent)
  │   ├─ Scrum Master (subagent)
  │   ├─ Story Writers (4 subagents in parallel) — PARALLEL
  │   ├─ Developers (4 subagents in parallel) — PARALLEL
  │   ├─ QA Engineer (subagent)
  │   ├─ DevOps Engineer (subagent)
  │   └─ Tech Lead (subagent)
  └─ Each subagent has FULL context for their task (no limits!)
```

**Benefits:**
- ✅ **Unlimited context** - Each subagent gets full conversation history for their task
- ✅ **Parallel execution** - Multiple agents work simultaneously (Phase 2, 4b, 5)
- ✅ **Specialized focus** - Each agent is expert in their domain
- ✅ **Master coordination** - Orchestrator manages handoffs and dependencies

---

## Current Implementation: Agent Teams in Action

### Phase 2: PM + UX (Parallel Agent Teams)

```typescript
// Orchestrator spawns 2 agents in parallel
await Promise.all([
  Task({
    subagent_type: "Product Manager",
    prompt: "Read product-brief.md and create comprehensive PRD",
    description: "Create PRD"
  }),
  Task({
    subagent_type: "UX Designer",
    prompt: "Read product-brief.md and create UX wireframes",
    description: "Create wireframes"
  })
]);

// Both agents work simultaneously with full context
// No manual copy-paste between sessions
```

### Phase 4b: Story Writers (Parallel Subagent Spawning)

```typescript
// Orchestrator reads epics
const epics = await readEpics();

// Spawn 1 story writer per epic (PARALLEL)
await Promise.all(
  epics.map(epic =>
    Task({
      subagent_type: "Story Writer",
      prompt: `Create stories for ${epic.title}. Read docs/epics/${epic.id}.md and create all stories.`,
      description: `Write stories for ${epic.title}`,
      run_in_background: true // Parallel execution
    })
  )
);

// If 4 epics → 4 agents writing stories simultaneously
```

### Phase 5: 4 Developers (Parallel Agent Teams with Dependencies)

```typescript
// Database Engineer goes first (no dependencies)
const dbResult = await Task({
  subagent_type: "Database Engineer",
  prompt: "Implement all Database track stories",
  description: "Database implementation"
});

// Backend depends on Database (sequential)
const backendResult = await Task({
  subagent_type: "Backend Developer",
  prompt: "Implement all Backend track stories. Database is ready.",
  description: "Backend implementation"
});

// Frontend + Mobile depend on Backend (PARALLEL)
await Promise.all([
  Task({
    subagent_type: "Frontend Developer",
    prompt: "Implement all Frontend track stories. Backend APIs are ready.",
    description: "Frontend implementation"
  }),
  Task({
    subagent_type: "Mobile Developer",
    prompt: "Implement all Mobile track stories. Backend APIs are ready.",
    description: "Mobile implementation"
  })
]);

// 4 agents, 3 parallel pairs: DB → Backend → (Frontend + Mobile)
```

---

## Enhanced Features: How They Use Agent Teams

### 1. Quick Flow Workflows (Agent Teams)

**WRONG** (Single Agent):
```typescript
// ❌ This defeats the purpose
await Task({
  subagent_type: "Quick Flow Solo Dev",
  prompt: "Do everything: spec, architecture, development, testing, deployment"
});
```

**RIGHT** (Orchestrated Agent Teams):
```typescript
// ✅ Quick Flow = Compressed phases with agent teams

// Quick Spec: PM + Architect in parallel
await Promise.all([
  Task({
    subagent_type: "Product Manager",
    prompt: "Create minimal PRD (3 features max) from product brief",
    description: "Quick PRD"
  }),
  Task({
    subagent_type: "System Architect",
    prompt: "Create lightweight architecture.md (no ADRs for quick flow)",
    description: "Quick Architecture"
  })
]);

// Quick Dev: Single developer BUT orchestrated
await Task({
  subagent_type: "Quick Flow Solo Dev",
  prompt: `You are a full-stack developer handling DB + Backend + Frontend for quick flow.
           Read docs/prd.md and docs/architecture.md.
           Create 1-3 stories max.
           Implement with git SHA tracking.`,
  description: "Quick implementation"
});

// QA + Deploy still use separate agents
await Task({ subagent_type: "QA Engineer", ... });
await Task({ subagent_type: "DevOps Engineer", ... });
```

**Key**: Quick Flow compresses phases, not agents. Still uses agent teams, just fewer stories.

---

### 2. Tech Writer Agent (Subagent Spawning)

```typescript
// Phase 2: Tech Writer runs in parallel with PM + UX
await Promise.all([
  Task({ subagent_type: "Product Manager", ... }),
  Task({ subagent_type: "UX Designer", ... }),
  Task({
    subagent_type: "Tech Writer",
    prompt: "Read product-brief.md and create initial README.md",
    description: "Create README",
    run_in_background: true // Parallel
  })
]);

// Phase 6: Tech Writer refines docs after QA
await Task({
  subagent_type: "Tech Writer",
  prompt: `Read all docs and test-plan.md.
           Create:
           - docs/user-guide.md
           - docs/api-reference.md
           - docs/troubleshooting.md`,
  description: "User documentation"
});
```

**Benefit**: Tech Writer is a proper subagent with full context, not a skill.

---

### 3. Research Modules (Parallel Research Agents)

```typescript
// Phase 1: Business Analyst spawns 3 research agents in parallel
const researchResults = await Promise.all([
  Task({
    subagent_type: "Market Researcher",
    prompt: `Use WebSearch to research:
             - Competitor products
             - Market trends
             - User reviews
             Output: docs/research/market-analysis.md`,
    description: "Market research"
  }),
  Task({
    subagent_type: "Domain Researcher",
    prompt: `Use WebSearch to research:
             - Industry terminology
             - Domain standards (e.g., HIPAA, GDPR)
             - Best practices
             Output: docs/research/domain-analysis.md`,
    description: "Domain research"
  }),
  Task({
    subagent_type: "Technical Researcher",
    prompt: `Use WebSearch to research:
             - Tech stack options
             - Framework comparisons
             - Architecture patterns
             Output: docs/research/tech-analysis.md`,
    description: "Tech research"
  })
]);

// Business Analyst synthesizes results
await Task({
  subagent_type: "Business Analyst",
  prompt: `Read all research docs and user input.
           Create comprehensive product-brief.md with research citations.`,
  description: "Create product brief"
});
```

**Benefit**: 3 specialized researchers work in parallel, not sequential WebSearches.

---

### 4. Adaptive Complexity Scaling (Orchestrator Intelligence)

```typescript
// Orchestrator detects complexity BEFORE spawning agents
async function determineWorkflow(productBrief: string) {
  const complexity = await analyzeComplexity(productBrief);

  if (complexity === "SIMPLE") {
    // Quick Flow: Fewer phases, compressed agent teams
    return executeQuickFlow();
  } else if (complexity === "MEDIUM") {
    // Standard Flow: Current 8-phase workflow
    return executeStandardFlow();
  } else {
    // Enterprise Flow: Add Research agents, more reviews
    return executeEnterpriseFlow();
  }
}

async function executeEnterpriseFlow() {
  // Phase 0: Research (3 agents in parallel)
  await spawnResearchAgents();

  // Phase 1-8: Standard flow
  await executeStandardFlow();

  // Phase 9: Additional Tech Writer for enterprise docs
  await Task({
    subagent_type: "Tech Writer",
    prompt: "Create enterprise docs: compliance, security audit, architecture decision log",
    description: "Enterprise documentation"
  });
}
```

**Benefit**: Orchestrator chooses workflow, agents execute in parallel.

---

### 5. Course Correction (Re-spawning Agents)

```typescript
// User invokes: /bmad-correct-course
async function correctCourse(changes: string) {
  // Analyze impact
  const impact = await Task({
    subagent_type: "Business Analyst",
    prompt: `User wants to change: ${changes}
             Analyze impact on existing PRD, epics, stories.
             Output: docs/impact-analysis.md`,
    description: "Impact analysis"
  });

  // Re-run affected phases with subagents
  if (impact.affectsPRD) {
    // Re-spawn PM to update PRD
    await Task({
      subagent_type: "Product Manager",
      prompt: "Update PRD based on impact-analysis.md. Mark deprecated features.",
      description: "Update PRD"
    });
  }

  if (impact.affectsArchitecture) {
    // Re-spawn Architect
    await Task({
      subagent_type: "System Architect",
      prompt: "Update architecture.md and create new ADR for pivot decision.",
      description: "Update architecture"
    });
  }

  if (impact.affectsStories) {
    // Re-spawn Scrum Master + Story Writers
    await Task({
      subagent_type: "Scrum Master",
      prompt: "Update sprint-plan.md. Mark deprecated stories. Create new epics for pivot.",
      description: "Update sprint plan"
    });

    // Spawn story writers for new epics only
    const newEpics = await readNewEpics();
    await Promise.all(
      newEpics.map(epic =>
        Task({
          subagent_type: "Story Writer",
          prompt: `Create stories for new epic: ${epic.title}`,
          description: `Write stories for ${epic.title}`
        })
      )
    );
  }
}
```

**Benefit**: Re-spawns only affected agents, not entire workflow.

---

### 6. Per-Story Code Review (Subagent per Story)

```typescript
// Developer completes story → Orchestrator spawns Tech Lead
async function reviewStory(storyId: string) {
  const review = await Task({
    subagent_type: "Tech Lead",
    prompt: `Review STORY-${storyId}:
             - Read all commits in story file
             - Check naming-registry.md compliance
             - Validate security checklist
             - Check test coverage
             Output: Approve or request changes in story file`,
    description: `Review STORY-${storyId}`
  });

  if (review.status === "CHANGES_REQUESTED") {
    // Re-spawn developer for fixes
    await Task({
      subagent_type: getDeveloperType(storyId), // Frontend/Backend/etc
      prompt: `Fix issues in STORY-${storyId} based on Tech Lead feedback.`,
      description: `Fix STORY-${storyId}`
    });

    // Re-review
    await reviewStory(storyId);
  }
}
```

**Benefit**: Tech Lead is spawned per story, not once at end.

---

### 7. Interactive Help (Orchestrator Skill, Not Subagent)

```typescript
// This is a SKILL for the orchestrator, not a subagent
// (Skills are allowed for meta-operations)

skill: bmad-help.md
---
When user types /bmad-help:

1. Read current project state (docs/project-tracker.md)
2. Identify current phase
3. Provide contextual guidance:
   - Phase 1: "Next step: Run /bmad-next to start Phase 2 (Planning)"
   - Phase 5 (in progress): "4 developers are working. Check docs/project-tracker.md for progress."
   - After QA fails: "Quality gate failed. Review docs/test-plan.md bugs. Fix with developers."
4. Answer follow-up questions using project context

This is NOT a subagent - it's orchestrator intelligence.
```

**Why Not a Subagent**: Help is meta-guidance, not implementation work.

---

## Orchestrator Architecture

### Master Agent: BMad Orchestrator

```markdown
# .claude/agents/bmad-orchestrator.md

You are the **BMad Orchestrator**, the master agent coordinating 13+ specialized agents.

## Your Capabilities

1. **Spawn Subagents**: Use Task tool to spawn specialized agents
2. **Parallel Coordination**: Spawn multiple agents with Promise.all
3. **Dependency Management**: Ensure sequential dependencies (DB → Backend → Frontend)
4. **Progress Tracking**: Update docs/project-tracker.md after each phase
5. **Quality Gates**: Run gate checks before phase transitions
6. **Context Management**: Each subagent gets full context for their work

## Phase Execution Pattern

For each phase:
1. Read current project state
2. Determine which agents to spawn
3. Check dependencies (can agents run in parallel?)
4. Spawn agents (sequential or parallel)
5. Wait for completion
6. Validate outputs
7. Run quality gate
8. Update project tracker
9. Notify user

## Subagent Spawning Examples

### Sequential (Dependencies)
```typescript
const db = await Task({ subagent_type: "Database Engineer", ... });
const backend = await Task({ subagent_type: "Backend Developer", ... });
```

### Parallel (No Dependencies)
```typescript
await Promise.all([
  Task({ subagent_type: "Product Manager", ... }),
  Task({ subagent_type: "UX Designer", ... })
]);
```

### Background (Fire and Forget)
```typescript
Task({
  subagent_type: "Tech Writer",
  run_in_background: true,
  ...
});
```

## Error Handling

If subagent fails:
1. Log error in project tracker
2. Ask user for guidance
3. Re-spawn agent with fixes OR
4. Skip to next phase (if non-critical)

DO NOT proceed if critical agent fails (e.g., Architect).
```

---

## Agent Teams vs Skills: When to Use What

### Use **Agent Teams** (Subagent Spawning) For:
- ✅ **Implementation work** (writing code, docs, specs)
- ✅ **Parallel execution** (multiple agents working simultaneously)
- ✅ **Full context needed** (agent needs entire project history)
- ✅ **Complex reasoning** (multi-step workflows)
- ✅ **Cross-phase work** (Tech Writer in Phase 2 + 6)

**Examples**:
- Product Manager creating PRD
- 4 developers implementing stories in parallel
- Story Writers creating stories per epic
- Research agents doing market/domain/tech analysis

### Use **Skills** For:
- ✅ **Meta-operations** (help, status, tracking)
- ✅ **User commands** (/bmad-help, /bmad-status, /bmad-next)
- ✅ **Quick utilities** (validate docs, generate diagrams)
- ✅ **Orchestrator helpers** (complexity detection, impact analysis)

**Examples**:
- `/bmad-help` - Contextual guidance
- `/bmad-status` - Show current phase
- `/bmad-validate-doc` - Document validation
- `/bmad-mermaid` - Diagram generation

---

## Performance Characteristics

### Parallel Agent Teams (Current Implementation)

```
Phase 5: 4 Developers (Sequential + Parallel)

Database Engineer:    [██████] 30 min
                              ↓
Backend Developer:            [████████] 45 min
                                      ↓
Frontend Developer:                   [██████] 30 min ┐
Mobile Developer:                     [██████] 30 min ┘ PARALLEL

Total: 30 + 45 + 30 = 105 minutes (1h 45min)

WITHOUT parallelization:
30 + 45 + 30 + 30 = 135 minutes (2h 15min)

Speedup: 22% faster
```

### Quick Flow with Agent Teams

```
Quick Flow: Compressed Phases, Parallel Agents

Phase 1: Business Analyst          [███] 10 min
Phase 2: PM + Architect            [████] 15 min (parallel)
Phase 3: Scrum Master              [██] 5 min
Phase 4: Solo Dev                  [██████] 30 min
Phase 5: QA + DevOps               [████] 15 min (parallel)

Total: 75 minutes (1h 15min)

vs Standard Flow: 105 minutes
Speedup: 29% faster
```

---

## Conclusion: Agent Teams Are Core

**Every new feature MUST leverage agent teams:**

1. **Quick Flow** → Compressed phases + Solo Dev agent (still orchestrated)
2. **Tech Writer** → Subagent spawned in Phase 2 + 6
3. **Research** → 3 research agents in parallel (Phase 1)
4. **Course Correction** → Re-spawn affected agents only
5. **Per-Story Review** → Tech Lead subagent per story
6. **Adaptive Scaling** → Orchestrator chooses workflow, spawns agent teams

**Skills are only for**:
- `/bmad-help` (meta-guidance)
- `/bmad-validate-doc` (utility)
- `/bmad-mermaid` (diagram gen)

**Agent teams deliver**:
- ✅ Parallel execution
- ✅ Unlimited context per agent
- ✅ Specialized expertise
- ✅ Master orchestration
- ✅ True BMAD methodology at scale

This is why our implementation is superior to original BMAD-METHOD's sequential execution model.

---

**References:**
- Claude Code Agent Teams: https://code.claude.com/docs/en/agent-teams
- Task Tool Documentation: https://code.claude.com/docs/en/tools/task
- Parallel Execution Examples: See `.claude/agents/bmad-orchestrator.md`
