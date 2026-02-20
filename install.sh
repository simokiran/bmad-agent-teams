#!/usr/bin/env bash
# ============================================================================
# BMad Method Installer
# ============================================================================
# Installs the 12-Agent BMad Method into any project directory.
#
# Usage:
#   npx @bmad-code/agent-teams install [target-directory] [options]
#   -OR-
#   ./install.sh [target-directory]
#
# Environment variables:
#   BMAD_FORCE=1       - Overwrite existing files without prompt
#   BMAD_AUTO_YES=1    - Skip all confirmation prompts
# ============================================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

TARGET="${1:-.}"
FORCE="${BMAD_FORCE:-0}"
AUTO_YES="${BMAD_AUTO_YES:-0}"

echo -e "${BOLD}"
echo "╔══════════════════════════════════════════════════╗"
echo "║  BMad Method — 12-Agent AI Development Team     ║"
echo "║  Installer                                       ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if Claude Code is available
if command -v claude &> /dev/null; then
  echo -e "${GREEN}✅ Claude Code detected${NC}"
else
  echo -e "${YELLOW}⚠️  Claude Code not found. Install it first:${NC}"
  echo "   npm install -g @anthropic-ai/claude-code"
  echo ""
fi

echo -e "${BLUE}Installing to: ${TARGET}${NC}"
echo ""

# Create directory structure in target project
echo "Creating project structure..."
mkdir -p "${TARGET}/.claude/agents"
mkdir -p "${TARGET}/.claude/commands"
mkdir -p "${TARGET}/.claude/skills"
mkdir -p "${TARGET}/.claude/templates"
mkdir -p "${TARGET}/.claude/examples"
mkdir -p "${TARGET}/.claude/scripts"
mkdir -p "${TARGET}/docs"  # Project docs (created by bmad-init workflow)

# These directories will be created by /bmad-init command:
# - docs/stories/
# - docs/adrs/
# - docs/epics/
# - src/
# - tests/

# Check if files already exist
if [[ -f "${TARGET}/.claude/agents/orchestrator.md" ]] && [[ "$FORCE" != "1" ]]; then
  if [[ "$AUTO_YES" != "1" ]]; then
    echo -e "${YELLOW}⚠️  BMad agents already exist. Overwrite? (y/N)${NC}"
    read -r confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
      echo "Aborted. Existing files preserved."
      exit 0
    fi
  else
    echo -e "${YELLOW}⚠️  BMad agents already exist. Skipping (use --force to overwrite)${NC}"
    exit 0
  fi
fi

# Detect source directory (when running from cloned repo)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "${SCRIPT_DIR}/.claude/agents" ]]; then
  # Installing from cloned repo
  echo "Installing from local repository..."
  
  # Copy agents
  cp -r "${SCRIPT_DIR}/.claude/agents/"* "${TARGET}/.claude/agents/"
  echo -e "  ${GREEN}✅ 12 agent definitions${NC}"
  
  # Copy commands
  if [[ -d "${SCRIPT_DIR}/.claude/commands" ]]; then
    cp -r "${SCRIPT_DIR}/.claude/commands/"* "${TARGET}/.claude/commands/"
    echo -e "  ${GREEN}✅ 8 slash commands${NC}"
  fi

  # Copy skills
  if [[ -d "${SCRIPT_DIR}/.claude/skills" ]]; then
    mkdir -p "${TARGET}/.claude/skills"
    cp -r "${SCRIPT_DIR}/.claude/skills/"* "${TARGET}/.claude/skills/"
    echo -e "  ${GREEN}✅ BMad skills${NC}"
  fi

  # Copy examples to .claude/examples/
  if [[ -d "${SCRIPT_DIR}/examples" ]]; then
    cp -r "${SCRIPT_DIR}/examples/"* "${TARGET}/.claude/examples/" 2>/dev/null || true
    echo -e "  ${GREEN}✅ Code examples${NC}"
  fi

  # Copy settings (don't overwrite existing)
  if [[ ! -f "${TARGET}/.claude/settings.json" ]]; then
    cp "${SCRIPT_DIR}/.claude/settings.json" "${TARGET}/.claude/settings.json"
    echo -e "  ${GREEN}✅ settings.json (Agent Teams enabled)${NC}"
  else
    echo -e "  ${YELLOW}⏭️  settings.json already exists (skipped)${NC}"
  fi

  # Copy templates to .claude/templates/
  if [[ -d "${SCRIPT_DIR}/templates" ]]; then
    cp -r "${SCRIPT_DIR}/templates/"* "${TARGET}/.claude/templates/" 2>/dev/null || true
    echo -e "  ${GREEN}✅ Document templates${NC}"
  fi

  # Copy scripts to .claude/scripts/
  if [[ -d "${SCRIPT_DIR}/scripts" ]]; then
    cp -r "${SCRIPT_DIR}/scripts/"* "${TARGET}/.claude/scripts/" 2>/dev/null || true
    chmod +x "${TARGET}/.claude/scripts/"*.sh 2>/dev/null || true
    echo -e "  ${GREEN}✅ Orchestration scripts${NC}"
  fi

  # Copy BMad internal templates (SESSION-TRACKER, etc.)
  if [[ -f "${SCRIPT_DIR}/docs/SESSION-TRACKER.md" ]]; then
    mkdir -p "${TARGET}/.claude/templates"
    cp "${SCRIPT_DIR}/docs/SESSION-TRACKER.md" "${TARGET}/.claude/templates/"
    echo -e "  ${GREEN}✅ Session tracker template${NC}"
  fi

else
  echo -e "${YELLOW}Cannot find BMad source files. Run this script from the bmad-agent-teams directory.${NC}"
  exit 1
fi

# Create workflow status file
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

# Set environment variable reminder
echo ""
echo -e "${BOLD}Installation complete!${NC}"
echo ""
echo "═══════════════════════════════════════════════════"
echo ""
echo "  BMad Framework installed to .claude/ directory:"
echo "    .claude/agents/       — 15 agent definitions"
echo "    .claude/commands/     — 8 slash commands"
echo "    .claude/skills/       — BMad skills"
echo "    .claude/templates/    — Document templates"
echo "    .claude/examples/     — Code examples"
echo "    .claude/scripts/      — Orchestration scripts"
echo "    .claude/settings.json — Agent Teams enabled"
echo ""
echo "  Project directories (for your code):"
echo "    docs/                 — Project documents (created by bmad-init)"
echo "    src/                  — Your source code (created by bmad-init)"
echo "    tests/                — Your tests (created by bmad-init)"
echo ""
echo "  To get started:"
echo ""
echo "    1. Enable Agent Teams in your shell:"
echo -e "       ${BLUE}export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1${NC}"
echo ""
echo "    2. Start Claude Code:"
echo -e "       ${BLUE}claude${NC}"
echo ""
echo "    3. Initialize the project:"
echo -e "       ${BLUE}/bmad-init${NC}"
echo ""
echo "    4. Describe your project and let the 12-agent"
echo "       team build it for you!"
echo ""
echo "  For help at any time:"
echo -e "       ${BLUE}/bmad-help${NC}"
echo ""
echo "═══════════════════════════════════════════════════"
