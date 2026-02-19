# Contributing to BMad Agent Teams

Thank you for your interest in contributing to BMad Agent Teams! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Issues

If you encounter a bug or have a feature request:

1. Check if the issue already exists in [GitHub Issues](https://github.com/bmad-code-org/bmad-agent-teams/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (OS, Node.js version, Claude Code version)

### Suggesting Enhancements

For feature suggestions:

1. Open a [GitHub Discussion](https://github.com/bmad-code-org/bmad-agent-teams/discussions)
2. Describe the feature and its benefits
3. Provide examples of how it would be used
4. Discuss implementation approaches

### Pull Requests

1. **Fork the repository** and create a new branch
2. **Make your changes**:
   - Follow existing code style
   - Update documentation if needed
   - Test your changes
3. **Commit with clear messages**:
   ```bash
   git commit -m "Add feature: support for custom agent models"
   ```
4. **Push to your fork** and create a pull request
5. **Describe your changes** in the PR description

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/bmad-agent-teams.git
cd bmad-agent-teams

# Install dependencies (if any)
npm install

# Test the installer locally
./install.sh /tmp/test-project

# Or test with npx (link your local package)
npm link
cd /tmp/test-project
npx @bmad-code/agent-teams install
```

## Project Structure

```
bmad-agent-teams/
├── .claude/
│   ├── agents/       # Agent definitions
│   └── commands/     # Slash command definitions
├── templates/        # Document templates
├── scripts/          # Helper scripts
├── cli.js            # CLI entry point
├── index.js          # Module entry point
├── install.sh        # Installation script
└── package.json      # npm package config
```

## Contribution Areas

### 1. Agent Improvements

Enhance agent definitions in `.claude/agents/*.md`:
- Improve prompts for better output
- Add quality checks
- Enhance error handling
- Optimize model selection

### 2. New Commands

Add new slash commands in `.claude/commands/*.md`:
- Project analytics
- Custom workflows
- Integration with external tools

### 3. Documentation

Improve documentation:
- Usage examples
- Tutorial videos
- Best practices
- Troubleshooting guides

### 4. Templates

Enhance document templates in `templates/`:
- Better structure
- More examples
- Industry-specific variants

### 5. Scripts

Add helper scripts in `scripts/`:
- Git automation
- Report generation
- Integration tools

## Code Style

- Use clear, descriptive variable names
- Add comments for complex logic
- Follow existing patterns in the codebase
- Keep functions focused and small

## Testing

Before submitting a PR:

1. Test the installation process
2. Run through a complete workflow (/bmad-init → /bmad-next → ... → /bmad-review)
3. Verify all documentation is accurate
4. Check that examples work

## Documentation Standards

When updating documentation:

- Use clear, concise language
- Provide examples
- Include screenshots when helpful
- Update the table of contents if needed

## Agent Definition Guidelines

When modifying agents:

1. Keep the YAML frontmatter format:
   ```yaml
   ---
   name: Agent Name
   description: Brief description
   model: sonnet|opus|haiku
   ---
   ```

2. Maintain consistent sections:
   - Role
   - Input
   - Output
   - Process
   - Quality Criteria

3. Test agent behavior in isolation before submitting

## Command Definition Guidelines

For slash commands:

1. Clear description at the top
2. "What This Command Does" section
3. "Execution" section with bash code blocks
4. Examples if applicable

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Open a [GitHub Discussion](https://github.com/bmad-code-org/bmad-agent-teams/discussions) or join our community chat.

## Recognition

Contributors are recognized in:
- The project README
- Release notes
- The contributors list

Thank you for helping make BMad Agent Teams better! 🚀
