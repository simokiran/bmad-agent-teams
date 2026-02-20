# Developer Workflow Template (Shared)

**Purpose**: Standard workflow for all developer agents (reduce repetition)

---

## Workflow Per Story

### 1. Read Story File

```markdown
Read docs/stories/STORY-NNN.md completely:
- User story and acceptance criteria
- Tasks breakdown
- Technical notes and naming references
- Dependencies (must complete first)
```

### 2. Check Dependencies

```markdown
Are prerequisite stories done?
- Check story "Depends On" field
- Verify those stories have "Done" status
- If blocked, wait or notify orchestrator
```

### 3. Check Available Skills

```markdown
Read docs/skills-required.md for available Claude Code skills:
- Backend: wordpress, laravel, django, graphql
- Frontend: react, nextjs, tailwind, accessibility
- Database: postgresql, mysql, mongodb, prisma
- Mobile: react-native, flutter, swiftui, compose

Can any skill help scaffold this story?
```

### 4. Update Story Status

```markdown
Change story status from "Not Started" to "In Progress"
Update status checkbox in story file
```

### 5. Implement Each Task

```bash
For EACH task in the story:

# a) OPTIONALLY invoke skill if applicable:
#    Example: /react "Create LoginForm component with email/password fields"
#    Review skill output and customize per naming-registry.md

# b) Implement the task:
#    - Use skill output as starting point (if invoked)
#    - Follow naming registry conventions
#    - Ensure cross-layer consistency (DB → API → Type → UI)

# c) Commit with story-prefixed message:
git add -A
git commit -m "[STORY-NNN] task: <task description>"

# d) Capture SHA and update story file:
COMMIT_SHA=$(git rev-parse --short HEAD)
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")
# Update Git Task Tracking table in story file

# e) Update naming registry if created new entities
```

### 6. After All Tasks Complete

```bash
# Final story file update:
git add docs/stories/STORY-NNN.md
git commit -m "[STORY-NNN] complete: <story title>"

# Push to remote:
git push origin sprint/sprint-1
```

### 7. Notify Team Lead

```markdown
Use SendMessage or notify orchestrator:
"STORY-NNN complete and pushed. All acceptance criteria met."
```

---

## Naming Registry Updates (All Developers)

**CRITICAL**: Update naming registry after creating ANY new entity

### When to Update

```markdown
Created new database table/column? → Update Section 1
Created new API endpoint? → Update Section 2
Created new TypeScript type? → Update Section 3
Created new frontend route? → Update Section 4
Created new component? → Update Section 5
Created new form field? → Update Section 6
Created new mobile screen? → Update Section 7
```

### How to Update

```bash
# 1. Read current naming registry
Read docs/naming-registry.md

# 2. Add your new entities to relevant sections
# 3. Update Section 10 (Cross-Reference Mapping) if multi-layer

# 4. Commit naming registry update:
git add docs/naming-registry.md
git commit -m "[STORY-NNN] update: naming registry with <entity-name>"
```

---

## Error Handling (All Developers)

### Common Scenarios

**Pre-commit hook fails:**
```bash
# ❌ DON'T: git commit --amend (modifies previous commit!)
# ✅ DO: Fix issue, create NEW commit
# Fix the issue
git add -A
git commit -m "[STORY-NNN] task: <description> (fixes pre-commit issues)"
```

**Tests failing:**
```bash
# ❌ DON'T: Mark story as complete with failing tests
# ✅ DO: Debug, fix tests, commit fix
npm test  # or equivalent
# Fix failing tests
git add -A
git commit -m "[STORY-NNN] fix: Resolve failing tests"
```

**Blocked by dependency:**
```bash
# ❌ DON'T: Try to work around missing dependency
# ✅ DO: Notify orchestrator, wait for dependency
"STORY-NNN blocked by STORY-XXX (not complete). Waiting."
```

---

## Quality Checks Before Marking Complete

```markdown
- [ ] All acceptance criteria verified (manual or automated)
- [ ] All tasks have commit SHAs recorded
- [ ] Naming registry updated
- [ ] No compiler/linter errors
- [ ] Tests passing (unit + integration if applicable)
- [ ] Code follows project conventions (from architecture.md)
- [ ] Security checklist passed (if applicable)
- [ ] Story file updated with final status
```

---

**Token Savings**: This template saves ~50 lines per agent × 4 agents = 200 lines (~5k tokens)
