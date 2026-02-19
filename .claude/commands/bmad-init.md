# /bmad-init — Initialize BMad 12-Agent Team

Initialize the BMad Method project structure and prepare the agent team for orchestration.

## What This Command Does

1. Creates the full project directory structure
2. Initializes the workflow status tracker
3. Validates all 12 agent definitions are present
4. Enables Agent Teams (sets environment variable)
5. Provides the user with next steps

## Execution

```bash
# Create project structure
mkdir -p docs/stories docs/adrs docs/epics src tests scripts

# Initialize git if not already
git init 2>/dev/null || true
echo "node_modules/" >> .gitignore 2>/dev/null || true
echo ".env" >> .gitignore 2>/dev/null || true

# Create workflow status file
cat > docs/bmm-workflow-status.yaml << 'EOF'
project:
  name: ""
  level: 2  # Enterprise level (full workflow)
  initialized: true
  
phases:
  discovery:
    status: pending  # pending | in_progress | complete | failed
    agent: analyst
    output: docs/product-brief.md
    gate_passed: false
    
  planning:
    status: pending
    agents: [product-manager, ux-designer]
    outputs: [docs/prd.md, docs/ux-wireframes.md]
    gate_passed: false
    
  architecture:
    status: pending
    agent: architect
    outputs: [docs/architecture.md, docs/adrs/]
    gate_score: 0
    gate_passed: false  # Requires >= 90/100
    
  sprint_planning:
    status: pending
    agent: scrum-master
    outputs: [docs/sprint-plan.md, docs/stories/]
    gate_passed: false
    
  implementation:
    status: pending
    agents: [frontend-developer, backend-developer, database-engineer]
    parallel: true
    tracks:
      frontend: { stories: [], status: pending }
      backend: { stories: [], status: pending }
      database: { stories: [], status: pending }
    gate_passed: false
    
  quality_assurance:
    status: pending
    agent: qa-engineer
    output: docs/test-plan.md
    gate_passed: false
    
  deployment:
    status: pending
    agent: devops-engineer
    output: docs/deploy-config.md
    gate_passed: false
    
  final_review:
    status: pending
    agent: tech-lead
    output: docs/review-checklist.md
    verdict: null  # ship | ship_with_notes | do_not_ship
EOF

echo "✅ BMad Method initialized!"
echo ""
echo "Project structure created:"
echo "  docs/          — All planning documents"
echo "  docs/epics/    — Epic files (EPIC-001.md, etc.)"
echo "  docs/stories/  — Sprint story files"  
echo "  docs/adrs/     — Architecture Decision Records"
echo "  src/           — Implementation code"
echo "  tests/         — Test files"
echo ""
echo "12 Agents ready:"
echo "  1.  Orchestrator (Team Lead)"
echo "  2.  Business Analyst"
echo "  3.  Product Manager"
echo "  4.  UX Designer"
echo "  5.  System Architect"
echo "  6.  Scrum Master (creates Epics)"
echo "  7.  Story Writers (parallel — 1 per epic)"
echo "  8.  Frontend Developer"
echo "  9.  Backend Developer"
echo "  10. Database Engineer"
echo "  11. QA Engineer"
echo "  12. DevOps Engineer"
echo "  13. Tech Lead"
echo ""
echo "Git workflow:"
echo "  • Every task → git commit with [STORY-NNN] prefix"
echo "  • Commit SHA recorded in story file"
echo "  • Every story complete → git push to sprint branch"
echo "  • Sprint complete → merge to develop + tag"
echo ""
echo "🚀 Next step: Describe your project idea, and I'll start Phase 1 (Discovery)."
```

## Agent Team Environment Setup

To enable parallel agent teams for Phase 5 (Implementation), ensure this is in your settings:

```json
// .claude/settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "allow": ["Read", "Write", "Execute"]
  }
}
```
