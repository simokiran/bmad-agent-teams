# Changelog

All notable changes to the BMad Agent Teams plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- npm package publishing
- Example project repository
- Video tutorial
- VS Code extension integration
- Webhook support for external tools
- Custom agent templates

## [1.0.0] - 2024-02-19

### Added - Initial Release

#### Core Plugin
- ✅ 12 specialized AI agents (Orchestrator, Business Analyst, PM, UX Designer, Architect, Scrum Master, Frontend/Backend/DB Developers, QA, DevOps, Tech Lead)
- ✅ 8 slash commands (/bmad-init, /bmad-status, /bmad-next, /bmad-gate, /bmad-sprint, /bmad-track, /bmad-review, /bmad-help)
- ✅ 8-phase structured workflow (Discovery → Planning → Architecture → Sprint Planning → Implementation → QA → Deployment → Review)
- ✅ Agent Teams integration for parallel execution
- ✅ Document-driven relay architecture

#### Installation
- ✅ npm package structure with CLI support
- ✅ `npx @bmad-code/agent-teams install` command
- ✅ Manual installation via install.sh script
- ✅ Support for installation flags (--yes, --force)
- ✅ Environment variable support (BMAD_FORCE, BMAD_AUTO_YES)

#### Features
- ✅ Epic-Story hierarchy (PRD features → Epics → Stories)
- ✅ Git task tracking (commit per task, SHA recording)
- ✅ Quality gates (90% architecture gate, QA gate, Tech Lead ship/no-ship)
- ✅ Parallel agent execution (Phase 2: PM+UX, Phase 4b: Story Writers, Phase 5: Dev Team)
- ✅ Live project tracking dashboard
- ✅ Sprint branch workflow

#### Documentation
- ✅ Comprehensive README.md
- ✅ USAGE-GUIDE.md with detailed instructions
- ✅ WORKED-EXAMPLE.md with complete walkthrough
- ✅ ADVANCED-CONFIG.md for customization
- ✅ BMAD-COMPLETE-REFERENCE.md (5,041 lines, 34 files documented)
- ✅ CONTRIBUTING.md for contributors
- ✅ MIT LICENSE

#### Templates
- ✅ Product Brief template
- ✅ Epic template
- ✅ Story template with git tracking
- ✅ ADR (Architecture Decision Record) template

#### Scripts
- ✅ Git automation scripts
- ✅ Orchestration helpers

### Technical Details
- Node.js >= 18.0.0
- Peer dependency: @anthropic-ai/claude-code >= 0.1.0
- Agent Teams experimental feature required
- CommonJS module format for broad compatibility

## Version History

### Versioning Strategy

- **Major (X.0.0)**: Breaking changes to agent definitions, command structure, or workflow
- **Minor (1.X.0)**: New agents, commands, or features that are backward compatible
- **Patch (1.0.X)**: Bug fixes, documentation updates, template improvements

### Upgrade Notes

#### 1.0.0
Initial release - no upgrade needed.

## Future Versions

### Planned for 1.1.0
- [ ] Agent model auto-selection based on task complexity
- [ ] Integration with GitHub Issues/Projects
- [ ] Jira integration for enterprise teams
- [ ] Slack notifications for phase completion
- [ ] Custom quality gate definitions
- [ ] Agent personality customization

### Planned for 1.2.0
- [ ] Multi-sprint support
- [ ] Epic dependencies and ordering
- [ ] Story point estimation
- [ ] Velocity tracking
- [ ] Burndown charts

### Planned for 2.0.0
- [ ] Visual project dashboard (web UI)
- [ ] Real-time collaboration mode
- [ ] Custom agent creation wizard
- [ ] Plugin marketplace for community agents
- [ ] Integration with popular project management tools

---

**Note**: Dates follow YYYY-MM-DD format. All changes are tracked in this file and in git commit history.
