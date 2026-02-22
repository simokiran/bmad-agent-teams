# Testing BMad Plugin After Bug Fixes

## Issues Fixed
1. ✅ UX Designer no longer references non-existent skills-required.md
2. ✅ bmad-next now validates project is initialized first
3. ✅ Added clearer error messages

## Test Steps

### 1. Navigate to Test Project (CORRECT PATH!)
```bash
cd /Users/meddev/Desktop/brandsandcorner
# NOT brandsandcorners with 's' - check your path!
```

### 2. Clean Up Old State (if any)
```bash
# Remove any partial/broken docs from previous failed runs
rm -rf docs/ .claude/
```

### 3. Initialize BMad
```bash
# In Claude Code, run:
/bmad-init
```

**Expected Output:**
- Creates `docs/` folder with session-tracker.md and bmm-workflow-status.yaml
- Orchestrator assumes role and asks you to describe your project
- Business Analyst agent spawns to create Product Brief (Phase 1)

### 4. Advance to Phase 2 (The Previously Broken Phase!)
```bash
# After Phase 1 completes, run:
/bmad-next
```

**Expected Output:**
- Orchestrator detects Phase 1 is complete
- Spawns Product Manager + UX Designer in parallel
- Both agents write their files (prd.md, ux-wireframes.md)
- Returns brief confirmations (not full content)
- **Should NOT hang or run out of memory**

### 5. Monitor Memory Usage
```bash
# In another terminal, monitor memory:
top -pid $(pgrep -f "claude")
```

Watch for:
- Memory should stay stable (not continuously growing)
- Agents should complete within 2-5 minutes
- No infinite loops

## What Should Happen

### Phase 1: Discovery
- Business Analyst reads user input
- Creates `docs/product-brief.md`
- Returns: "✅ Product Brief created. Sections: [N]. Pages: [M]."

### Phase 2: Planning (THE FIXED PHASE)
- Product Manager reads product-brief.md
- Creates `docs/prd.md`
- Returns: "✅ PRD created. Features: [N]. Personas: [M]."

- UX Designer reads product-brief.md (NO LONGER tries to read skills-required.md!)
- Creates `docs/ux-wireframes.md`
- Returns: "✅ UX wireframes created. Screens: [N]. Flows: [M]."

Both run in parallel, both complete cleanly.

## If It Still Hangs

Check:
1. Are you in the correct directory? (`pwd` should show `/Users/meddev/Desktop/brandsandcorner`)
2. Did `/bmad-init` complete successfully? (check `ls docs/`)
3. Is there enough disk space? (`df -h .`)
4. Are there any error messages in the agent output?

## Debug Mode

To see detailed agent output:
```bash
# Set debug environment variable
export CLAUDE_CODE_DEBUG=1

# Then run /bmad-next
/bmad-next
```

This will show more detailed logs of what agents are doing.

## Report Back

After testing, report:
- ✅ Phase 2 completed without hanging
- ✅ Memory stayed stable
- ✅ Files were created (prd.md, ux-wireframes.md)
- ❌ OR: Still hangs at [specific step], error: [message]
