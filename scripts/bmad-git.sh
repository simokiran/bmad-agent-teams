#!/usr/bin/env bash
# ============================================================================
# bmad-git.sh — Git Task Tracking Helpers for BMad Developer Agents
# ============================================================================
# Automates the commit-per-task and push-per-story workflow.
#
# Usage:
#   ./scripts/bmad-git.sh task-commit STORY-001 "Implement login form validation"
#   ./scripts/bmad-git.sh story-push STORY-001 "User Authentication"
#   ./scripts/bmad-git.sh sprint-start 1
#   ./scripts/bmad-git.sh sprint-merge 1
#   ./scripts/bmad-git.sh status STORY-001
# ============================================================================

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
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

# ============================================================================
# task-commit: Commit a task, record SHA in story file
# ============================================================================
task_commit() {
  local story_id="$1"
  local task_desc="$2"
  local task_num="${3:-}"
  local story_file="$STORIES_DIR/${story_id}.md"

  if [[ ! -f "$story_file" ]]; then
    log_fail "Story file not found: $story_file"
    exit 1
  fi

  # Stage all changes
  git add -A

  # Check if there's anything to commit
  if git diff --cached --quiet; then
    log_warn "No changes staged. Nothing to commit."
    return 0
  fi

  # Commit with story-prefixed message
  local commit_msg="[${story_id}] task: ${task_desc}"
  git commit -m "$commit_msg"
  log_git "Committed: $commit_msg"

  # Capture SHA and timestamp
  local sha=$(git rev-parse --short HEAD)
  local timestamp=$(date -u +"%Y-%m-%d %H:%M UTC")

  log_ok "SHA: $sha | Time: $timestamp"

  # Update the story file's Git Task Tracking table
  # Find the task row by task number or description and update it
  if [[ -n "$task_num" ]]; then
    # Update by task number: find the row starting with "| N |"
    # Replace ⬜ with ✅, — with SHA, — with timestamp
    sed -i "s/| ${task_num} |.*⬜.*|.*—.*|.*—.*|/| ${task_num} | ${task_desc} | ✅ | \`${sha}\` | ${timestamp} |/" "$story_file"
  fi

  # Append to Commit Log section
  # Find the commit log code block and append
  local log_entry="${sha}  ${commit_msg}"
  sed -i "/^(populated by developer/c\\${log_entry}" "$story_file" 2>/dev/null || true

  # Update Total Commits count
  local total_commits=$(git log --oneline --all | grep -c "\[${story_id}\]" 2>/dev/null || echo "0")
  sed -i "s/\*\*Total Commits\*\*: [0-9]*/\*\*Total Commits\*\*: ${total_commits}/" "$story_file" 2>/dev/null || true

  # Update First/Last Commit
  local first_sha=$(git log --oneline --reverse --all | grep "\[${story_id}\]" | head -1 | awk '{print $1}')
  local last_sha="$sha"
  sed -i "s/\*\*First Commit\*\*: .*/\*\*First Commit\*\*: \`${first_sha}\`/" "$story_file" 2>/dev/null || true
  sed -i "s/\*\*Last Commit\*\*: .*/\*\*Last Commit\*\*: \`${last_sha}\`/" "$story_file" 2>/dev/null || true

  # If story was "Not Started", change to "In Progress"
  sed -i 's/- \[x\] Not Started/- [ ] Not Started/' "$story_file" 2>/dev/null || true
  sed -i 's/- \[ \] In Progress/- [x] In Progress/' "$story_file" 2>/dev/null || true

  echo ""
  echo "  Story: ${story_id}"
  echo "  Task:  ${task_desc}"
  echo "  SHA:   ${sha}"
  echo "  Time:  ${timestamp}"
  echo ""
}

# ============================================================================
# story-push: Mark story as done, push to sprint branch
# ============================================================================
story_push() {
  local story_id="$1"
  local story_title="$2"
  local story_file="$STORIES_DIR/${story_id}.md"

  if [[ ! -f "$story_file" ]]; then
    log_fail "Story file not found: $story_file"
    exit 1
  fi

  # Update story status to Done
  sed -i 's/- \[x\] In Progress/- [ ] In Progress/' "$story_file" 2>/dev/null || true
  sed -i 's/- \[x\] Code Complete/- [ ] Code Complete/' "$story_file" 2>/dev/null || true
  sed -i 's/- \[ \] Tests Passing/- [x] Tests Passing/' "$story_file" 2>/dev/null || true
  sed -i 's/- \[ \] Pushed/- [x] Pushed/' "$story_file" 2>/dev/null || true
  sed -i 's/- \[ \] Done/- [x] Done/' "$story_file" 2>/dev/null || true

  # Update Pushed status in Git Summary
  sed -i 's/\*\*Pushed\*\*: ❌ No/\*\*Pushed\*\*: ✅ Yes/' "$story_file" 2>/dev/null || true

  # Commit the story file update
  git add "$story_file"
  git commit -m "[${story_id}] complete: ${story_title}"

  local final_sha=$(git rev-parse --short HEAD)
  sed -i "s/\*\*Last Commit\*\*: .*/\*\*Last Commit\*\*: \`${final_sha}\`/" "$story_file" 2>/dev/null || true

  # Push to sprint branch
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

# ============================================================================
# sprint-start: Create sprint branch
# ============================================================================
sprint_start() {
  local sprint_num="$1"
  local branch="sprint/sprint-${sprint_num}"

  # Ensure we're on develop or main
  git checkout develop 2>/dev/null || git checkout main 2>/dev/null || true

  # Pull latest
  git pull origin "$(git branch --show-current)" 2>/dev/null || true

  # Create sprint branch
  git checkout -b "$branch"
  log_ok "Created branch: ${branch}"

  echo ""
  echo "  Sprint ${sprint_num} started"
  echo "  Branch: ${branch}"
  echo "  Ready for implementation"
  echo ""
}

# ============================================================================
# sprint-merge: Merge sprint branch to develop
# ============================================================================
sprint_merge() {
  local sprint_num="$1"
  local branch="sprint/sprint-${sprint_num}"

  git checkout develop 2>/dev/null || git checkout main
  git pull origin "$(git branch --show-current)" 2>/dev/null || true

  git merge --no-ff "$branch" -m "Merge ${branch}: Sprint ${sprint_num} complete"
  git push origin "$(git branch --show-current)"

  # Tag the sprint
  git tag "sprint-${sprint_num}-complete"
  git push --tags

  log_ok "Sprint ${sprint_num} merged to $(git branch --show-current)"
  echo ""
  echo "  Tag: sprint-${sprint_num}-complete"
  echo ""
}

# ============================================================================
# status: Show git status for a story
# ============================================================================
status() {
  local story_id="$1"

  echo ""
  echo "Git commits for ${story_id}:"
  echo "─────────────────────────────"
  git log --oneline --all | grep "\[${story_id}\]" || echo "  (no commits yet)"
  echo ""
  echo "Branch: $(git branch --show-current)"
  echo "Unpushed commits: $(git log --oneline @{u}..HEAD 2>/dev/null | wc -l || echo 'N/A')"
  echo ""
}

# ============================================================================
# update-tracker: Update the project tracker with git stats
# ============================================================================
update_tracker() {
  local tracker_file="$PROJECT_ROOT/docs/project-tracker.md"

  if [[ ! -f "$tracker_file" ]]; then
    log_warn "Project tracker not found. Skipping."
    return 0
  fi

  # Update "Last Updated" timestamp
  local now=$(date -u +"%Y-%m-%d %H:%M UTC")
  sed -i "s/\*\*Last Updated\*\*: .*/\*\*Last Updated\*\*: ${now}/" "$tracker_file" 2>/dev/null || true

  # Update branch name
  local branch=$(git branch --show-current 2>/dev/null || echo "N/A")
  sed -i "s/\*\*Branch\*\*: .*/\*\*Branch\*\*: ${branch}/" "$tracker_file" 2>/dev/null || true

  log_ok "Project tracker updated at ${now}"
}

# ============================================================================
# Main Dispatcher
# ============================================================================
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
    echo ""
    echo "Usage: $0 <command> [args]"
    echo ""
    echo "Commands:"
    echo "  task-commit STORY-NNN \"description\" [num]  Commit task, record SHA in story"
    echo "  story-push  STORY-NNN \"title\"               Mark done, push to sprint branch"
    echo "  sprint-start N                              Create sprint/sprint-N branch"
    echo "  sprint-merge N                              Merge sprint to develop + tag"
    echo "  status STORY-NNN                            Show commits for a story"
    echo "  update-tracker                              Update project-tracker.md"
    ;;
esac
