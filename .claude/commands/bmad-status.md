# /bmad-status — Show Current Project Status

Check the current phase, document status, and next steps for the BMad workflow.

## Execution

Read `docs/bmm-workflow-status.yaml` and display the current state. Also check which documents exist on disk.

```bash
echo "═══════════════════════════════════════════"
echo "  BMad Method — Project Status Dashboard"
echo "═══════════════════════════════════════════"
echo ""

# Check each phase's output documents
check_file() {
  if [[ -f "$1" ]]; then
    local lines=$(wc -l < "$1")
    echo "  ✅ $2 ($lines lines)"
  else
    echo "  ⬜ $2 (not created)"
  fi
}

echo "Phase 1: Discovery"
check_file "docs/product-brief.md" "Product Brief"
echo ""

echo "Phase 2: Planning"
check_file "docs/prd.md" "Product Requirements Document"
check_file "docs/ux-wireframes.md" "UX Specification"
echo ""

echo "Phase 3: Architecture"
check_file "docs/architecture.md" "Technical Architecture"
adr_count=$(find docs/adrs -name "ADR-*.md" 2>/dev/null | wc -l)
echo "  📋 Architecture Decision Records: $adr_count"
echo ""

echo "Phase 4: Sprint Planning"
check_file "docs/sprint-plan.md" "Sprint Plan"
story_count=$(find docs/stories -name "STORY-*.md" 2>/dev/null | wc -l)
if [[ $story_count -gt 0 ]]; then
  done_count=$(grep -l "Done" docs/stories/STORY-*.md 2>/dev/null | wc -l)
  echo "  📋 Stories: $done_count/$story_count complete"
else
  echo "  ⬜ Stories: none created"
fi
echo ""

echo "Phase 5: Implementation"
src_files=$(find src -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" 2>/dev/null | wc -l)
test_files=$(find tests -type f -name "*.test.*" 2>/dev/null | wc -l)
echo "  📁 Source files: $src_files"
echo "  🧪 Test files: $test_files"
echo ""

echo "Phase 6: Quality Assurance"
check_file "docs/test-plan.md" "Test Plan & Results"
echo ""

echo "Phase 7: Deployment"
check_file "docs/deploy-config.md" "Deployment Configuration"
echo ""

echo "Phase 8: Final Review"
check_file "docs/review-checklist.md" "Review Checklist"
echo ""

echo "═══════════════════════════════════════════"
```

## Determining Next Phase

After displaying status, identify the current phase based on which documents exist:

1. No `product-brief.md` → **Phase 1: Discovery** — Spawn Analyst
2. No `prd.md` or `ux-wireframes.md` → **Phase 2: Planning** — Spawn PM + UX
3. No `architecture.md` → **Phase 3: Architecture** — Spawn Architect
4. No stories in `docs/stories/` → **Phase 4: Sprint Planning** — Spawn Scrum Master
5. Stories exist but not all "Done" → **Phase 5: Implementation** — Spawn Dev Team
6. No `test-plan.md` → **Phase 6: QA** — Spawn QA Engineer
7. No `deploy-config.md` → **Phase 7: Deployment** — Spawn DevOps
8. No `review-checklist.md` → **Phase 8: Review** — Spawn Tech Lead
9. All documents exist → **🎉 Complete!** — Ready to ship

Tell the user: "You are currently in Phase [N]. To advance, say `/bmad-next` or tell me to start Phase [N]."
