# Document Templates

Base templates for every file that Game Dojo generates. Each template uses `{{PLACEHOLDER}}` variables that get filled in during generation. Never leave a placeholder unfilled — replace every one with project-specific content.

---

## 1. GEMINI.md Template

```markdown
# {{PROJECT_NAME}} — Project Rules

> This file is the **single source of truth** for AI agents working in this codebase.
> Read it completely before performing any task.

## Project Overview

**Name:** {{PROJECT_NAME}}
**Description:** {{PROJECT_DESCRIPTION}}
**Type:** {{PROJECT_TYPE}}
**Status:** {{PROJECT_STATUS}}

## Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
{{TECH_STACK_TABLE}}

## Coding Conventions

### File Naming
- {{FILE_NAMING_CONVENTION}}

### Component/Module Structure
- {{COMPONENT_STRUCTURE_RULES}}

### Import Order
1. {{IMPORT_ORDER_RULES}}

### Naming Conventions
- **Variables:** {{VARIABLE_NAMING}}
- **Functions:** {{FUNCTION_NAMING}}
- **Classes/Types:** {{CLASS_NAMING}}
- **Constants:** {{CONSTANT_NAMING}}
- **Files:** {{FILE_NAMING}}

## Code Style

### Language-Specific Rules
{{LANGUAGE_SPECIFIC_RULES}}

### Error Handling
- {{ERROR_HANDLING_PATTERN}}

### Logging
- {{LOGGING_PATTERN}}

## Testing Requirements

- **Unit tests:** {{UNIT_TEST_REQUIREMENTS}}
- **Integration tests:** {{INTEGRATION_TEST_REQUIREMENTS}}
- **E2E tests:** {{E2E_TEST_REQUIREMENTS}}
- **Coverage threshold:** {{COVERAGE_THRESHOLD}}

## Environment Variables

All environment variables must be defined in `.env.example` with descriptions.

| Variable | Description | Required | Default |
|----------|------------|----------|---------|
{{ENV_VARS_TABLE}}

## Project Structure

```
{{FOLDER_STRUCTURE}}
```

## Key Commands

| Command | Description |
|---------|-------------|
{{COMMANDS_TABLE}}

## Documentation References

- [Architecture](docs/ARCHITECTURE.md)
- [API Specification](docs/API_SPEC.md)
- [Database Schema](docs/DATABASE_SCHEMA.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Design System](DESIGN_SYSTEM.md)
- [Agent Rules](AGENTS.md)

## Rules for AI Agents

1. Always read this file before starting any task.
2. Follow the coding conventions exactly — do not introduce new patterns.
3. Run `{{LINT_COMMAND}}` before considering any change complete.
4. Run `{{TEST_COMMAND}}` to verify changes don't break existing functionality.
5. Update relevant documentation when changing public APIs or schemas.
6. Never commit secrets, API keys, or credentials.
7. When uncertain about a design decision, reference docs/ARCHITECTURE.md.
```

---

## 2. AGENTS.md Template

```markdown
# Agent Behavior Rules — {{PROJECT_NAME}}

## Scope of Authority

### Files Agents CAN Modify
{{MODIFIABLE_FILES_LIST}}

### Files Agents MUST NOT Modify (Without Explicit Permission)
{{PROTECTED_FILES_LIST}}

### Files Agents Should NEVER Modify
- `.env` / `.env.local` (contains secrets)
- `{{LOCK_FILE}}` (auto-generated)
- `.git/` (version control internals)

## Commit & PR Standards

### Commit Message Format
```
{{COMMIT_FORMAT}}
```

**Types:** feat, fix, docs, style, refactor, test, chore, perf, ci, build
**Scope:** The module or component affected (e.g., auth, api, ui)

### PR Description Template
```
## What
Brief description of the change.

## Why
The motivation behind this change.

## How
Technical approach taken.

## Testing
How this was tested.

## Checklist
- [ ] Tests pass
- [ ] Linting passes
- [ ] Documentation updated
- [ ] No secrets committed
```

## Before Making Changes

1. **Read GEMINI.md** for project rules and conventions.
2. **Read the relevant skill** for the type of work being done.
3. **Check existing patterns** — look at similar files before creating new ones.
4. **Run the test suite** before and after changes.

## Quality Gates

Every change must pass these checks before being considered complete:

1. `{{LINT_COMMAND}}` — No linting errors
2. `{{TYPE_CHECK_COMMAND}}` — No type errors
3. `{{TEST_COMMAND}}` — All tests pass
4. `{{FORMAT_COMMAND}}` — Code is properly formatted

## Handling Ambiguity

When requirements are unclear:
1. Check existing patterns in the codebase first.
2. Reference docs/ARCHITECTURE.md for architectural decisions.
3. Make the simplest choice that doesn't close off future options.
4. Document the decision with a code comment explaining the rationale.
5. If the decision is significant, ask the user before proceeding.

## Error Handling

- Always handle errors explicitly — no silent catches.
- Use the project's established error handling pattern (see GEMINI.md).
- Log errors with sufficient context for debugging.
- Return user-friendly error messages to the frontend.

## Security Rules

- Never hardcode secrets, API keys, or credentials.
- Always validate and sanitize user input.
- Use parameterized queries — never construct SQL/NoSQL queries with string concatenation.
- Follow the principle of least privilege for all operations.
- Check for common vulnerabilities (XSS, CSRF, injection) in any user-facing code.
```

---

## 3. DESIGN_SYSTEM.md Template

```markdown
# Design System — {{PROJECT_NAME}}

## Color Palette

### Primary Colors
| Name | Hex | CSS Variable | Usage |
|------|-----|-------------|-------|
{{PRIMARY_COLORS_TABLE}}

### Neutral Colors
| Name | Hex | CSS Variable | Usage |
|------|-----|-------------|-------|
{{NEUTRAL_COLORS_TABLE}}

### Semantic Colors
| Name | Hex | CSS Variable | Usage |
|------|-----|-------------|-------|
| Success | {{SUCCESS_COLOR}} | `--color-success` | Confirmations, positive states |
| Warning | {{WARNING_COLOR}} | `--color-warning` | Caution states, pending actions |
| Error | {{ERROR_COLOR}} | `--color-error` | Errors, destructive actions |
| Info | {{INFO_COLOR}} | `--color-info` | Informational messages |

### Dark Mode
{{DARK_MODE_COLORS}}

## Typography

### Font Stack
- **Heading:** {{HEADING_FONT}}
- **Body:** {{BODY_FONT}}
- **Monospace:** {{MONO_FONT}}

### Type Scale
| Level | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| h1 | {{H1_SIZE}} | {{H1_WEIGHT}} | {{H1_LINE_HEIGHT}} | Page titles |
| h2 | {{H2_SIZE}} | {{H2_WEIGHT}} | {{H2_LINE_HEIGHT}} | Section titles |
| h3 | {{H3_SIZE}} | {{H3_WEIGHT}} | {{H3_LINE_HEIGHT}} | Subsections |
| h4 | {{H4_SIZE}} | {{H4_WEIGHT}} | {{H4_LINE_HEIGHT}} | Card titles |
| body-lg | {{BODY_LG_SIZE}} | {{BODY_LG_WEIGHT}} | {{BODY_LG_LINE_HEIGHT}} | Emphasized body |
| body | {{BODY_SIZE}} | {{BODY_WEIGHT}} | {{BODY_LINE_HEIGHT}} | Default text |
| body-sm | {{BODY_SM_SIZE}} | {{BODY_SM_WEIGHT}} | {{BODY_SM_LINE_HEIGHT}} | Secondary text |
| caption | {{CAPTION_SIZE}} | {{CAPTION_WEIGHT}} | {{CAPTION_LINE_HEIGHT}} | Labels, metadata |

## Spacing System

Use a {{SPACING_BASE}}px base unit. All spacing should be multiples of this base:

| Token | Value | Usage |
|-------|-------|-------|
| `--space-1` | {{SPACE_1}} | Tight spacing, icon gaps |
| `--space-2` | {{SPACE_2}} | Input padding, small gaps |
| `--space-3` | {{SPACE_3}} | Card padding, element gaps |
| `--space-4` | {{SPACE_4}} | Section padding |
| `--space-5` | {{SPACE_5}} | Large section gaps |
| `--space-6` | {{SPACE_6}} | Page-level spacing |

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | {{RADIUS_SM}} | Badges, tags |
| `--radius-md` | {{RADIUS_MD}} | Buttons, inputs |
| `--radius-lg` | {{RADIUS_LG}} | Cards, modals |
| `--radius-xl` | {{RADIUS_XL}} | Large cards, hero sections |
| `--radius-full` | 9999px | Avatars, pills |

## Shadows

| Token | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | {{SHADOW_SM}} | Subtle elevation |
| `--shadow-md` | {{SHADOW_MD}} | Cards, dropdowns |
| `--shadow-lg` | {{SHADOW_LG}} | Modals, popovers |
| `--shadow-xl` | {{SHADOW_XL}} | Floating elements |

## Component Patterns

### Buttons
{{BUTTON_PATTERNS}}

### Cards
{{CARD_PATTERNS}}

### Forms
{{FORM_PATTERNS}}

### Modals / Dialogs
{{MODAL_PATTERNS}}

### Navigation
{{NAV_PATTERNS}}

## Responsive Breakpoints

| Name | Min Width | Target |
|------|-----------|--------|
{{BREAKPOINTS_TABLE}}

## Animation & Transitions

- **Duration (fast):** {{DURATION_FAST}} — Hovers, toggles
- **Duration (normal):** {{DURATION_NORMAL}} — Modals, accordions
- **Duration (slow):** {{DURATION_SLOW}} — Page transitions
- **Easing:** {{EASING_FUNCTION}}
- **Reduced motion:** Always respect `prefers-reduced-motion: reduce`

## Accessibility

- **WCAG Level:** {{WCAG_LEVEL}}
- **Minimum contrast ratio:** {{CONTRAST_RATIO}}
- All interactive elements must be keyboard accessible.
- All images must have alt text.
- Forms must have visible labels (no placeholder-only labels).
- Focus indicators must be clearly visible.
- Color must not be the only way to convey information.

## Icons

- **Library:** {{ICON_LIBRARY}}
- **Default size:** {{ICON_DEFAULT_SIZE}}
- **Stroke width:** {{ICON_STROKE_WIDTH}}
```

---

## 4. README.md Template

````markdown
# {{PROJECT_NAME}}

{{PROJECT_TAGLINE}}

{{BADGES}}

## Overview

{{PROJECT_OVERVIEW}}

## Features

{{FEATURES_LIST}}

## Tech Stack

{{TECH_STACK_SUMMARY}}

## Quick Start

### Prerequisites

{{PREREQUISITES}}

### Installation

```bash
{{INSTALL_COMMANDS}}
```

### Environment Setup

```bash
cp .env.example .env
# Fill in the required environment variables
```

### Development

```bash
{{DEV_COMMAND}}
```

The app will be available at `{{DEV_URL}}`.

### Build

```bash
{{BUILD_COMMAND}}
```

### Test

```bash
{{TEST_COMMAND}}
```

## Project Structure

```
{{PROJECT_STRUCTURE}}
```

## Documentation

- [Architecture](docs/ARCHITECTURE.md) — System architecture and design decisions
- [API Specification](docs/API_SPEC.md) — API endpoints and schemas
- [Database Schema](docs/DATABASE_SCHEMA.md) — Data model documentation
- [Deployment Guide](docs/DEPLOYMENT.md) — Deployment instructions
- [Design System](DESIGN_SYSTEM.md) — UI/UX standards

## Contributing

1. Create a feature branch: `git checkout -b feat/your-feature`
2. Make your changes following the conventions in [GEMINI.md](GEMINI.md)
3. Run tests: `{{TEST_COMMAND}}`
4. Run linting: `{{LINT_COMMAND}}`
5. Commit using [conventional commits](https://www.conventionalcommits.org/): `git commit -m "feat(scope): description"`
6. Push and open a pull request

## License

{{LICENSE}}
````

---

## 5. SKILL.md Template (Generic / Reusable)

```markdown
---
name: {{SKILL_NAME}}
description: "{{SKILL_DESCRIPTION}}"
---

# {{SKILL_TITLE}}

{{SKILL_OVERVIEW}}

## When to Use This Skill

{{WHEN_TO_USE}}

## Prerequisites

{{PREREQUISITES}}

## Step-by-Step Process

### Step 1 — {{STEP_1_TITLE}}

{{STEP_1_INSTRUCTIONS}}

### Step 2 — {{STEP_2_TITLE}}

{{STEP_2_INSTRUCTIONS}}

### Step 3 — {{STEP_3_TITLE}}

{{STEP_3_INSTRUCTIONS}}

### Step 4 — {{STEP_4_TITLE}}

{{STEP_4_INSTRUCTIONS}}

### Step 5 — {{STEP_5_TITLE}}

{{STEP_5_INSTRUCTIONS}}

## Quality Checklist

Before considering this workflow complete, verify:

{{QUALITY_CHECKLIST}}

## Common Patterns

{{COMMON_PATTERNS}}

## Troubleshooting

{{TROUBLESHOOTING}}
```

---

## 6. hooks.json Template

```json
{
  "hooks": [
    {
      "event": "pre_commit",
      "description": "Run quality checks before every commit",
      "steps": [
        {
          "action": "run",
          "command": "{{LINT_COMMAND}}",
          "description": "Lint check"
        },
        {
          "action": "run",
          "command": "{{TYPE_CHECK_COMMAND}}",
          "description": "Type check"
        },
        {
          "action": "run",
          "command": "{{FORMAT_CHECK_COMMAND}}",
          "description": "Format check"
        }
      ]
    },
    {
      "event": "pre_push",
      "description": "Run tests before pushing",
      "steps": [
        {
          "action": "run",
          "command": "{{TEST_COMMAND}}",
          "description": "Run test suite"
        }
      ]
    },
    {
      "event": "post_checkout",
      "description": "Install dependencies after branch switch",
      "steps": [
        {
          "action": "run",
          "command": "{{INSTALL_COMMAND}}",
          "description": "Install dependencies"
        }
      ]
    },
    {
      "event": "post_file_create",
      "description": "Auto-actions when new files are created",
      "match": "{{SOURCE_PATTERN}}",
      "steps": [
        {
          "action": "run",
          "command": "{{FORMAT_COMMAND}} {{FILE}}",
          "description": "Format new file"
        }
      ]
    }
  ]
}
```

---

## 7. mcp_config.json Template

```json
{
  "mcpServers": {
    "{{MCP_SERVER_1_NAME}}": {
      "command": "{{MCP_SERVER_1_COMMAND}}",
      "args": {{MCP_SERVER_1_ARGS}},
      "env": {
        {{MCP_SERVER_1_ENV}}
      }
    },
    "{{MCP_SERVER_2_NAME}}": {
      "command": "{{MCP_SERVER_2_COMMAND}}",
      "args": {{MCP_SERVER_2_ARGS}},
      "env": {
        {{MCP_SERVER_2_ENV}}
      }
    }
  }
}
```

---

## 8. ARCHITECTURE.md Template

````markdown
# Architecture — {{PROJECT_NAME}}

## System Overview

{{ARCHITECTURE_OVERVIEW}}

```mermaid
{{SYSTEM_OVERVIEW_DIAGRAM}}
```

## Component Architecture

{{COMPONENT_ARCHITECTURE_DESCRIPTION}}

```mermaid
{{COMPONENT_DIAGRAM}}
```

## Data Flow

{{DATA_FLOW_DESCRIPTION}}

```mermaid
{{DATA_FLOW_DIAGRAM}}
```

## Infrastructure

{{INFRASTRUCTURE_DESCRIPTION}}

```mermaid
{{INFRASTRUCTURE_DIAGRAM}}
```

## Key Design Decisions

### {{DECISION_1_TITLE}}
- **Decision:** {{DECISION_1}}
- **Rationale:** {{DECISION_1_RATIONALE}}
- **Alternatives considered:** {{DECISION_1_ALTERNATIVES}}
- **Trade-offs:** {{DECISION_1_TRADEOFFS}}

### {{DECISION_2_TITLE}}
- **Decision:** {{DECISION_2}}
- **Rationale:** {{DECISION_2_RATIONALE}}
- **Alternatives considered:** {{DECISION_2_ALTERNATIVES}}
- **Trade-offs:** {{DECISION_2_TRADEOFFS}}

### {{DECISION_3_TITLE}}
- **Decision:** {{DECISION_3}}
- **Rationale:** {{DECISION_3_RATIONALE}}
- **Alternatives considered:** {{DECISION_3_ALTERNATIVES}}
- **Trade-offs:** {{DECISION_3_TRADEOFFS}}

## Module Breakdown

### {{MODULE_1_NAME}}
- **Purpose:** {{MODULE_1_PURPOSE}}
- **Key files:** {{MODULE_1_FILES}}
- **Dependencies:** {{MODULE_1_DEPS}}
- **Public API:** {{MODULE_1_API}}

### {{MODULE_2_NAME}}
- **Purpose:** {{MODULE_2_PURPOSE}}
- **Key files:** {{MODULE_2_FILES}}
- **Dependencies:** {{MODULE_2_DEPS}}
- **Public API:** {{MODULE_2_API}}

## Security Architecture

{{SECURITY_ARCHITECTURE}}

## Performance Considerations

{{PERFORMANCE_CONSIDERATIONS}}

## Scalability Plan

{{SCALABILITY_PLAN}}
````

---

## 9. API_SPEC.md Template

````markdown
# API Specification — {{PROJECT_NAME}}

## Base URL

- **Development:** `{{DEV_API_URL}}`
- **Staging:** `{{STAGING_API_URL}}`
- **Production:** `{{PROD_API_URL}}`

## Authentication

{{AUTH_DESCRIPTION}}

### Authentication Flow

```mermaid
{{AUTH_FLOW_DIAGRAM}}
```

### Headers
```
Authorization: Bearer <access_token>
Content-Type: application/json
```

## Error Response Format

All errors follow this structure:

```json
{
  "error": {
    "code": "{{ERROR_CODE_EXAMPLE}}",
    "message": "Human-readable error message",
    "details": {}
  }
}
```

### Standard Error Codes

| HTTP Status | Code | Description |
|-------------|------|-------------|
| 400 | `VALIDATION_ERROR` | Request body or params failed validation |
| 401 | `UNAUTHORIZED` | Missing or invalid authentication |
| 403 | `FORBIDDEN` | Authenticated but insufficient permissions |
| 404 | `NOT_FOUND` | Resource does not exist |
| 409 | `CONFLICT` | Resource already exists or state conflict |
| 422 | `UNPROCESSABLE` | Valid request but cannot be processed |
| 429 | `RATE_LIMITED` | Too many requests |
| 500 | `INTERNAL_ERROR` | Unexpected server error |

## Rate Limiting

- **Default limit:** {{RATE_LIMIT}} requests per {{RATE_LIMIT_WINDOW}}
- **Rate limit headers:**
  - `X-RateLimit-Limit` — Maximum requests per window
  - `X-RateLimit-Remaining` — Requests remaining
  - `X-RateLimit-Reset` — Unix timestamp when the window resets

## Versioning

{{VERSIONING_STRATEGY}}

## Endpoints

{{API_ENDPOINTS}}

### {{RESOURCE_1_NAME}}

#### List {{RESOURCE_1_PLURAL}}
```
GET /api/v1/{{RESOURCE_1_PATH}}
```

**Query Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
{{RESOURCE_1_LIST_PARAMS}}

**Response (200):**
```json
{{RESOURCE_1_LIST_RESPONSE}}
```

#### Get {{RESOURCE_1_SINGULAR}}
```
GET /api/v1/{{RESOURCE_1_PATH}}/:id
```

**Response (200):**
```json
{{RESOURCE_1_GET_RESPONSE}}
```

#### Create {{RESOURCE_1_SINGULAR}}
```
POST /api/v1/{{RESOURCE_1_PATH}}
```

**Request Body:**
```json
{{RESOURCE_1_CREATE_BODY}}
```

**Response (201):**
```json
{{RESOURCE_1_CREATE_RESPONSE}}
```

#### Update {{RESOURCE_1_SINGULAR}}
```
PATCH /api/v1/{{RESOURCE_1_PATH}}/:id
```

**Request Body:**
```json
{{RESOURCE_1_UPDATE_BODY}}
```

**Response (200):**
```json
{{RESOURCE_1_UPDATE_RESPONSE}}
```

#### Delete {{RESOURCE_1_SINGULAR}}
```
DELETE /api/v1/{{RESOURCE_1_PATH}}/:id
```

**Response (204):** No content
````

---

## 10. DATABASE_SCHEMA.md Template

````markdown
# Database Schema — {{PROJECT_NAME}}

## Overview

- **Database:** {{DATABASE_TYPE}} {{DATABASE_VERSION}}
- **ORM:** {{ORM_NAME}}
- **Migration tool:** {{MIGRATION_TOOL}}

## Entity-Relationship Diagram

```mermaid
{{ER_DIAGRAM}}
```

## Tables

### {{TABLE_1_NAME}}

{{TABLE_1_DESCRIPTION}}

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
{{TABLE_1_COLUMNS}}

**Indexes:**
{{TABLE_1_INDEXES}}

**Relations:**
{{TABLE_1_RELATIONS}}

### {{TABLE_2_NAME}}

{{TABLE_2_DESCRIPTION}}

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
{{TABLE_2_COLUMNS}}

**Indexes:**
{{TABLE_2_INDEXES}}

**Relations:**
{{TABLE_2_RELATIONS}}

## Migration Strategy

{{MIGRATION_STRATEGY}}

### Creating a New Migration
```bash
{{CREATE_MIGRATION_COMMAND}}
```

### Running Migrations
```bash
{{RUN_MIGRATION_COMMAND}}
```

### Rolling Back
```bash
{{ROLLBACK_MIGRATION_COMMAND}}
```

## Seed Data

{{SEED_DATA_DESCRIPTION}}

```bash
{{SEED_COMMAND}}
```

## Data Lifecycle

{{DATA_LIFECYCLE_DESCRIPTION}}

## Backup Strategy

{{BACKUP_STRATEGY}}
````

---

## 11. DEPLOYMENT.md Template

````markdown
# Deployment Guide — {{PROJECT_NAME}}

## Environments

| Environment | URL | Branch | Auto-deploy |
|-------------|-----|--------|------------|
{{ENVIRONMENTS_TABLE}}

## Prerequisites

{{DEPLOYMENT_PREREQUISITES}}

## Environment Variables

These must be set in every deployment environment:

| Variable | Description | Required | Secret |
|----------|------------|----------|--------|
{{DEPLOYMENT_ENV_VARS}}

## Build Process

### Development Build
```bash
{{DEV_BUILD_COMMAND}}
```

### Production Build
```bash
{{PROD_BUILD_COMMAND}}
```

### Build Verification
```bash
{{BUILD_VERIFY_COMMAND}}
```

## Deployment Steps

### {{DEPLOY_PLATFORM}} Deployment

{{DEPLOYMENT_STEPS}}

### Manual Deployment
```bash
{{MANUAL_DEPLOY_COMMANDS}}
```

## CI/CD Pipeline

{{CICD_DESCRIPTION}}

```mermaid
{{CICD_DIAGRAM}}
```

### Pipeline Configuration
```yaml
{{CICD_CONFIG}}
```

## Monitoring

### Health Checks
- **Endpoint:** `{{HEALTH_CHECK_URL}}`
- **Expected response:** `200 OK`
- **Check interval:** {{HEALTH_CHECK_INTERVAL}}

### Logging
{{LOGGING_CONFIGURATION}}

### Error Tracking
{{ERROR_TRACKING_SETUP}}

### Performance Monitoring
{{PERFORMANCE_MONITORING_SETUP}}

## Rollback Procedures

### Automatic Rollback
{{AUTO_ROLLBACK_DESCRIPTION}}

### Manual Rollback
```bash
{{MANUAL_ROLLBACK_COMMANDS}}
```

## Troubleshooting

### Common Issues

#### {{ISSUE_1_TITLE}}
- **Symptom:** {{ISSUE_1_SYMPTOM}}
- **Cause:** {{ISSUE_1_CAUSE}}
- **Fix:** {{ISSUE_1_FIX}}

#### {{ISSUE_2_TITLE}}
- **Symptom:** {{ISSUE_2_SYMPTOM}}
- **Cause:** {{ISSUE_2_CAUSE}}
- **Fix:** {{ISSUE_2_FIX}}

## Disaster Recovery

{{DISASTER_RECOVERY_PLAN}}
````
