# Context Isolation Strategy (Token Optimization Phase 2)

**Purpose**: Orchestrator extracts epic-specific context instead of passing full PRD+Architecture to each story writer
**Impact**: 80% token reduction in Phase 4b (Story Writing)
**Status**: Implementation guide for v1.2.0

---

## Problem: Redundant Context in Parallel Agents

### Current Approach (Wasteful)

```typescript
// Phase 4b: Spawn 4 story writers in parallel
const epics = await readEpics(); // 4 epics

await Promise.all(
  epics.map(epic =>
    Task({
      subagent_type: "Story Writer",
      prompt: `Create stories for ${epic.title}.

               Read these files:
               - docs/epics/${epic.id}.md
               - docs/prd.md  ← 20k tokens (ALL features, ALL personas)
               - docs/architecture.md  ← 25k tokens (ENTIRE architecture)
               - docs/naming-registry.md

               Create 5-10 stories.`,
      description: `Write stories for ${epic.title}`
    })
  )
);

// Result: Each of 4 agents reads PRD (20k) + Architecture (25k)
// Total: 4 × 45k = 180k tokens of REDUNDANT reads
// (PRD and Architecture are read 4 times with identical content)
```

---

## Solution: Orchestrator Extracts Relevant Context

### Optimized Approach (Context Isolation)

```typescript
// Phase 4b: Orchestrator preparation

// 1. Read source documents ONCE (orchestrator does this)
const prd = await Read({ file_path: "docs/prd.md" });
const architecture = await Read({ file_path: "docs/architecture.md" });
const namingRegistry = await Read({ file_path: "docs/naming-registry.md" });
const projectSummary = await Read({ file_path: "docs/PROJECT-SUMMARY.md" });

// 2. Read all epics
const epics = await readEpics();

// 3. For EACH epic, extract relevant context
const storyWriterPrompts = epics.map(epic => {
  // Extract only features relevant to this epic
  const relevantFeatures = extractFeaturesForEpic(epic, prd);

  // Extract only architecture constraints relevant to this epic
  const relevantArchitecture = extractArchitectureForEpic(epic, architecture);

  // Extract only naming conventions relevant to this epic's track
  const relevantNaming = extractNamingForTrack(epic.track, namingRegistry);

  return {
    epic,
    context: {
      projectSummary, // 5k tokens (full summary - small enough to include)
      features: relevantFeatures, // 2-3k tokens (only epic's features)
      architecture: relevantArchitecture, // 3-5k tokens (only epic's constraints)
      naming: relevantNaming // 2-3k tokens (only epic's track naming)
    }
  };
});

// 4. Spawn story writers with MINIMAL context
await Promise.all(
  storyWriterPrompts.map(({ epic, context }) =>
    Task({
      subagent_type: "Story Writer",
      prompt: `Create stories for EPIC-${epic.id}: ${epic.title}

               PROJECT CONTEXT (from orchestrator):

               Tech Stack (from PROJECT-SUMMARY):
               ${context.projectSummary.techStack}

               Epic Features (from PRD):
               ${context.features}

               Architecture Constraints (relevant to ${epic.track}):
               ${context.architecture}

               Naming Conventions (${epic.track} track):
               ${context.naming}

               FILES TO READ:
               - docs/epics/${epic.id}.md (your primary input)
               - docs/naming-registry.md (full registry for cross-reference)

               DO NOT READ:
               - docs/prd.md (orchestrator extracted relevant parts above)
               - docs/architecture.md (orchestrator extracted relevant parts above)

               Create 5-10 stories using template from templates/story.md`,
      description: `Write stories for ${epic.title}`
    })
  )
);

// Result: Each agent receives 10-15k tokens of context
// Total: 4 × 15k = 60k tokens
// Savings: 180k → 60k = 120k tokens (67% reduction!)
```

---

## Context Extraction Functions

### 1. Extract Features for Epic

```typescript
function extractFeaturesForEpic(epic: Epic, prd: PRD): string {
  // Epic references specific PRD features (e.g., F-001, F-002)
  const epicFeatureIds = epic.features; // ["F-001", "F-002"]

  const relevantFeatures = epicFeatureIds.map(featureId => {
    const feature = prd.features.find(f => f.id === featureId);
    return `
### ${feature.id}: ${feature.title}
**Description**: ${feature.description}
**Acceptance Criteria**:
${feature.acceptanceCriteria.map(ac => `- ${ac}`).join('\n')}
**User Personas**: ${feature.personas.join(', ')}
    `.trim();
  }).join('\n\n');

  return relevantFeatures;
  // Result: 2-3k tokens (only features for this epic, not all 20 PRD features)
}
```

### 2. Extract Architecture for Epic

```typescript
function extractArchitectureForEpic(epic: Epic, architecture: Architecture): string {
  const track = epic.track; // "Backend", "Frontend", "Database", "Mobile"

  // Extract only relevant architecture sections
  const relevantSections = [];

  // Always include tech stack
  relevantSections.push(`
## Tech Stack
${architecture.techStack[track]}
  `);

  // Track-specific sections
  if (track === "Backend") {
    relevantSections.push(architecture.apiDesign);
    relevantSections.push(architecture.authentication);
    relevantSections.push(architecture.errorHandling);
  } else if (track === "Frontend") {
    relevantSections.push(architecture.frontendFramework);
    relevantSections.push(architecture.styling);
    relevantSections.push(architecture.stateManagement);
  } else if (track === "Database") {
    relevantSections.push(architecture.dataModel);
    relevantSections.push(architecture.databaseChoice);
  } else if (track === "Mobile") {
    relevantSections.push(architecture.mobileFramework);
    relevantSections.push(architecture.platformTargets);
  }

  return relevantSections.join('\n\n');
  // Result: 3-5k tokens (only relevant architecture, not entire 25k doc)
}
```

### 3. Extract Naming for Track

```typescript
function extractNamingForTrack(track: string, namingRegistry: NamingRegistry): string {
  const relevantSections = [];

  // Always include Section 10 (Cross-Reference Mapping)
  relevantSections.push(namingRegistry.crossReference);

  // Track-specific sections
  if (track === "Backend") {
    relevantSections.push(namingRegistry.section1); // Database
    relevantSections.push(namingRegistry.section2); // API Endpoints
    relevantSections.push(namingRegistry.section3); // Types
  } else if (track === "Frontend") {
    relevantSections.push(namingRegistry.section2); // API (for consumption)
    relevantSections.push(namingRegistry.section3); // Types
    relevantSections.push(namingRegistry.section4); // Routes
    relevantSections.push(namingRegistry.section5); // Components
    relevantSections.push(namingRegistry.section6); // Forms
  } else if (track === "Database") {
    relevantSections.push(namingRegistry.section1); // Database
  } else if (track === "Mobile") {
    relevantSections.push(namingRegistry.section2); // API
    relevantSections.push(namingRegistry.section3); // Types
    relevantSections.push(namingRegistry.section7); // Mobile
  }

  return relevantSections.join('\n\n');
  // Result: 2-3k tokens (only relevant naming, not entire 10k registry)
}
```

---

## Implementation in Orchestrator

### Phase 4b Enhancement

Update `.claude/agents/orchestrator.md` with context isolation:

```markdown
## Phase 4b: Story Writing (Context Isolation)

### Step 1: Read Source Documents (Once)
```typescript
const prd = await Read({ file_path: "docs/prd.md" });
const architecture = await Read({ file_path: "docs/architecture.md" });
const namingRegistry = await Read({ file_path: "docs/naming-registry.md" });
const projectSummary = await Read({ file_path: "docs/PROJECT-SUMMARY.md" });
const epics = await readEpics();
```

### Step 2: Extract Epic-Specific Context
For each epic, extract:
- Features (only epic's features from PRD)
- Architecture (only epic track's sections)
- Naming (only epic track's conventions)

### Step 3: Spawn Story Writers with Minimal Context
Pass extracted context in prompt, not file paths.

Story writers read:
- Epic file (provided)
- Naming registry (for full cross-reference)

Story writers DO NOT read:
- PRD (orchestrator extracted relevant parts)
- Architecture (orchestrator extracted relevant parts)
```

---

## Token Impact Analysis

### Before Context Isolation

```
4 Story Writers (parallel):

  Story Writer 1 (Epic 1: User Auth):
    Reads: PRD (20k) + Architecture (25k) + Epic (5k) + Naming (10k)
    Total: 60k tokens

  Story Writer 2 (Epic 2: Dashboard):
    Reads: PRD (20k) + Architecture (25k) + Epic (5k) + Naming (10k)
    Total: 60k tokens

  Story Writer 3 (Epic 3: Resources):
    Reads: PRD (20k) + Architecture (25k) + Epic (5k) + Naming (10k)
    Total: 60k tokens

  Story Writer 4 (Epic 4: Settings):
    Reads: PRD (20k) + Architecture (25k) + Epic (5k) + Naming (10k)
    Total: 60k tokens

Phase 4b Total: 4 × 60k = 240k tokens
```

### After Context Isolation

```
Orchestrator (one-time cost):
  Reads: PRD (20k) + Architecture (25k) + Naming (10k) + Summary (5k) + 4 Epics (20k)
  Total: 80k tokens

4 Story Writers (parallel):

  Story Writer 1 (Epic 1: User Auth):
    Context from orchestrator: 10k tokens (features + arch + naming extracted)
    Reads: Epic (5k) + Naming sections (3k)
    Total: 18k tokens

  Story Writer 2 (Epic 2: Dashboard):
    Context: 10k + Reads: 8k
    Total: 18k tokens

  Story Writer 3 (Epic 3: Resources):
    Context: 10k + Reads: 8k
    Total: 18k tokens

  Story Writer 4 (Epic 4: Settings):
    Context: 10k + Reads: 8k
    Total: 18k tokens

Phase 4b Total: 80k (orchestrator) + (4 × 18k) = 152k tokens

Savings: 240k → 152k = 88k tokens (37% reduction in Phase 4b!)
```

---

## Benefits

1. **Massive Token Reduction**: 88k tokens saved in Phase 4b alone
2. **Faster Story Writing**: Agents receive only relevant context, less to process
3. **Better Focus**: Story writers see only what matters for their epic
4. **Orchestrator Intelligence**: Orchestrator understands project structure deeply

---

## Drawbacks

1. **Orchestrator Complexity**: More logic in orchestrator (context extraction)
2. **Maintenance**: Extraction functions need updates if document structure changes
3. **Edge Cases**: Some epics might need full context (rare)

---

## Fallback Mechanism

```typescript
// If epic is Full-Stack or requires full context:
if (epic.track === "Full-Stack" || epic.requiresFullContext) {
  // Fall back to letting agent read full docs
  prompt = `Read docs/prd.md and docs/architecture.md for full context...`;
} else {
  // Use context isolation (normal case)
  prompt = `Context extracted by orchestrator: ${extractedContext}...`;
}
```

---

## Implementation Checklist

- [ ] Create context extraction functions in orchestrator
- [ ] Update Phase 4b workflow to extract context
- [ ] Test with 4-epic project
- [ ] Measure token savings (before/after)
- [ ] Document in orchestrator.md
- [ ] Add fallback for Full-Stack epics

---

## Future Enhancements (Phase 3)

- **Semantic Chunking**: Use LLM to intelligently extract relevant sections
- **Caching**: Cache extracted context for reuse
- **Dynamic Context**: Adjust context size based on epic complexity

---

**Status**: Design complete, ready for v1.2.0 implementation
**Expected Savings**: 88k tokens in Phase 4b (37% reduction)
**Total Phase 2 Savings**: 255k tokens (30% overall reduction)
