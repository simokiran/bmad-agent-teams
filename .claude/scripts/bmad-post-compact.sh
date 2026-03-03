#!/bin/bash
# BMad Post-Compaction Recovery Hook
# Runs after context compaction (SessionStart with "compact" matcher).
# stdout is INJECTED directly into Claude's post-compaction context.

# Read hook input from stdin (JSON with cwd, etc.)
INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Fallback if cwd not provided
if [ -z "$CWD" ]; then
  CWD="$(pwd)"
fi

TRACKER="$CWD/docs/session-tracker.md"

# Only run in BMad projects
if [ ! -f "$TRACKER" ]; then
  exit 0
fi

# Everything below goes to stdout and is INJECTED into Claude's context
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
