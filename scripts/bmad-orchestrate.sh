#!/usr/bin/env bash
# ============================================================================
# BMad Method — 12-Agent Orchestration Runner
# ============================================================================
# This script orchestrates the full BMad workflow using Claude Code's
# subagent spawning and Agent Teams capabilities.
#
# Usage: 
#   In Claude Code, tell the Orchestrator agent what to build.
#   The orchestrator reads this script's logic and manages the workflow.
#
# Or run phases individually:
#   ./scripts/bmad-orchestrate.sh phase1 "Your project idea here"
#   ./scripts/bmad-orchestrate.sh phase2
#   ./scripts/bmad-orchestrate.sh phase3
#   ... through phase8
# ============================================================================

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/docs"
STATUS_FILE="$DOCS_DIR/bmm-workflow-status.yaml"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_phase() { echo -e "${BLUE}━━━ Phase $1: $2 ━━━${NC}"; }
log_ok()    { echo -e "${GREEN}✅ $1${NC}"; }
log_warn()  { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_fail()  { echo -e "${RED}❌ $1${NC}"; }
log_agent() { echo -e "${BLUE}🤖 Spawning agent: $1${NC}"; }

# ============================================================================
# Phase 1: Discovery — Business Analyst
# ============================================================================
phase1() {
  log_phase "1" "Discovery"
  log_agent "Business Analyst"
  
  local idea="$1"
  
  echo "The Business Analyst will transform your idea into a structured Product Brief."
  echo ""
  echo "Input: $idea"
  echo "Output: docs/product-brief.md"
  echo ""
  echo "--- Claude Code Subagent Spawn ---"
  echo "Task({"
  echo "  name: 'analyst',"
  echo "  prompt: 'You are the Business Analyst agent. Read your instructions from .claude/agents/analyst.md."
  echo "           The user\\'s project idea is: $idea"
  echo "           Create docs/product-brief.md following your template. Be specific and measurable.',"
  echo "  subagent_type: 'general-purpose'"
  echo "})"
  echo ""
  
  # Gate check
  if [[ -f "$DOCS_DIR/product-brief.md" ]]; then
    log_ok "Product Brief created at docs/product-brief.md"
    echo "Gate check: Verify the brief has all required sections..."
    grep -q "Problem Statement" "$DOCS_DIR/product-brief.md" && log_ok "Problem Statement ✓"
    grep -q "Target Users" "$DOCS_DIR/product-brief.md" && log_ok "Target Users ✓"
    grep -q "MVP Scope" "$DOCS_DIR/product-brief.md" && log_ok "MVP Scope ✓"
    grep -q "Success Metrics" "$DOCS_DIR/product-brief.md" && log_ok "Success Metrics ✓"
  else
    log_warn "Product Brief not yet created. Spawn the analyst agent."
  fi
}

# ============================================================================
# Phase 2: Planning — Product Manager + UX Designer (Parallel)
# ============================================================================
phase2() {
  log_phase "2" "Planning"
  
  if [[ ! -f "$DOCS_DIR/product-brief.md" ]]; then
    log_fail "Cannot start Phase 2: docs/product-brief.md missing. Run Phase 1 first."
    exit 1
  fi
  
  echo "Spawning PM and UX Designer in parallel..."
  echo ""
  
  log_agent "Product Manager"
  echo "Task({"
  echo "  name: 'product-manager',"
  echo "  prompt: 'You are the Product Manager agent. Read .claude/agents/product-manager.md for instructions."
  echo "           Read docs/product-brief.md as input."
  echo "           Create docs/prd.md with detailed feature specs and acceptance criteria.',"
  echo "  subagent_type: 'general-purpose',"
  echo "  run_in_background: true"
  echo "})"
  echo ""
  
  log_agent "UX Designer"
  echo "Task({"
  echo "  name: 'ux-designer',"
  echo "  prompt: 'You are the UX Designer agent. Read .claude/agents/ux-designer.md for instructions."
  echo "           Read docs/product-brief.md as input."
  echo "           Create docs/ux-wireframes.md with information architecture, user flows, and screen specs.',"
  echo "  subagent_type: 'general-purpose',"
  echo "  run_in_background: true"
  echo "})"
  echo ""
  
  echo "Both agents running in parallel. Wait for completion..."
  
  # Gate check
  local gate_pass=true
  [[ -f "$DOCS_DIR/prd.md" ]] && log_ok "PRD created" || { log_warn "PRD missing"; gate_pass=false; }
  [[ -f "$DOCS_DIR/ux-wireframes.md" ]] && log_ok "UX Spec created" || { log_warn "UX Spec missing"; gate_pass=false; }
  
  if $gate_pass; then
    log_ok "Phase 2 Gate: PASSED"
    echo "Ready for Phase 3: Architecture"
  fi
}

# ============================================================================
# Phase 3: Architecture — System Architect
# ============================================================================
phase3() {
  log_phase "3" "Architecture"
  
  if [[ ! -f "$DOCS_DIR/prd.md" ]]; then
    log_fail "Cannot start Phase 3: docs/prd.md missing. Run Phase 2 first."
    exit 1
  fi
  
  log_agent "System Architect"
  echo "Task({"
  echo "  name: 'architect',"
  echo "  prompt: 'You are the System Architect agent. Read .claude/agents/architect.md for instructions."
  echo "           Read docs/prd.md and docs/ux-wireframes.md as input."
  echo "           Create docs/architecture.md with full technical design."
  echo "           Create ADRs in docs/adrs/ for each major technology decision."
  echo "           Run the Solutioning Gate Check — score must be >= 90/100.',"
  echo "  subagent_type: 'general-purpose'"
  echo "})"
  echo ""
  
  echo "⚠️  SOLUTIONING GATE: Architecture must score ≥ 90/100"
  echo "    If it fails, the architect will be re-spawned to fill gaps."
}

# ============================================================================
# Phase 4: Sprint Planning — Scrum Master
# ============================================================================
phase4() {
  log_phase "4" "Sprint Planning"
  
  if [[ ! -f "$DOCS_DIR/architecture.md" ]]; then
    log_fail "Cannot start Phase 4: docs/architecture.md missing. Run Phase 3 first."
    exit 1
  fi
  
  log_agent "Scrum Master"
  echo "Task({"
  echo "  name: 'scrum-master',"
  echo "  prompt: 'You are the Scrum Master agent. Read .claude/agents/scrum-master.md for instructions."
  echo "           Read docs/prd.md, docs/architecture.md, and docs/ux-wireframes.md."
  echo "           Create docs/sprint-plan.md with story summary and dependency graph."
  echo "           Create individual story files in docs/stories/STORY-001.md through STORY-NNN.md."
  echo "           Assign each story to a track: Frontend, Backend, or Database."
  echo "           Maximize parallel work — minimize cross-track dependencies.',"
  echo "  subagent_type: 'general-purpose'"
  echo "})"
  echo ""
  
  echo "After sprint planning, review the sprint plan before proceeding to implementation."
}

# ============================================================================
# Phase 5: Implementation — Agent Team (3 developers in parallel)
# ============================================================================
phase5() {
  log_phase "5" "Implementation (PARALLEL)"
  
  if [[ ! -d "$DOCS_DIR/stories" ]] || [[ -z "$(ls -A "$DOCS_DIR/stories" 2>/dev/null)" ]]; then
    log_fail "Cannot start Phase 5: No stories in docs/stories/. Run Phase 4 first."
    exit 1
  fi
  
  echo "🔥 This is the big one — spawning 3 developers as an Agent Team!"
  echo ""
  echo "--- Agent Team Setup ---"
  echo ""
  echo "// 1. Create the team"
  echo "TeamCreate({"
  echo "  team_name: 'sprint-1',"
  echo "  description: 'Sprint 1 implementation — 3 parallel development tracks'"
  echo "})"
  echo ""
  echo "// 2. Create tasks from story files"
  echo "// (One TaskCreate per story, with track/dependency info)"
  
  # List available stories
  echo ""
  echo "Available stories:"
  for story in "$DOCS_DIR"/stories/STORY-*.md; do
    if [[ -f "$story" ]]; then
      local title=$(head -1 "$story" | sed 's/^# //')
      echo "  📋 $(basename "$story"): $title"
    fi
  done
  
  echo ""
  echo "// 3. Spawn three parallel developers"
  echo ""
  
  log_agent "Frontend Developer"
  echo "Task({"
  echo "  team_name: 'sprint-1',"
  echo "  name: 'frontend-dev',"
  echo "  prompt: 'You are the Frontend Developer. Read .claude/agents/frontend-developer.md."
  echo "           Read docs/architecture.md and docs/ux-wireframes.md."
  echo "           Claim and implement all Frontend-track stories from docs/stories/."
  echo "           Write code in src/ and tests in tests/."
  echo "           Update each story file status when complete.',"
  echo "  subagent_type: 'general-purpose',"
  echo "  run_in_background: true"
  echo "})"
  echo ""
  
  log_agent "Backend Developer"
  echo "Task({"
  echo "  team_name: 'sprint-1',"
  echo "  name: 'backend-dev',"
  echo "  prompt: 'You are the Backend Developer. Read .claude/agents/backend-developer.md."
  echo "           Read docs/architecture.md."
  echo "           Claim and implement all Backend-track stories from docs/stories/."
  echo "           Write code in src/ and tests in tests/."
  echo "           Update each story file status when complete.',"
  echo "  subagent_type: 'general-purpose',"
  echo "  run_in_background: true"
  echo "})"
  echo ""
  
  log_agent "Database Engineer"
  echo "Task({"
  echo "  team_name: 'sprint-1',"
  echo "  name: 'db-engineer',"
  echo "  prompt: 'You are the Database Engineer. Read .claude/agents/database-engineer.md."
  echo "           Read docs/architecture.md."
  echo "           Claim and implement all Database-track stories from docs/stories/."
  echo "           Write migrations, seeds, queries, and types."
  echo "           Update each story file status when complete.',"
  echo "  subagent_type: 'general-purpose',"
  echo "  run_in_background: true"
  echo "})"
  echo ""
  
  echo "All 3 developers working in parallel!"
  echo "Use Shift+Down to cycle between teammates and monitor progress."
  echo "The team lead (Orchestrator) will synthesize results when all tracks complete."
}

# ============================================================================
# Phase 6: Quality Assurance — QA Engineer
# ============================================================================
phase6() {
  log_phase "6" "Quality Assurance"
  
  log_agent "QA Engineer"
  echo "Task({"
  echo "  name: 'qa-engineer',"
  echo "  prompt: 'You are the QA Engineer. Read .claude/agents/qa-engineer.md."
  echo "           Read docs/prd.md for acceptance criteria."
  echo "           Read all story files in docs/stories/."
  echo "           Review all code in src/ and tests in tests/."
  echo "           Run existing tests. Write additional tests for gaps."
  echo "           Create docs/test-plan.md with complete results."
  echo "           Report bugs with severity and reproduction steps.',"
  echo "  subagent_type: 'general-purpose'"
  echo "})"
}

# ============================================================================
# Phase 7: Deployment — DevOps Engineer
# ============================================================================
phase7() {
  log_phase "7" "Deployment Configuration"
  
  log_agent "DevOps Engineer"
  echo "Task({"
  echo "  name: 'devops-engineer',"
  echo "  prompt: 'You are the DevOps Engineer. Read .claude/agents/devops-engineer.md."
  echo "           Read docs/architecture.md for deployment architecture."
  echo "           Create docs/deploy-config.md."
  echo "           Create CI/CD pipeline configuration."
  echo "           Create Dockerfile if architecture requires containers."
  echo "           Create .env.example with all required variables.',"
  echo "  subagent_type: 'general-purpose'"
  echo "})"
}

# ============================================================================
# Phase 8: Final Review — Tech Lead
# ============================================================================
phase8() {
  log_phase "8" "Final Review"
  
  log_agent "Tech Lead"
  echo "Task({"
  echo "  name: 'tech-lead',"
  echo "  prompt: 'You are the Tech Lead. Read .claude/agents/tech-lead.md."
  echo "           This is the FINAL review before shipping."
  echo "           Read ALL docs, ALL code, ALL tests."
  echo "           Create docs/review-checklist.md with your verdict."
  echo "           Be thorough — check architecture compliance, code quality,"
  echo "           security, performance, test coverage, and documentation."
  echo "           Give a clear SHIP / SHIP WITH NOTES / DO NOT SHIP verdict.',"
  echo "  subagent_type: 'general-purpose'"
  echo "})"
  echo ""
  echo "Awaiting Tech Lead verdict..."
}

# ============================================================================
# Main Dispatcher
# ============================================================================
case "${1:-help}" in
  phase1) phase1 "${2:-}" ;;
  phase2) phase2 ;;
  phase3) phase3 ;;
  phase4) phase4 ;;
  phase5) phase5 ;;
  phase6) phase6 ;;
  phase7) phase7 ;;
  phase8) phase8 ;;
  all)
    echo "Running full BMad pipeline..."
    phase1 "${2:-}"
    phase2
    phase3
    phase4
    phase5
    phase6
    phase7
    phase8
    echo ""
    log_ok "Full BMad pipeline complete! 🚀"
    ;;
  help|*)
    echo "BMad Method — 12-Agent Orchestration Runner"
    echo ""
    echo "Usage: $0 <phase> [args]"
    echo ""
    echo "Phases:"
    echo "  phase1 \"idea\"  — Discovery (Business Analyst)"
    echo "  phase2         — Planning (PM + UX Designer)"
    echo "  phase3         — Architecture (System Architect)"
    echo "  phase4         — Sprint Planning (Scrum Master)"
    echo "  phase5         — Implementation (3 devs in parallel)"
    echo "  phase6         — Quality Assurance (QA Engineer)"
    echo "  phase7         — Deployment (DevOps Engineer)"
    echo "  phase8         — Final Review (Tech Lead)"
    echo "  all \"idea\"     — Run entire pipeline"
    echo ""
    echo "Or in Claude Code, use these commands:"
    echo "  /bmad-init    — Initialize project"
    echo "  /bmad-status  — Check current phase"
    echo "  /bmad-next    — Advance to next phase"
    ;;
esac
