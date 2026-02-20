# STORY-NNN: [Descriptive Title]

> Created by: Story Writer Agent (Phase 4b) | Epic: EPIC-NNN

## Metadata
- **Points**: [1 | 2 | 3 | 5 | 8]
- **Track**: [Frontend | Backend | Database | Mobile | Full-Stack]
- **Priority**: [P0 | P1 | P2]
- **Sprint**: 1
- **Epic**: [EPIC-NNN]
- **Depends On**: [STORY-XXX or None]
- **Blocks**: [STORY-YYY or None]
- **PRD Feature**: [F-NNN]

## User Story

As a **[persona name]**,
I want **[specific action]**
so that **[measurable benefit]**.

## Acceptance Criteria

- [ ] **AC-1**: [Given/When/Then or specific testable criterion]
- [ ] **AC-2**: [Criterion]
- [ ] **AC-3**: [Criterion]

## Tasks

Individual committable units of work. Each task = one git commit.

- [ ] TASK-1: [Specific implementation task — e.g., "Create users table migration"]
- [ ] TASK-2: [Task — e.g., "Add email validation to registration endpoint"]
- [ ] TASK-3: [Task — e.g., "Write unit tests for login flow"]
- [ ] TASK-4: [Task — e.g., "Handle error states in login form"]

## Technical Notes

### Naming Registry References
**CRITICAL**: Check `docs/naming-registry.md` for all entity names. Update the registry after implementation.

#### Database Names (if applicable)
- Tables: `[table_name]` (snake_case - see Section 1 of naming registry)
- Columns: `[column_name]` (snake_case - see Section 1 of naming registry)
- Indexes: `idx_[table]_[column]` (see Section 1 of naming registry)

#### API Names (if applicable)
- Endpoints: `[METHOD] /api/[path]` (kebab-case path - see Section 2 of naming registry)
- Request types: `[Entity]Request` (PascalCase - see Section 3 of naming registry)
- Response types: `[Entity]Response` (PascalCase - see Section 3 of naming registry)

#### Frontend Names (if applicable)
- Routes: `/[path]` (lowercase, hyphenated - see Section 4 of naming registry)
- Components: `[ComponentName]` (PascalCase - see Section 5 of naming registry)
- Form fields: `[fieldName]` (camelCase - see Section 6 of naming registry)

#### Mobile Names (if applicable)
- Screens: `[ScreenName]` (PascalCase + "Screen" - see Section 7 of naming registry)
- Components: `[ComponentName]` (PascalCase - see Section 7 of naming registry)
- Navigation: `/[route]` (lowercase - see Section 7 of naming registry)

### Files to Create
- `src/[path]/[filename]` — [Purpose]

### Files to Modify
- `src/[path]/[filename]` — [What change]

### Cross-Layer Mapping
Example: If this story involves user registration:
```
DB:       users.email (VARCHAR)
API:      POST /api/auth/register { email: string }
Type:     RegisterRequest { email: string }
Frontend: <input name="email" />
Mobile:   <TextInput keyboardType="email-address" />
```

### Key Architecture Decisions
- See `docs/adrs/ADR-NNN-[topic].md`

## Test Requirements

- [ ] **Unit test**: [What to test]
- [ ] **Integration test**: [What to test, if applicable]

## Out of Scope

- [Explicitly list what this story does NOT include]

---

## Git Task Tracking

> **DEVELOPERS**: After completing each task, commit and record the SHA here.
> When ALL tasks are done, push to the sprint branch.

| # | Task | Status | Commit SHA | Timestamp |
|---|------|--------|------------|-----------|
| 1 | [Task-1 description] | ⬜ | — | — |
| 2 | [Task-2 description] | ⬜ | — | — |
| 3 | [Task-3 description] | ⬜ | — | — |
| 4 | [Task-4 description] | ⬜ | — | — |

### Commit Log
```
(populated by developer as tasks complete)
```

### Story Git Summary
- **Branch**: sprint/sprint-1
- **Total Commits**: 0
- **First Commit**: —
- **Last Commit**: —
- **Pushed**: ❌ No

---

## Status

- [x] Not Started
- [ ] In Progress
- [ ] Code Complete
- [ ] Tests Passing
- [ ] Pushed
- [ ] Done

## Implementation Details

**For detailed implementation notes, see**: `docs/stories/STORY-NNN-implementation.md`

> Developers: Keep this story file LEAN (spec only). Put verbose notes, debugging logs, code snippets in the implementation log file. Other agents don't need to read implementation details.

**Quick Notes** (optional, keep brief):
- [One-line notes only, e.g., "Used bcrypt with 10 rounds"]
- [Link to implementation log for details]

---

**Token Optimization**: Story spec stays ~5k tokens. Implementation log can be 10-15k tokens but is NOT re-read by other agents.
