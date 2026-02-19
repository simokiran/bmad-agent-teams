---
name: bmad-generate-summary
description: Generate PROJECT-SUMMARY.md for quick reference (Token Optimization)
---

# Generate Project Summary

**Purpose**: Create a concise project summary for agents to read instead of full PRD + Architecture (69% token reduction)

## When to Run

**Automatically after Phase 3** (Architecture complete):
- Orchestrator invokes: `/bmad-generate-summary`
- Generates `docs/PROJECT-SUMMARY.md`
- All future agents read summary first before loading full docs

## How It Works

### Step 1: Read Source Documents

```markdown
Read the following files:
1. docs/prd.md (Product Requirements)
2. docs/architecture.md (Technical Architecture)
3. docs/naming-registry.md (Naming Conventions)
```

### Step 2: Extract Key Information

Extract essential information:

**From PRD:**
- Project title and description (1-2 sentences)
- Key features (3-5 bullet points)
- User personas (names only, not full descriptions)
- Critical acceptance criteria (high-level only)

**From Architecture:**
- Tech stack (exact technologies and versions)
- Key architecture decisions (from ADRs - titles only)
- API design pattern (REST/GraphQL/etc)
- Database choice and ORM
- Authentication method
- Deployment target

**From Naming Registry:**
- Database convention (snake_case)
- API convention (camelCase)
- Types convention (PascalCase)
- Routes convention (kebab-case)
- Critical naming examples (users.email → { email } → User.email)

### Step 3: Generate Summary File

Write to `docs/PROJECT-SUMMARY.md`:

```markdown
# Project Summary: [Project Name]

**Auto-generated**: [Timestamp]
**Purpose**: Quick reference for agents (read this before loading full docs)

---

## Project Overview

**Description**: [1-2 sentence project description from PRD]

**Type**: [Web App | Mobile App | API | Full-Stack | etc]

---

## Tech Stack

| Layer | Technology | Version | Notes |
|-------|-----------|---------|-------|
| **Frontend** | [e.g., Next.js] | [14.0] | [App Router] |
| **Backend** | [e.g., Next.js API Routes] | [14.0] | [Serverless] |
| **Database** | [e.g., PostgreSQL] | [15.0] | [Hosted on Vercel] |
| **ORM** | [e.g., Prisma] | [5.0] | [Type-safe queries] |
| **Auth** | [e.g., NextAuth.js] | [4.0] | [JWT tokens] |
| **Mobile** | [e.g., React Native] | [0.72] | [Expo] |
| **Styling** | [e.g., Tailwind CSS] | [3.3] | [JIT mode] |
| **Testing** | [e.g., Jest + Playwright] | [29.0 / 1.39] | [Unit + E2E] |
| **CI/CD** | [e.g., GitHub Actions] | [N/A] | [Auto-deploy to Vercel] |
| **Deployment** | [e.g., Vercel] | [N/A] | [Preview + Production] |

---

## Key Features (from PRD)

1. **[Feature 1 Name]** - [1-line description]
2. **[Feature 2 Name]** - [1-line description]
3. **[Feature 3 Name]** - [1-line description]
4. **[Feature 4 Name]** - [1-line description]
5. **[Feature 5 Name]** - [1-line description]

*Full details: See `docs/prd.md`*

---

## User Personas

- **[Persona 1 Name]** - [1-line role description]
- **[Persona 2 Name]** - [1-line role description]
- **[Persona 3 Name]** - [1-line role description]

*Full personas: See `docs/prd.md` Section 2*

---

## Naming Conventions (CRITICAL)

| Layer | Convention | Example |
|-------|-----------|----------|
| **Database** | snake_case | `users`, `user_sessions`, `created_at` |
| **API Paths** | kebab-case | `/api/auth/register`, `/api/users/:id` |
| **API JSON** | camelCase | `{ email: "...", createdAt: "..." }` |
| **Types** | PascalCase | `User`, `RegisterRequest`, `AuthResponse` |
| **Components** | PascalCase | `RegisterForm`, `UserCard`, `Dashboard` |
| **Routes** | lowercase + hyphen | `/auth/login`, `/user-profile` |
| **Mobile Screens** | PascalCase + "Screen" | `RegisterScreen`, `DashboardScreen` |

**Cross-Layer Example**:
```
Database:  users.email (VARCHAR)
API:       POST /api/auth/register { email: "user@example.com" }
Type:      RegisterRequest { email: string }
Frontend:  <input name="email" />
Mobile:    <TextInput keyboardType="email-address" />
```

*Full naming registry: See `docs/naming-registry.md`*

---

## Architecture Decisions (ADRs)

Key decisions from `docs/adrs/`:

1. **ADR-001**: [Decision Title] - [1-line rationale]
2. **ADR-002**: [Decision Title] - [1-line rationale]
3. **ADR-003**: [Decision Title] - [1-line rationale]

*Full ADRs: See `docs/adrs/ADR-*.md`*

---

## API Design Pattern

**Pattern**: [REST | GraphQL | tRPC | etc]

**Base URL**: `[/api | https://api.example.com]`

**Authentication**: `[Bearer token | Session cookie | API key]`

**Response Format**:
```json
{
  "success": true,
  "data": { ... },
  "error": null,
  "meta": { "page": 1, "total": 100 }
}
```

*Full API docs: See `docs/architecture.md` Section 5*

---

## Database Schema Overview

**Database**: [PostgreSQL | MySQL | MongoDB]

**Key Tables**:
- `users` - User accounts and authentication
- `sessions` - User sessions for auth
- `resources` - [Main entity description]
- `[other_table]` - [Description]

*Full schema: See `docs/naming-registry.md` Section 1*

---

## Project Structure

```
src/
├── app/                 # [Next.js routes | Pages]
├── components/          # [Reusable UI components]
│   ├── ui/              # [Design system components]
│   └── features/        # [Feature-specific components]
├── lib/                 # [Shared utilities]
│   ├── db/              # [Database client & queries]
│   ├── auth/            # [Auth configuration]
│   └── utils/           # [Helper functions]
├── types/               # [TypeScript types]
└── hooks/               # [Custom React hooks]

mobile/
├── src/
│   ├── screens/         # [Mobile screens]
│   ├── components/      # [Mobile components]
│   ├── navigation/      # [Navigation setup]
│   └── services/        # [API services]
```

*Full structure: See `docs/architecture.md` Section 3*

---

## When to Read Full Documents

**Read this summary first**, then load full docs ONLY if you need:

- **`docs/prd.md`** - Detailed feature specs, full user personas, all acceptance criteria
- **`docs/architecture.md`** - Detailed system design, security architecture, performance targets
- **`docs/naming-registry.md`** - All tables/columns, all endpoints, all types (comprehensive)
- **`docs/ux-wireframes.md`** - Detailed screen specs, user flows, component library

**Token Savings**:
- Summary: ~5k tokens
- Full docs: ~45k tokens
- **Reduction: 89%** for agents who only need context, not full details

---

## Summary Statistics

- **Total Features**: [N]
- **Total Epics**: [N] (once created)
- **Total Stories**: [N] (once created)
- **Estimated Project Size**: [Small | Medium | Large]
- **Tech Stack Complexity**: [Simple | Moderate | Complex]

---

*This summary is auto-generated. For full details, see source documents in `docs/`.*
```

### Step 4: Notify Completion

```
"PROJECT-SUMMARY.md generated successfully.
 Agents can now read summary (5k tokens) instead of full docs (45k tokens).
 Token savings: 89% for context-only tasks."
```

---

## Usage by Agents

All agents should update their workflow:

### Before (Wasteful)
```markdown
## Input
- Read docs/prd.md (20k tokens)
- Read docs/architecture.md (25k tokens)
- Read docs/naming-registry.md (10k tokens)
Total: 55k tokens
```

### After (Optimized)
```markdown
## Lazy Loading Protocol
1. Read docs/PROJECT-SUMMARY.md (5k tokens) ← Quick context
2. IF you need detailed feature specs → Read docs/prd.md (20k tokens)
3. IF you need detailed architecture → Read docs/architecture.md (25k tokens)
4. IF you need comprehensive naming → Read docs/naming-registry.md (10k tokens)

Average case: 5k + (0.2 × 55k) = 16k tokens
Savings: 71%
```

---

## Regeneration

**When to regenerate:**
- After PRD is updated (course correction)
- After architecture changes
- After naming registry major updates

**How to regenerate:**
```bash
/bmad-generate-summary --force
```

---

## Quality Criteria

Summary must be:
- [ ] Under 200 lines (5k tokens max)
- [ ] Contains all tech stack entries
- [ ] Contains top 5 features from PRD
- [ ] Contains naming convention examples
- [ ] Contains ADR titles (not full content)
- [ ] Contains project structure overview
- [ ] Cross-layer naming example included

---

## Token Impact Analysis

### Before PROJECT-SUMMARY.md

```
Phase 4b: 4 Story Writers
  Each reads: PRD (20k) + Architecture (25k) = 45k
  Total: 4 × 45k = 180k tokens

Phase 5: 4 Developers
  Each reads: PRD (20k) + Architecture (25k) + Naming (10k) = 55k
  Total: 4 × 55k = 220k tokens

Combined: 400k tokens
```

### After PROJECT-SUMMARY.md

```
Phase 4b: 4 Story Writers
  Each reads: PROJECT-SUMMARY (5k) + Epic (5k) = 10k
  Occasional full doc read: 0.2 × 45k = 9k
  Average per writer: 19k
  Total: 4 × 19k = 76k tokens

Phase 5: 4 Developers
  Each reads: PROJECT-SUMMARY (5k) + Story (5k) + Naming sections (3k) = 13k
  Occasional full doc read: 0.2 × 55k = 11k
  Average per developer: 24k
  Total: 4 × 24k = 96k tokens

Combined: 172k tokens

Savings: 400k → 172k = 228k tokens (57% reduction!)
```

---

## Implementation Checklist

- [ ] Skill created: `.claude/skills/bmad-generate-summary.md`
- [ ] Orchestrator updated to invoke after Phase 3
- [ ] All developer agents updated to read PROJECT-SUMMARY first
- [ ] Story Writer agent reads PROJECT-SUMMARY (not full PRD)
- [ ] Template documented in `templates/PROJECT-SUMMARY.md`

---

**Status**: Token Optimization Phase 1 - Strategy #3
**Impact**: 57% token reduction in Phases 4b + 5
**Cost**: ~$1-2 savings per project
