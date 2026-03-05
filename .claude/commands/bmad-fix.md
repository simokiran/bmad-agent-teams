# /bmad-fix — Create On-Demand Story (Fixes, Features, Extensions)

**CRITICAL**: This command triggers the MAIN CHAT to assume the BMad Orchestrator role directly. The orchestrator is the team lead and operates in the main session, NOT as a subagent.

## What This Command Does

1. **You (main chat) assume the BMad Orchestrator role**
2. **You read** `.claude/agents/orchestrator.md` to load your role
3. **You read** `docs/session-tracker.md` to understand current state
4. **You determine** the story type (fix, feature, or extension)
5. **You collect details** from the user
6. **You spawn Story Writer** to create the story (STORY-NNN) with tasks and acceptance criteria
7. **You ask user** to review and approve the story
8. **You spawn Developer agent** to implement
9. **Developer commits** using `bmad-git.sh task-commit` per task

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
   - You ONLY collect requirements, spawn agents, and update the session tracker

## Usage

```
/bmad-fix                              — Interactive: asks what type and details
/bmad-fix carousel not scrolling       — Bug fix story
/bmad-fix add wishlist page            — New feature story
/bmad-fix extend STORY-205 with X      — Extend existing story
```

## Architecture

```
User: /bmad-fix
   ↓
Orchestrator: Load role + session state
   ↓
Orchestrator: Determine story type (fix / feature / extension)
   ↓
Orchestrator: Collect details from user
   ↓
Orchestrator: Determine next story number + sprint context
   ↓
Orchestrator: Spawn Story Writer agent
   → Story Writer creates docs/stories/STORY-NNN.md
   ↓
Orchestrator: Show story to user for approval
   ↓
Orchestrator: Spawn appropriate Developer agent
   → Developer implements, commits per task
   ↓
Orchestrator: Update session tracker
```

## Execution

### Step 1: Determine Story Type

```typescript
// Check if user provided context after /bmad-fix
if (!userInput) {
  const storyType = await AskUserQuestion({
    questions: [{
      question: "What kind of story do you need?",
      header: "Story Type",
      multiSelect: false,
      options: [
        {
          label: "Bug fixes",
          description: "Fix issues found on staging or reported by users"
        },
        {
          label: "New feature",
          description: "Add new functionality not in the current sprint"
        },
        {
          label: "Extend existing story",
          description: "Add tasks/scope to an existing story"
        }
      ]
    }]
  });
}
```

### Step 2: Collect Details

```typescript
// For bug fixes:
//   - Ask for specific issues (what's broken, where, steps to reproduce)
// For new features:
//   - Ask for feature description, user-facing behavior, affected pages/components
// For extensions:
//   - Ask which story to extend and what to add

const details = await AskUserQuestion({
  questions: [{
    question: "Describe the details. For fixes: what's broken and where. For features: what it should do.",
    header: "Details",
    multiSelect: false,
    options: [
      { label: "I'll type them out", description: "Provide a detailed description" }
    ]
  }]
});
```

### Step 3: Determine Story Context

```typescript
// Find the next available story number
const existingStories = await Glob({ pattern: "docs/stories/STORY-*.md" });
const nextStoryNum = /* parse highest number + 1 */;

// Find the current sprint
const sessionTracker = await Read({ file_path: "docs/session-tracker.md" });
const currentSprint = /* parse from tracker */;
const currentBranch = /* parse from tracker or git */;

// Determine the track (Frontend, Backend, etc.) from the descriptions
```

### Step 4: Spawn Story Writer

```typescript
// CRITICAL: Orchestrator does NOT write the story itself — ALWAYS spawn Story Writer
await Agent({
  subagent_type: "Story Writer",
  description: `Create story STORY-${nextStoryNum}`,
  prompt: `Create a ${storyType} story.

STORY NUMBER: STORY-${nextStoryNum}
SPRINT: Sprint ${currentSprint}
TRACK: ${track} (Frontend/Backend/Database as appropriate)
TYPE: ${storyType === "fixes" ? "Bug Fix" : storyType === "feature" ? "New Feature" : "Extension"}

${storyType === "fixes" ? "ISSUES TO FIX:" : "REQUIREMENTS:"}
${userDetails}

INSTRUCTIONS:
1. Read docs/PROJECT-SUMMARY.md for tech stack context
2. Read docs/naming-registry.md for naming conventions
3. Create docs/stories/STORY-${nextStoryNum}.md using the story template
4. Create one task per item in the Tasks section
5. Write testable acceptance criteria
6. Set Story Points based on complexity
7. Set Status: Not Started

Use the Write tool to create the story file directly.
Return the file path and a brief summary of tasks created.`
});
```

### Step 5: User Verification

```typescript
// Read the created story and show to user
const story = await Read({ file_path: `docs/stories/STORY-${nextStoryNum}.md` });

const approval = await AskUserQuestion({
  questions: [{
    question: "Review the story. Approve to proceed with implementation?",
    header: "Approve",
    multiSelect: false,
    options: [
      { label: "Approve — start implementing", description: "Spawn developer agent to implement all tasks" },
      { label: "Edit first", description: "I want to adjust the story before implementation" },
      { label: "Story only", description: "Keep the story but don't implement yet" },
      { label: "Cancel", description: "Delete the story" }
    ]
  }]
});
```

### Step 6: Spawn Developer Agent

```typescript
if (approved) {
  await Agent({
    subagent_type: trackToDeveloper(track), // "Frontend Developer", "Backend Developer", etc.
    description: `Implement STORY-${nextStoryNum}`,
    prompt: `Implement all tasks in docs/stories/STORY-${nextStoryNum}.md

Read the story file for the full task list and acceptance criteria.
For each task:
1. Implement the task
2. Commit using: .claude/scripts/bmad-git.sh task-commit STORY-${nextStoryNum} "task description" TASK_NUMBER

After all tasks are done:
.claude/scripts/bmad-git.sh story-push STORY-${nextStoryNum} "Story Title"

Return a brief summary of what was done and the commit SHAs.`
  });

  // Update session tracker
  await Edit({
    file_path: "docs/session-tracker.md",
    // Add to Decision Log: "STORY-NNN (type) created and implemented via /bmad-fix"
  });
}
```

## When to Use This Command

- **Fixes**: After deploying a sprint to staging and finding visual/behavior issues
- **Features**: When the user wants new functionality not in the current sprint plan
- **Extensions**: When an existing story needs more scope (new tasks, expanded behavior)
- Any time you need a story outside the normal phase-driven flow

## Relationship to Other Commands

- `/bmad-fix` — **Creates any on-demand story** (fixes, features, extensions) + optionally implements
- `/bmad-next` — Advances phases (use after stories are done)
- `/bmad-sprint` — Runs full sprint implementation (for planned stories from Phase 4b)
- `/bmad-correct-course` (v1.2) — Major project pivots (changing PRD, adding/dropping whole epics)

## Benefits

- Single command for all unplanned work (fixes, features, extensions)
- Story Writer creates proper story with acceptance criteria — never ad-hoc
- Git-tracked with `bmad-git.sh task-commit` per task
- User approves story before implementation starts
- "Story only" option lets you batch stories and implement later
- Orchestrator never writes specialist artifacts
