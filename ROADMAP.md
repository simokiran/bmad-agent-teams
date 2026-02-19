# BMad Agent Teams Roadmap

This document outlines the planned features and improvements for the BMad Agent Teams plugin.

## Current Status: v1.0.0 (Initial Release)

**Release Date**: February 19, 2024
**Status**: ✅ Complete and ready for use

### What's Included in v1.0.0

- ✅ 12 specialized AI agents
- ✅ 8-phase structured workflow
- ✅ 8 slash commands
- ✅ Epic-Story hierarchy
- ✅ Git task tracking
- ✅ Quality gates
- ✅ Parallel agent execution
- ✅ npm package with CLI
- ✅ Comprehensive documentation

---

## Short-Term Goals (v1.1.0 - v1.3.0)

### v1.1.0 - Enhanced Integration (Q2 2024)

**Focus**: Better integration with development tools

#### Features
- [ ] **GitHub Integration**
  - Automatic issue creation from stories
  - PR creation and linking
  - Status sync between BMad and GitHub Projects
  - Commit linking to story files

- [ ] **Slack Notifications**
  - Phase completion alerts
  - Quality gate status
  - Deploy notifications
  - Tech Lead verdict announcements

- [ ] **Custom Quality Gates**
  - User-defined gate criteria
  - Custom scoring rubrics
  - Configurable pass/fail thresholds

- [ ] **Agent Model Auto-Selection**
  - Automatic model selection based on task complexity
  - Cost optimization mode (prefer sonnet over opus when possible)
  - Speed optimization mode (prefer haiku for simple tasks)

#### Improvements
- [ ] Better error messages
- [ ] Progress indicators for long-running agents
- [ ] Interrupt/resume agent support
- [ ] Template hot-reloading

**Target**: April 2024

---

### v1.2.0 - Multi-Sprint Support (Q3 2024)

**Focus**: Long-term project management

#### Features
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

- [ ] **Story Refinement**
  - Story splitting recommendations
  - Acceptance criteria validation
  - Story completeness scoring

#### Improvements
- [ ] Better story assignment to developers
- [ ] Automatic epic sizing
- [ ] Sprint planning wizard

**Target**: July 2024

---

### v1.3.0 - Enterprise Features (Q4 2024)

**Focus**: Enterprise team support

#### Features
- [ ] **Jira Integration**
  - Bidirectional sync with Jira
  - Epic → Jira Epic mapping
  - Story → Jira Story mapping
  - Sprint board sync

- [ ] **Multi-Team Support**
  - Team-specific agents
  - Cross-team dependencies
  - Team dashboards
  - Resource allocation

- [ ] **Custom Agent Templates**
  - Agent creation wizard
  - Agent template library
  - Community-shared agents
  - Agent versioning

- [ ] **Audit Logging**
  - Full audit trail of agent decisions
  - Phase transition logs
  - Quality gate evaluations
  - Git commit tracking

#### Improvements
- [ ] Role-based access control
- [ ] SSO integration
- [ ] Custom workflow phases

**Target**: October 2024

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
