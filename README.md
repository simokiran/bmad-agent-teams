# BMad Agent Teams for Claude Code

> Ship production-quality software with a 12-agent AI development team — all orchestrated from a single Claude Code session.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Extension-purple)](https://claude.ai/code)

## What is This?

**BMad Agent Teams** is a Claude Code extension that implements the **BMad Method** (Breakthrough Method for Agile AI-Driven Development). It transforms your Claude Code session into a complete software development team with 12 specialized AI agents working together through structured phases.

### Key Features

- **12 Specialized Agents**: Business Analyst, Product Manager, UX Designer, System Architect, Scrum Master, Frontend/Backend/Database Developers, QA Engineer, DevOps Engineer, Tech Lead, and an Orchestrator to manage them all
- **8-Phase Structured Workflow**: Discovery → Planning → Architecture → Sprint Planning → Implementation → QA → Deployment → Final Review
- **Parallel Execution**: Agents work in parallel where possible (PM + UX, Story Writers, Implementation Team)
- **Epic-Story Hierarchy**: PRD features break down into Epics, which break down into Stories with clear acceptance criteria
- **Git Task Tracking**: Every task = 1 commit, SHA recorded in story file, automatic push on story completion
- **Quality Gates**: Architecture completeness check (90%+ required), QA gate, Tech Lead ship/no-ship verdict
- **Live Project Tracking**: Real-time dashboard showing epic → story → task → git progress

## Installation

### Quick Install (Recommended)

```bash
npx @bmad-code/agent-teams install
```

This will install BMad Method into your current directory.

### Install to Specific Directory

```bash
npx @bmad-code/agent-teams install ./my-project
```

### Install with Options

```bash
# Skip confirmation prompts
npx @bmad-code/agent-teams install --yes

# Force overwrite existing files
npx @bmad-code/agent-teams install --force

# Both
npx @bmad-code/agent-teams install ./my-project --yes --force
```

### Manual Installation

```bash
# Clone this repository
git clone https://github.com/bmad-code-org/bmad-agent-teams.git
cd bmad-agent-teams

# Run installer
./install.sh /path/to/your/project
```

## Quick Start

1. **Install the extension** (see above)

2. **Enable Agent Teams** in your shell:
   ```bash
   export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
   ```

3. **Start Claude Code** in your project directory:
   ```bash
   cd /path/to/your/project
   claude
   ```

4. **Initialize the BMad Method**:
   ```
   /bmad-init
   ```

5. **Describe your project**:
   ```
   I want to build a task management app with user authentication,
   project boards, and real-time collaboration features...
   ```

6. **Let the agents work**! The orchestrator will guide you through each phase:
   ```
   /bmad-status    # Check current progress
   /bmad-next      # Advance to next phase
   /bmad-track     # View project dashboard
   /bmad-gate      # Run quality gate check
   /bmad-sprint    # Begin implementation sprint
   /bmad-review    # Trigger final review
   /bmad-help      # Get contextual help
   ```

## How It Works

### The Orchestration Model

The BMad Method uses a **document-driven relay** architecture where a single Orchestrator agent manages 12 specialized agents through an 8-phase workflow. Agents communicate through documents (not shared memory), and work happens both sequentially and in parallel depending on the phase.

```
You → /bmad-init → Orchestrator → Spawns agents → Manages workflow → Ships product
```

The Orchestrator:
- ✅ Spawns specialized agents at the right time
- ✅ Manages phase transitions and quality gates
- ✅ Coordinates parallel work (3 parallelization points)
- ✅ Tracks progress through all phases
- ✅ Never writes code (only manages agents)

### The 12-Agent Team

| Agent | Role | Model | Phase |
|-------|------|-------|-------|
| **Orchestrator** | Team lead, coordinates all agents | Opus | All phases |
| **Business Analyst** | Requirements discovery, product brief | Sonnet | Phase 1 |
| **Product Manager** | PRD creation, feature specs | Sonnet | Phase 2 |
| **UX Designer** | Wireframes, user flows | Sonnet | Phase 2 |
| **System Architect** | Technical design, ADRs | Opus | Phase 3 |
| **Scrum Master** | Epic creation, sprint planning | Sonnet | Phase 4 |
| **Story Writers** | Convert epics to stories (1 per epic) | Sonnet | Phase 4b |
| **Frontend Developer** | UI implementation, components | Sonnet | Phase 5 |
| **Backend Developer** | API, business logic | Sonnet | Phase 5 |
| **Database Engineer** | Schema, migrations, queries | Sonnet | Phase 5 |
| **QA Engineer** | Test plans, validation | Sonnet | Phase 6 |
| **DevOps Engineer** | Deployment configs, CI/CD | Sonnet | Phase 7 |
| **Tech Lead** | Final review, ship decision | Opus | Phase 8 |

### The 8-Phase Workflow

The workflow progresses through 8 phases with 3 parallelization points for maximum efficiency:

#### Phase 1: Discovery (Single Agent)
**Orchestrator spawns**: 1 subagent (Business Analyst)
**Parallel**: ❌ No

```
Business Analyst:
  - Asks clarifying questions about your project
  - Analyzes requirements and constraints
  - Creates user personas
  - Writes docs/product-brief.md
```

**Output**: `docs/product-brief.md`

---

#### Phase 2: Planning (Parallel - 2 Agents)
**Orchestrator spawns**: 2 parallel subagents (PM + UX Designer)
**Parallel**: ✅ Yes - Both work simultaneously

```
Product Manager                    UX Designer
  - Reads product brief              - Reads product brief
  - Defines features                 - Designs user flows
  - Writes acceptance criteria       - Creates wireframes
  - Creates docs/prd.md              - Creates docs/ux-wireframes.md

Both complete at the same time →
```

**Output**: `docs/prd.md` + `docs/ux-wireframes.md`

**Why Parallel?** PM focuses on *what* to build, UX focuses on *how users interact*. No dependencies.

---

#### Phase 3: Architecture (Single Agent)
**Orchestrator spawns**: 1 subagent (System Architect)
**Parallel**: ❌ No (needs full context from both PM and UX)

```
System Architect:
  - Reads PRD + UX wireframes
  - Designs technical architecture
  - Selects technology stack
  - Creates docs/naming-registry.md ⭐ (single source of truth for ALL naming)
  - Writes docs/architecture.md
  - Writes docs/adrs/ADR-*.md (Architecture Decision Records)
  - Self-evaluates with Solutioning Gate checklist
```

**Output**:
- `docs/architecture.md`
- `docs/naming-registry.md` (database, API, types, routes, components - all names)
- `docs/adrs/ADR-*.md`

**QUALITY GATE**: Must score ≥90/100 on completeness rubric

---

#### Phase 4: Epic Creation (Single Agent)
**Orchestrator spawns**: 1 subagent (Scrum Master)
**Parallel**: ❌ No (needs holistic view)

```
Scrum Master:
  - Groups PRD features into Epics
  - Assigns story number ranges per epic (prevents conflicts)
  - Defines track distribution (Database → Backend → Frontend)
  - Creates docs/epics/EPIC-001.md, EPIC-002.md, etc.
  - Writes docs/sprint-plan.md
```

**Output**: `docs/epics/EPIC-*.md` + `docs/sprint-plan.md`

**Example Epic**:
```markdown
EPIC-001: User Authentication
  Story Range: STORY-001 to STORY-099
  Track Distribution:
    - Database: users table, sessions table
    - Backend: /api/auth/register, /api/auth/login
    - Frontend: LoginPage, RegisterPage, AuthProvider
```

---

#### Phase 4b: Story Writing (Parallel - N Agents, One Per Epic!)
**Orchestrator spawns**: N parallel subagents (N = number of epics)
**Parallel**: ✅ Yes - One story-writer agent per epic

```
Story Writer 1          Story Writer 2          Story Writer 3
  (EPIC-001)              (EPIC-002)              (EPIC-003)
     ↓                        ↓                        ↓
Creates STORY-001      Creates STORY-100      Creates STORY-200
Creates STORY-002      Creates STORY-101      Creates STORY-201
Creates STORY-003      Creates STORY-102      Creates STORY-202
     ...                     ...                     ...

All story writers check docs/naming-registry.md for consistency →
All complete at the same time →
```

**Output**: `docs/stories/STORY-*.md` (all stories for all epics)

**Why Parallel?** Each epic is independent. Story number ranges prevent collisions.

**Example Story**:
```markdown
# STORY-001: Create users database table
Track: Database
Depends On: None
Blocks: STORY-003 (Backend needs this table)

## Naming Registry References (from docs/naming-registry.md)
- Table: users (snake_case - Section 1)
- Columns: id, email, password_hash, created_at, updated_at

## Tasks
- [ ] Create migration file
- [ ] Add email uniqueness constraint
- [ ] Add indexes
- [ ] Write seed data
```

---

#### Phase 5: Implementation (Agent Team - 3 Developers in Parallel!)
**Orchestrator spawns**: Agent Team (Database + Backend + Frontend)
**Parallel**: ✅ Yes - All 3 developers work simultaneously

This is the **most complex phase** with true parallel coordination:

```
Database Engineer          Backend Developer         Frontend Developer
     ↓                           ↓                          ↓
Claims Database stories    Waits for Database      Waits for Backend
Checks naming registry     Checks naming registry  Checks naming registry
     ↓                           ↓                          ↓
Implements STORY-001       Starts STORY-003        Starts STORY-006
  - Creates users table      - Register endpoint       - RegisterForm
  - Commits each task        - Uses users.email        - Calls /api/auth/register
  - Updates naming registry  - Maps to camelCase       - Form: name="email"
  - Records SHAs in story    - Updates registry        - Updates registry
  - Pushes                   - Pushes                  - Pushes
     ↓                           ↓                          ↓
Implements STORY-002       Implements STORY-004    Implements STORY-007
  - Creates sessions table   - Login endpoint          - LoginPage
     ↓                           ↓                          ↓
     ... continues ...           ... continues ...         ... continues ...

ALL THREE WORKING IN PARALLEL! →
```

**How They Coordinate**:
1. All read `docs/naming-registry.md` BEFORE starting
2. Stories have "Depends On" field (enforces execution order)
3. Database stories have no dependencies (run first)
4. Backend stories depend on Database
5. Frontend stories depend on Backend
6. Each task = 1 git commit with SHA recorded in story file
7. Each completed story = 1 git push

**Output**:
- `src/` - All implementation code
- `tests/` - All test files
- Updated `docs/naming-registry.md`
- All story files with git commit SHAs

**Example Parallel Timeline**:
```
Time 0:00
├─ Database Engineer starts STORY-001 (users table)
├─ Backend Developer waits (blocked)
└─ Frontend Developer waits (blocked)

Time 0:15
├─ Database Engineer completes STORY-001 ✅
│   → Updates naming-registry.md with users.email
├─ Backend Developer starts STORY-003 (register endpoint)
│   → Reads naming-registry.md: users.email → API email
└─ Frontend Developer still waits

Time 0:30
├─ Database Engineer starts STORY-002 (sessions table)
├─ Backend Developer completes STORY-003 ✅
│   → Updates naming-registry.md with POST /api/auth/register
└─ Frontend Developer starts STORY-006 (RegisterForm)
    → Reads naming-registry.md for API contract

Time 0:45
ALL THREE WORKING IN PARALLEL NOW! ⚡
```

**Naming Consistency Example**:
```
Database Column → API Field → TypeScript Type → Form Input
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
users.email     → email      → email: string   → <input name="email" />
users.created_at → createdAt → createdAt: string → "Joined: Feb 19"
```

---

#### Phase 6: Quality Assurance (Single Agent)
**Orchestrator spawns**: 1 subagent (QA Engineer)
**Parallel**: ❌ No (needs to test everything)

```
QA Engineer:
  - Reads all stories and acceptance criteria
  - Runs all unit, integration, and E2E tests
  - Validates all PRD acceptance criteria met
  - Writes docs/test-plan.md with results
```

**Output**: `docs/test-plan.md`

**QUALITY GATE**: All tests must pass

---

#### Phase 7: Deployment (Single Agent)
**Orchestrator spawns**: 1 subagent (DevOps Engineer)
**Parallel**: ❌ No

```
DevOps Engineer:
  - Reads architecture
  - Creates CI/CD pipelines
  - Configures environments (dev, staging, production)
  - Writes docs/deploy-config.md
```

**Output**: `docs/deploy-config.md`

---

#### Phase 8: Final Review (Single Agent)
**Orchestrator spawns**: 1 subagent (Tech Lead)
**Parallel**: ❌ No (needs full context)

```
Tech Lead:
  - Reviews ALL code
  - Checks architecture compliance
  - Verifies test coverage
  - Audits security
  - Reviews naming consistency (via naming-registry.md)
  - Writes docs/review-checklist.md
  - Gives verdict: Ship ✅ / Ship with Notes ⚠️ / Do Not Ship ❌
```

**Output**: `docs/review-checklist.md`

**QUALITY GATE**: Ship/No-Ship decision

---

### Parallel Work Summary

| Phase | Agents | Mode | Parallel? | Coordination Method |
|-------|--------|------|-----------|-------------------|
| 1: Discovery | Business Analyst | Subagent | ❌ No | N/A |
| 2: Planning | PM + UX Designer | Subagent | ✅ Yes (2) | Independent work |
| 3: Architecture | System Architect | Subagent | ❌ No | Needs full context |
| 4: Epic Creation | Scrum Master | Subagent | ❌ No | Holistic view needed |
| 4b: Story Writing | N Story Writers | Subagent | ✅ Yes (N) | Story number ranges |
| 5: Implementation | DB + Backend + Frontend | **Agent Team** | ✅ Yes (3) | Naming registry + Dependencies |
| 6: QA | QA Engineer | Subagent | ❌ No | Tests everything |
| 7: Deployment | DevOps Engineer | Subagent | ❌ No | Single config |
| 8: Final Review | Tech Lead | Subagent | ❌ No | Holistic audit |

### Subagent vs Agent Teams

#### Subagent Spawning (Claude Code's Task Tool)
**Used in**: Phases 1, 2, 3, 4, 4b, 6, 7, 8

Agents work independently and communicate via documents:
- Each agent is spawned separately
- No shared memory between agents
- Documents (files) are the communication method
- Orchestrator manages handoffs

**Example (Phase 2)**:
```javascript
// Orchestrator spawns PM and UX in parallel
await Promise.all([
  spawnSubagent('product-manager'),
  spawnSubagent('ux-designer')
]);
// Both read product-brief.md, write their outputs
```

#### Agent Teams (Claude Code's Experimental Feature)
**Used in**: Phase 5 only (Implementation)

Multiple agents coordinate on shared work:
- 3 agents work in same session (Database + Backend + Frontend)
- Share access to story files and naming registry
- Coordinate via dependencies and naming consistency
- All work on same codebase simultaneously

**Example (Phase 5)**:
```javascript
// Orchestrator spawns agent team
spawnAgentTeam({
  agents: ['database-engineer', 'backend-developer', 'frontend-developer'],
  sharedContext: {
    stories: 'docs/stories/*.md',
    namingRegistry: 'docs/naming-registry.md'
  }
});
// All 3 claim stories, implement in parallel, coordinate via registry
```

### Document-Driven Relay

Agents communicate through documents, not shared memory:

```
product-brief.md → prd.md + ux-wireframes.md → architecture.md + naming-registry.md + adrs/
  → epics/ → stories/ → src/ + tests/ + updated naming-registry.md
  → test-plan.md → deploy-config.md → review-checklist.md
```

**The Naming Registry** (`docs/naming-registry.md`) is the key to parallel work:
- Created by System Architect in Phase 3
- Contains ALL naming decisions (database, API, types, routes, components)
- Checked by ALL developer agents before creating entities
- Updated by ALL developer agents after implementation
- Prevents naming conflicts across layers

**Example Naming Registry Entry**:
```markdown
### Cross-Reference Mapping: User Registration

| Layer | Name | Type | Notes |
|-------|------|------|-------|
| Database | users.email | VARCHAR(255) | User email column |
| API | POST /api/auth/register | Endpoint | Registration |
| API | { email: "..." } | JSON field | Request body |
| Type | RegisterRequest.email | string | TypeScript type |
| Frontend | <input name="email" /> | Input | Form field |
| State | const [email, setEmail] | useState | React state |
```

Each agent:
1. Reads artifacts from previous phases
2. **Checks naming-registry.md for consistency**
3. Performs specialized work
4. Writes structured outputs
5. **Updates naming-registry.md with new entities**
6. Hands off to next agent or works in parallel

## Slash Commands

| Command | Description |
|---------|-------------|
| `/bmad-init` | Initialize project structure and agent team |
| `/bmad-status` | Show current phase and progress |
| `/bmad-next` | Advance to next phase (with gate checks) |
| `/bmad-gate` | Run quality gate check for current phase |
| `/bmad-sprint` | Begin implementation sprint (Phase 5) |
| `/bmad-track` | Show project tracker dashboard |
| `/bmad-review` | Trigger final Tech Lead review |
| `/bmad-help` | Get contextual help and guidance |

## Project Structure After Installation

```
your-project/
├── .claude/
│   ├── agents/           # 12 agent definitions (*.md)
│   ├── commands/         # 8 slash commands (*.md)
│   └── settings.json     # Agent Teams enabled
├── docs/
│   ├── product-brief.md  # Phase 1 output
│   ├── prd.md            # Phase 2 output
│   ├── ux-wireframes.md  # Phase 2 output
│   ├── architecture.md   # Phase 3 output
│   ├── adrs/             # Architecture Decision Records
│   ├── epics/            # EPIC-001.md, EPIC-002.md, ...
│   ├── stories/          # STORY-001.md, STORY-002.md, ...
│   ├── sprint-plan.md    # Phase 4 output
│   ├── test-plan.md      # Phase 6 output
│   ├── deploy-config.md  # Phase 7 output
│   └── review-checklist.md # Phase 8 output
├── src/                  # Your application code
├── tests/                # Test files
├── templates/            # Document templates
├── scripts/              # Helper scripts
└── CLAUDE.md             # Project context for Claude
```

## Git Workflow

During Phase 5 (Implementation), developers follow strict git discipline:

1. **Create sprint branch**: `git checkout -b sprint/sprint-1`
2. **One commit per task**: Each task checkbox in a story = 1 commit
3. **Commit format**: `[STORY-NNN] task: description`
4. **SHA tracking**: Commit SHA recorded next to task in story file
5. **Push per story**: When all tasks complete, `git push origin sprint/sprint-1`
6. **Merge on sprint completion**: `git merge sprint/sprint-1` into `develop`

Example story file with git tracking:

```markdown
## Tasks
- [x] Create user model schema (commit: a1b2c3d)
- [x] Add email validation (commit: e4f5g6h)
- [x] Write migration file (commit: i7j8k9l)
- [ ] Add unit tests

## Git Commits
| SHA | Message | Date |
|-----|---------|------|
| a1b2c3d | [STORY-001] task: Create user model schema | 2024-01-15 |
| e4f5g6h | [STORY-001] task: Add email validation | 2024-01-15 |
| i7j8k9l | [STORY-001] task: Write migration file | 2024-01-15 |
```

## Quality Gates

### Solutioning Gate (Phase 3)

Before proceeding to Sprint Planning, the architecture must score ≥90/100 on:
- All PRD features have technical approach
- Data model covers all entities
- API endpoints cover all features
- Security model is defined
- Testing strategy is concrete
- Performance targets are set
- Deployment approach is defined
- Error handling is standardized
- Tech stack choices have rationale (ADRs)
- Project structure is clear

### QA Gate (Phase 6)

All tests must pass before deployment planning.

### Ship/No-Ship Gate (Phase 8)

Tech Lead reviews:
- Code quality
- Architecture compliance
- Test coverage
- Security posture
- Performance benchmarks
- Documentation completeness

Verdict: **Ship** | **Ship with Notes** | **Do Not Ship**

## Advanced Usage

### Customizing Agents

Edit agent definitions in `.claude/agents/*.md` to customize:
- Model selection (sonnet, opus, haiku)
- Agent instructions
- Output formats
- Quality criteria

### Customizing Workflows

Edit commands in `.claude/commands/*.md` to adjust:
- Phase transitions
- Quality gate thresholds
- Document templates
- Git workflows

### Integrating with Existing Projects

BMad Method works with existing codebases. Just run `/bmad-init` and describe what you want to add/change. The agents will:
1. Analyze existing code structure
2. Propose changes that fit your patterns
3. Maintain consistency with your conventions

## Documentation

- **[USAGE-GUIDE.md](USAGE-GUIDE.md)** - Detailed usage instructions
- **[WORKED-EXAMPLE.md](WORKED-EXAMPLE.md)** - Complete example project walkthrough
- **[ADVANCED-CONFIG.md](ADVANCED-CONFIG.md)** - Advanced configuration options
- **[BMAD-COMPLETE-REFERENCE.md](BMAD-COMPLETE-REFERENCE.md)** - Full reference documentation

## Requirements

- **Claude Code CLI**: Install with `npm install -g @anthropic-ai/claude-code`
- **Agent Teams Feature**: Set `export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- **Node.js**: v18 or higher (for installation)
- **Git**: For version control and task tracking

## Comparison to Official BMad Method

This extension is inspired by the [official BMad Method](https://github.com/bmad-code-org/BMAD-METHOD) and adapted specifically for Claude Code's Agent Teams capability:

| Feature | Official BMad | This Extension |
|---------|---------------|----------------|
| Installation | `npx bmad-method install` | `npx @bmad-code/agent-teams install` |
| Platform | CLI-agnostic | Claude Code specific |
| Agent System | Flexible (multi-platform) | Claude Code subagent spawn |
| Party Mode | ✅ Multi-agent chat | ✅ Parallel agent teams |
| Epic-Story Hierarchy | ✅ | ✅ |
| Git Task Tracking | ✅ | ✅ |
| Quality Gates | ✅ | ✅ |

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Credits

- Inspired by the [BMad Method](https://github.com/bmad-code-org/BMAD-METHOD)
- Built for [Claude Code](https://claude.ai/code) by Anthropic
- Integration approach learned from [BMAD_Openclaw](https://github.com/ErwanLorteau/BMAD_Openclaw)

## Support

- **Issues**: [GitHub Issues](https://github.com/bmad-code-org/bmad-agent-teams/issues)
- **Discussions**: [GitHub Discussions](https://github.com/bmad-code-org/bmad-agent-teams/discussions)
- **Documentation**: See [USAGE-GUIDE.md](USAGE-GUIDE.md)

---

**Ready to ship production software with AI?**

```bash
npx @bmad-code/agent-teams install
cd your-project && claude
/bmad-init
```

Let the 12-agent team handle the rest. 🚀
