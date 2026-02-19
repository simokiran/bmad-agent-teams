# Naming Registry & Data Dictionary
**Project**: [Project Name]
**Last Updated**: [Auto-updated by agents]
**Maintained By**: All developer agents (Architect creates, developers update)

> **PURPOSE**: This is the single source of truth for ALL naming conventions across database, API, types, routes, and frontend. Every agent MUST check this document before creating new entities and update it when adding new names.

---

## Naming Conventions

### General Rules
- **Database**: `snake_case` for tables and columns
- **API Routes**: `kebab-case` for paths, `camelCase` for JSON fields
- **TypeScript Types**: `PascalCase` for types/interfaces, `camelCase` for properties
- **React Components**: `PascalCase` for files and component names
- **Variables/Functions**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`

---

## 1. Database Schema Registry

### Tables

| Table Name | Description | Columns | Indexes | Created By | Story |
|------------|-------------|---------|---------|------------|-------|
| `users` | User accounts | id, email, name, password_hash, created_at, updated_at | idx_users_email (UNIQUE) | Architect | STORY-001 |
| `sessions` | User sessions | id, user_id, token, expires_at, created_at | idx_sessions_token, idx_sessions_user_id | Database Engineer | STORY-002 |

### Column Name Standards

**User-Related**:
- `user_id` - Foreign key to users table (always this exact name)
- `created_by_user_id` - User who created the record
- `updated_by_user_id` - User who last updated

**Timestamps** (always include both):
- `created_at` - TIMESTAMP NOT NULL DEFAULT NOW()
- `updated_at` - TIMESTAMP NOT NULL DEFAULT NOW()

**Common Patterns**:
- `is_[status]` - Boolean flags (e.g., `is_active`, `is_deleted`)
- `[entity]_id` - Foreign keys (e.g., `project_id`, `task_id`)
- `[field]_hash` - Hashed values (e.g., `password_hash`)

---

## 2. API Endpoint Registry

### Endpoints

| Method | Path | Description | Request Body | Response Type | Created By | Story |
|--------|------|-------------|--------------|---------------|------------|-------|
| POST | `/api/auth/register` | User registration | `RegisterRequest` | `AuthResponse` | Backend Developer | STORY-003 |
| POST | `/api/auth/login` | User login | `LoginRequest` | `AuthResponse` | Backend Developer | STORY-004 |
| POST | `/api/auth/logout` | User logout | None | `SuccessResponse` | Backend Developer | STORY-005 |
| GET | `/api/users/:id` | Get user profile | None | `UserResponse` | Backend Developer | STORY-006 |

### API Field Naming

**Request/Response Bodies**:
- Use `camelCase` for JSON fields
- Match TypeScript interface property names exactly
- Example: Database `created_at` → API response `createdAt`

**Common Response Fields**:
```typescript
{
  success: boolean;
  data: T | null;
  error: ErrorObject | null;
  meta?: {
    page?: number;
    total?: number;
    limit?: number;
  }
}
```

---

## 3. TypeScript Type Registry

### Types & Interfaces

| Type Name | Purpose | Properties | File Location | Created By | Story |
|-----------|---------|------------|---------------|------------|-------|
| `User` | User entity | id, email, name, createdAt, updatedAt | `src/types/user.ts` | Backend Developer | STORY-001 |
| `Session` | Session entity | id, userId, token, expiresAt, createdAt | `src/types/auth.ts` | Backend Developer | STORY-002 |
| `RegisterRequest` | Registration payload | email, password, name | `src/types/auth.ts` | Backend Developer | STORY-003 |
| `LoginRequest` | Login payload | email, password | `src/types/auth.ts` | STORY-004 |
| `AuthResponse` | Auth success response | user: User, token: string | `src/types/auth.ts` | Backend Developer | STORY-005 |

### Type Naming Patterns

**Entity Types**: `User`, `Project`, `Task` (singular, PascalCase)
**Request Types**: `[Action][Entity]Request` (e.g., `CreateProjectRequest`)
**Response Types**: `[Entity]Response` or `[Action]Response` (e.g., `UserResponse`, `AuthResponse`)
**Props Types**: `[ComponentName]Props` (e.g., `LoginFormProps`)
**State Types**: `[Feature]State` (e.g., `AuthState`)

---

## 4. Route Registry (Frontend)

### Page Routes

| Route Path | Component | Page Title | Auth Required | Created By | Story |
|------------|-----------|------------|---------------|------------|-------|
| `/` | `HomePage` | Home | No | Frontend Developer | STORY-010 |
| `/login` | `LoginPage` | Login | No | Frontend Developer | STORY-011 |
| `/register` | `RegisterPage` | Register | No | Frontend Developer | STORY-012 |
| `/dashboard` | `DashboardPage` | Dashboard | Yes | Frontend Developer | STORY-013 |
| `/profile/:id` | `ProfilePage` | User Profile | Yes | Frontend Developer | STORY-014 |

### Route Naming Standards

- Use lowercase, hyphenated paths: `/user-profile`, not `/UserProfile`
- Pluralize collections: `/projects`, `/tasks`
- Singular for single items: `/project/:id`, `/task/:id`
- Actions as verbs: `/login`, `/register`, `/reset-password`

---

## 5. Component Registry (Frontend)

### Shared Components

| Component Name | Purpose | Props Interface | File Location | Created By | Story |
|----------------|---------|-----------------|---------------|------------|-------|
| `Button` | Reusable button | `ButtonProps` | `src/components/ui/Button.tsx` | Frontend Developer | STORY-020 |
| `Input` | Form input field | `InputProps` | `src/components/ui/Input.tsx` | Frontend Developer | STORY-021 |
| `LoginForm` | Login form | `LoginFormProps` | `src/components/auth/LoginForm.tsx` | Frontend Developer | STORY-011 |

### Component Naming Standards

**Files**: PascalCase matching component name (`Button.tsx`, `LoginForm.tsx`)
**Folders**:
- `src/components/ui/` - Base design system components
- `src/components/features/` - Feature-specific components
- `src/components/layout/` - Layout components

---

## 6. Form Field Registry

### Form Field Names

| Form | Field Name | HTML Input Name | State Variable | Validation | Story |
|------|------------|-----------------|----------------|------------|-------|
| Login | Email | `email` | `email` | Email format | STORY-011 |
| Login | Password | `password` | `password` | Min 8 chars | STORY-011 |
| Register | Email | `email` | `email` | Email format | STORY-012 |
| Register | Password | `password` | `password` | Min 8 chars | STORY-012 |
| Register | Name | `name` | `name` | Min 2 chars | STORY-012 |

### Form Naming Standards

- HTML `name` attribute matches API field name (camelCase)
- React state variable matches field name exactly
- Validation error keys match field names

---

## 7. Mobile Registry (Apps)

### Mobile Screens

| Screen Name | Platform | Purpose | Navigation Route | File Location | Created By | Story |
|-------------|----------|---------|------------------|---------------|------------|-------|
| `RegisterScreen` | React Native | User registration | `/register` | `mobile/src/screens/auth/RegisterScreen.tsx` | Mobile Developer | STORY-020 |
| `LoginScreen` | React Native | User login | `/login` | `mobile/src/screens/auth/LoginScreen.tsx` | Mobile Developer | STORY-021 |

### Mobile Components

| Component Name | Platform | Purpose | Props | File Location | Created By | Story |
|----------------|----------|---------|-------|---------------|------------|-------|
| `Button` | React Native | Reusable button | `ButtonProps` | `mobile/src/components/ui/Button.tsx` | Mobile Developer | STORY-025 |
| `Input` | React Native | Form input | `InputProps` | `mobile/src/components/ui/Input.tsx` | Mobile Developer | STORY-026 |

### Mobile Navigation

| Route | Screen | Auth Required | Deep Link | Created By | Story |
|-------|--------|---------------|-----------|------------|-------|
| `/` | `HomeScreen` | No | `app://` | Mobile Developer | STORY-030 |
| `/login` | `LoginScreen` | No | `app://login` | Mobile Developer | STORY-021 |
| `/register` | `RegisterScreen` | No | `app://register` | Mobile Developer | STORY-020 |
| `/dashboard` | `DashboardScreen` | Yes | `app://dashboard` | Mobile Developer | STORY-031 |

### Mobile Naming Standards

**React Native / Expo**:
- Screens: `PascalCase` + "Screen" suffix (`RegisterScreen`)
- Components: `PascalCase` (`Button`, `Card`)
- Files: Match component name (`RegisterScreen.tsx`)

**Flutter**:
- Screens: `PascalCase` + "Screen" suffix (`RegisterScreen`)
- Files: `snake_case` (`register_screen.dart`)

**SwiftUI**:
- Views: `PascalCase` + "Screen" suffix (`RegisterScreen`)
- Files: Match struct name (`RegisterScreen.swift`)

**Kotlin / Compose**:
- Composables: `PascalCase` (`RegisterScreen`)
- Files: `PascalCase` (`RegisterScreen.kt`)

---

## 8. State Management Registry

### Global State

| State Slice | Properties | File Location | Created By | Story |
|-------------|------------|---------------|------------|-------|
| `auth` | user, token, isAuthenticated, isLoading | `src/store/authSlice.ts` | Frontend Developer | STORY-030 |
| `ui` | theme, sidebarOpen, notifications | `src/store/uiSlice.ts` | Frontend Developer | STORY-031 |

### State Naming Standards

- State slices: `camelCase` (e.g., `auth`, `userProfile`)
- Actions: `verb + noun` (e.g., `setUser`, `clearAuth`)
- Selectors: `select + PropertyName` (e.g., `selectUser`, `selectIsAuthenticated`)

---

## 9. Environment Variables

### Environment Variable Registry

| Variable Name | Purpose | Example Value | Required | Created By | Story |
|---------------|---------|---------------|----------|------------|-------|
| `DATABASE_URL` | Postgres connection | `postgresql://...` | Yes | Database Engineer | STORY-001 |
| `JWT_SECRET` | JWT signing key | `random-secret` | Yes | Backend Developer | STORY-004 |
| `API_BASE_URL` | API endpoint | `http://localhost:3000` | Yes | Backend Developer | STORY-001 |
| `NEXT_PUBLIC_API_URL` | Public API URL | `/api` | Yes | Frontend Developer | STORY-010 |

---

## 10. Error Code Registry

### Error Codes

| Code | Name | Message | HTTP Status | Created By | Story |
|------|------|---------|-------------|------------|-------|
| `AUTH_001` | `INVALID_CREDENTIALS` | Invalid email or password | 401 | Backend Developer | STORY-004 |
| `AUTH_002` | `EMAIL_IN_USE` | Email already registered | 409 | Backend Developer | STORY-003 |
| `AUTH_003` | `SESSION_EXPIRED` | Session has expired | 401 | Backend Developer | STORY-005 |
| `VAL_001` | `VALIDATION_ERROR` | Input validation failed | 400 | Backend Developer | STORY-003 |

---

## 11. Cross-Reference Mapping

### Example: User Registration Flow

| Layer | Name | Type | Notes |
|-------|------|------|-------|
| **Database** | `users` table | Table | Stores user records |
| | `email` column | VARCHAR(255) | User email |
| | `password_hash` column | VARCHAR(255) | Bcrypt hashed password |
| **API** | `POST /api/auth/register` | Endpoint | Registration endpoint |
| | `email` field | string (JSON) | Request body field |
| | `password` field | string (JSON) | Request body field (plain text, hashed by API) |
| **Types** | `RegisterRequest` | Interface | TypeScript type for request |
| | `email` property | string | Matches API field |
| | `password` property | string | Matches API field |
| **Frontend** | `/register` | Route | Registration page |
| | `RegisterForm` | Component | Registration form component |
| | `email` | Input name | Form field name |
| | `password` | Input name | Form field name |
| **Mobile** | `RegisterScreen` | Screen | Registration screen |
| | `RegisterScreen.tsx` | File | React Native screen component |
| | `email` state | State variable | TextInput value |
| | `keyboardType="email-address"` | TextInput prop | Email keyboard |
| **State** | `auth.user` | State property | Stores logged-in user |

---

## Agent Responsibilities

### When to Update This Document

**System Architect**:
- ✅ Creates this document in Phase 3
- ✅ Defines initial tables, API patterns, type conventions
- ✅ Sets up naming standards

**Database Engineer**:
- ✅ Before creating any table: Check if table name exists
- ✅ Before adding any column: Check naming pattern
- ✅ After creating migration: Add table/columns to Section 1
- ✅ Update Cross-Reference Mapping (Section 10)

**Backend Developer**:
- ✅ Before creating any endpoint: Check if path exists
- ✅ Before defining types: Check existing type names
- ✅ After creating endpoint: Add to Section 2 (API Registry)
- ✅ After creating types: Add to Section 3 (Type Registry)
- ✅ Update Cross-Reference Mapping (Section 10)

**Frontend Developer**:
- ✅ Before creating any route: Check route registry
- ✅ Before creating any component: Check component registry
- ✅ Before naming form fields: Check form field registry
- ✅ After creating route: Add to Section 4 (Route Registry)
- ✅ After creating component: Add to Section 5 (Component Registry)
- ✅ After creating form: Add fields to Section 6 (Form Field Registry)
- ✅ Update Cross-Reference Mapping (Section 11)

**Mobile Developer**:
- ✅ Before creating any screen: Check Section 7 (Mobile Registry)
- ✅ Before creating components: Check mobile component registry
- ✅ Before calling APIs: Check Section 2 for endpoint contracts
- ✅ After creating screen: Add to Section 7 (Mobile Screens)
- ✅ After creating component: Add to Section 7 (Mobile Components)
- ✅ After creating navigation: Add to Section 7 (Mobile Navigation)
- ✅ Update Cross-Reference Mapping (Section 11)

---

## Update Protocol

1. **Read this document** before starting any task that creates new entities
2. **Check for conflicts** - ensure your names don't collide
3. **Follow conventions** - match the established patterns
4. **Add new entries** immediately after creating entities
5. **Update cross-references** - maintain Section 10 mapping
6. **Document in story file** - reference this document in technical notes

---

**Last Updated**: [Timestamp]
**Updated By**: [Agent Name]
**Related Story**: [STORY-NNN]
