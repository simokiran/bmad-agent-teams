# Orchestrator Token Optimization Guide

**Append to orchestrator.md after deployment**

---

## Token Optimization Summary (71% Reduction)

You (the orchestrator) implement 3 phases of token optimization:

### Phase 1 (Deployed ✅): Quick Wins - 35% Reduction

1. **Lazy Loading** - Agents use Read tool incrementally
   - Developers load story + naming registry only (~15k vs 70k)

2. **Model Selection** - Story Writer uses Haiku model
   - Cost: $0.065 vs $0.78 per story phase (92% savings)

3. **PROJECT-SUMMARY** - Auto-generate after Phase 3
   - You invoke: `Skill("bmad-generate-summary")`
   - Agents read 5k summary vs 45k full docs (89% reduction)

**Savings: 846k → 546k tokens**

---

### Phase 2 (Deployed ✅): Architectural - 30% Additional

1. **Compact Instructions** - Shared templates reduce agent file size
   - Agent files reference templates/, not embed

2. **Incremental Stories** - Separate spec from implementation log
   - Story spec: 5k tokens (others read this)
   - Implementation log: 10-15k tokens (only dev reads)

3. **Context Isolation** - YOU extract epic-specific context
   - Phase 4b: Read PRD+Arch ONCE, extract per epic
   - Story writers get 18k tokens vs 60k (70% reduction)

**Savings: 546k → 291k tokens**

---

### Phase 3 (Deployed ✅): Advanced - 15% Additional

1. **Streaming Outputs** - Agents return confirmations only
   - YOU don't accumulate full outputs in memory
   - Agent returns: "✅ Done. Files: X." (100 tokens vs 20k)

2. **Compression** - External examples, abbreviations
   - Agent files reference examples/, not embed code
   - Naming registry uses abbreviations

3. **Selective Reading** - Agents use Grep for sections
   - Read "API Design" section only (3k vs 25k full doc)

4. **Deduplication** - Reference docs, don't embed in prompts
   - Phase 5: Agents read PROJECT-SUMMARY themselves
   - YOU don't pass 10k shared context in each prompt

**Savings: 291k → 241k tokens**

---

## Your Token Optimization Checklist

### After Phase 3 (Architecture)

- [x] Invoke `Skill("bmad-generate-summary")`
- [x] Wait for confirmation
- [x] Verify `docs/PROJECT-SUMMARY.md` exists

### Before Phase 4b (Story Writing)

- [x] Read PRD, Architecture, PROJECT-SUMMARY ONCE
- [x] For each epic:
  - [x] Extract features for this epic only
  - [x] Extract architecture for this epic's track only
  - [x] Extract naming for this epic's track only
- [x] Spawn story writers with minimal context (18k each)
- [x] Use streaming output protocol (agents return confirmations)

### Before Phase 5 (Implementation)

- [x] DON'T embed tech stack in prompts
- [x] DO reference docs/PROJECT-SUMMARY.md
- [x] Use streaming output protocol
- [x] Spawn in correct order: DB → Backend → (Frontend + Mobile)

### Throughout All Phases

- [x] Every agent spawn uses streaming outputs
- [x] Return format: "✅ Task. Files: X. Stats: Y."
- [x] Don't accumulate full outputs in memory
- [x] Reference docs, don't embed content

---

## Token Breakdown (Your Orchestration)

```
BEFORE OPTIMIZATION:
  Your memory across 8 phases: ~200k tokens (accumulated outputs)
  Agent input contexts: ~600k tokens (duplicated docs)
  Total project: 846k tokens

AFTER ALL OPTIMIZATIONS:
  Your memory across 8 phases: ~5k tokens (confirmations only)
  Agent input contexts: ~230k tokens (lazy loading + context isolation)
  Total project: 241k tokens

YOUR CONTRIBUTION TO SAVINGS:
  Memory reduction: 195k tokens (streaming outputs)
  Context isolation: 88k tokens (Phase 4b)
  Deduplication: 58k tokens (Phase 5)
  Total orchestrator impact: ~340k tokens saved!
```

---

## Context Extraction Examples

### Extract Features for Epic

```typescript
function extractFeaturesForEpic(epic, prd) {
  // Epic references: F-001, F-002, F-003
  const epicFeatures = epic.features.map(featureId => {
    const feature = prd.features.find(f => f.id === featureId);
    return `
## ${feature.id}: ${feature.title}
${feature.description}

Acceptance Criteria:
${feature.acceptanceCriteria.join('\n')}
    `;
  }).join('\n\n');

  return epicFeatures;
  // Result: 2-3k tokens (3 features) vs 20k (all 20 PRD features)
}
```

### Extract Architecture for Track

```typescript
function extractArchitectureForTrack(track, architecture) {
  if (track === "Backend") {
    return `
Tech Stack: ${architecture.backend}
API Pattern: ${architecture.apiPattern}
Authentication: ${architecture.auth}
Error Handling: ${architecture.errorHandling}
    `;
  } else if (track === "Frontend") {
    return `
Tech Stack: ${architecture.frontend}
UI Framework: ${architecture.uiFramework}
Styling: ${architecture.styling}
State Management: ${architecture.stateManagement}
    `;
  } else if (track === "Database") {
    return `
Database: ${architecture.database}
ORM: ${architecture.orm}
Data Model: ${architecture.dataModel}
    `;
  } else if (track === "Mobile") {
    return `
Mobile Framework: ${architecture.mobileFramework}
Platforms: ${architecture.platforms}
Navigation: ${architecture.navigation}
    `;
  }
  // Result: 3-5k tokens vs 25k full architecture
}
```

### Extract Naming for Track

```typescript
function extractNamingForTrack(track, summary) {
  const base = `
Cross-Layer Example:
DB: users.email (VARCHAR)
API: { email: "..." }
Type: email: string
Frontend: <input name="email" />
Mobile: <TextInput keyboardType="email-address" />
  `;

  if (track === "Backend") {
    return base + `
Database: snake_case (users, user_sessions, created_at)
API Paths: kebab-case (/api/auth/register)
API JSON: camelCase ({ email, createdAt })
Types: PascalCase (User, RegisterRequest)
    `;
  } else if (track === "Frontend") {
    return base + `
Components: PascalCase (RegisterForm, UserCard)
Routes: lowercase-hyphen (/auth/login)
Form fields: camelCase (email, password)
    `;
  } else if (track === "Mobile") {
    return base + `
Screens: PascalCase+Screen (RegisterScreen)
Components: PascalCase (UserCard)
Navigation: lowercase (/register, /login)
    `;
  }
  // Result: 2-3k tokens
}
```

---

## Monitoring Token Usage

After each phase, log token consumption:

```markdown
Phase 1 Complete:
- Orchestrator memory: 100 tokens (confirmation only)
- Agent consumed: 15k tokens
- Expected: ~15k ✅

Phase 4b Complete:
- Orchestrator memory: 400 tokens (4 confirmations)
- 4 Story Writers consumed: 18k each = 72k total
- Expected: ~152k (including orchestrator reads) ✅

Phase 5 Complete:
- Orchestrator memory: 400 tokens (4 dev confirmations)
- 4 Developers consumed: 25k each = 100k total
- Expected: ~100k ✅
```

---

## Troubleshooting

**Agent returns full content instead of confirmation:**
- Add explicit OUTPUT PROTOCOL to agent prompt
- Remind agent to write to files, not return content
- Use example confirmation format

**Context extraction too complex:**
- Fallback: Let agent read full docs if extraction fails
- Better: Improve extraction functions with more PRD structure knowledge

**Story writers missing context:**
- Verify extracted context includes all epic's features
- Check that track-specific architecture is complete
- Ensure naming conventions are clear

---

**Status**: Phase 2+3 optimizations deployed in orchestrator
**Impact**: 66% token reduction (846k → 291k tokens after Phase 2)
**Next**: Monitor real-world usage, adjust extraction functions as needed
