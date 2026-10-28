---
name: skill-crafter
description: "Creates custom Antigravity skills (SKILL.md files) for a project based on its tech stack and workflow requirements. Use this skill when the agent needs to generate project-specific skills like 'feature-development', 'testing-strategy', 'deployment', 'database-management', or 'api-development' tailored to the project's technology choices."
---

# Skill Crafter Skill

Generate project-specific Antigravity skills tailored to a project's technology stack and workflow requirements. Each generated skill becomes a reusable instruction set that guides the agent through common development tasks for that particular project.

## Determining What Skills a Project Needs

Analyze the project specification to identify required skills. Every project gets the **minimum skill set**, and additional skills are added based on project type and technology choices.

### Decision Process

1. Read the project's tech stack (language, framework, database, deployment target).
2. Identify the project type (web app, API, mobile app, CLI tool, AI/ML, game).
3. **Check the Local Skills Library (`C:\Users\Vinod krishna\antigravity_skills`)**:
   - Search for pre-existing specialized skills that match the tech stack (e.g. `zod-validation-expert`, `docker-compose`, `playwright-e2e`, `prisma-schema`).
   - If a matching skill already exists, adapt or copy it rather than generating from scratch.
4. Apply the minimum skill set.
5. Add type-specific skills.
6. Add technology-specific skills where a tool has complex workflows (e.g., Prisma migrations, Docker Compose).

## Minimum Skills (Every Project)

Every bootstrapped project must have these four skills:

### 1. project-setup

**Purpose:** Guide the agent through initial repository setup, dependency installation, and environment configuration.

**Must include:**
- Exact commands to initialize the project (`npm init`, `python -m venv`, etc.)
- Dependency installation commands with the project's package manager
- Environment variable setup (`.env` file creation with required variables)
- Database setup if applicable (create database, run initial migrations)
- Verification steps to confirm setup is complete (run a health check, start the dev server)

**Example frontmatter:**
```yaml
---
name: project-setup
description: "Initialize the project repository, install all dependencies, configure environment variables, and verify the development environment is ready. Use this skill when setting up the project for the first time or onboarding to a new machine."
---
```

### 2. feature-development

**Purpose:** Define the step-by-step workflow for implementing a new feature in this specific project.

**Must include:**
- Branch naming convention (e.g., `feature/`, `feat/`)
- File creation patterns (where to put new files based on the project's architecture)
- Code patterns specific to the framework (e.g., Express route → controller → service → repository)
- How to write and run tests for the new feature
- How to update documentation when adding features
- Pre-commit checklist (lint, test, type-check)

**Example frontmatter:**
```yaml
---
name: feature-development
description: "Step-by-step workflow for implementing new features in this project. Covers branch creation, code architecture patterns, testing requirements, and pre-commit checks. Use this skill when building any new feature or functionality."
---
```

### 3. testing-strategy

**Purpose:** Define the testing approach, frameworks, patterns, and coverage requirements.

**Must include:**
- Test framework and runner (e.g., Vitest, pytest, Jest)
- Test file naming and location conventions
- Unit test patterns with examples specific to the project's architecture
- Integration test patterns (API endpoint testing, database testing)
- How to run tests (single file, full suite, watch mode, coverage)
- Minimum coverage thresholds
- Mocking patterns for the project's dependencies

**Example frontmatter:**
```yaml
---
name: testing-strategy
description: "Testing framework configuration, test patterns, and coverage requirements for this project. Covers unit tests, integration tests, and end-to-end tests with framework-specific examples. Use this skill when writing tests or setting up test infrastructure."
---
```

### 4. deployment

**Purpose:** Document the build, deploy, and rollback procedures.

**Must include:**
- Build command and output location
- Environment-specific configurations (dev, staging, production)
- Deployment commands or CI/CD pipeline description
- Health check verification after deployment
- Rollback procedure
- Environment variable management for production

**Example frontmatter:**
```yaml
---
name: deployment
description: "Build, deploy, and rollback procedures for all environments. Covers CI/CD pipeline configuration, environment management, health checks, and emergency rollback. Use this skill when deploying the application or setting up deployment infrastructure."
---
```

## Additional Skills by Project Type

### Web Applications (Frontend + Backend)

| Skill | When to Include | Key Content |
|---|---|---|
| `api-development` | Always for full-stack | Route definition, request validation, response formatting, error handling, versioning |
| `database-management` | When using any database | Schema design, migrations, seeding, backup/restore, query optimization |
| `frontend-development` | When project has UI | Component architecture, state management patterns, styling approach, accessibility |
| `authentication` | When auth is required | Auth flow implementation, session/token management, role-based access, security best practices |

### Mobile Applications

| Skill | When to Include | Key Content |
|---|---|---|
| `device-testing` | Always for mobile | Emulator setup, physical device debugging, platform-specific testing, responsive testing |
| `app-store-deployment` | When targeting app stores | Build signing, store listing preparation, review guidelines, update procedures |
| `offline-support` | When offline capability needed | Local storage strategy, sync mechanisms, conflict resolution, cache invalidation |
| `push-notifications` | When notifications needed | Provider setup (FCM/APNs), notification handling, deep linking, permission management |

### CLI Tools

| Skill | When to Include | Key Content |
|---|---|---|
| `command-structure` | Always for CLIs | Command hierarchy, subcommand patterns, help text conventions, output formatting |
| `argument-parsing` | Always for CLIs | Argument types, validation, default values, environment variable fallbacks |
| `distribution` | When publishing the CLI | Package publishing (npm/pip/brew), binary compilation, version management, installation instructions |

### AI/ML Projects

| Skill | When to Include | Key Content |
|---|---|---|
| `model-training` | When training models | Training loop patterns, hyperparameter management, checkpoint saving, GPU utilization |
| `data-pipeline` | When processing data | Data ingestion, transformation, validation, storage, versioning |
| `experiment-tracking` | When running experiments | Metrics logging, experiment comparison, reproducibility, artifact management |
| `model-serving` | When deploying models | API wrapping, batch inference, model versioning, A/B testing |

### Game Development

| Skill | When to Include | Key Content |
|---|---|---|
| `game-loop` | Always for games | Frame management, input handling, state updates, rendering pipeline |
| `asset-management` | When using game assets | Asset pipeline, format conventions, loading strategies, optimization |
| `level-design` | When game has levels | Level data format, editor workflow, testing levels, procedural generation |
| `multiplayer` | When multiplayer is needed | Network architecture, state sync, latency handling, matchmaking |

## Skill Writing Best Practices

### Structure

Every generated `SKILL.md` should follow this structure:

```markdown
---
name: skill-name
description: "Clear description of when and why to use this skill."
---

# Skill Title

One-paragraph overview of what this skill covers.

## Prerequisites

What must be set up before using this skill.

## Workflow

Step-by-step procedure with numbered steps.

### Step 1: [Action]

Detailed instructions with code examples.

### Step 2: [Action]

...

## Validation

How to verify the procedure was completed correctly.

## Troubleshooting

Common issues and their solutions.

## Reference

Links to related skills, documentation, or external resources.
```

### Keep SKILL.md Concise

- The main `SKILL.md` should be scannable — ideally under 200 lines.
- Move lengthy reference material to a `references/` subdirectory.
- Move complex multi-step scripts to a `scripts/` subdirectory.
- Use tables for mapping data (tech → config) instead of long prose.

### Include Validation Steps for Every Procedure

Every procedure in a skill must end with a verification step. The agent should never assume success.

```markdown
### Validation

Run the following to confirm the migration was applied:

```bash
npx prisma migrate status
```

Expected output should show no pending migrations.
```

### Use Executable Scripts for Complex Commands

If a procedure involves more than 3 commands in sequence, create a script:

```
.agents/skills/database-management/scripts/reset-db.sh
```

```bash
#!/bin/bash
# Reset the development database to a clean state
set -e

echo "Dropping database..."
npx prisma migrate reset --force

echo "Running seeds..."
npx prisma db seed

echo "Database reset complete."
```

Reference the script from `SKILL.md`:

```markdown
To reset the database, run the reset script:

```bash
bash .agents/skills/database-management/scripts/reset-db.sh
```
```

### Write Descriptions That Trigger on the Right Prompts

The `description` field in frontmatter determines when the skill is activated. Write it to match natural developer language.

**Weak description:**
```yaml
description: "Database skill"
```

**Strong description:**
```yaml
description: "Manage database schema changes, run migrations, seed data, and perform backup/restore operations. Use this skill when creating tables, modifying columns, writing migration files, seeding test data, or troubleshooting database issues."
```

**Rules for good descriptions:**
1. Start with action verbs describing what the skill does.
2. Include the specific nouns a developer would use ("migrations", "seed data", "schema").
3. End with "Use this skill when..." followed by concrete trigger scenarios.
4. Include synonyms for common terms ("deploy" / "release" / "ship" / "push to production").

### Technology-Specific Content

Every skill must be tailored to the project's actual technology choices. Never write generic instructions.

**Generic (bad):**
```markdown
## Running Tests

Run your project's test suite using the appropriate command.
```

**Specific (good):**
```markdown
## Running Tests

Run the full test suite with coverage:

```bash
npx vitest run --coverage
```

Run a single test file:

```bash
npx vitest run src/services/user.service.test.ts
```

Run tests in watch mode during development:

```bash
npx vitest
```
```

## Generating a Skill

When creating a new skill:

1. **Create the directory:** `.agents/skills/{skill-name}/`
2. **Write SKILL.md** with proper frontmatter, following the structure template above.
3. **Create `references/`** if the skill needs reference documentation (schema examples, API docs, configuration templates).
4. **Create `scripts/`** if the skill involves multi-step automated procedures.
5. **Validate** the skill using the project-validator skill (Check 3: frontmatter validation).

### Directory Layout

```
.agents/skills/{skill-name}/
├── SKILL.md              # Main instructions (required)
├── references/            # Reference docs (optional)
│   ├── schema-examples.md
│   └── config-templates.md
└── scripts/               # Automation scripts (optional)
    ├── setup.sh
    └── validate.sh
```

## Skill Naming Conventions

- Use lowercase with hyphens: `feature-development`, not `FeatureDevelopment` or `feature_development`.
- Use descriptive compound names: `database-management`, not just `database`.
- Match the directory name to the frontmatter `name` field exactly.
- Keep names under 30 characters.
