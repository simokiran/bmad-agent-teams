# /bmad-design — Create Frontend Design Prototype

Spawn the Frontend Design Prototyper to create an HTML/CSS/JS demo and update the visual identity guide.

## What This Command Does

1. Identifies what the user wants to prototype
2. Spawns the Frontend Design Prototyper agent (one-off, not added to team)
3. Agent reads UX wireframes and existing visual identity guide
4. Agent creates a self-contained HTML prototype in `docs/design-prototypes/`
5. Agent updates `docs/visual-identity-guide.md` with design tokens
6. Returns the file path so user can open in browser

## Usage

```
/bmad-design                              — Asks what to prototype
/bmad-design login page                   — Prototypes the login page
/bmad-design dashboard header component   — Prototypes the dashboard header
/bmad-design product card with pricing    — Prototypes a product card
```

## Execution

### Step 1: Parse Design Request

Check if the user provided a description after `/bmad-design`:
- **If provided**: Use it as the design request
- **If not provided**: Ask the user what they want prototyped

```typescript
// If no request specified, ask the user
if (!designRequest) {
  const answer = await AskUserQuestion({
    questions: [{
      question: "What component, screen, or element would you like prototyped?",
      header: "Design",
      multiSelect: false,
      options: [
        {
          label: "Full page/screen",
          description: "Complete page layout (e.g., login page, dashboard, landing page)"
        },
        {
          label: "Component",
          description: "Individual UI component (e.g., navigation bar, card, form)"
        },
        {
          label: "Design system update",
          description: "Update visual identity guide with new tokens or patterns"
        }
      ]
    }]
  });
  // User will describe specifics in their response
}
```

### Step 2: Verify Prerequisites

```bash
# Check if UX wireframes exist (required input for prototyper)
ls docs/ux-wireframes.md 2>/dev/null
```

If wireframes don't exist, warn the user:
```
⚠️ No UX wireframes found (docs/ux-wireframes.md).
The prototyper works best with wireframes as input.
Proceeding anyway — the prototype will be based on your description and general best practices.
```

### Step 3: Spawn Frontend Design Prototyper

```typescript
await Task({
  subagent_type: "Frontend Design Prototyper",
  description: "Create design prototype",
  prompt: `Create a frontend design prototype.

**DESIGN REQUEST:**
${designRequest}

**INPUT:**
- Read: docs/ux-wireframes.md (if exists — UX specifications)
- Read: docs/visual-identity-guide.md (if exists — existing design tokens)
- Read: docs/PROJECT-SUMMARY.md (if exists — project context)

**OUTPUT:**
- Create: docs/design-prototypes/{component-name}.html (self-contained demo)
- Update: docs/visual-identity-guide.md (create or update with design tokens)

**REQUIREMENTS:**
- Self-contained HTML file (HTML + CSS + JS in one file)
- Responsive design (mobile + desktop)
- Interactive states (hover, focus, active)
- Realistic placeholder content
- Accessible (semantic HTML, focus states, contrast)

**OUTPUT PROTOCOL:**
After creating the prototype and updating the guide, return ONLY:
"✅ Design prototype created. File: docs/design-prototypes/{name}.html. Guide: updated. Components: [list]."

DO NOT return the full HTML content in your response.`
});
```

### Step 4: Report Results

After the prototyper completes, inform the user:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 DESIGN PROTOTYPE CREATED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Prototype: docs/design-prototypes/{name}.html
Guide: docs/visual-identity-guide.md

→ Open the HTML file in your browser to preview
→ Frontend developers will follow the visual identity guide
→ Run /bmad-design again to create more prototypes
```

## Notes

- This command can be used at any time, but is most useful during Phase 5 (Implementation)
- The visual identity guide accumulates tokens across multiple prototypes
- Frontend developers are instructed to check `docs/visual-identity-guide.md` for design consistency
- Each prototype is independent — you can create as many as needed
