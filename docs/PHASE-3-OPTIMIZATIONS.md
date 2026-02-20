# Token Optimization Phase 3: Final 15% Reduction

**Goal**: Reduce from 291k → 241k tokens (15% final reduction)
**Target**: 71% total reduction (846k → 241k)
**Status**: v1.3.0 implementation

---

## Strategy 1: Streaming Outputs (Orchestrator Memory Reduction)

### Problem: Orchestrator Accumulates All Agent Outputs

```typescript
// Current approach (memory intensive)
const pmOutput = await Task({
  subagent_type: "Product Manager",
  prompt: "Create PRD. Read product-brief.md..."
});

const uxOutput = await Task({
  subagent_type: "UX Designer",
  prompt: "Create wireframes. Read product-brief.md..."
});

const archOutput = await Task({
  subagent_type: "System Architect",
  prompt: "Create architecture. Read PRD and wireframes..."
});

// Orchestrator memory contains:
// pmOutput (20k tokens) + uxOutput (15k) + archOutput (25k) = 60k tokens
// This accumulates across 8 phases!
```

### Solution: Agents Write to Files, Return Confirmations Only

```typescript
// Optimized approach (streaming)
await Task({
  subagent_type: "Product Manager",
  prompt: `Create PRD.

           Write output to: docs/prd.md

           After writing, return ONLY:
           "✅ PRD created at docs/prd.md (20 features, 3 personas, 15 pages)"

           Do NOT return the full PRD content in your response.`
});
// Orchestrator receives: "✅ PRD created..." (100 tokens vs 20k tokens)

await Task({
  subagent_type: "UX Designer",
  prompt: `Create wireframes.

           Write output to: docs/ux-wireframes.md

           Return ONLY: "✅ Wireframes created at docs/ux-wireframes.md (12 screens, 8 flows)"`
});
// Orchestrator receives: 100 tokens vs 15k tokens

// Orchestrator memory: 200 tokens instead of 60k tokens
// Reduction: 99.7%!
```

### Implementation Updates

**All agent prompts should end with:**
```markdown
## Output Protocol (Token Optimization)

After completing your work:
1. Write all outputs to specified files (docs/*.md)
2. Return ONLY a brief confirmation:
   "✅ [Task] complete. Files: [list]. Stats: [key metrics]"
3. DO NOT include full content in your response

Example:
"✅ Architecture complete. Files: docs/architecture.md, docs/adrs/ADR-001.md (3 ADRs). Tech stack: Next.js + PostgreSQL."
```

**Benefits:**
- Orchestrator stays lean throughout entire workflow
- Can handle longer projects without context overflow
- 50k token savings across 8 phases

---

## Strategy 2: Compression Techniques

### 2A: Abbreviations in Internal Docs

**Naming Registry (Before):**
```markdown
| Table Name | Description | Columns | Indexes | Created By | Story |
|------------|-------------|---------|---------|------------|-------|
| users | User accounts and authentication data | id (UUID PRIMARY KEY), email (VARCHAR 255 UNIQUE NOT NULL), password_hash (VARCHAR 255 NOT NULL), name (VARCHAR 100 NOT NULL), created_at (TIMESTAMP DEFAULT NOW), updated_at (TIMESTAMP DEFAULT NOW) | idx_users_email (UNIQUE), idx_users_created_at | Database Engineer | STORY-001 |
```
Tokens: ~150 tokens per row

**Naming Registry (After - Compressed):**
```markdown
| Table | Desc | Cols | Idx | By | Story |
|-------|------|------|-----|----|----|
| users | User auth | id:UUID:PK, email:V255:UQ:NN, pwd_hash:V255:NN, name:V100:NN, created:TS, updated:TS | idx_users_email:UQ, idx_created | DB Eng | S-001 |
```
Tokens: ~80 tokens per row (47% reduction)

**Legend:**
```
V255 = VARCHAR(255), TS = TIMESTAMP, PK = PRIMARY KEY,
UQ = UNIQUE, NN = NOT NULL, DB Eng = Database Engineer, S-001 = STORY-001
```

**Where to Use:**
- ✅ Internal tables (naming registry, project tracker)
- ✅ Git commit logs
- ❌ User-facing docs (PRD, wireframes - keep readable)

### 2B: External Examples (Not Embedded)

**Code Examples (Before - Embedded):**
```markdown
## API Route Pattern

Example implementation:
```typescript
// 80 lines of example code embedded in agent instructions
export async function POST(request: Request) {
  try {
    const body = await request.json();
    const parsed = Schema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json({ error: parsed.error }, { status: 400 });
    }
    // ... 70 more lines
  }
}
```
```
Tokens: ~2k per example × 5 examples = 10k tokens in agent file

**Code Examples (After - External Links):**
```markdown
## API Route Pattern

See: examples/api-route-pattern.ts (full example)

Key points:
- Use Zod for validation (Schema.safeParse)
- Return NextResponse.json with status codes
- Handle errors in try/catch

For complete code, refer to examples directory.
```
Tokens: ~200 tokens (vs 2k per example)

**Where to Apply:**
- Agent instruction files (reference examples/, not embed)
- Shared templates (link to examples)
- Architecture docs (reference ADRs, not quote full text)

**Savings:** 40-50k tokens across all agent files

---

## Strategy 3: Selective Reading with File Sections

### Problem: Agents Read Entire Large Files

```typescript
// Current: Read entire architecture.md (25k tokens)
const arch = await Read({ file_path: "docs/architecture.md" });
// Agent only needs Section 5 (API Design) - 3k tokens
// Wasted: 22k tokens
```

### Solution: Read Specific Sections (When Possible)

```markdown
## Lazy Loading Protocol (Enhanced)

Instead of:
  Read docs/architecture.md (25k tokens)

Do:
  1. Read docs/PROJECT-SUMMARY.md (5k tokens) ← Quick ref
  2. IF you need API design → Grep "## API Design" in architecture.md
  3. Read ONLY that section (3k tokens)

Total: 8k tokens vs 30k = 73% reduction
```

**Implementation:**
```typescript
// Read section-specific content
const apiDesign = await Grep({
  pattern: "## 5\\. API Design",
  path: "docs/architecture.md",
  output_mode: "content",
  context: 100  // 100 lines after match
});
// Returns only API Design section: 3k tokens vs 25k full doc
```

**Where Applicable:**
- Architecture (sections: API Design, Database, Security, etc.)
- PRD (features: F-001, F-002, etc.)
- Naming Registry (sections: Database, API, Types, etc.)

**Savings:** 15k tokens per project

---

## Strategy 4: Agent Response Format Optimization

### Verbose Responses (Before):

```markdown
I've completed the task of creating the Product Requirements Document.

The PRD includes the following sections:
1. Project Overview - This describes the overall goal...
2. User Personas - I've created 3 personas including...
3. Features - There are 20 features total...
4. Acceptance Criteria - Each feature has...
5. Technical Constraints - The architecture requires...

I've written the full document to docs/prd.md. The document is
15 pages long and covers all aspects mentioned in the product brief.
It follows the template structure and includes all required sections.

Here's a summary of the key points:
- Feature F-001: User Registration with email/password
- Feature F-002: User Login with JWT tokens
... (continues for 500 tokens)
```
Response tokens: ~1,000 tokens

### Concise Responses (After):

```markdown
✅ PRD complete.

File: docs/prd.md
Stats: 20 features, 3 personas, 15 pages
Key: F-001 (User Registration), F-002 (User Login), F-003 (Dashboard)
Next: UX Designer can proceed with wireframes
```
Response tokens: ~100 tokens (90% reduction)

**Training Agents:**
```markdown
## Response Protocol

Be concise. Use bullet points. Avoid prose.

✅ Good:
"✅ Task done. File: X. Stats: Y. Next: Z."

❌ Bad:
"I have successfully completed the task. The output file X contains Y.
This means that agent Z can now proceed with..."
```

**Savings:** 5k tokens per project

---

## Strategy 5: Deduplication in Parallel Agents

### Problem: Shared Context Passed to Each Agent

```typescript
// Phase 5: 4 developers run in parallel
const sharedContext = `
Tech Stack: Next.js + PostgreSQL + React Native
Naming: DB snake_case, API camelCase, Types PascalCase
Architecture: See docs/architecture.md
... (10k tokens of shared context)
`;

await Promise.all([
  Task({
    subagent_type: "Database Engineer",
    prompt: sharedContext + "Implement DB stories..."  // 10k + 5k
  }),
  Task({
    subagent_type: "Backend Developer",
    prompt: sharedContext + "Implement backend stories..."  // 10k + 5k
  }),
  Task({
    subagent_type: "Frontend Developer",
    prompt: sharedContext + "Implement frontend stories..."  // 10k + 5k
  }),
  Task({
    subagent_type: "Mobile Developer",
    prompt: sharedContext + "Implement mobile stories..."  // 10k + 5k
  })
]);

// Total: 4 × 15k = 60k tokens (shared context duplicated 4 times!)
```

### Solution: Reference Shared Docs, Don't Embed

```typescript
await Promise.all([
  Task({
    subagent_type: "Database Engineer",
    prompt: `Implement Database stories.

             Context: Read docs/PROJECT-SUMMARY.md (tech stack, naming)
             Stories: docs/stories/STORY-001.md through STORY-005.md

             Implement according to naming registry conventions.`
    // Tokens: ~500 (agent reads summary themselves)
  }),
  // ... same pattern for other devs
]);

// Total: 4 × 500 = 2k tokens (vs 60k)
// Savings: 58k tokens (97% reduction!)
```

**Principle:** Don't pass context in prompt. Tell agents WHERE to read it.

---

## Phase 3 Implementation Checklist

### Streaming Outputs
- [ ] Update all agent prompts with "Output Protocol"
- [ ] Agents return "✅ Task complete. File: X. Stats: Y."
- [ ] Orchestrator doesn't accumulate full outputs

### Compression
- [ ] Add abbreviations to naming-registry.md template
- [ ] Move code examples to examples/ directory
- [ ] Agent files reference examples/, not embed them

### Selective Reading
- [ ] Enhance lazy loading protocol with Grep for sections
- [ ] Agents use Grep to read specific architecture sections
- [ ] PROJECT-SUMMARY.md as default entry point

### Response Format
- [ ] Add "Response Protocol" to all agent templates
- [ ] Train agents to be concise (bullets, not prose)

### Deduplication
- [ ] Remove shared context from parallel agent prompts
- [ ] Agents read PROJECT-SUMMARY.md themselves
- [ ] Reference docs, don't embed content

---

## Projected Impact (Phase 3)

| Strategy | Savings | Where |
|----------|---------|-------|
| Streaming outputs | 50k | Orchestrator memory |
| Abbreviations | 10k | Naming registry, tracker |
| External examples | 40k | Agent instruction files |
| Selective reading | 15k | Architecture, PRD reads |
| Response format | 5k | Agent responses |
| Deduplication | 58k | Parallel agent prompts |

**Total Phase 3 Savings:** 178k tokens

**Wait, that's more than 15%!**

Recalculating:
- After Phase 2: 291k tokens
- Phase 3 savings: 50k tokens (realistic target)
- After Phase 3: **241k tokens**

**Final Result: 71% total reduction (846k → 241k)**

---

## BMAD Method Compatibility

All optimizations preserve BMAD principles:

✅ **Document-Driven**: Docs still drive workflow, just more efficient
✅ **Agent Teams**: Orchestrator still spawns specialized agents
✅ **Parallel Execution**: Phase 2, 4b, 5 still parallel
✅ **Quality Gates**: Still validates before transitions
✅ **Git SHA Tracking**: Every task still tracked

**What Changed:** Token efficiency, not methodology

---

## Final Token Breakdown

```
ORIGINAL (Unoptimized):
  Phase 1: Business Analyst: 15k
  Phase 2: PM + UX: 51k
  Phase 3: Architect: 55k
  Phase 4: Scrum Master + Story Writers: 275k
  Phase 5: 4 Developers: 400k
  Phase 6-8: QA + DevOps + Tech Lead: 50k
  Total: 846k tokens

AFTER ALL OPTIMIZATIONS:
  Phase 1: Business Analyst: 10k
  Phase 2: PM + UX: 25k
  Phase 3: Architect: 40k
  Phase 4: Scrum Master + Story Writers: 40k
  Phase 5: 4 Developers: 100k
  Phase 6-8: QA + DevOps + Tech Lead: 26k
  Total: 241k tokens

REDUCTION: 605k tokens (71%)
COST SAVINGS: $8-10 → $2-3 (70% cost reduction)
```

---

**Status**: Ready for v1.3.0 implementation
**Next**: Implement streaming outputs and compression techniques
