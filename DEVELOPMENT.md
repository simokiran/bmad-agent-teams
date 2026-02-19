# Development Guide

This guide is for developers who want to contribute to or modify the BMad Agent Teams plugin.

## Table of Contents

1. [Development Setup](#development-setup)
2. [Project Structure](#project-structure)
3. [Testing the Plugin](#testing-the-plugin)
4. [Agent Development](#agent-development)
5. [Command Development](#command-development)
6. [Release Process](#release-process)
7. [Debugging](#debugging)

---

## Development Setup

### Prerequisites

```bash
# Required
node >= 18.0.0
npm >= 9.0.0
git >= 2.30.0

# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code

# Enable Agent Teams
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

### Clone and Setup

```bash
# Clone the repository
git clone https://github.com/bmad-code-org/bmad-agent-teams.git
cd bmad-agent-teams

# Install dependencies (if any)
npm install

# Link for local development
npm link
```

### Verify Installation

```bash
# Test the installer
./install.sh /tmp/bmad-test-project

# Or test via npx (using linked package)
cd /tmp/another-test
npx @bmad-code/agent-teams install
```

---

## Project Structure

```
bmad-agent-teams/
├── .claude/                  # Claude Code configuration
│   ├── agents/              # 12 agent definitions
│   │   ├── orchestrator.md
│   │   ├── analyst.md
│   │   ├── product-manager.md
│   │   ├── ux-designer.md
│   │   ├── architect.md
│   │   ├── scrum-master.md
│   │   ├── frontend-developer.md
│   │   ├── backend-developer.md
│   │   ├── database-engineer.md
│   │   ├── qa-engineer.md
│   │   ├── devops-engineer.md
│   │   └── tech-lead.md
│   ├── commands/            # 8 slash commands
│   │   ├── bmad-init.md
│   │   ├── bmad-status.md
│   │   ├── bmad-next.md
│   │   ├── bmad-gate.md
│   │   ├── bmad-sprint.md
│   │   ├── bmad-track.md
│   │   ├── bmad-review.md
│   │   └── bmad-help.md
│   └── settings.json        # Agent Teams config
├── templates/               # Document templates
│   ├── product-brief.md
│   ├── epic.md
│   ├── story.md
│   └── adr.md
├── scripts/                 # Helper scripts
│   ├── bmad-git.sh
│   └── bmad-orchestrate.sh
├── docs/                    # Plugin development docs
│   └── architecture-diagram.mermaid
├── cli.js                   # CLI entry point
├── index.js                 # Module API
├── install.sh               # Installation script
├── package.json             # npm package config
├── CHANGELOG.md             # Version history
├── DEVELOPMENT.md           # This file
├── ROADMAP.md               # Future plans
└── README.md                # User-facing documentation
```

### Key Files

| File | Purpose |
|------|---------|
| `cli.js` | Command-line interface for npx installation |
| `index.js` | Programmatic API for module usage |
| `install.sh` | Bash script that copies files to target project |
| `.claude/agents/*.md` | Agent definitions with YAML frontmatter |
| `.claude/commands/*.md` | Slash command definitions |
| `templates/*.md` | Document templates copied to target projects |

---

## Testing the Plugin

### Local Testing Workflow

1. **Make your changes** to agent/command files

2. **Test installation** in a temporary directory:
```bash
rm -rf /tmp/bmad-test
mkdir /tmp/bmad-test
./install.sh /tmp/bmad-test
```

3. **Verify files** were copied:
```bash
ls -la /tmp/bmad-test/.claude/agents/
ls -la /tmp/bmad-test/.claude/commands/
```

4. **Run Claude Code** and test the workflow:
```bash
cd /tmp/bmad-test
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
claude

# Inside Claude Code:
/bmad-init
# Describe a test project
/bmad-status
/bmad-next
# etc.
```

### Testing Individual Agents

To test a single agent without running the full workflow:

```bash
cd /tmp/bmad-test
claude

# Manually spawn an agent using the Task tool
# Example: Test the Business Analyst agent
# The orchestrator would normally do this, but you can test directly
```

### Automated Testing

Currently manual testing is required. Future versions will include:
- [ ] Unit tests for CLI
- [ ] Integration tests for full workflow
- [ ] Agent output validation tests
- [ ] Template rendering tests

---

## Agent Development

### Agent File Structure

Each agent is defined in `.claude/agents/<agent-name>.md`:

```markdown
---
name: Agent Display Name
description: Brief description for the agent list
model: sonnet|opus|haiku
---

# Agent Name

## Role
[What this agent does]

## Input
[What documents/context this agent reads]

## Output
[What documents this agent creates]

## Process
[Step-by-step workflow]

## Quality Criteria
[How to verify output quality]
```

### Model Selection Guidelines

| Model | When to Use |
|-------|-------------|
| **Opus** | Complex reasoning (Orchestrator, Architect, Tech Lead) |
| **Sonnet** | Most agents - good balance of speed and quality |
| **Haiku** | Fast, simple tasks (not currently used) |

### Agent Best Practices

1. **Clear Role Definition**: Single responsibility principle
2. **Explicit Inputs**: List all required documents
3. **Structured Outputs**: Use templates, consistent formatting
4. **Quality Gates**: Self-evaluation criteria
5. **Error Handling**: What to do when inputs are incomplete

### Adding a New Agent

1. Create `.claude/agents/new-agent.md`
2. Define YAML frontmatter (name, description, model)
3. Write agent instructions following the structure above
4. Update the orchestrator to spawn the agent in the correct phase
5. Add the agent to README.md documentation
6. Test the agent in isolation and in the full workflow
7. Update CHANGELOG.md

---

## Command Development

### Command File Structure

Each command is defined in `.claude/commands/<command-name>.md`:

```markdown
# /command-name — Short Description

Detailed description of what this command does.

## What This Command Does

1. First thing
2. Second thing
3. Third thing

## Execution

```bash
# Bash commands that get executed
echo "Example"
```

## Usage Examples

[Optional examples of how to use the command]
```

### Adding a New Command

1. Create `.claude/commands/new-command.md`
2. Write the command following the structure above
3. Update the orchestrator's command handling if needed
4. Add the command to README.md command table
5. Test the command
6. Update CHANGELOG.md

---

## Release Process

### Pre-Release Checklist

- [ ] All changes documented in CHANGELOG.md
- [ ] Version number updated in package.json
- [ ] README.md updated if features changed
- [ ] All agents tested in full workflow
- [ ] Installation script tested on clean directory
- [ ] Documentation reviewed and updated

### Version Bumping

```bash
# Patch release (1.0.0 → 1.0.1)
npm version patch

# Minor release (1.0.0 → 1.1.0)
npm version minor

# Major release (1.0.0 → 2.0.0)
npm version major
```

### Publishing to npm

```bash
# Ensure you're logged in
npm login

# Publish
npm publish

# Or publish as scoped package
npm publish --access public
```

### Git Tagging

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag
git push origin v1.0.0

# Push all tags
git push --tags
```

---

## Debugging

### Common Issues

#### 1. Agent Not Spawning

**Symptom**: Orchestrator doesn't spawn an agent

**Debug**:
- Check agent definition exists in `.claude/agents/`
- Verify YAML frontmatter is valid
- Check orchestrator's spawn logic in `.claude/agents/orchestrator.md`
- Ensure `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set

#### 2. Command Not Working

**Symptom**: Slash command doesn't execute

**Debug**:
- Check command file exists in `.claude/commands/`
- Verify command name matches (case-sensitive)
- Check bash syntax in Execution section
- Test bash commands manually in terminal

#### 3. Installation Fails

**Symptom**: install.sh errors out

**Debug**:
```bash
# Run with verbose output
bash -x install.sh /tmp/test

# Check file permissions
ls -la install.sh
chmod +x install.sh
```

#### 4. Agent Produces Wrong Output

**Symptom**: Agent creates incorrect documents

**Debug**:
- Review agent instructions for clarity
- Check input documents are correct
- Verify template is being used
- Test with simpler input
- Check model selection (might need opus instead of sonnet)

### Debugging Techniques

#### 1. Trace Installation

```bash
# Add debug output to install.sh
set -x  # Enable bash debug mode
# Your commands here
set +x  # Disable debug mode
```

#### 2. Inspect Agent Output

After running a phase, check the generated documents:
```bash
cat /tmp/bmad-test/docs/product-brief.md
cat /tmp/bmad-test/docs/prd.md
# etc.
```

#### 3. Check Claude Code Logs

Claude Code may have logs in:
```bash
~/.claude/logs/
# Check for error messages
```

#### 4. Test Agent Prompts

Copy agent instructions and test manually in Claude Code:
```
Act as a Business Analyst. [paste agent instructions here]
```

---

## Development Workflow

### Typical Development Cycle

1. **Create feature branch**
   ```bash
   git checkout -b feature/new-agent-name
   ```

2. **Make changes**
   - Edit agent/command files
   - Update documentation
   - Update CHANGELOG.md

3. **Test locally**
   ```bash
   ./install.sh /tmp/test
   cd /tmp/test
   claude
   # Test your changes
   ```

4. **Commit changes**
   ```bash
   git add .
   git commit -m "feat: add new agent for X"
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/new-agent-name
   # Create PR on GitHub
   ```

6. **Merge and release**
   ```bash
   git checkout main
   git merge feature/new-agent-name
   npm version minor
   npm publish
   git push --tags
   ```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

## Questions?

- **Issues**: [GitHub Issues](https://github.com/bmad-code-org/bmad-agent-teams/issues)
- **Discussions**: [GitHub Discussions](https://github.com/bmad-code-org/bmad-agent-teams/discussions)

---

**Happy developing! 🚀**
