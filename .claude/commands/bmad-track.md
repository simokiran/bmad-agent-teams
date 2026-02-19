# /bmad-track — Project Tracker Dashboard

Display the full project tracking view: epics → stories → tasks → git commits.

## Execution

Read all epic files, story files, and git log to build the dashboard. Write/update `docs/project-tracker.md`.

```bash
echo "═══════════════════════════════════════════════════"
echo "  BMad Method — Project Tracker"
echo "═══════════════════════════════════════════════════"
echo ""

TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")
BRANCH=$(git branch --show-current 2>/dev/null || echo "N/A")

echo "Last Updated: $TIMESTAMP"
echo "Branch: $BRANCH"
echo ""

# ── EPIC PROGRESS ──
echo "╔═══════════════════════════════════════════════╗"
echo "║  Epic Progress                                 ║"
echo "╠═══════════════════════════════════════════════╣"

for epic_file in docs/epics/EPIC-*.md; do
  [[ -f "$epic_file" ]] || continue
  
  epic_id=$(basename "$epic_file" .md)
  epic_title=$(head -1 "$epic_file" | sed 's/^# [A-Z-]*: //')
  
  # Find stories belonging to this epic
  story_count=$(grep -rl "Epic.*${epic_id}" docs/stories/ 2>/dev/null | wc -l)
  done_count=$(grep -rl "Epic.*${epic_id}" docs/stories/ 2>/dev/null | xargs grep -l "\[x\] Done" 2>/dev/null | wc -l)
  
  if [[ $story_count -gt 0 ]]; then
    pct=$((done_count * 100 / story_count))
    bar_fill=$((pct / 10))
    bar_empty=$((10 - bar_fill))
    bar=$(printf '█%.0s' $(seq 1 $bar_fill 2>/dev/null) ; printf '░%.0s' $(seq 1 $bar_empty 2>/dev/null))
  else
    pct=0
    bar="░░░░░░░░░░"
  fi
  
  printf "║ %-10s %-20s %2d/%2d  %s %3d%% ║\n" "$epic_id" "$epic_title" "$done_count" "$story_count" "$bar" "$pct"
done

echo "╚═══════════════════════════════════════════════╝"
echo ""

# ── STORY STATUS ──
echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║  Story Status                                                     ║"
echo "╠═══════════════════════════════════════════════════════════════════╣"
echo "║ Story      │ Epic       │ Track    │ Pts │ Status     │ Commits  ║"
echo "╟────────────┼────────────┼──────────┼─────┼────────────┼──────────╢"

for story_file in docs/stories/STORY-*.md; do
  [[ -f "$story_file" ]] || continue
  
  story_id=$(basename "$story_file" .md)
  epic=$(grep -o "EPIC-[0-9]*" "$story_file" 2>/dev/null | head -1 || echo "—")
  track=$(grep "Track.*:" "$story_file" 2>/dev/null | head -1 | sed 's/.*: //' || echo "—")
  points=$(grep "Points.*:" "$story_file" 2>/dev/null | head -1 | sed 's/.*: //' || echo "—")
  
  # Determine status
  if grep -q "\[x\] Done" "$story_file" 2>/dev/null; then
    status="✅ Done"
  elif grep -q "\[x\] In Progress" "$story_file" 2>/dev/null; then
    status="🔄 Active"
  else
    status="⬜ Pending"
  fi
  
  # Count commits for this story
  commits=$(git log --oneline 2>/dev/null | grep -c "\[${story_id}\]" || echo "0")
  
  # Get last SHA
  last_sha=$(git log --oneline 2>/dev/null | grep "\[${story_id}\]" | head -1 | awk '{print $1}' || echo "—")
  
  printf "║ %-10s │ %-10s │ %-8s │ %3s │ %-10s │ %s (%s)  ║\n" \
    "$story_id" "$epic" "$track" "$points" "$status" "$commits" "$last_sha"
done

echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

# ── TRACK PROGRESS ──
echo "╔═════════════════════════════════════════════╗"
echo "║  Track Progress                              ║"
echo "╠═════════════════════════════════════════════╣"

for track in "Database" "Backend" "Frontend"; do
  assigned=$(grep -rl "Track.*${track}" docs/stories/ 2>/dev/null | wc -l)
  done=$(grep -rl "Track.*${track}" docs/stories/ 2>/dev/null | xargs grep -l "\[x\] Done" 2>/dev/null | wc -l)
  active=$(grep -rl "Track.*${track}" docs/stories/ 2>/dev/null | xargs grep -l "\[x\] In Progress" 2>/dev/null | wc -l)
  pending=$((assigned - done - active))
  
  printf "║ %-10s  Assigned: %2d  Done: %2d  Active: %2d  Pending: %2d ║\n" \
    "$track" "$assigned" "$done" "$active" "$pending"
done

echo "╚═════════════════════════════════════════════╝"
echo ""

# ── RECENT GIT ACTIVITY ──
echo "╔═══════════════════════════════════════════════════════╗"
echo "║  Recent Git Activity (last 10 commits)                ║"
echo "╠═══════════════════════════════════════════════════════╣"

git log --oneline -10 2>/dev/null | while read line; do
  printf "║  %s  ║\n" "$line"
done || echo "║  (no git history)                                      ║"

echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# ── OVERALL PROGRESS ──
total_stories=$(find docs/stories -name "STORY-*.md" 2>/dev/null | wc -l)
done_stories=$(grep -rl "\[x\] Done" docs/stories/ 2>/dev/null | wc -l)
total_commits=$(git log --oneline 2>/dev/null | grep -c "\[STORY" || echo "0")

if [[ $total_stories -gt 0 ]]; then
  overall_pct=$((done_stories * 100 / total_stories))
else
  overall_pct=0
fi

echo "Overall: ${done_stories}/${total_stories} stories complete (${overall_pct}%)"
echo "Total commits: ${total_commits}"
echo "Branch: ${BRANCH}"
```

## Writing to docs/project-tracker.md

After displaying the dashboard, also write it to `docs/project-tracker.md` so it persists as a document:

```markdown
# Project Tracker: [Project Name]
**Last Updated**: [timestamp]
**Current Phase**: [detected from document existence]
**Branch**: [current git branch]

[Epic Progress table]
[Story Status table]
[Track Progress table]
[Recent Git Activity]
[Overall Progress]
```

## When to Update

The orchestrator should run `/bmad-track` (or update the tracker file):
1. After every phase transition
2. Every time a developer completes a story (Phase 5)
3. When the user asks for status
4. Before quality gate checks (Phase 6)
