# Required Skills for Project

**Project**: [Project Name]
**Last Updated**: [Date]
**Created By**: System Architect (Phase 3)

> **PURPOSE**: This document lists all Claude Code skills required for this project. The Orchestrator will check/install these skills before Phase 5 (Implementation), and developers will invoke them during their work.

---

## What Are Skills?

Claude Code Skills are specialized capabilities that agents can invoke using the `Skill` tool. Skills provide domain-specific expertise (e.g., WordPress development, Figma design, React patterns, database optimization).

---

## Required Skills by Agent

### UX Designer Skills

| Skill Name | Purpose | When to Use | Installation |
|------------|---------|-------------|--------------|
| `design` | Create wireframes, mockups, design systems | Phase 2 (Planning) - UX wireframes | Pre-installed with Claude Code |
| `figma` | Generate Figma designs, export assets | Phase 2 - If Figma is design tool | `/install figma-skill` |

**UX Designer Usage**:
```markdown
When creating wireframes in Phase 2:
1. Invoke: /design to create visual mockups
2. Output: Design specifications, component library
```

---

### Backend Developer Skills

| Skill Name | Purpose | When to Use | Installation |
|------------|---------|-------------|--------------|
| `wordpress` | WordPress theme/plugin development | If tech stack uses WordPress | `npm install -g @wordpress/skills` |
| `laravel` | Laravel framework patterns | If using Laravel | `npm install -g @laravel/skills` |
| `django` | Django framework patterns | If using Django | `pip install django-skills` |
| `nestjs` | NestJS patterns and modules | If using NestJS | `npm install -g @nestjs/skills` |
| `graphql` | GraphQL schema design and resolvers | If API uses GraphQL | Pre-installed |
| `api-design` | RESTful API best practices | All backend projects | Pre-installed |

**Backend Developer Usage Example (WordPress)**:
```markdown
When implementing STORY-003 (Create custom post type):
1. Read story and architecture
2. Invoke: /wordpress to scaffold custom post type
3. Implement returned code
4. Commit with SHA tracking
```

---

### Frontend Developer Skills

| Skill Name | Purpose | When to Use | Installation |
|------------|---------|-------------|--------------|
| `react` | React components and hooks | If using React | Pre-installed |
| `vue` | Vue components and composition API | If using Vue | `npm install -g @vue/skills` |
| `nextjs` | Next.js app router patterns | If using Next.js | Pre-installed |
| `tailwind` | Tailwind CSS utility patterns | If using Tailwind | Pre-installed |
| `accessibility` | WCAG compliance, a11y patterns | All frontend projects | Pre-installed |

**Frontend Developer Usage Example**:
```markdown
When implementing STORY-006 (Create RegisterForm):
1. Read naming-registry.md for API contract
2. Invoke: /react to scaffold form component
3. Customize with form fields from story
4. Invoke: /accessibility to ensure WCAG compliance
5. Commit with SHA tracking
```

---

### Mobile Developer Skills

| Skill Name | Purpose | When to Use | Installation |
|------------|---------|-------------|--------------|
| `react-native` | React Native components | If using React Native | Pre-installed |
| `flutter` | Flutter widgets and state management | If using Flutter | `flutter pub add skills` |
| `swiftui` | SwiftUI views and modifiers | If using SwiftUI | Xcode integration |
| `compose` | Jetpack Compose patterns | If using Kotlin Compose | Android Studio integration |
| `mobile-a11y` | Mobile accessibility patterns | All mobile projects | Pre-installed |

**Mobile Developer Usage Example (React Native)**:
```markdown
When implementing STORY-009 (Create RegisterScreen):
1. Read naming-registry.md for API contract
2. Invoke: /react-native to scaffold screen
3. Customize with TextInputs from story
4. Invoke: /mobile-a11y for accessibility
5. Commit with SHA tracking
```

---

### Database Engineer Skills

| Skill Name | Purpose | When to Use | Installation |
|------------|---------|-------------|--------------|
| `postgresql` | PostgreSQL schema design, indexes | If using PostgreSQL | Pre-installed |
| `mysql` | MySQL schema and optimization | If using MySQL | Pre-installed |
| `mongodb` | MongoDB schema and queries | If using MongoDB | Pre-installed |
| `prisma` | Prisma schema and migrations | If using Prisma ORM | `npm install -g prisma-skills` |
| `drizzle` | Drizzle ORM patterns | If using Drizzle ORM | `npm install -g drizzle-skills` |

**Database Engineer Usage Example**:
```markdown
When implementing STORY-001 (Create users table):
1. Read architecture.md for database choice
2. Invoke: /postgresql to generate migration
3. Review and customize schema
4. Commit with SHA tracking
```

---

### QA Engineer Skills

| Skill Name | Purpose | When to Use | Installation |
|------------|---------|-------------|--------------|
| `testing` | Test plan generation, coverage analysis | Phase 6 (QA) | Pre-installed |
| `playwright` | E2E test generation | If using Playwright | Pre-installed |
| `cypress` | E2E test generation | If using Cypress | `npm install -g cypress-skills` |
| `jest` | Unit test generation | If using Jest | Pre-installed |

**QA Engineer Usage Example**:
```markdown
When creating test plan in Phase 6:
1. Read all stories and acceptance criteria
2. Invoke: /testing to generate test plan
3. Invoke: /playwright to generate E2E tests
4. Run tests and document results
```

---

### DevOps Engineer Skills

| Skill Name | Purpose | When to Use | Installation |
|------------|---------|-------------|--------------|
| `docker` | Dockerfile and docker-compose | If using Docker | Pre-installed |
| `kubernetes` | K8s manifests and configs | If deploying to K8s | `kubectl install skills` |
| `terraform` | Infrastructure as code | If using Terraform | `terraform install skills` |
| `github-actions` | CI/CD pipeline generation | If using GitHub Actions | Pre-installed |

**DevOps Engineer Usage Example**:
```markdown
When creating deployment config in Phase 7:
1. Read architecture.md for infrastructure
2. Invoke: /docker to generate Dockerfile
3. Invoke: /github-actions for CI/CD pipeline
4. Commit configs
```

---

## Project-Specific Skills

### This Project Requires:

**Must Have** (Install before Phase 5):
- [ ] `skill-name-1` - Purpose: [Why this skill is critical]
- [ ] `skill-name-2` - Purpose: [Why this skill is critical]

**Nice to Have** (Install if needed):
- [ ] `skill-name-3` - Purpose: [When this skill helps]

**Not Needed**:
- ❌ `skill-name-4` - Reason: [Why we're not using this]

---

## Installation Instructions

### Before Phase 5 (Implementation)

**Orchestrator**: Check this section before spawning developer agents.

```bash
# Example installation commands (replace with actual skills)

# If using WordPress
npm install -g @wordpress/claude-skills

# If using React Native
npm install -g @react-native/claude-skills

# If using Prisma
npm install -g @prisma/claude-skills

# Verify installation
claude skills list
```

---

## Skill Usage Protocol

### For All Developer Agents

**BEFORE implementing ANY task:**
1. ✅ Check `docs/skills-required.md` for available skills
2. ✅ Read skill documentation (if unfamiliar)
3. ✅ Decide if skill would help with current task

**DURING implementation:**
1. ✅ Invoke skill using `Skill` tool (e.g., `/wordpress`, `/react`, `/design`)
2. ✅ Review skill output
3. ✅ Customize as needed for story requirements
4. ✅ Integrate with naming registry conventions

**Example Skill Invocation**:
```markdown
# In agent's workflow
1. Read STORY-003: "Create WordPress custom post type for Projects"
2. Check skills-required.md → WordPress skill available
3. Invoke: /wordpress with prompt "Create custom post type 'project' with fields: title, description, client_name, start_date"
4. Skill returns scaffolded code
5. Customize field names to match naming-registry.md
6. Commit: [STORY-003] task: Create project custom post type
```

---

## Skill Decision Matrix

| Technology | Skill to Use | Agent | Phase |
|------------|--------------|-------|-------|
| WordPress | `wordpress` | Backend Developer | 5 |
| React | `react` | Frontend Developer | 5 |
| React Native | `react-native` | Mobile Developer | 5 |
| PostgreSQL | `postgresql` | Database Engineer | 5 |
| Figma | `figma` | UX Designer | 2 |
| Playwright | `playwright` | QA Engineer | 6 |
| Docker | `docker` | DevOps Engineer | 7 |

---

## How System Architect Determines Required Skills

### Step 1: Analyze Tech Stack
```markdown
# From architecture.md Technology Stack section
Frontend: Next.js + React + Tailwind
Backend: WordPress REST API
Database: MySQL
Mobile: React Native
Testing: Playwright
Deployment: Docker + GitHub Actions
```

### Step 2: Map to Skills
```markdown
Next.js + React → /react, /nextjs skills
WordPress → /wordpress skill (CRITICAL)
MySQL → /mysql skill
React Native → /react-native skill
Tailwind → /tailwind skill (optional)
Playwright → /playwright skill
Docker → /docker skill
```

### Step 3: Document in `skills-required.md`
```markdown
Required Skills:
- wordpress (Backend Developer)
- react (Frontend Developer)
- react-native (Mobile Developer)
- mysql (Database Engineer)
- playwright (QA Engineer)
- docker (DevOps Engineer)
```

---

## Skill Best Practices

### Do's ✅
- Invoke skills for scaffolding/boilerplate generation
- Customize skill output to match naming registry
- Use skills for domain-specific patterns (WP hooks, React patterns)
- Document skill usage in story technical notes

### Don'ts ❌
- Don't blindly use skill output without customization
- Don't skip naming registry checks after using skills
- Don't use skills if simpler manual implementation exists
- Don't forget to commit skill-generated code with proper SHAs

---

## Troubleshooting

### Skill Not Found
```bash
# Check installed skills
claude skills list

# Install missing skill
claude skills install <skill-name>

# Or use npm/pip depending on skill
npm install -g @<skill-package>
```

### Skill Output Doesn't Match Naming Registry
```markdown
Problem: Skill generated code with different naming convention
Solution:
1. Take skill output as starting point
2. Rename according to naming-registry.md
3. Update naming registry if skill introduced new entities
4. Commit with note: "Adapted <skill-name> output to naming conventions"
```

---

## Updates

This document is updated by:
- **System Architect** (Phase 3): Initial skill requirements
- **Orchestrator** (Phase 5): Verification skills are installed
- **Developers** (Phase 5): Notes on additional skills discovered during implementation

**Last Updated**: [Timestamp]
**Updated By**: [Agent Name]
