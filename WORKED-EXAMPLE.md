# BMad Method — Worked Example

## Project: "TimeFlow" — Freelancer Time Tracking & Invoicing SaaS

This document walks through what each phase and agent actually produces when you build a real project with the 12-agent team.

---

## Phase 1: Discovery → Business Analyst

**Prompt**: "Build me a SaaS app that helps freelancers track time and invoice clients automatically."

**What the Analyst produces** (`docs/product-brief.md`):

```markdown
# Product Brief: TimeFlow

## 1. Problem Statement
Freelancers spend an average of 4+ hours per week on administrative tasks
like time tracking and invoicing. Current tools are either too complex
(Harvest, Toggl+FreshBooks combo) or too simple (spreadsheets). Freelancers
need a unified tool that makes time tracking effortless and automatically
generates professional invoices.

## 2. Target Users
### Primary Persona: "Freelance Fiona"
- Solo web designer, 3 years experience
- 4-6 active clients at any time
- Pain: Forgets to start/stop timers, loses billable hours
- Pain: Spends Sunday evenings creating invoices manually
- Goal: Get paid faster with less admin work

## 5. MVP Scope
### In Scope
- [ ] One-click time tracking with project/client tags
- [ ] Automatic invoice generation from tracked time
- [ ] Client management (name, email, hourly rate)
- [ ] Dashboard with weekly/monthly summaries
- [ ] PDF invoice export and email sending

### Out of Scope
- [ ] Payment processing (Stripe integration — Phase 2)
- [ ] Team/collaboration features
- [ ] Mobile app (web-responsive only for MVP)
```

**Gate Check**: ✅ All 8 sections present, specific personas, SMART metrics.

---

## Phase 2: Planning → PM + UX Designer (Parallel)

**What the PM produces** (`docs/prd.md`):

```markdown
## Feature F-001: Time Tracking
- Priority: P0 (Must Have)
- User Story: As Freelance Fiona, I want to start/stop a timer with one
  click so that I never forget to track billable hours.
- Acceptance Criteria:
  - AC-1: User can start a timer with a single click/tap
  - AC-2: Timer persists across browser refresh/close
  - AC-3: User can assign a running timer to a project/client
  - AC-4: Timer displays elapsed time in HH:MM:SS format
  - AC-5: User can manually add time entries (for forgotten tracking)
  - AC-6: Time entries show in a daily/weekly list view

## Feature F-002: Invoice Generation
- Priority: P0 (Must Have)
- Acceptance Criteria:
  - AC-1: User can select time entries to include in an invoice
  - AC-2: Invoice auto-calculates total from hours × client rate
  - AC-3: Invoice includes line items, dates, and project names
  - AC-4: User can preview invoice before sending
  - AC-5: Invoice exports as PDF
  - AC-6: User can email invoice directly from the app
```

**What the UX Designer produces** (`docs/ux-wireframes.md`):

```markdown
## User Flows

### Flow 1: Track Time
[Open App] → [See Dashboard] → [Click "Start Timer"] → [Timer Running]
  → [Click "Stop"] → [Assign to Project] → [Time Entry Saved]

### Screen: Dashboard
- Layout: 2-column (sidebar nav + main content)
- Components:
  - Active Timer: Large, prominent at top of main area
  - Today's Entries: List below timer
  - Sidebar: Projects, Clients, Invoices, Settings
- States:
  - No timer: "Start tracking" CTA
  - Timer running: Green pulsing indicator + elapsed time
  - Entries exist: Table with edit/delete actions
```

---

## Phase 3: Architecture → System Architect

**What the Architect produces** (`docs/architecture.md`):

```markdown
## Technology Stack
| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Frontend | Next.js 14 (App Router) | SSR + RSC, excellent DX |
| Styling | Tailwind CSS | Utility-first, consistent design |
| Backend | Next.js API Routes | Unified codebase, serverless |
| Database | PostgreSQL (Supabase) | Relational data, free tier |
| Auth | NextAuth.js | Open source, multiple providers |
| Email | Resend | Simple API, free tier |
| PDF | @react-pdf/renderer | React-based PDF generation |
| Hosting | Vercel | Zero-config Next.js deployment |

## Data Model
- User (id, email, name, business_name, logo_url)
- Client (id, user_id, name, email, hourly_rate, currency)
- Project (id, client_id, name, color, is_active)
- TimeEntry (id, project_id, start_time, end_time, description, is_manual)
- Invoice (id, user_id, client_id, number, status, due_date, total, pdf_url)
- InvoiceLineItem (id, invoice_id, time_entry_id, description, hours, rate, amount)

## Solutioning Gate Check: 142/150 (94.6%) ✅ PASS
```

---

## Phase 4: Sprint Planning → Scrum Master

**What the Scrum Master produces** (`docs/sprint-plan.md` + 12 story files):

```markdown
# Sprint Plan: TimeFlow — Sprint 1

## Sprint Goal
Deliver core time tracking, client management, and invoice generation.

## Story Summary
| ID | Title | Pts | Track | Depends On |
|----|-------|-----|-------|------------|
| STORY-001 | Database Schema & Migrations | 5 | Database | None |
| STORY-002 | Seed Data for Development | 2 | Database | STORY-001 |
| STORY-003 | Auth Setup (NextAuth) | 3 | Backend | STORY-001 |
| STORY-004 | Client CRUD API | 3 | Backend | STORY-001 |
| STORY-005 | Time Entry CRUD API | 5 | Backend | STORY-001 |
| STORY-006 | Invoice Generation API | 5 | Backend | STORY-005 |
| STORY-007 | App Layout + Navigation | 3 | Frontend | None |
| STORY-008 | Timer Component | 5 | Frontend | STORY-005 |
| STORY-009 | Client Management Page | 3 | Frontend | STORY-004 |
| STORY-010 | Time Entry List View | 3 | Frontend | STORY-005 |
| STORY-011 | Invoice Builder Page | 5 | Frontend | STORY-006 |
| STORY-012 | PDF Export + Email | 3 | Backend | STORY-006 |

## Parallel Tracks
Database: STORY-001 → STORY-002 (done first, others depend on it)
Backend:  STORY-003 → STORY-004 → STORY-005 → STORY-006 → STORY-012
Frontend: STORY-007 → STORY-008 → STORY-009 → STORY-010 → STORY-011

Total: 45 points across 12 stories
```

---

## Phase 5: Implementation → 3 Developers (Agent Team)

**What happens**: The Orchestrator creates Agent Team "sprint-1" and spawns:

1. **Database Engineer**: Creates the PostgreSQL schema, migrations, seed data.
   Produces: `src/lib/db/migrations/001_create_tables.ts`, `src/lib/db/seeds/`, `src/types/database.ts`

2. **Backend Developer**: Builds API routes, auth, business logic.
   Produces: `src/app/api/clients/route.ts`, `src/app/api/time-entries/route.ts`, `src/app/api/invoices/route.ts`

3. **Frontend Developer**: Builds UI components and pages.
   Produces: `src/components/Timer.tsx`, `src/app/dashboard/page.tsx`, `src/app/invoices/page.tsx`

All three work simultaneously — DB finishes first (unblocking backend), frontend uses mocks until APIs are ready, then integrates.

---

## Phase 6: QA → QA Engineer

**Key findings** (`docs/test-plan.md`):

```markdown
## Acceptance Criteria Verification
| Feature | ACs | Pass | Fail |
|---------|-----|------|------|
| F-001: Time Tracking | 6 | 6 | 0 |
| F-002: Invoicing | 6 | 5 | 1 |
| F-003: Client Mgmt | 4 | 4 | 0 |
| F-004: Dashboard | 3 | 3 | 0 |

## Bug Report
### BUG-001: Invoice PDF missing project names
- Severity: Medium
- AC F-002-AC-3 partially fails: line items show hours but not project names
- Suggested fix: Include project.name in invoice line item query JOIN

## QA Sign-off: ⚠️ CONDITIONAL PASS
Fix BUG-001 (medium severity) before shipping.
```

---

## Phase 7: Deployment → DevOps Engineer

**Produces**: GitHub Actions CI/CD, Vercel config, `.env.example`, health check endpoints.

---

## Phase 8: Final Review → Tech Lead

```markdown
## Final Verdict: ⚠️ SHIP WITH NOTES

Architecture Compliance: 95% (minor deviation: used Drizzle ORM instead of raw SQL)
Code Quality: 8/10 (clean, well-typed, consistent patterns)
Test Coverage: 82% (above 80% target)
Security: Passed (auth, validation, CORS all correct)
Performance: Passed (LCP < 1.5s, API < 100ms)

Notes:
1. Fix BUG-001 (invoice line items) before launch
2. Add rate limiting to public API endpoints (low priority)
3. Consider adding error boundary components (nice-to-have)

Recommendation: Ship after BUG-001 fix. Remaining items can go in Sprint 2.
```

---

## Timeline Summary

| Phase | Agent(s) | Token Cost | Wall Time |
|-------|----------|-----------|-----------|
| 1. Discovery | Analyst | ~5K | 2 min |
| 2. Planning | PM + UX | ~15K | 5 min (parallel) |
| 3. Architecture | Architect | ~12K | 4 min |
| 4. Sprint Planning | Scrum Master | ~10K | 3 min |
| 5. Implementation | 3 Developers | ~80K | 15 min (parallel) |
| 6. QA | QA Engineer | ~15K | 5 min |
| 7. Deployment | DevOps | ~8K | 3 min |
| 8. Review | Tech Lead | ~10K | 4 min |
| **Total** | **12 agents** | **~155K** | **~41 min** |

From idea to production-ready codebase in under an hour. 🚀
