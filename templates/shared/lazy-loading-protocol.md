# Lazy Loading Protocol (Shared Template)

**Purpose**: Reduce token consumption by loading only needed files

## Principle: Load Files On-Demand

**DON'T** load all project files upfront. **DO** use the Read tool to load files as needed.

## Standard Loading Pattern

### Step 1: Read Your Primary Input
```markdown
Start with the file most relevant to your task:
- Story Writer → Read docs/epics/EPIC-NNN.md
- Developer → Read docs/stories/STORY-NNN.md
- QA Engineer → Read docs/test-plan.md
- Tech Lead → Read docs/review-checklist.md
```

### Step 2: Load Supporting Files As Needed

**REQUIRED files** (always read):
- `docs/naming-registry.md` - For naming conventions (Sections relevant to your track)

**OPTIONAL files** (read only if needed):
- `docs/prd.md` - If acceptance criteria unclear from story
- `docs/architecture.md` - If tech stack/design decisions unclear
- `docs/ux-wireframes.md` - If UI specifications unclear
- `docs/PROJECT-SUMMARY.md` - Quick reference (read this before full docs)

### Step 3: Load Incrementally

```markdown
# Good (lazy loading)
1. Read story file
2. Read naming-registry.md (only sections I need)
3. If unclear about API contract → Read architecture.md Section 5 (API Design)
4. If unclear about feature → Read PROJECT-SUMMARY.md or specific PRD section

# Bad (eager loading)
1. Read ALL files at once (prd, architecture, wireframes, epics, stories, naming-registry)
Result: 70k tokens vs 15k tokens
```

## Example: Frontend Developer

```markdown
Task: Implement STORY-007 (Create LoginForm component)

Step 1: Read story
Read docs/stories/STORY-007.md (5k tokens)

Step 2: Read naming registry
Read docs/naming-registry.md Sections 4, 5, 6 (component, route, form naming) (3k tokens)

Step 3: Read architecture IF needed
If unsure about form validation → Read docs/architecture.md Section "Frontend → Form Validation" (2k tokens)

Total loaded: 10k tokens (vs 70k if loaded everything)
Savings: 86%
```

## When to Load Full Documents

Load full documents ONLY when:
- Creating initial architecture (Architect needs full PRD)
- Writing comprehensive docs (Tech Writer needs full context)
- Final review (Tech Lead needs full project understanding)

Otherwise: **Load incrementally, read sections, use PROJECT-SUMMARY.md**

## Token Savings

| Loading Pattern | Tokens Loaded | Use Case |
|----------------|---------------|----------|
| Lazy (story + naming registry only) | 10-15k | Most developer tasks |
| Incremental (story + naming + 1-2 sections) | 20-25k | Complex tasks needing context |
| Full (all docs) | 60-70k | Architecture, final review only |

**Target**: 80% of agents use lazy loading (10-15k tokens)
