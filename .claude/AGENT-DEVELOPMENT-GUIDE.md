# BMad Agent Development Guide

## Core Principle: Autonomous Professionals

**Every BMad agent must be a fully autonomous professional**, not a micromanaged task executor. Each agent contains complete instructions in their own file and knows how to execute their role without orchestrator handholding.

## Required Architecture

### 1. Agent File Structure

Every agent file in `.claude/agents/` must contain:

```markdown
---
name: Agent Name
description: Brief description of agent role
model: opus|sonnet|haiku
---

# Agent Name

## Role
Clear definition of agent's professional role and responsibilities.

## Input
What documents/files the agent needs to read.

## Output
What files the agent will create.

## Workflow
Step-by-step process the agent follows autonomously.

## Output Protocol (Streaming Outputs)
**REQUIRED SECTION** - See below for standard format.
```

### 2. Output Protocol Standard

**Every agent MUST include this section:**

```markdown
## Output Protocol (Streaming Outputs)

After completing [agent's main task]:

1. **Write [specific files]** to `path/to/file.md`
2. **Return ONLY a brief confirmation**:

```
✅ [Task name] complete.
File: path/to/file.md
[Key metric 1]: [value]
[Key metric 2]: [value]
```

**DO NOT** return the full content in your response. The file is the deliverable.
```

### 3. Why This Matters

**Problem:** Without OUTPUT PROTOCOL, agents complete their work but:
- Don't write files (content lost)
- Return verbose responses (token waste)
- Unclear when they're actually done

**Solution:** OUTPUT PROTOCOL tells the agent:
1. Write to specific file paths (persistent artifacts)
2. Return brief confirmation only (token efficiency)
3. Clear completion signal (orchestrator knows to continue)

## Orchestrator Spawn Pattern

When orchestrator spawns an agent, use **minimal prompts** that reference the agent's autonomy:

```typescript
Task({
  subagent_type: "Product Manager",
  description: "Create PRD",
  prompt: `Create PRD.

**INPUT:**
- Read: docs/product-brief.md

**OUTPUT:**
- Write to: docs/prd.md

**OUTPUT PROTOCOL:**
After writing docs/prd.md, return ONLY:
"✅ PRD created. File: docs/prd.md. Features: [N]. Personas: [M]."

DO NOT return the full PRD content in your response.`
})
```

**Key Points:**
- Agent already knows HOW to create a PRD (it's in their file)
- Orchestrator just specifies INPUT and OUTPUT paths
- OUTPUT PROTOCOL ensures consistent response format

## Token Optimization

### Model Selection
- **Opus**: Complex reasoning (Tech Lead, System Architect)
- **Sonnet**: Standard development (Frontend, Backend, QA, DevOps)
- **Haiku**: Simple tasks, reading/writing structured docs

### Lazy Loading
Agents should load files on-demand, not eagerly:

```markdown
### Required Files (Read for Every Story)
- `docs/naming-registry.md` (Sections 2-6 only)

### Optional Files (Read Only If Needed)
- `docs/ux-wireframes.md` — If UI specifications unclear
- `docs/architecture.md` — If tech stack unclear
```

**Token Savings:** Load 10-15k tokens (lazy) vs 70k tokens (eager) = 79% reduction

## Quality Checklist for New Agents

Before adding a new agent to BMad:

- [ ] Agent file has clear Role, Input, Output sections
- [ ] Workflow is self-contained (agent is autonomous)
- [ ] **OUTPUT PROTOCOL section is present and follows standard format**
- [ ] Model selection appropriate for task complexity
- [ ] Input files use lazy loading when possible
- [ ] Orchestrator spawn pattern uses minimal prompt
- [ ] Agent tested end-to-end (spawns, writes files, returns confirmation)

## Anti-Patterns to Avoid

### ❌ Micromanaging Orchestrator
```typescript
// BAD: Orchestrator tells agent every step
prompt: `1. Read product brief
2. Identify key features
3. Create user personas
4. Write PRD sections: Overview, Features, Personas
5. Format as markdown
6. Save to docs/prd.md`
```

### ✅ Autonomous Agent
```typescript
// GOOD: Agent already knows these steps (they're in agent file)
prompt: `Create PRD.
INPUT: docs/product-brief.md
OUTPUT: docs/prd.md`
```

### ❌ Verbose Response
```markdown
Agent returns: "I have created a comprehensive PRD with 12 features...
[3000 words of PRD content]..."
```

### ✅ Brief Confirmation
```markdown
Agent returns: "✅ PRD created. File: docs/prd.md. Features: 12. Personas: 3."
```

### ❌ Missing File Write
```markdown
Agent creates content in memory but doesn't write to file.
Result: Content lost when agent terminates.
```

### ✅ Explicit File Write
```markdown
Agent uses Write tool to save docs/prd.md.
Result: Persistent artifact for next agent.
```

## Testing Your Agent

1. **Spawn Test**: Can orchestrator spawn it with minimal prompt?
2. **File Test**: Does it write expected files to correct paths?
3. **Response Test**: Does it return brief confirmation (not full content)?
4. **Handoff Test**: Can next agent read its output and continue?

## Examples

See existing agents for reference implementations:
- `.claude/agents/analyst.md` — Phase 1 discovery
- `.claude/agents/product-manager.md` — Phase 2 planning
- `.claude/agents/architect.md` — Phase 3 architecture
- `.claude/agents/frontend-developer.md` — Phase 5 implementation
- `.claude/agents/qa-engineer.md` — Phase 6 quality assurance
- `.claude/agents/tech-lead.md` — Phase 8 final review

All follow the autonomous professional pattern with OUTPUT PROTOCOL.
