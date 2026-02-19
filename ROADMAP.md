# BMad Agent Teams Roadmap

This document outlines the planned features and improvements for the BMad Agent Teams plugin.

## Current Status: v1.0.0 (Initial Release)

**Release Date**: February 19, 2026
**Status**: ✅ Complete and ready for use

### What's Included in v1.0.0

- ✅ 13 specialized AI agents (incl. Mobile Developer)
- ✅ 8-phase structured workflow
- ✅ 8 slash commands
- ✅ Epic-Story hierarchy
- ✅ Git SHA tracking per task
- ✅ Quality gates
- ✅ Parallel agent execution (4 developers work simultaneously)
- ✅ **Naming Registry System** (unified DB/API/Types/Frontend/Mobile naming)
- ✅ **Claude Code Skills Integration** (agents invoke /wordpress, /react, etc.)
- ✅ npm package with CLI
- ✅ Comprehensive documentation

### What Makes Our Implementation Unique

- **Naming Registry**: Single source of truth preventing naming conflicts across stack layers
- **Skills-Aware Agents**: All developers can invoke Claude Code skills and customize output
- **Mobile-First**: Dedicated Mobile Developer agent (React Native, Flutter, SwiftUI, Kotlin)
- **Granular Git Tracking**: Every task = 1 commit with SHA recorded in story file
- **Parallel Coordination**: 4 specialized developers work in parallel with naming registry preventing conflicts

---

## Short-Term Goals (v1.1.0 - v1.3.0)

### v1.1.0 - Original BMAD-METHOD Features (Q2 2026)

**Focus**: Adopt best features from original BMAD-METHOD

> See [ENHANCEMENT-ROADMAP.md](docs/ENHANCEMENT-ROADMAP.md) and [COMPARISON-WITH-ORIGINAL.md](docs/COMPARISON-WITH-ORIGINAL.md) for detailed analysis

#### Priority 1 Features (High Impact, Medium Effort)

- [ ] **Interactive Help System** (`/bmad-help`)
  - Contextual guidance at any phase
  - "What do I do next?" support
  - Follow-up questions enabled
  - Workflow navigation assistance
  - **Impact**: Users never stuck or confused
  - **Effort**: Medium (new skill + context awareness)

- [ ] **Quick Flow Workflows** (Simple Projects)
  - `/bmad-quick-spec` — Fast specification (PRD + Architecture combined)
  - `/bmad-quick-dev` — Single agent handles all development tracks
  - New agent: `quick-flow-solo-dev.md`
  - Auto-detect project complexity (< 5 stories = quick flow suggested)
  - **Impact**: 80% faster for MVPs and prototypes
  - **Effort**: Medium (new workflow + agent)

- [ ] **Tech Writer Agent**
  - Creates user-facing documentation (README, user guides, API reference)
  - Runs in Phase 2 (initial docs) and Phase 6 (post-QA refinement)
  - Outputs: README.md, docs/api-reference.md, docs/user-guide.md
  - **Impact**: Professional docs without developer overhead
  - **Effort**: Low (new agent, similar to existing ones)

- [ ] **Research Modules** (Phase 1 Enhancement)
  - `/bmad-research-market` — Competitor analysis via WebSearch
  - `/bmad-research-domain` — Domain terminology and standards
  - `/bmad-research-technical` — Tech stack options and best practices
  - Enhances Business Analyst agent
  - **Impact**: Data-driven product brief instead of assumptions
  - **Effort**: Medium (extend Business Analyst with research workflows)

#### Developer Experience Improvements

- [ ] Better error messages with recovery suggestions
- [ ] Progress indicators for long-running agents
- [ ] Interrupt/resume agent support
- [ ] Template hot-reloading during development

**Target**: April 2026

---

### v1.2.0 - Adaptive Workflows & Quality (Q3 2026)

**Focus**: Workflow flexibility and quality gates

#### Priority 2 Features (High Impact, High Effort)

- [ ] **Adaptive Complexity Scaling**
  - Auto-detect project size from product brief
  - SIMPLE (< 5 features) → Quick Flow
  - MEDIUM (5-15 features) → Standard Flow (current)
  - COMPLEX (15+ features) → Enterprise Flow (+ research, formal reviews)
  - **Impact**: Right-sized process for every project
  - **Effort**: High (complexity detection algorithm + workflow switching)

- [ ] **Course Correction** (`/bmad-correct-course`)
  - Mid-project pivot support
  - Impact analysis on existing stories/epics
  - Options: update PRD, create new epic, deprecate stories
  - Re-run affected phases (re-architect, re-sprint-plan)
  - **Impact**: Support agile adaptation to changing requirements
  - **Effort**: High (state analysis + re-planning logic)

- [ ] **Code Review Workflow** (Per-Story)
  - Tech Lead reviews each story after completion (not just final review)
  - Reviews: commits, naming registry compliance, security, test coverage
  - Feedback loop: ✅ Approved or ⚠️ Changes Requested
  - **Impact**: Catch issues early, improve code quality
  - **Effort**: Medium (extend Tech Lead agent with per-story review)

#### Multi-Sprint Support

- [ ] **Multiple Sprint Support**
  - Sprint backlog management
  - Sprint 1, 2, 3, ... tracking
  - Story carry-over between sprints
  - Sprint retrospectives

- [ ] **Epic Dependencies**
  - Define epic → epic dependencies
  - Automatic story ordering based on dependencies
  - Dependency graph visualization

- [ ] **Velocity Tracking**
  - Story point estimation
  - Velocity calculation per sprint
  - Burndown charts
  - ETA predictions

#### Improvements
- [ ] Better story assignment to developers
- [ ] Automatic epic sizing
- [ ] Sprint planning wizard

**Target**: July 2026

---

### v1.3.0 - Documentation & Validation (Q4 2026)

**Focus**: Documentation quality and validation

#### Priority 3 Features (Medium Impact, Low Effort)

- [ ] **Document Validation Workflow** (`/bmad-validate-doc`)
  - Validate PRD: all sections present, acceptance criteria clear, no ambiguous language
  - Validate Architecture: tech stack complete, ADRs referenced, security/performance quantified
  - Validate Stories: user story format, testable ACs, valid dependencies, atomic tasks
  - **Impact**: Document quality gates prevent downstream issues
  - **Effort**: Low (validation rules + checker skill)

- [ ] **Mermaid Diagram Generation** (`/bmad-mermaid`)
  - Generate system architecture (C4 model), database ERD, API flows
  - Generate user flow diagrams, sprint workflow, git branching strategy
  - Output: docs/diagrams/*.mmd files
  - **Impact**: Visual diagrams improve comprehension
  - **Effort**: Low (Mermaid syntax generation)

- [ ] **Project Context Generation** (`/bmad-context`)
  - Generate docs/PROJECT-CONTEXT.md summarizing project state
  - Includes: tech stack, architecture decisions, naming conventions, sprint status
  - Use case: onboarding, resuming after context loss, sharing with external AI
  - **Impact**: One file explains entire project
  - **Effort**: Low (aggregate existing docs)

#### Enterprise Integration

- [ ] **GitHub Integration**
  - Automatic issue creation from stories
  - PR creation and linking
  - Status sync between BMad and GitHub Projects
  - Commit linking to story files

- [ ] **Jira Integration**
  - Bidirectional sync with Jira
  - Epic → Jira Epic mapping
  - Story → Jira Story mapping
  - Sprint board sync

- [ ] **Slack Notifications**
  - Phase completion alerts
  - Quality gate status
  - Deploy notifications
  - Tech Lead verdict announcements

#### Improvements
- [ ] Custom Quality Gates (user-defined criteria)
- [ ] Agent Model Auto-Selection (cost/speed optimization)
- [ ] Audit Logging (full agent decision trail)

**Target**: October 2026

---

## Mid-Term Goals (v2.0.0 - v2.5.0)

### v2.0.0 - Visual Dashboard (Q1 2025)

**Focus**: Web-based project visualization

#### Features
- [ ] **Web Dashboard**
  - Real-time project status
  - Epic → Story → Task hierarchy view
  - Gantt chart view
  - Agent activity monitor
  - Git commit visualization

- [ ] **Live Collaboration**
  - Multiple users watching same project
  - Real-time updates
  - Chat with agents
  - Team annotations

- [ ] **Analytics**
  - Project health score
  - Agent performance metrics
  - Time to ship analytics
  - Code quality trends

**Target**: January 2025

---

### v2.1.0 - AI Enhancements (Q2 2025)

**Focus**: Smarter agents

#### Features
- [ ] **Agent Learning**
  - Learn from past projects
  - Pattern recognition
  - Automatic best practice suggestions
  - Custom agent training

- [ ] **Proactive Agents**
  - Agents suggest improvements
  - Detect potential issues early
  - Recommend refactoring
  - Security vulnerability scanning

- [ ] **Agent Collaboration**
  - Agents can communicate directly
  - Conflict resolution between agents
  - Consensus building
  - Peer review system

**Target**: April 2025

---

### v2.2.0 - Platform Expansion (Q3 2025)

**Focus**: Support more platforms

#### Features
- [ ] **VS Code Extension**
  - Sidebar integration
  - In-editor agent commands
  - Inline story viewing
  - Git integration

- [ ] **JetBrains Plugin**
  - IntelliJ IDEA
  - PyCharm
  - WebStorm
  - PhpStorm

- [ ] **Web IDE Support**
  - GitHub Codespaces
  - Gitpod
  - Replit
  - CodeSandbox

**Target**: July 2025

---

## Long-Term Vision (v3.0.0+)

### v3.0.0 - Plugin Marketplace (2026)

**Goal**: Community-driven ecosystem

#### Features
- [ ] **Agent Marketplace**
  - Publish custom agents
  - Download community agents
  - Agent reviews and ratings
  - Paid agent marketplace

- [ ] **Template Marketplace**
  - Industry-specific templates
  - Company template libraries
  - Template versioning
  - Template dependencies

- [ ] **Workflow Marketplace**
  - Custom workflow definitions
  - Industry best practices
  - Regulatory compliance workflows
  - Team-specific workflows

---

### v3.1.0 - AI Autonomy (2026)

**Goal**: Fully autonomous development

#### Features
- [ ] **End-to-End Automation**
  - From idea to deployed product
  - Minimal human intervention
  - Self-healing code
  - Automatic refactoring

- [ ] **Intelligent Planning**
  - AI-driven architecture decisions
  - Technology stack recommendations
  - Cost optimization
  - Performance optimization

- [ ] **Production Monitoring**
  - Live error detection
  - Automatic bug fixes
  - Performance tuning
  - Security patching

---

## Community Requests

### Most Requested Features

Track community feature requests here as they come in:

1. [ ] **Custom phases** - Add/remove phases from workflow
2. [ ] **Agent customization UI** - Visual editor for agent prompts
3. [ ] **Story templates** - More story template options
4. [ ] **Multiple language support** - Non-English documentation
5. [ ] **Offline mode** - Work without internet connection

### Vote on Features

Users can vote on features via:
- GitHub Discussions: [Feature Requests](https://github.com/bmad-code-org/bmad-agent-teams/discussions/categories/feature-requests)
- GitHub Issues: [Enhancement Label](https://github.com/bmad-code-org/bmad-agent-teams/labels/enhancement)

---

## Development Principles

### What Guides This Roadmap

1. **User Value First**: Features must solve real problems
2. **Quality Over Speed**: Ship when ready, not when scheduled
3. **Backward Compatibility**: Don't break existing projects
4. **Community Driven**: Listen to user feedback
5. **Open Source**: Keep the core free and open

### What We Won't Build

- **Closed Source Features**: Core stays open source
- **Vendor Lock-in**: No proprietary formats
- **Data Collection**: No telemetry without opt-in
- **Breaking Changes**: Avoid major version bumps

---

## How to Influence the Roadmap

### Ways to Contribute

1. **Use the Plugin**: Real-world usage informs priorities
2. **Report Issues**: Bug reports help us improve
3. **Request Features**: Tell us what you need
4. **Submit PRs**: Code contributions accelerate development
5. **Spread the Word**: More users = more resources

### Priority Factors

Features are prioritized based on:
- **User demand** (votes, comments)
- **Implementation effort** (time, complexity)
- **Strategic fit** (alignment with vision)
- **Community contributions** (PRs, sponsorship)

---

## Versioning Strategy

### Semantic Versioning

- **Major (X.0.0)**: Breaking changes, major new features
- **Minor (1.X.0)**: New features, backward compatible
- **Patch (1.0.X)**: Bug fixes, documentation

### Release Cadence

- **Patch releases**: As needed (bug fixes)
- **Minor releases**: Quarterly (new features)
- **Major releases**: Yearly (significant changes)

---

## Get Involved

Want to help shape the future of BMad Agent Teams?

- **Contribute**: See [CONTRIBUTING.md](CONTRIBUTING.md)
- **Discuss**: [GitHub Discussions](https://github.com/bmad-code-org/bmad-agent-teams/discussions)
- **Sponsor**: Support development (coming soon)
- **Spread the Word**: Share with your team

---

**Last Updated**: February 19, 2024
**Next Review**: May 2024

*This roadmap is subject to change based on community feedback and development resources.*
