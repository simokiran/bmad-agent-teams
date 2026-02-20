# Code Examples Directory

**Purpose**: External code examples referenced by agents (Token Optimization Phase 3)

## Why External Examples?

**Before (Embedded):**
- Agent instruction files contain 80-line code examples
- 5 examples × 2k tokens = 10k tokens per agent file
- Total: 10k × 13 agents = 130k tokens

**After (External):**
- Agent files reference examples/ directory
- Agents read examples when needed (lazy loading)
- Agent files: ~200 tokens per reference
- Savings: ~120k tokens across all agents

## Directory Structure

```
examples/
├── api-patterns/           # API route patterns
│   ├── nextjs-api-route.ts         # Next.js API route with Zod
│   ├── express-endpoint.ts          # Express endpoint pattern
│   └── graphql-resolver.ts          # GraphQL resolver pattern
├── component-patterns/     # UI component patterns
│   ├── react-form.tsx               # React form with validation
│   ├── react-native-screen.tsx      # React Native screen
│   └── flutter-widget.dart          # Flutter widget pattern
├── database-patterns/      # Database patterns
│   ├── prisma-migration.ts          # Prisma migration example
│   ├── query-helper.ts              # Database query helper
│   └── typeorm-entity.ts            # TypeORM entity pattern
└── README.md              # This file
```

## Usage by Agents

### In Agent Instructions (Before)

```markdown
## API Route Pattern

Example:
```typescript
// 80 lines of embedded code...
export async function POST(request: Request) {
  // ...
}
```
```

Tokens: 2,000

### In Agent Instructions (After)

```markdown
## API Route Pattern

See: .claude/examples/api-patterns/nextjs-api-route.ts

Key points:
- Use Zod for validation (Schema.safeParse)
- Return NextResponse.json with status codes
- Separate business logic from route handler

Read the full example when implementing your first API route.
```

Tokens: 150 (93% reduction)

## When to Read Examples

**Don't read upfront.** Use lazy loading:

1. Read example when implementing similar feature
2. Skim for pattern understanding
3. Adapt to your story requirements
4. Follow naming registry conventions

## Adding New Examples

When adding examples:
- Keep them concise (< 100 lines)
- Include comments explaining key concepts
- Follow project conventions
- Reference from agent instructions (don't embed)

## Token Savings

| Pattern | Before (Embedded) | After (External) | Savings |
|---------|------------------|------------------|---------|
| API routes | 2k × 4 agents | 150 × 4 | 7.4k |
| Components | 2k × 2 agents | 150 × 2 | 3.7k |
| Database | 2k × 1 agent | 150 × 1 | 1.85k |
| **Total** | **16k tokens** | **1.2k tokens** | **14.8k** |

---

**Status**: Phase 3 optimization - external examples
**Impact**: 14.8k token savings across agent instruction files
