#!/bin/bash
# BMad Post-Compaction Recovery Hook
# Runs after context compaction (SessionStart with "compact" matcher).
# stdout is INJECTED directly into Claude's post-compaction context.
#
# OPTIMIZATION: Instead of injecting the entire session tracker (~76KB),
# this script selectively extracts only recovery-essential sections (~15KB).
# Historical session logs, completed phase checklists, token tracking,
# and duplicated recovery protocols are skipped (still readable on demand).

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

CRITICAL: You are a COORDINATOR, not an implementer.
NEVER produce specialist artifacts yourself — not code, not stories, not test plans, not architecture docs.
ALWAYS delegate to the appropriate agent: Developer agents for code, Story Writer for stories, QA Engineer for test plans, etc.

IMMEDIATE ACTIONS:
1. The session tracker SUMMARY is included below (key sections only)
2. Increment the "Compaction Events" counter in docs/session-tracker.md
3. Read .claude/agents/orchestrator.md for your full role definition
4. Resume from the "Next Action Queue" in the session tracker
5. Brief the user: "Session recovered. Phase: [X]. Resuming: [action]."
6. If you need full phase history, read the complete docs/session-tracker.md

DO NOT start fresh or create your own plans. You are mid-workflow.
DO NOT ask the user "what should I do?" — the session tracker tells you.
DO NOT write code yourself — spawn the appropriate developer agent.
RECOVERY

echo ""
echo "=== CURRENT SESSION STATE (SUMMARY) ==="
echo ""

# --- Selective extraction via awk ---
# Injects only recovery-essential sections, skipping:
#   - Completed phase checklists (phases before current)
#   - Token Optimization Tracking
#   - Post-Compaction Recovery Protocol (duplicated in orchestrator.md)
#   - Recovery Example (duplicated in orchestrator.md)
#   - Orchestrator Instructions for Session Tracking (reference only)
#   - Old session log entries (keeps last 2)

awk '
BEGIN {
    printing = 0
    in_phase = 0
    phase_active = 0
    collecting_sessions = 0
    session_count = 0
}

# Detect H2 headers (## Section)
/^## / {
    section = $0
    sub(/^## /, "", section)

    # --- Always-inject sections ---
    if (section ~ /^Project Metadata/ ||
        section ~ /^Current State/ ||
        section ~ /^Active Background Tasks/ ||
        section ~ /^Git Tracking/ ||
        section ~ /^Blockers and Issues/ ||
        section ~ /^User Notes/ ||
        section ~ /^Pre-Compaction Checkpoint/ ||
        section ~ /^Critical/) {
        # Flush any pending session collection
        if (collecting_sessions) { collecting_sessions = 0 }
        printing = 1
        in_phase = 0
        print
        next
    }

    # --- Phase Progress Checklist (filter to active phases only) ---
    if (section ~ /^Phase Progress Checklist/) {
        if (collecting_sessions) { collecting_sessions = 0 }
        printing = 1
        in_phase = 1
        print
        next
    }

    # --- Known skip sections (still in file, not injected) ---
    if (section ~ /^Token Optimization/ ||
        section ~ /^Post-Compaction Recovery/ ||
        section ~ /^Recovery Example/ ||
        section ~ /^Orchestrator Instructions/) {
        if (collecting_sessions) { collecting_sessions = 0 }
        printing = 0
        in_phase = 0
        next
    }

    # --- Session Log header (new template container) ---
    if (section ~ /^Session Log$/) {
        printing = 0
        in_phase = 0
        collecting_sessions = 1
        next
    }

    # --- Session entries: "## Session N:" or "## *Session*" ---
    # Handles both old format (H2 session entries) and new format (under ## Session Log)
    if (section ~ /Session/) {
        in_phase = 0
        printing = 0
        collecting_sessions = 1
        # This is a new session entry
        session_count++
        if (session_count <= 2) {
            if (session_count == 1) session_buf_1 = $0 "\n"
            else session_buf_2 = $0 "\n"
        } else {
            session_buf_1 = session_buf_2
            session_buf_2 = $0 "\n"
        }
        next
    }

    # --- Any other unknown H2 section — skip ---
    printing = 0
    in_phase = 0
    if (collecting_sessions) { collecting_sessions = 0 }
    next
}

# Inside Phase Progress: detect H3 phase sub-headers (### Phase N: ...)
in_phase && /^### Phase [0-9]/ {
    if ($0 ~ /⏳/ || $0 ~ /❌/) {
        phase_active = 1
        print
    } else {
        phase_active = 0
    }
    next
}

# Inside phase progress, respect phase_active flag
in_phase {
    if (phase_active) print
    next
}

# Collecting session entries — buffer content of current session
collecting_sessions {
    # Detect H3 session entries under ## Session Log container
    if ($0 ~ /^### Session/ || $0 ~ /^### [0-9]{4}-[0-9]{2}-[0-9]{2}/) {
        session_count++
        if (session_count <= 2) {
            if (session_count == 1) session_buf_1 = $0 "\n"
            else session_buf_2 = $0 "\n"
        } else {
            session_buf_1 = session_buf_2
            session_buf_2 = $0 "\n"
        }
        next
    }

    # Append line to the current (latest) session buffer
    if (session_count >= 1) {
        if (session_count == 1) {
            session_buf_1 = session_buf_1 $0 "\n"
        } else {
            session_buf_2 = session_buf_2 $0 "\n"
        }
    }
    next
}

# Default: print if in an always-inject section
printing { print }

END {
    # Output last 2 session entries
    if (session_count > 0) {
        print "## Recent Sessions"
        print ""
        if (session_count == 1) {
            printf "%s", session_buf_1
        } else {
            printf "%s", session_buf_1
            printf "%s", session_buf_2
        }
        if (session_count > 2) {
            print "[" (session_count - 2) " older session(s) omitted — read full docs/session-tracker.md if needed]"
        }
        print ""
    }
}
' "$TRACKER"

echo ""
echo "=== END SESSION STATE ==="
echo ""
echo "Resume from the Next Action Queue above. Do NOT ask the user what to do."
echo "For full session history, read: docs/session-tracker.md"
