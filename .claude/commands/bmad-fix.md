# /bmad-fix — Create Fix Story from Staging Issues

**CRITICAL**: This command triggers the MAIN CHAT to assume the BMad Orchestrator role directly, then run the fix workflow. The orchestrator is the team lead and operates in the main session, NOT as a subagent.

## What This Command Does

1. **You (main chat) assume the BMad Orchestrator role**
2. **You read** `.claude/agents/orchestrator.md` to load your role
3. **You read** `docs/session-tracker.md` to understand current state
4. **You collect issues** from the user (visual bugs, layout problems, behavior issues found on staging)
5. **You spawn Story Writer** to create a fix story (STORY-NNN) with acceptance criteria
6. **You spawn Developer agent** to implement all fixes
7. **Developer commits and pushes** using `bmad-git.sh task-commit` per fix

## Role Assumption Protocol

When this command is invoked, YOU (the main chat Claude instance) must:

1. **Read your orchestrator role definition:**
   - File: `.claude/agents/orchestrator.md`
   - This defines your responsibilities, delegation rules, and spawn patterns

2. **Read the session tracker:**
   - File: `docs/session-tracker.md`
   - This shows current state: phase, sprint, active blockers

3. **Remember: you are a coordinator, NOT an implementer:**
   - Do NOT write the story yourself — spawn **Story Writer** agent
   - Do NOT write code yourself — spawn **Developer** agent
   - You ONLY collect issues, spawn agents, and update the session tracker

## Usage

```
/bmad-fix                    — Asks for issue list interactively
/bmad-fix carousel broken    — Creates fix story for carousel issue
```

## Architecture

```
User: /bmad-fix
   ↓
Orchestrator: Collect issues from user
   ↓
Orchestrator: Determine next story number + sprint context
   ↓
Orchestrator: Spawn Story Writer agent
   → Story Writer creates docs/stories/STORY-NNN.md with fix tasks
   ↓
Orchestrator: Ask user to verify story
   ↓
Orchestrator: Spawn appropriate Developer agent
   → Developer implements fixes, commits per task
   ↓
Orchestrator: Update session tracker
```

## Execution

### Step 1: Collect Issues

```typescript
// Check if user provided issues after /bmad-fix
if (!issueDescription) {
  const issues = await AskUserQuestion({
    questions: [{
      question: "What issues did you find on staging? Describe all problems you want fixed.",
      header: "Issues",
      multiSelect: false,
      options: [
        {
          label: "Visual/Layout issues",
          description: "CSS, spacing, alignment, responsive problems"
        },
        {
          label: "Behavior issues",
          description: "Broken interactions, wrong functionality, JS errors"
        },
        {
          label: "Both visual and behavior",
          description: "Mix of styling and functional problems"
        }
      ]
    }]
  });

  // Then ask for specific details
  const details = await AskUserQuestion({
    questions: [{
      question: "List each specific issue (one per line or comma-separated). Include page/component if known.",
      header: "Details",
      multiSelect: false,
      options: [
        { label: "I'll type them out", description: "Provide a detailed list of issues" }
      ]
    }]
  });
}
```

### Step 2: Determine Story Context

```typescript
// Find the next available story number
const existingStories = await Glob({ pattern: "docs/stories/STORY-*.md" });
const nextStoryNum = /* parse highest number + 1 */;

// Find the current sprint
const sessionTracker = await Read({ file_path: "docs/session-tracker.md" });
const currentSprint = /* parse from tracker */;
const currentBranch = /* parse from tracker or git */;

// Determine the track (Frontend, Backend, etc.) from the issue descriptions
// Most staging fixes are Frontend track
```

### Step 3: Spawn Story Writer

```typescript
// CRITICAL: Orchestrator does NOT write the story itself
await Agent({
  subagent_type: "Story Writer",
  description: `Create fix story STORY-${nextStoryNum}`,
  prompt: `Create a fix story for post-staging issues.

STORY NUMBER: STORY-${nextStoryNum}
SPRINT: Sprint ${currentSprint}
TRACK: ${track} (Frontend/Backend/Database as appropriate)
TYPE: Bug Fix

ISSUES TO FIX:
${issueList}

INSTRUCTIONS:
1. Read docs/PROJECT-SUMMARY.md for tech stack context
2. Read docs/naming-registry.md for naming conventions
3. Create docs/stories/STORY-${nextStoryNum}.md using the story template
4. Title: "Sprint ${currentSprint} Staging Fixes — ${briefDescription}"
5. Create one task per issue in the Tasks section
6. Write testable acceptance criteria for each fix
7. Set Story Points based on complexity (typically 3-5 for fix batches)
8. Set Status: Not Started

Use the Write tool to create the story file directly.
Return the file path and a brief summary of tasks created.`
});
```

### Step 4: User Verification

```typescript
// Read the created story
const story = await Read({ file_path: `docs/stories/STORY-${nextStoryNum}.md` });

// Show to user
console.log(`Story created: docs/stories/STORY-${nextStoryNum}.md`);

const approval = await AskUserQuestion({
  questions: [{
    question: "Review the fix story above. Approve to proceed with implementation?",
    header: "Approve",
    multiSelect: false,
    options: [
      { label: "Approve — start fixing", description: "Spawn developer agent to implement all fixes" },
      { label: "Edit first", description: "I want to adjust the story before implementation" },
      { label: "Cancel", description: "Don't implement yet" }
    ]
  }]
});
```

### Step 5: Spawn Developer Agent

```typescript
if (approved) {
  await Agent({
    subagent_type: trackToDeveloper(track), // "Frontend Developer", "Backend Developer", etc.
    description: `Implement fixes from STORY-${nextStoryNum}`,
    prompt: `Implement all fixes in docs/stories/STORY-${nextStoryNum}.md

Read the story file for the full task list and acceptance criteria.
For each task:
1. Implement the fix
2. Commit using: .claude/scripts/bmad-git.sh task-commit STORY-${nextStoryNum} "task description" TASK_NUMBER

After all tasks are done:
.claude/scripts/bmad-git.sh story-push STORY-${nextStoryNum} "Sprint ${currentSprint} Staging Fixes"

Return a brief summary of what was fixed and the commit SHAs.`
  });

  // Update session tracker
  await Edit({
    file_path: "docs/session-tracker.md",
    // Add to Decision Log: "Fix story STORY-NNN created and implemented"
  });
}
```

## When to Use This Command

- After deploying a sprint to staging and finding visual/behavior issues
- When the user reports bugs that aren't covered by existing stories
- When post-deploy QA reveals problems before formal Phase 6
- Any time you need a structured fix batch outside the normal sprint flow

## Relationship to Other Commands

- `/bmad-fix` — **Creates a fix story + implements** (what you need after staging review)
- `/bmad-next` — Advances phases (use after fixes are done to enter Phase 6)
- `/bmad-sprint` — Runs full sprint implementation (for planned stories, not fixes)
- `/bmad-correct-course` (v1.2) — Major project pivots (changing PRD, adding/dropping epics)

## Benefits

- Structured fix tracking with proper story file and acceptance criteria
- Uses existing BMad agents (Story Writer + Developer) — orchestrator never writes artifacts
- Git-tracked with `bmad-git.sh task-commit` per fix
- User approves story before implementation starts
- Fits naturally into the BMad workflow between sprint completion and Phase 6 QA
