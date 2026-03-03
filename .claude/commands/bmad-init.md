# /bmad-init — Initialize BMad 12-Agent Team

Initialize the BMad Method project structure. After initialization, the MAIN CHAT assumes the orchestrator role to begin the workflow.

## What This Command Does

1. Creates the full project directory structure
2. Initializes the session tracker (docs/session-tracker.md)
3. Validates all agent definitions are present
4. **Main chat assumes orchestrator role** from `.claude/agents/orchestrator.md`
5. **You (as orchestrator) ask user** to describe project
6. **You begin Phase 1 (Discovery)** by spawning Business Analyst as subagent

## Step 1: Create Project Structure

```bash
# Create project directories
mkdir -p docs/stories docs/adrs docs/epics docs/design-prototypes src tests scripts .claude/scripts

# Initialize git if not already
git init 2>/dev/null || true
echo "node_modules/" >> .gitignore 2>/dev/null || true
echo ".env" >> .gitignore 2>/dev/null || true

# Create BMad workflow status (YAML - phase tracking)
cat > docs/bmm-workflow-status.yaml << 'EOF'
project:
  name: ""
  level: 2  # Enterprise level (full workflow)
  initialized: true

phases:
  discovery:
    status: pending  # pending | in_progress | complete | failed
    agent: analyst
    output: docs/product-brief.md
    gate_passed: false

  planning:
    status: pending
    agents: [product-manager, ux-designer]
    outputs: [docs/prd.md, docs/ux-wireframes.md]
    gate_passed: false

  architecture:
    status: pending
    agent: architect
    outputs: [docs/architecture.md, docs/adrs/]
    gate_score: 0
    gate_passed: false  # Requires >= 90/100

  sprint_planning:
    status: pending
    agent: scrum-master
    outputs: [docs/sprint-plan.md, docs/epics/]
    gate_passed: false

  story_creation:
    status: pending
    agents: [story-writer]  # Parallel (1 per epic)
    outputs: [docs/stories/]
    gate_passed: false

  implementation:
    status: pending
    agents: [frontend-developer, backend-developer, database-engineer]
    mode: agent-team  # Uses Agent Team coordination
    tracks:
      frontend: { stories: [], status: pending }
      backend: { stories: [], status: pending }
      database: { stories: [], status: pending }
    gate_passed: false

  quality_assurance:
    status: pending
    agent: qa-engineer
    output: docs/test-plan.md
    gate_passed: false

  deployment:
    status: pending
    agent: devops-engineer
    output: docs/deploy-config.md
    gate_passed: false

  final_review:
    status: pending
    agent: tech-lead
    output: docs/review-checklist.md
    verdict: null  # ship | ship_with_notes | do_not_ship
EOF

# Create orchestrator session tracker (for recovery)
cat > docs/session-tracker.md << 'EOF'
# BMad Orchestrator Session Tracker

**Purpose**: Orchestrator working memory for context compaction recovery

**Session Started**: [Timestamp will be set by orchestrator]
**Last Updated**: [Timestamp]

## Current Orchestrator State

**Current Phase**: Not started
**Sub-phase/Action**: Waiting for /bmad-init to spawn orchestrator
**Status**: Idle

## Active Agent Spawns

| Agent ID | Agent Type | Phase | Spawn Time | Status |
|----------|------------|-------|------------|--------|
| — | — | — | — | — |

## Background Tasks (Agent Team)

| Task ID | Agent Name | Story | Started | Last Update | Status |
|---------|-----------|--------|---------|-------------|--------|
| — | — | — | — | — | — |

## Issues and Resolutions

### Issue Log
| # | Timestamp | Phase | Issue | Resolution | Status |
|---|-----------|-------|-------|------------|--------|
| — | — | — | — | — | — |

**Example entries:**
- `#1 | 2026-02-21 15:30 | Phase 3 | Architect gate score 85/100 (below 90) | Re-spawned architect with feedback: "Add more details to API design section" | Resolved - Score: 92/100`
- `#2 | 2026-02-21 16:45 | Phase 5 | Frontend dev: naming-registry.md conflict with backend | Coordinated via SendMessage, backend updated first, frontend pulled changes | Resolved`

## Decisions Made

### Decision Log
| # | Timestamp | Phase | Decision | Rationale | Outcome |
|---|-----------|-------|----------|-----------|---------|
| — | — | — | — | — | — |

**Example entries:**
- `#1 | 2026-02-21 14:00 | Phase 4 | Created 3 epics instead of 5 | User stories were similar, grouped by user journey | Sprint plan: 3 epics, 12 stories`
- `#2 | 2026-02-21 17:00 | Phase 5 | Used Agent Team (not sequential) | 12 stories with dependencies, coordination needed | Saved ~40 minutes`

## Important Context

### Context Notes (for post-compaction recovery)
- [Critical information orchestrator needs to remember]
- [User preferences mentioned during session]
- [Deviations from standard workflow]
- [Special requirements or constraints]

**Example entries:**
- `User emphasized: "Must support mobile devices first, desktop is secondary"`
- `Database: Using PostgreSQL 15+ for JSONB features (mentioned in Phase 1)`
- `Skipped Phase 7 (DevOps) - user will deploy manually to existing infrastructure`

## Next Action Queue

1. [Action that orchestrator should take next]
2. [Following action if automatic mode]

## Session Variables

- **Sprint Branch**: [Not created]
- **Team Name**: [Not created]
- **Stories Assigned**: [0]
- **User Availability**: [Full-time | Part-time | Async]
- **Target Deadline**: [None | Date]

## Blockers and Issues (Current)

**Active Blockers:**
- [None | Description of blocker and what's needed to unblock]

**Waiting On:**
- [User approval | Agent completion | External dependency]

## Context Recovery Information

**Compaction Events**: 0
**Last Compaction**: Never

**Recovery Checklist (post-compaction):**
- [ ] Read this session-tracker.md
- [ ] Check bmm-workflow-status.yaml for phase status
- [ ] Check for active background tasks
- [ ] Review recent issues and decisions
- [ ] Read important context notes
- [ ] Resume from "Next Action Queue"

---
**Note**: This is the orchestrator's working memory.
- **For project progress**: See `docs/project-tracker.md`
- **For phase status**: See `docs/bmm-workflow-status.yaml`
EOF

# Create CLAUDE.md for auto-recovery after context compaction
cat > CLAUDE.md << 'CLAUDEMD'
# BMad Orchestrator Project

## Role Assignment

You are the **BMad Orchestrator** for this project. You coordinate 12 specialized AI agents through the BMad Method workflow.

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

# Deploy pre-compact and post-compact hook scripts
cat > .claude/scripts/bmad-pre-compact.sh << 'PRECOMPACT'
#!/bin/bash
# BMad Pre-Compaction Hook
# Runs before context compaction to save a checkpoint to session-tracker.md

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

if [ -z "$CWD" ]; then
  CWD="$(pwd)"
fi

TRACKER="$CWD/docs/session-tracker.md"
if [ ! -f "$TRACKER" ]; then
  exit 0
fi

TIMESTAMP=$(date -u '+%Y-%m-%d %H:%M UTC')

RECENT_TOOLS=""
RECENT_AGENTS=""
RECENT_FILES=""

if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  RECENT_TOOLS=$(tail -200 "$TRANSCRIPT" | jq -r 'select(.type == "tool_use") | .name // empty' 2>/dev/null | sort | uniq -c | sort -rn | head -10)
  RECENT_AGENTS=$(tail -200 "$TRANSCRIPT" | jq -r 'select(.type == "tool_use" and .name == "Task") | .input.description // empty' 2>/dev/null | tail -5)
  RECENT_FILES=$(tail -200 "$TRANSCRIPT" | jq -r 'select(.type == "tool_use" and (.name == "Write" or .name == "Edit")) | .input.file_path // empty' 2>/dev/null | sort -u | tail -10)
fi

CHECKPOINT="## Pre-Compaction Checkpoint

**Checkpoint Time**: $TIMESTAMP
**Trigger**: Context about to be compacted

**Recent Tool Activity**:
\`\`\`
${RECENT_TOOLS:-No tool activity captured}
\`\`\`

**Recent Agent Spawns**:
${RECENT_AGENTS:-None captured}

**Recently Modified Files**:
${RECENT_FILES:-None captured}"

if grep -q "## Pre-Compaction Checkpoint" "$TRACKER"; then
  python3 -c "
import re
with open('$TRACKER', 'r') as f:
    content = f.read()
content = re.sub(r'\n## Pre-Compaction Checkpoint.*?(?=\n## |\Z)', '', content, flags=re.DOTALL)
with open('$TRACKER', 'w') as f:
    f.write(content.rstrip() + '\n')
" 2>/dev/null
fi

printf "\n%s\n" "$CHECKPOINT" >> "$TRACKER"
echo "Pre-compaction checkpoint saved to session tracker." >&2
PRECOMPACT

cat > .claude/scripts/bmad-post-compact.sh << 'POSTCOMPACT'
#!/bin/bash
# BMad Post-Compaction Recovery Hook
# stdout is INJECTED directly into Claude's post-compaction context.

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

if [ -z "$CWD" ]; then
  CWD="$(pwd)"
fi

TRACKER="$CWD/docs/session-tracker.md"

if [ ! -f "$TRACKER" ]; then
  exit 0
fi

cat << 'RECOVERY'
=== BMAD ORCHESTRATOR: POST-COMPACTION RECOVERY ===

You are the **BMad Orchestrator** for this project. Your context was just compacted.

IMMEDIATE ACTIONS:
1. The session tracker content is included below — read it carefully
2. Increment the "Compaction Events" counter in docs/session-tracker.md
3. Read .claude/agents/orchestrator.md for your full role definition
4. Resume from the "Next Action Queue" in the session tracker
5. Brief the user: "Session recovered. Phase: [X]. Resuming: [action]."

DO NOT start fresh or create your own plans. You are mid-workflow.
DO NOT ask the user "what should I do?" — the session tracker tells you.
RECOVERY

echo ""
echo "=== CURRENT SESSION STATE ==="
echo ""
cat "$TRACKER"
echo ""
echo "=== END SESSION STATE ==="
echo ""
echo "Resume from the Next Action Queue above. Do NOT ask the user what to do."
POSTCOMPACT

chmod +x .claude/scripts/bmad-pre-compact.sh .claude/scripts/bmad-post-compact.sh

# Deploy git task tracking helper script
cat > .claude/scripts/bmad-git.sh << 'BMADGIT'
#!/usr/bin/env bash
# bmad-git.sh — Git Task Tracking Helpers for BMad Developer Agents
# Automates the commit-per-task and push-per-story workflow.
#
# Usage:
#   .claude/scripts/bmad-git.sh task-commit STORY-001 "Implement login form" 1
#   .claude/scripts/bmad-git.sh story-push STORY-001 "User Authentication"
#   .claude/scripts/bmad-git.sh sprint-start 1
#   .claude/scripts/bmad-git.sh sprint-merge 1
#   .claude/scripts/bmad-git.sh status STORY-001

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STORIES_DIR="$PROJECT_ROOT/docs/stories"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_ok()   { echo -e "${GREEN}✅ $1${NC}"; }
log_warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_fail() { echo -e "${RED}❌ $1${NC}"; }
log_git()  { echo -e "${BLUE}🔀 $1${NC}"; }

task_commit() {
  local story_id="$1"
  local task_desc="$2"
  local task_num="${3:-}"
  local story_file="$STORIES_DIR/${story_id}.md"

  if [[ ! -f "$story_file" ]]; then
    log_fail "Story file not found: $story_file"
    exit 1
  fi

  git add -A

  if git diff --cached --quiet; then
    log_warn "No changes staged. Nothing to commit."
    return 0
  fi

  local commit_msg="[${story_id}] task: ${task_desc}"
  git commit -m "$commit_msg"
  log_git "Committed: $commit_msg"

  local sha=$(git rev-parse --short HEAD)
  local timestamp=$(date -u +"%Y-%m-%d %H:%M UTC")

  log_ok "SHA: $sha | Time: $timestamp"

  if [[ -n "$task_num" ]]; then
    sed -i '' "s/| ${task_num} |.*⬜.*|.*—.*|.*—.*|/| ${task_num} | ${task_desc} | ✅ | \`${sha}\` | ${timestamp} |/" "$story_file"
  fi

  local log_entry="${sha}  ${commit_msg}"
  sed -i '' "/^(populated by developer/c\\
${log_entry}" "$story_file" 2>/dev/null || true

  local total_commits=$(git log --oneline --all | grep -c "\[${story_id}\]" 2>/dev/null || echo "0")
  sed -i '' "s/\*\*Total Commits\*\*: [0-9]*/\*\*Total Commits\*\*: ${total_commits}/" "$story_file" 2>/dev/null || true

  local first_sha=$(git log --oneline --reverse --all | grep "\[${story_id}\]" | head -1 | awk '{print $1}')
  local last_sha="$sha"
  sed -i '' "s/\*\*First Commit\*\*: .*/\*\*First Commit\*\*: \`${first_sha}\`/" "$story_file" 2>/dev/null || true
  sed -i '' "s/\*\*Last Commit\*\*: .*/\*\*Last Commit\*\*: \`${last_sha}\`/" "$story_file" 2>/dev/null || true

  sed -i '' 's/- \[x\] Not Started/- [ ] Not Started/' "$story_file" 2>/dev/null || true
  sed -i '' 's/- \[ \] In Progress/- [x] In Progress/' "$story_file" 2>/dev/null || true

  echo ""
  echo "  Story: ${story_id}"
  echo "  Task:  ${task_desc}"
  echo "  SHA:   ${sha}"
  echo "  Time:  ${timestamp}"
  echo ""
}

story_push() {
  local story_id="$1"
  local story_title="$2"
  local story_file="$STORIES_DIR/${story_id}.md"

  if [[ ! -f "$story_file" ]]; then
    log_fail "Story file not found: $story_file"
    exit 1
  fi

  sed -i '' 's/- \[x\] In Progress/- [ ] In Progress/' "$story_file" 2>/dev/null || true
  sed -i '' 's/- \[x\] Code Complete/- [ ] Code Complete/' "$story_file" 2>/dev/null || true
  sed -i '' 's/- \[ \] Tests Passing/- [x] Tests Passing/' "$story_file" 2>/dev/null || true
  sed -i '' 's/- \[ \] Pushed/- [x] Pushed/' "$story_file" 2>/dev/null || true
  sed -i '' 's/- \[ \] Done/- [x] Done/' "$story_file" 2>/dev/null || true
  sed -i '' 's/\*\*Pushed\*\*: ❌ No/\*\*Pushed\*\*: ✅ Yes/' "$story_file" 2>/dev/null || true

  git add "$story_file"
  git commit -m "[${story_id}] complete: ${story_title}"

  local final_sha=$(git rev-parse --short HEAD)
  sed -i '' "s/\*\*Last Commit\*\*: .*/\*\*Last Commit\*\*: \`${final_sha}\`/" "$story_file" 2>/dev/null || true

  local branch=$(git branch --show-current)
  log_git "Pushing ${story_id} to ${branch}..."
  git push origin "$branch"

  log_ok "Story ${story_id} complete and pushed!"
  echo ""
  echo "  Story:  ${story_id} — ${story_title}"
  echo "  Branch: ${branch}"
  echo "  Final SHA: ${final_sha}"
  echo ""
}

sprint_start() {
  local sprint_num="$1"
  local branch="sprint/sprint-${sprint_num}"

  git checkout develop 2>/dev/null || git checkout main 2>/dev/null || true
  git pull origin "$(git branch --show-current)" 2>/dev/null || true
  git checkout -b "$branch"
  log_ok "Created branch: ${branch}"
}

sprint_merge() {
  local sprint_num="$1"
  local branch="sprint/sprint-${sprint_num}"

  git checkout develop 2>/dev/null || git checkout main
  git pull origin "$(git branch --show-current)" 2>/dev/null || true
  git merge --no-ff "$branch" -m "Merge ${branch}: Sprint ${sprint_num} complete"
  git push origin "$(git branch --show-current)"
  git tag "sprint-${sprint_num}-complete"
  git push --tags
  log_ok "Sprint ${sprint_num} merged and tagged"
}

status() {
  local story_id="$1"
  echo "Git commits for ${story_id}:"
  git log --oneline --all | grep "\[${story_id}\]" || echo "  (no commits yet)"
  echo "Branch: $(git branch --show-current)"
}

update_tracker() {
  local tracker_file="$PROJECT_ROOT/docs/project-tracker.md"
  if [[ ! -f "$tracker_file" ]]; then
    log_warn "Project tracker not found. Skipping."
    return 0
  fi
  local now=$(date -u +"%Y-%m-%d %H:%M UTC")
  sed -i '' "s/\*\*Last Updated\*\*: .*/\*\*Last Updated\*\*: ${now}/" "$tracker_file" 2>/dev/null || true
  local branch=$(git branch --show-current 2>/dev/null || echo "N/A")
  sed -i '' "s/\*\*Branch\*\*: .*/\*\*Branch\*\*: ${branch}/" "$tracker_file" 2>/dev/null || true
  log_ok "Project tracker updated at ${now}"
}

case "${1:-help}" in
  task-commit)
    [[ -z "${2:-}" ]] && { echo "Usage: $0 task-commit STORY-NNN \"task description\" [task_number]"; exit 1; }
    task_commit "$2" "${3:-task}" "${4:-}"
    ;;
  story-push)
    [[ -z "${2:-}" ]] && { echo "Usage: $0 story-push STORY-NNN \"story title\""; exit 1; }
    story_push "$2" "${3:-Story complete}"
    ;;
  sprint-start)
    [[ -z "${2:-}" ]] && { echo "Usage: $0 sprint-start N"; exit 1; }
    sprint_start "$2"
    ;;
  sprint-merge)
    [[ -z "${2:-}" ]] && { echo "Usage: $0 sprint-merge N"; exit 1; }
    sprint_merge "$2"
    ;;
  status)
    [[ -z "${2:-}" ]] && { echo "Usage: $0 status STORY-NNN"; exit 1; }
    status "$2"
    ;;
  update-tracker)
    update_tracker
    ;;
  help|*)
    echo "BMad Git Helpers — Task-level commit tracking"
    echo "Commands: task-commit, story-push, sprint-start, sprint-merge, status, update-tracker"
    ;;
esac
BMADGIT

chmod +x .claude/scripts/bmad-git.sh

# Deploy hooks configuration to .claude/settings.json if not already present
if [ ! -f .claude/settings.json ]; then
  cat > .claude/settings.json << 'SETTINGS'
{
  "hooks": {
    "PreCompact": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/bmad-pre-compact.sh",
            "timeout": 30
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/scripts/bmad-post-compact.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
SETTINGS
elif ! grep -q "PreCompact" .claude/settings.json; then
  echo "⚠️  Note: .claude/settings.json exists but missing hook configuration."
  echo "   Add PreCompact and SessionStart hooks manually. See .claude/scripts/ for hook scripts."
fi

echo "✅ Project structure created"
echo "✅ Phase tracking initialized: docs/bmm-workflow-status.yaml"
echo "✅ Session tracker initialized: docs/session-tracker.md"
echo "✅ Auto-recovery hooks deployed: .claude/scripts/"
echo "✅ Project CLAUDE.md created with orchestrator role"
echo ""
echo "Three-level tracking:"
echo "  1. docs/bmm-workflow-status.yaml — Phase gates (used by /bmad-status, /bmad-gate)"
echo "  2. docs/project-tracker.md — Epic/Story dashboard (created by /bmad-track)"
echo "  3. docs/session-tracker.md — Orchestrator session state (for recovery)"
echo ""
echo "Auto-recovery:"
echo "  - PreCompact hook: Saves checkpoint before context compaction"
echo "  - PostCompact hook: Injects orchestrator role + session state after compaction"
```

## Step 2: Assume Orchestrator Role

**YOU (main chat) must now assume the orchestrator role and begin the workflow:**

1. **Read your orchestrator role definition:**
   ```typescript
   const orchestratorRole = await Read({
     file_path: ".claude/agents/orchestrator.md"
   });
   ```

2. **Update session tracker to mark initialization:**
   ```typescript
   await Edit({
     file_path: "docs/session-tracker.md",
     old_string: "**Current Phase**: Not started",
     new_string: `**Current Phase**: Phase 1: Discovery
**Session Started**: ${new Date().toISOString()}`
   });
   ```

3. **Greet the user and gather project info:**
   - Ask user to describe their project idea (2-3 sentences)
   - Ask about target users and main problem being solved
   - Capture any technical preferences mentioned

4. **Begin Phase 1 (Discovery):**
   ```typescript
   await Task({
     subagent_type: "Business Analyst",
     description: "Create Product Brief",
     prompt: `Create Product Brief for: [user's project description]

     OUTPUT: docs/product-brief.md

     Use template from: .claude/templates/product-brief-template.md

     OUTPUT PROTOCOL:
     Return only: "✅ Product Brief created. Sections: [N]. Pages: [M]."

     DO NOT return full content.`
   });
   ```

5. **Continue the workflow:**
   - After each phase completes, advance to the next
   - Update session-tracker.md after each phase
   - Use spawn patterns from `.claude/agents/orchestrator.md`
   - Implement token optimization strategies

**Result:** YOU (main chat) are now the orchestrator and manage the entire workflow

## Step 3: Remove Old Workflow File

The old `bmm-workflow-status.yaml` is replaced by `session-tracker.md` which is:
- Human-readable markdown (not YAML)
- Used by orchestrator for recovery
- Tracks artifacts, tasks, blockers
- Updated after each phase
## What Happens Next

After /bmad-init completes:

1. **Main chat (as orchestrator) greets you** and asks about your project
2. **You describe** your project idea (2-3 sentences)
3. **Main chat spawns Business Analyst** as subagent (Phase 1: Discovery)
4. **Business Analyst creates** `docs/product-brief.md`
5. **Main chat automatically advances** to Phase 2, 3, 4...
6. **You can stop anytime** with Ctrl+C or by asking
7. **Resume anytime** with `/bmad-next`

The main chat assumes the **orchestrator role in automated mode** - you describe your project once, then it orchestrates all 12 specialist agents through the complete workflow.

## Monitoring Progress

While you (as orchestrator) coordinate the workflow:
- `/bmad-status` - Show current phase and progress
- `/bmad-track` - Show epic/story dashboard
- `docs/session-tracker.md` - Your persistent state file

## Agent Team Environment Setup

To enable parallel agent teams for Phase 5 (Implementation), ensure this is in your settings:

```json
// .claude/settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "allow": ["Read", "Write", "Execute"]
  }
}
```
