# BMad Method — Advanced Configuration

## Customizing the Agent Pipeline

### Change the Tech Stack Preference

Edit `.claude/agents/architect.md` and add a section:

```markdown
## Tech Stack Preferences (Project-Specific)
When designing the architecture for this project, prefer:
- Frontend: Vue 3 + Nuxt (instead of React/Next.js)
- Backend: Python + FastAPI (instead of Node.js)
- Database: MongoDB (instead of PostgreSQL)
- Hosting: AWS (instead of Vercel)
```

The Architect agent reads this and adjusts all downstream decisions accordingly.

### Add Custom Agents

Create a new file in `.claude/agents/`. Example security auditor:

```markdown
---
name: Security Auditor
description: Performs OWASP Top 10 security audit
model: sonnet
---

# Security Auditor Agent

## Role
You perform security audits against the OWASP Top 10...

## Input
- src/ — All application code
- docs/architecture.md — Auth and security design

## Output
Write docs/security-audit.md with findings...
```

Then update the Orchestrator to include this agent between Phase 6 and Phase 7.

### Modify Quality Gate Thresholds

Edit `.claude/commands/bmad-gate.md`:

```
# For a prototype/hackathon (lower standards):
Architecture Gate: 70/100 (instead of 90/100)
Test Coverage: 50% (instead of 80%)

# For enterprise/regulated (higher standards):
Architecture Gate: 95/100
Test Coverage: 90%
Security Audit: Required (add as Phase 6.5)
```

### Scale to More Developers

For large projects, add specialized implementation agents:

```
Phase 5 Team (expanded):
├── frontend-dev (UI components, pages)
├── backend-dev (API routes, business logic)
├── db-engineer (schema, migrations, queries)
├── auth-specialist (authentication & authorization)
├── integration-dev (third-party API integrations)
└── test-engineer (writes tests in parallel with devs)
```

Create agent definitions for each and update `/bmad-sprint` spawn sequence.

---

## Model Configuration

### Cost-Optimized (Recommended)
```json
{
  "env": {
    "CLAUDE_CODE_SUBAGENT_MODEL": "claude-sonnet-4-5-20250929"
  }
}
```
- Orchestrator: Opus (your main session)
- Architect + Tech Lead: Opus (complex reasoning)
- All others: Sonnet (focused tasks)
- Estimated cost: ~$5-15 per full pipeline run

### Speed-Optimized
```json
{
  "env": {
    "CLAUDE_CODE_SUBAGENT_MODEL": "claude-haiku-4-5-20251001"
  }
}
```
- Fastest execution, lowest cost
- Quality may be lower for complex architecture decisions
- Good for prototypes and hackathons

### Quality-Maximized
```json
{
  "env": {
    "CLAUDE_CODE_SUBAGENT_MODEL": "claude-opus-4-6"
  }
}
```
- Every agent runs on Opus
- Highest quality output
- Most expensive (~$30-50 per pipeline run)
- Use for production enterprise projects

---

## Workflow Variations

### Lightweight Mode (Levels 0-1)
For simple projects, skip the full pipeline:

```
Phase 1: Brief (simplified — 1 paragraph)
Phase 2: Tech Spec (combined PRD + Architecture, no UX)
Phase 3: Stories (3-5 stories max)
Phase 4: Implementation (single developer, no Agent Team)
Phase 5: Quick Review (combined QA + Review)
```

Configure by adding to `CLAUDE.md`:
```
## Project Level: 0
Skip phases: UX Designer, Scrum Master (create stories directly),
             DevOps Engineer. Combine QA + Tech Lead into single review.
```

### Enterprise Mode (Level 3+)
For large, complex projects:

```
Phase 1: Discovery (Analyst + Market Research Agent)
Phase 2: Planning (PM + UX + Accessibility Specialist)
Phase 3: Architecture (Architect + Security Architect)
Phase 3.5: Architecture Review Board (3 agents debate the design)
Phase 4: Sprint Planning (Scrum Master creates multi-sprint roadmap)
Phase 5: Implementation (6+ parallel developers)
Phase 5.5: Code Review (Peer review agent)
Phase 6: QA (QA + Performance Testing + Security Audit)
Phase 7: Deployment (DevOps + SRE Agent)
Phase 8: Final Review (Tech Lead + Architecture Review)
```

### Party Mode
Bring multiple agents into one session to collaborate:

```
You: Let's discuss the authentication approach. Bring in the Architect,
     Backend Developer, and Security Auditor to debate.

Orchestrator: [Spawns 3 agents in discussion mode]

Architect: "I recommend NextAuth with JWT tokens because..."
Backend Dev: "That works, but we need to consider session invalidation..."
Security: "JWTs have a known revocation problem. Consider opaque tokens..."
```

This is great for resolving design disagreements before implementation.

---

## Integration with Existing Projects

### Adding BMad to an Existing Codebase

1. Run `./install.sh /path/to/existing-project`
2. Edit `CLAUDE.md` to describe the existing project structure
3. Skip Phase 1-3 if you already have requirements and architecture
4. Start at Phase 4: Tell the Scrum Master about specific features to add
5. Phase 5: Developers will work within your existing code structure

### Iterative Development (Multiple Sprints)

After Phase 8, loop back for Sprint 2:

```
You: Start Sprint 2. Add these features from the "Out of Scope" list:
     - Stripe payment integration
     - Team collaboration
     - Mobile app

Orchestrator: [Re-runs Phase 4 → 5 → 6 → 7 → 8 with new features]
```

The existing docs are updated, not replaced. New stories are created, and developers build on top of Sprint 1 code.

---

## Troubleshooting

### "Agent doesn't follow its instructions"
- Ensure the agent .md file has proper YAML frontmatter
- Make the prompt in the spawn command reference the agent file explicitly
- Add "CRITICAL: Read .claude/agents/[name].md FIRST before doing anything"

### "Agent Teams won't spawn"
- Verify: `echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` → should print `1`
- Check `.claude/settings.json` has the env var set
- Ensure you're running Claude Code (not claude.ai web interface)

### "Quality gate keeps failing"
- Read the gate output to see which dimensions scored low
- Edit the upstream document to address gaps
- Re-spawn the agent with: "Focus specifically on [gap area]"
- If persistent, lower the threshold temporarily

### "Developers conflict on shared files"
- Review the Scrum Master's story assignments — tracks should be file-independent
- If conflict occurs, tell the orchestrator to reassign file ownership
- Use the `SendMessage` API to coordinate between teammates

### "Too expensive"
- Use Sonnet for all subagents (not Opus)
- Reduce story count per sprint
- Use Lightweight Mode for simpler projects
- Skip optional phases (UX, DevOps) for prototypes
