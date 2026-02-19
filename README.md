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

```
Phase 1: Discovery
  └─ Business Analyst → docs/product-brief.md

Phase 2: Planning (PARALLEL)
  ├─ Product Manager → docs/prd.md
  └─ UX Designer → docs/ux-wireframes.md

Phase 3: Architecture
  └─ System Architect → docs/architecture.md + docs/adrs/
      └─ QUALITY GATE: 90% completeness required

Phase 4: Epic Creation
  └─ Scrum Master → docs/epics/EPIC-*.md + docs/sprint-plan.md

Phase 4b: Story Writing (PARALLEL — one agent per epic!)
  └─ Story Writers → docs/stories/STORY-*.md

Phase 5: Implementation (PARALLEL Agent Team)
  ├─ Frontend Developer → src/components/, src/app/
  ├─ Backend Developer → src/api/, src/lib/
  └─ Database Engineer → src/db/, migrations/
      └─ Git: commit per task, push per story

Phase 6: Quality Assurance
  └─ QA Engineer → docs/test-plan.md + test execution
      └─ QUALITY GATE: All tests must pass

Phase 7: Deployment
  └─ DevOps Engineer → docs/deploy-config.md

Phase 8: Final Review
  └─ Tech Lead → docs/review-checklist.md
      └─ VERDICT: Ship / Ship with Notes / Do Not Ship
```

### Document-Driven Relay

Agents communicate through documents, not shared memory:

```
product-brief.md → prd.md + ux-wireframes.md → architecture.md + adrs/
  → epics/ → stories/ → src/ + tests/ → test-plan.md → deploy-config.md
  → review-checklist.md
```

Each agent:
1. Reads artifacts from previous phases
2. Performs specialized work
3. Writes structured outputs
4. Hands off to next agent

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
