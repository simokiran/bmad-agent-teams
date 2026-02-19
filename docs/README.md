# Plugin Development Documentation

This `docs/` folder contains **development documentation for the BMad Agent Teams plugin itself**.

## ⚠️ Important Distinction

### This `docs/` Folder (Plugin Repository)

**Purpose**: Documentation ABOUT the plugin's architecture and design

**Contents**:
- `architecture-diagram.mermaid` - Visual diagram of the BMad Method workflow
- This README explaining the folder structure

**Audience**: Plugin developers and contributors

**Location**: `bmad-agent-teams/docs/` (this repository)

---

### The `docs/` Folder (Target Projects)

**Purpose**: Documentation FOR user projects built with BMad Method

**Contents** (created by `/bmad-init`):
- `product-brief.md` - Phase 1 output
- `prd.md` - Phase 2 output
- `ux-wireframes.md` - Phase 2 output
- `architecture.md` - Phase 3 output
- `adrs/` - Architecture Decision Records
- `epics/` - Epic files (EPIC-001.md, etc.)
- `stories/` - Story files (STORY-001.md, etc.)
- `sprint-plan.md` - Phase 4 output
- `test-plan.md` - Phase 6 output
- `deploy-config.md` - Phase 7 output
- `review-checklist.md` - Phase 8 output
- `project-tracker.md` - Live project dashboard

**Audience**: Project teams using BMad Method

**Location**: `your-project/docs/` (user's project after installation)

---

## Plugin Documentation Files

For plugin development documentation, see:

- **[DEVELOPMENT.md](../DEVELOPMENT.md)** - Development guide for contributors
- **[CHANGELOG.md](../CHANGELOG.md)** - Version history and release notes
- **[ROADMAP.md](../ROADMAP.md)** - Future features and plans
- **[CONTRIBUTING.md](../CONTRIBUTING.md)** - How to contribute
- **[README.md](../README.md)** - User-facing documentation

---

## Architecture Diagram

The Mermaid diagram in this folder visualizes the BMad Method workflow:

```
User → Orchestrator → Phase 1-8 → Ship
```

To view the diagram:
1. Install Mermaid CLI: `npm install -g @mermaid-js/mermaid-cli`
2. Generate image: `mmdc -i architecture-diagram.mermaid -o architecture.png`
3. Or view in GitHub (renders automatically)
4. Or use any Mermaid viewer/extension

---

## Adding Plugin Documentation

When adding new plugin documentation:

1. **Design docs**: Place in this `docs/` folder
2. **User guides**: Place in root (USAGE-GUIDE.md, etc.)
3. **Code docs**: Place inline in agent/command files
4. **API docs**: Place in root (API.md when we have one)

---

**Last Updated**: February 19, 2024
