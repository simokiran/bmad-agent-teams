#!/bin/bash
# BMad Pre-Compaction Hook
# Runs before context compaction to save a checkpoint to session-tracker.md
# Reads the transcript JSONL to extract recent activity context.

# Read hook input from stdin (JSON with transcript_path, cwd, etc.)
INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Fallback if cwd not provided
if [ -z "$CWD" ]; then
  CWD="$(pwd)"
fi

# Only run in BMad projects (session-tracker.md exists)
TRACKER="$CWD/docs/session-tracker.md"
if [ ! -f "$TRACKER" ]; then
  exit 0
fi

TIMESTAMP=$(date -u '+%Y-%m-%d %H:%M UTC')

# Extract recent context from transcript (last 200 lines)
RECENT_TOOLS=""
RECENT_AGENTS=""
RECENT_FILES=""

if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  # Extract recent tool uses (what was being worked on)
  RECENT_TOOLS=$(tail -200 "$TRANSCRIPT" | jq -r 'select(.type == "tool_use") | .name // empty' 2>/dev/null | sort | uniq -c | sort -rn | head -10)

  # Extract recent agent spawns
  RECENT_AGENTS=$(tail -200 "$TRANSCRIPT" | jq -r 'select(.type == "tool_use" and .name == "Task") | .input.description // empty' 2>/dev/null | tail -5)

  # Extract recently edited files
  RECENT_FILES=$(tail -200 "$TRANSCRIPT" | jq -r 'select(.type == "tool_use" and (.name == "Write" or .name == "Edit")) | .input.file_path // empty' 2>/dev/null | sort -u | tail -10)
fi

# Build checkpoint content
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

# Remove existing checkpoint section if present, then append new one
if grep -q "## Pre-Compaction Checkpoint" "$TRACKER"; then
  # Use python3 to safely replace the section
  python3 -c "
import re
with open('$TRACKER', 'r') as f:
    content = f.read()
# Remove old checkpoint section (from marker to next ## or EOF)
content = re.sub(r'\n## Pre-Compaction Checkpoint.*?(?=\n## |\Z)', '', content, flags=re.DOTALL)
with open('$TRACKER', 'w') as f:
    f.write(content.rstrip() + '\n')
" 2>/dev/null
fi

# Append new checkpoint
printf "\n%s\n" "$CHECKPOINT" >> "$TRACKER"

echo "Pre-compaction checkpoint saved to session tracker." >&2
