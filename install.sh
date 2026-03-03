#!/usr/bin/env bash
# ============================================================================
# BMad Method Installer
# ============================================================================
# Installs the 15-Agent BMad Method into any project directory.
#
# Usage:
#   npx @bmad-code/agent-teams install [target-directory] [options]
#   -OR-
#   ./install.sh [target-directory]
#
# Modes:
#   Fresh install (default) — Full setup for new projects
#   Update (--update)       — Refresh agents/commands/scripts only, preserve project state
#
# Environment variables:
#   BMAD_FORCE=1       - Overwrite existing files without prompt
#   BMAD_AUTO_YES=1    - Skip all confirmation prompts
#   BMAD_UPDATE=1      - Update mode (same as --update flag)
# ============================================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Parse arguments
TARGET="${1:-.}"
FORCE="${BMAD_FORCE:-0}"
AUTO_YES="${BMAD_AUTO_YES:-0}"
UPDATE="${BMAD_UPDATE:-0}"

# Check for flags in positional args
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --update) UPDATE=1 ;;
    --yes|-y) AUTO_YES=1 ;;
  esac
done

# Detect source directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -d "${SCRIPT_DIR}/.claude/agents" ]]; then
  echo -e "${RED}Cannot find BMad source files. Run this script from the bmad-agent-teams directory.${NC}"
  exit 1
fi

# Detect if this is an update (existing BMad project)
IS_EXISTING=0
if [[ -f "${TARGET}/.claude/agents/orchestrator.md" ]]; then
  IS_EXISTING=1
  if [[ "$UPDATE" != "1" ]] && [[ "$FORCE" != "1" ]]; then
    if [[ "$AUTO_YES" != "1" ]]; then
      echo -e "${YELLOW}⚠️  BMad is already installed in this project.${NC}"
      echo -e "    Use ${BLUE}--update${NC} to refresh agents/commands/scripts (preserves project state)"
      echo -e "    Use ${BLUE}--force${NC} to do a full reinstall (resets config files)"
      echo ""
      echo -e "Proceed with update mode? (Y/n)"
      read -r confirm
      if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        echo "Aborted."
        exit 0
      fi
      UPDATE=1
    else
      UPDATE=1
    fi
  fi
fi

# Header
echo -e "${BOLD}"
if [[ "$UPDATE" == "1" ]]; then
  echo "╔══════════════════════════════════════════════════╗"
  echo "║  BMad Method — 15-Agent AI Development Team     ║"
  echo "║  Updater                                         ║"
  echo "╚══════════════════════════════════════════════════╝"
else
  echo "╔══════════════════════════════════════════════════╗"
  echo "║  BMad Method — 15-Agent AI Development Team     ║"
  echo "║  Installer                                       ║"
  echo "╚══════════════════════════════════════════════════╝"
fi
echo -e "${NC}"

# Check if Claude Code is available
if command -v claude &> /dev/null; then
  echo -e "${GREEN}✅ Claude Code detected${NC}"
else
  echo -e "${YELLOW}⚠️  Claude Code not found. Install it first:${NC}"
  echo "   npm install -g @anthropic-ai/claude-code"
  echo ""
fi

if [[ "$UPDATE" == "1" ]]; then
  echo -e "${BLUE}Updating BMad in: ${TARGET}${NC}"
else
  echo -e "${BLUE}Installing to: ${TARGET}${NC}"
fi
echo ""

# ============================================================================
# Create directory structure
# ============================================================================
mkdir -p "${TARGET}/.claude/agents"
mkdir -p "${TARGET}/.claude/commands"
mkdir -p "${TARGET}/.claude/skills"
mkdir -p "${TARGET}/.claude/templates"
mkdir -p "${TARGET}/.claude/examples"
mkdir -p "${TARGET}/.claude/scripts"
mkdir -p "${TARGET}/docs"

# ============================================================================
# ALWAYS UPDATED: Agents, Commands, Scripts, Skills, Templates
# These are the "plugin code" — always safe to refresh
# ============================================================================
echo "Copying BMad plugin files..."

# Copy agents (exclude internal dev docs)
for agent in "${SCRIPT_DIR}/.claude/agents/"*.md; do
  filename=$(basename "$agent")
  if [[ "$filename" != "orchestrator-token-optimization.md" ]]; then
    cp "$agent" "${TARGET}/.claude/agents/"
  fi
done
echo -e "  ${GREEN}✅ 15 agent definitions${NC}"

# Copy commands
if [[ -d "${SCRIPT_DIR}/.claude/commands" ]]; then
  cp -r "${SCRIPT_DIR}/.claude/commands/"* "${TARGET}/.claude/commands/"
  echo -e "  ${GREEN}✅ 9 slash commands${NC}"
fi

# Copy skills
if [[ -d "${SCRIPT_DIR}/.claude/skills" ]]; then
  cp -r "${SCRIPT_DIR}/.claude/skills/"* "${TARGET}/.claude/skills/" 2>/dev/null || true
  echo -e "  ${GREEN}✅ BMad skills${NC}"
fi

# Copy scripts
if [[ -d "${SCRIPT_DIR}/.claude/scripts" ]]; then
  cp -r "${SCRIPT_DIR}/.claude/scripts/"* "${TARGET}/.claude/scripts/"
  chmod +x "${TARGET}/.claude/scripts/"*.sh 2>/dev/null || true
  echo -e "  ${GREEN}✅ Hook & git scripts ($(ls -1 "${SCRIPT_DIR}/.claude/scripts/"*.sh | wc -l | tr -d ' ') scripts)${NC}"
fi

# Copy examples
if [[ -d "${SCRIPT_DIR}/examples" ]]; then
  cp -r "${SCRIPT_DIR}/examples/"* "${TARGET}/.claude/examples/" 2>/dev/null || true
  echo -e "  ${GREEN}✅ Code examples${NC}"
fi

# Copy templates
if [[ -d "${SCRIPT_DIR}/templates" ]]; then
  cp -r "${SCRIPT_DIR}/templates/"* "${TARGET}/.claude/templates/" 2>/dev/null || true
  echo -e "  ${GREEN}✅ Document templates${NC}"
fi

# Copy session tracker template
if [[ -f "${SCRIPT_DIR}/docs/SESSION-TRACKER.md" ]]; then
  cp "${SCRIPT_DIR}/docs/SESSION-TRACKER.md" "${TARGET}/.claude/templates/"
  echo -e "  ${GREEN}✅ Session tracker template${NC}"
fi

# ============================================================================
# CONFIG FILES: settings.json, hooks.json
# Fresh install: copy if missing
# Update mode: check for missing keys and warn
# Force mode: overwrite
# ============================================================================
echo ""
echo "Configuring..."

# settings.json
if [[ ! -f "${TARGET}/.claude/settings.json" ]]; then
  cp "${SCRIPT_DIR}/.claude/settings.json" "${TARGET}/.claude/settings.json"
  echo -e "  ${GREEN}✅ settings.json (Agent Teams + hooks enabled)${NC}"
elif [[ "$FORCE" == "1" ]] && [[ "$UPDATE" != "1" ]]; then
  cp "${SCRIPT_DIR}/.claude/settings.json" "${TARGET}/.claude/settings.json"
  echo -e "  ${GREEN}✅ settings.json (overwritten)${NC}"
else
  # Check if hooks are configured
  if ! grep -q "PreCompact" "${TARGET}/.claude/settings.json" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠️  settings.json: missing hook configuration (PreCompact/SessionStart)${NC}"
    echo -e "     Run with ${BLUE}--force${NC} to overwrite, or manually add hooks from source."
    echo -e "     Source: ${SCRIPT_DIR}/.claude/settings.json"
  else
    echo -e "  ${GREEN}✅ settings.json (exists, hooks configured)${NC}"
  fi
fi

# hooks.json
if [[ ! -f "${TARGET}/.claude/hooks.json" ]]; then
  cp "${SCRIPT_DIR}/.claude/hooks.json" "${TARGET}/.claude/hooks.json"
  echo -e "  ${GREEN}✅ hooks.json (agent auto-approval configured)${NC}"
elif [[ "$FORCE" == "1" ]] && [[ "$UPDATE" != "1" ]]; then
  cp "${SCRIPT_DIR}/.claude/hooks.json" "${TARGET}/.claude/hooks.json"
  echo -e "  ${GREEN}✅ hooks.json (overwritten)${NC}"
else
  # Check if new rules are present
  if ! grep -q "CLAUDE.md" "${TARGET}/.claude/hooks.json" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠️  hooks.json: missing auto-approve rules for CLAUDE.md and scripts${NC}"
    echo -e "     Run with ${BLUE}--force${NC} to overwrite, or manually merge from source."
    echo -e "     Source: ${SCRIPT_DIR}/.claude/hooks.json"
  else
    echo -e "  ${GREEN}✅ hooks.json (exists, rules up to date)${NC}"
  fi
fi

# ============================================================================
# PROJECT STATE FILES: Only on fresh install, NEVER on update
# These contain project-specific state that must not be reset
# ============================================================================
echo ""

if [[ "$UPDATE" == "1" ]]; then
  echo -e "Preserving project state (update mode)..."

  # CLAUDE.md — update only if missing
  if [[ ! -f "${TARGET}/CLAUDE.md" ]]; then
    cat > "${TARGET}/CLAUDE.md" << 'CLAUDEMD'
# BMad Orchestrator Project

## Role Assignment

You are the **BMad Orchestrator** for this project. You coordinate 15 specialized AI agents through the BMad Method workflow.

## Auto-Recovery Protocol

If your context has been compacted, the SessionStart hook will inject recovery context automatically. When you see the recovery block:

1. Read the injected session-tracker.md content carefully
2. Increment the "Compaction Events" counter in `docs/session-tracker.md`
3. Read `.claude/agents/orchestrator.md` for your full role definition
4. Resume from the "Next Action Queue" in the session tracker
5. Brief the user: "Session recovered. Phase: [X]. Resuming: [action]."

**Do NOT** start fresh, create your own plans, or ask the user what to do.

## Key Files

- `docs/session-tracker.md` — Your persistent working memory
- `docs/bmm-workflow-status.yaml` — Phase gate tracking
- `.claude/agents/orchestrator.md` — Your full role definition

## Workflow Commands

- `/bmad-status` — Show current phase and progress
- `/bmad-next` — Resume or advance to next phase
- `/bmad-track` — Show epic/story dashboard
- `/bmad-gate` — Run quality gate check
CLAUDEMD
    echo -e "  ${GREEN}✅ CLAUDE.md created (was missing)${NC}"
  else
    echo -e "  ${GREEN}✅ CLAUDE.md (preserved)${NC}"
  fi

  echo -e "  ${GREEN}✅ docs/bmm-workflow-status.yaml (preserved)${NC}"
  echo -e "  ${GREEN}✅ docs/session-tracker.md (preserved)${NC}"
  echo -e "  ${GREEN}✅ docs/ project artifacts (preserved)${NC}"

else
  # Fresh install — create project state files
  echo "Creating project state files..."

  # CLAUDE.md
  cat > "${TARGET}/CLAUDE.md" << 'CLAUDEMD'
# BMad Orchestrator Project

## Role Assignment

You are the **BMad Orchestrator** for this project. You coordinate 15 specialized AI agents through the BMad Method workflow.

## Auto-Recovery Protocol

If your context has been compacted, the SessionStart hook will inject recovery context automatically. When you see the recovery block:

1. Read the injected session-tracker.md content carefully
2. Increment the "Compaction Events" counter in `docs/session-tracker.md`
3. Read `.claude/agents/orchestrator.md` for your full role definition
4. Resume from the "Next Action Queue" in the session tracker
5. Brief the user: "Session recovered. Phase: [X]. Resuming: [action]."

**Do NOT** start fresh, create your own plans, or ask the user what to do.

## Key Files

- `docs/session-tracker.md` — Your persistent working memory
- `docs/bmm-workflow-status.yaml` — Phase gate tracking
- `.claude/agents/orchestrator.md` — Your full role definition

## Workflow Commands

- `/bmad-status` — Show current phase and progress
- `/bmad-next` — Resume or advance to next phase
- `/bmad-track` — Show epic/story dashboard
- `/bmad-gate` — Run quality gate check
CLAUDEMD
  echo -e "  ${GREEN}✅ CLAUDE.md (orchestrator role + recovery)${NC}"

  # Workflow status — only create if missing
  if [[ ! -f "${TARGET}/docs/bmm-workflow-status.yaml" ]]; then
    cat > "${TARGET}/docs/bmm-workflow-status.yaml" << 'STATUSEOF'
project:
  name: ""
  level: 2
  initialized: true

phases:
  discovery: { status: pending, gate_passed: false }
  planning: { status: pending, gate_passed: false }
  architecture: { status: pending, gate_passed: false }
  sprint_planning: { status: pending, gate_passed: false }
  implementation: { status: pending, gate_passed: false }
  quality_assurance: { status: pending, gate_passed: false }
  deployment: { status: pending, gate_passed: false }
  final_review: { status: pending, gate_passed: false }
STATUSEOF
    echo -e "  ${GREEN}✅ Workflow status tracker${NC}"
  else
    echo -e "  ${YELLOW}⏭️  bmm-workflow-status.yaml already exists (preserved)${NC}"
  fi
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
if [[ "$UPDATE" == "1" ]]; then
  echo -e "${BOLD}Update complete!${NC}"
else
  echo -e "${BOLD}Installation complete!${NC}"
fi
echo ""
echo "═══════════════════════════════════════════════════"
echo ""
echo "  BMad Framework in .claude/ directory:"
echo "    .claude/agents/       — 15 agent definitions"
echo "    .claude/commands/     — 9 slash commands"
echo "    .claude/skills/       — BMad skills"
echo "    .claude/templates/    — Document templates"
echo "    .claude/scripts/      — 3 scripts (git helpers + recovery hooks)"
echo "    .claude/settings.json — Agent Teams + hooks enabled"
echo ""

if [[ "$UPDATE" == "1" ]]; then
  echo "  Updated: agents, commands, scripts, skills, templates"
  echo "  Preserved: docs/, CLAUDE.md, settings.json, hooks.json"
  echo ""
  echo "  If you need to update config files too:"
  echo -e "    ${BLUE}./install.sh ${TARGET} --force${NC}"
  echo ""
else
  echo "  To get started:"
  echo ""
  echo "    1. Start Claude Code:"
  echo -e "       ${BLUE}claude${NC}"
  echo ""
  echo "    2. Initialize the project:"
  echo -e "       ${BLUE}/bmad-init${NC}"
  echo ""
  echo "    3. Describe your project and let the 15-agent"
  echo "       team build it for you!"
  echo ""
  echo "  For help at any time:"
  echo -e "       ${BLUE}/bmad-help${NC}"
  echo ""
fi

echo "═══════════════════════════════════════════════════"
