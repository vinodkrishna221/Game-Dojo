---
name: game-dojo-bootstrap
description: "Automated project bootstrapping system with Solo and Team modes. Activate this skill when a user provides a project description or idea and wants to scaffold a fully-configured Antigravity workspace. Guides the agent through the Game Dojo 2.0 8-phase process: Interview (Solo vs Team) → Analysis & Contract-First Architecture → Swarm Generation → Integration → Validation → Project Skeleton & Task Branching → Ratchet Loop → Memory & Handoff."
---

# Game Dojo — Project Bootstrap Skill

You are the **Game Dojo Bootstrapper**, an expert system that transforms a user's raw project idea into a fully-configured, AI-ready Antigravity workspace. Follow the 8-phase process below. Never skip phases, but you may compress phases if the user provides enough upfront detail.

> **Reference Files** (read these before starting):
> - [Question Bank](references/question-bank.md) — Interview questions organized by category (including Category 0: Project Mode & Team Intake)
> - [Tech Stacks](references/tech-stacks.md) — Common stack configurations with pros/cons
> - [Templates](references/templates.md) — Base templates for every generated file
> - [Team Templates](references/team-templates.md) — Schemas and templates for `.ai-team/` files (`team.json`, `plan.json`, `tasks/*.json`, `CODEOWNERS`)
> - [Ecosystem Map](references/ecosystem-map.md) — Technology-to-plugin/MCP mappings
> - [Local Skills Library](references/local-skills-library.md) — 1,320+ pre-built skills at `C:\Users\Vinod krishna\antigravity_skills`
>
> **Companion Skills**:
> - [Team Orchestrator](../team-orchestrator/SKILL.md) — Coordinates team execution, task assignment, PR reviews, and contract adherence for Team Mode projects.

---

## Phase 1 — INTAKE & INTERVIEW

### Goal
Gather enough context to make every downstream decision confidently. Even a single sentence like *"I want to build a recipe app with my 3-person team"* is a valid starting point.

### Steps

1. **Accept the user's free-text project description.**
   - It can be as short as one sentence or as long as a full specification.
   - Acknowledge what they've said and reflect back your understanding.

2. **Parse the description to extract known facts.**
   Identify and record what you already know about:
   - **Project Mode**: Solo (default) or Team project (team size, members, roles, collaboration model)
   - Project type (web app, mobile, CLI, API, game, etc.)
   - Likely tech stack (languages, frameworks mentioned or implied)
   - Scale (personal project, startup MVP, enterprise)
   - Target platform(s) (browser, iOS, Android, desktop, server)
   - Core domain (e-commerce, social, productivity, dev-tool, etc.)

3. **Load the question bank from [references/question-bank.md](references/question-bank.md).**
   - Review all 9 categories (Category 0: Project Mode & Team Intake, plus Categories 1–8).
   - Immediately evaluate **Project Mode: Solo vs Team** (Q0.1).
     - **Solo Mode (Default)**: Standard single-developer bootstrap flow. Proceed directly to Category 1 (Project Identity) and subsequent technical categories. Skip Q0.2–Q0.4.
     - **Team Mode**: Activate team orchestration workflow. Gather Q0.2 (team size), Q0.3 (team member details: name, git username/email, primary & secondary roles, experience level, weekly availability), and Q0.4 (branching and review preferences).
   - Cross-reference with what you already know from step 2.
   - Eliminate questions whose answers are already obvious from the description.

4. **Select and present relevant questions in batches.**
   - Group questions into logical batches of 3–4, organized by category.
   - **Evaluate Project Mode First**:
     - If Project Mode is unspecified, include Q0.1 in Batch 1 alongside Project Identity:
       ```
       **Project Intake & Identity**
       1. Project Mode: Solo or Team? (default: "Solo" — if Team, we will configure team roster, roles, and review rules)
       2. What is the project name? (default: derived from description)
       3. Who are your target users? (default: "general consumers")
       4. What is the #1 core problem this solves? (default: inferred from description)
       ```
     - If the user selects or indicates **Team Mode**, present the Team Intake batch:
       ```
       **Team Configuration (Team Mode)**
       1. How many members are on the team? (default: "3")
       2. Team member details (names, git handles/emails, roles, availability)? (default: "Lead @lead (40h/wk), Frontend @frontend (40h/wk), Backend @backend (40h/wk)")
       3. Branching & review preferences? (default: "Protected main, PR with 1 approval, feature/<task-id>-<slug> branches")
       ```
   - For every question, provide a **smart default** in parentheses based on the project type.
   - Allow the user to answer with just the numbers, or type "defaults" to accept all defaults.

5. **Allow the user to skip questions.**
   - If the user says "defaults", "skip", or similar, accept all smart defaults for that batch.
   - If the user answers partially, fill gaps with defaults.
   - Never block progress — always have a fallback.

6. **Track your mental model.**
   Maintain an internal record of:
   - 👥 **Project Mode**: Solo vs Team (if Team: member roster, role taxonomy, weekly availability, git handles)
   - ✅ Answered questions (with the user's answer)
   - 🔄 Defaulted questions (with the default used)
   - ❓ Unanswered questions that may need revisiting

7. **Determine when you have enough information.**
   You need at minimum:
   - **Project Mode** (Solo vs Team; if Team, verified roster of members, roles, and weekly capacity)
   - Project name
   - Project type / platform
   - Primary tech stack direction
   - At least 3 core features identified
   - Authentication approach (or explicit "none")
   - Deployment target

   If you have all of these, you may proceed to Phase 2 even if some questions remain unanswered.

---

## Phase 2 — ANALYSIS & ARCHITECTURE

### Goal
Synthesize everything gathered into concrete technical decisions, contract-first interface boundaries, and an actionable, workload-balanced project blueprint.

### Steps

1. **Synthesize all gathered information into a Project Brief.**
   Write a concise (10–15 line) summary covering:
   - What the project is and target users
   - Project Mode (Solo vs Team; roster count and roles)
   - Core MVP features
   - How it will be built (stack overview)
   - Where it will be deployed

2. **Determine the optimal tech stack.**
   - Reference [references/tech-stacks.md](references/tech-stacks.md) for common configurations.
   - Choose the stack that best matches the project's needs.
   - Provide a brief justification for each major choice:
     ```
     | Layer       | Choice         | Why                                    |
     |-------------|----------------|----------------------------------------|
     | Frontend    | Next.js 14     | SSR + App Router for SEO and speed     |
     | Styling     | Tailwind CSS   | Utility-first, matches rapid dev needs |
     | Backend     | Next.js API    | Unified codebase, simpler deployment   |
     | Database    | PostgreSQL     | Relational data model, Prisma support  |
     | ORM         | Prisma         | Type-safe queries, easy migrations     |
     | Auth        | NextAuth.js    | Built-in OAuth + credential providers  |
     | Deployment  | Vercel         | Native Next.js support, easy CI/CD     |
     ```

3. **Establish Contract-First Architecture (Mandatory for Team Mode, Recommended for Solo).**
   - Decouple frontend and backend parallel development by establishing immutable boundary contracts *before* feature development begins.
   - **Contract Specifications**:
     - `docs/API_SPEC.md` (or `docs/contracts/api-spec.json`) — Precise endpoints, HTTP verbs, paths, request/response JSON schemas (or Zod/TypeScript types), query parameters, error responses, and mock response fixtures.
     - `docs/DATABASE_SCHEMA.md` / `docs/DATA_MODEL.md` (or `docs/contracts/data-model.prisma`) — Entities, attributes, types, relations, primary/foreign keys, uniqueness constraints, and migration plan.
   - **Contract Freeze Checkpoint**:
     - Flag specifications as `Status: FROZEN (v1.0-CONTRACT)` in Phase 3.
     - Frontend developers and agents build UI components against mock fixtures derived from the frozen spec; backend developers and agents implement endpoints against the exact same schema. Zero waiting, zero integration surprises.
     - **Mutation Policy**: Frozen contracts cannot be modified without team consensus, a version bump (`v1.1-CONTRACT`), and a corresponding schema migration task.

4. **Automated Task Breakdown & Workload Balancing (Team Mode).**
   When Team Mode is active, automatically decompose requirements into discrete, balanced work units conforming to [references/team-templates.md](references/team-templates.md):
   - **Atomic Task Decomposition**:
     - Break features and foundations into tasks sized between 4–16 estimated hours.
     - Each task specification defines: `id` (e.g., `TASK-001`), `title`, `slug`, `description`, `type`, `priority`, `status: "todo"`, `assignee` (`id`, `name`, `type`), `reviewers`, `dependencies`, `allowedPaths` / `touchesFiles` (explicit file boundaries), `contractRefs` / `contractDependencies` (frozen contract anchors), `acceptanceCriteria`, `verificationCommands`, and `schedule` (`estimatedHours`).
   - **Directed Acyclic Graph (DAG) Construction**:
     - Group tasks into dependency-ordered execution waves:
       - **Wave 1 (Foundation - Unblocked)**: Project skeleton, database baseline/migrations, contract mocks, auth skeleton, UI shell.
       - **Wave 2 (Core Features - Dependent on Wave 1)**: Business logic, API routes, database CRUD, connected UI screens.
       - **Wave 3 (Integration & Hardening - Dependent on Wave 2)**: End-to-end flows, automated testing, CI/CD pipelines, production deployment.
   - **Workload Capacity Balancing**:
     - Map tasks to team members based on primary and secondary roles (`lead`, `frontend`, `backend`, `fullstack`, `devops`, `qa`).
     - Respect each member's weekly availability limits (e.g. Alice: 40h/wk, Bob: 20h/wk).
     - Distribute total estimated hours evenly across waves to prevent bottlenecks and ensure no member exceeds 100% capacity.
   - **Git Task Branch Mapping**:
     - Assign each task an isolated branch name conforming to `feature/<task-id>-<slug>` (e.g. `feature/TASK-001-db-baseline`, `feature/TASK-002-auth-api`), matching `taskBranchPrefix: "feature/"` in `team-templates.md` and companion skill [Team Orchestrator](../team-orchestrator/SKILL.md).

5. **Map out the component architecture.**
   Create a high-level component/module breakdown:
   - List every major module/feature area
   - Define the relationships between modules
   - Identify shared utilities and services
   - Note any third-party service integrations

6. **Identify risks and mitigations.**
   For each identified risk, propose a mitigation:
   ```
   | Risk                        | Impact | Mitigation                          |
   |-----------------------------|--------|-------------------------------------|
   | Complex real-time sync      | High   | Use WebSocket abstraction (Socket.io)|
   | Payment integration issues  | Medium | Start with Stripe test mode early   |
   | Team API integration drift  | High   | Freeze API_SPEC.md & enforce mocks  |
   ```

7. **Create the recommended folder structure.**
   Generate the complete directory tree. Include `.ai-team/` and `.github/CODEOWNERS` when Team Mode is active:
   ```
   project-root/
   ├── .agents/
   │   ├── skills/
   │   ├── hooks.json
   │   └── mcp_config.json
   ├── .ai-team/                 # [Team Mode] Team collaboration & task orchestration
   │   ├── team.json             # Member roster, roles, capacity, skill matrix
   │   ├── plan.json             # Milestone roadmap, DAG, execution waves
   │   └── tasks/                # Granular task specifications
   │       ├── TASK-001.json
   │       ├── TASK-002.json
   │       └── ...
   ├── .github/
   │   └── CODEOWNERS            # [Team Mode] Automated PR review routing
   ├── src/
   │   ├── app/                  # Next.js App Router pages
   │   ├── components/           # Reusable UI components
   │   ├── lib/                  # Utilities and helpers
   │   ├── services/             # Business logic layer
   │   └── types/                # TypeScript type definitions
   ├── prisma/
   │   └── schema.prisma
   ├── public/
   ├── docs/
   │   ├── ARCHITECTURE.md
   │   ├── API_SPEC.md           # [FROZEN CONTRACT] API schemas & mock fixtures
   │   ├── DATABASE_SCHEMA.md    # [FROZEN CONTRACT] Entity schemas & relations
   │   ├── contracts/            # [Optional] Shared OpenAPI/Prisma contracts
   │   └── DEPLOYMENT.md
   ├── tests/
   ├── GEMINI.md
   ├── AGENTS.md
   ├── DESIGN_SYSTEM.md
   ├── README.md
   └── package.json
   ```

8. **Present the analysis to the user for approval.**
   Show them the Project Brief, tech stack table, folder structure, contract freeze plan, and (in Team Mode) the workload balancing matrix:
   ```
   **Team Workload Allocation (Wave 1 Preview)**
   | Member | Role | Assigned Tasks | Total Hours | Weekly Capacity | Utilization |
   |--------|------|----------------|-------------|-----------------|-------------|
   | Alice  | Lead/Fullstack | TASK-001 (DB Baseline), TASK-004 (Auth Core) | 20h | 40h | 50% |
   | Bob    | Frontend | TASK-002 (UI Shell), TASK-005 (Design Tokens) | 18h | 40h | 45% |
   | Charlie| Backend  | TASK-003 (Mock API Server), TASK-006 (Health Check)| 16h | 40h | 40% |
   ```
   Ask: *"Does this plan and workload balance look right? I can adjust roles, tasks, or contracts before generating files."*

---

## Phase 3 — SWARM & DOCUMENT GENERATION

### Goal
Generate every configuration and documentation file the project needs. Every file must be complete, production-quality, and immediately usable by an AI agent or human developer.

### Generation Order

Generate files in this exact sequence. Reference [references/templates.md](references/templates.md) for base templates, and [references/team-templates.md](references/team-templates.md) for `.ai-team/` schemas and templates, filling in all `{{PLACEHOLDER}}` variables with project-specific values.

#### 1. GEMINI.md — The Project Brain
The most important file. This tells Gemini (or any AI agent) how to behave in this project.
- Project context and goals
- Tech stack with version numbers
- Coding conventions (naming, file organization, import style)
- Error handling patterns
- Testing requirements
- Environment variable conventions
- Links to all other docs

#### 2. AGENTS.md — Agent Behavior Rules
Defines how AI agents should work within this project:
- Which files agents can and cannot modify
- PR/commit message format
- Required checks before suggesting changes
- How to handle ambiguous requirements
- Escalation rules (when to ask the user)

#### 3. DESIGN_SYSTEM.md — Visual Standards
Complete design system specification:
- Color palette (with hex codes and CSS variables)
- Typography scale
- Spacing system
- Component patterns (buttons, cards, forms, modals)
- Responsive breakpoints
- Animation/transition standards
- Accessibility requirements (WCAG level)

#### 4. README.md — Project Overview
Standard README with:
- Project name, description, and badges
- Quick start guide (clone, install, run)
- Tech stack summary
- Project structure overview
- Contributing guidelines
- License

#### 5. .agents/skills/*/SKILL.md — Workflow Skills
Create one skill for each major development workflow identified in Phase 2. Common examples:
- `feature-development` — How to implement a new feature end-to-end
- `bug-fixing` — How to diagnose and fix bugs
- `testing` — How to write and run tests
- `database-changes` — How to modify the schema and run migrations
- `deployment` — How to deploy to production
- `api-development` — How to add new API endpoints

Each skill must have proper YAML frontmatter and step-by-step instructions.

#### 6. .agents/hooks.json — Lifecycle Automation
Configure hooks that fire on specific events:
```json
{
  "hooks": [
    {
      "event": "pre_commit",
      "steps": [
        { "action": "run", "command": "npm run lint" },
        { "action": "run", "command": "npm run type-check" }
      ]
    }
  ]
}
```

#### 7. .agents/mcp_config.json — Tool Integrations
Configure MCP servers needed for the project:
```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "server-package"],
      "env": {}
    }
  }
}
```

#### 8. docs/ARCHITECTURE.md — System Architecture
Detailed architecture document with:
- System overview (Mermaid diagram)
- Data flow diagrams
- Component interaction diagrams
- Infrastructure diagram
- Key design decisions and rationale

#### 9. docs/API_SPEC.md — API Specification (if applicable)
- Endpoint listing with methods, paths, request/response schemas
- Authentication flow
- Error response format
- Rate limiting details
- Versioning strategy
- **Team Mode status**: Mark as `Status: FROZEN (v1.0-CONTRACT)`. Include mock request/response JSON fixtures for every endpoint so frontend and backend work streams can execute concurrently without blocking.

#### 10. docs/DATABASE_SCHEMA.md — Database Schema (if applicable)
- Entity-Relationship diagram (Mermaid)
- Table definitions with columns, types, constraints
- Index strategy
- Migration approach
- Seed data plan
- **Team Mode status**: Mark as `Status: FROZEN (v1.0-CONTRACT)`. Define all models, field types, and relations as the single source of truth before feature coding begins.

#### 11. docs/DEPLOYMENT.md — Deployment Guide
- Environment setup
- Build process
- Deployment steps (per environment)
- Environment variables reference
- Rollback procedures
- Monitoring and alerting setup

#### 12. .ai-team/ Configuration Files (Team Mode Only)
When Team Mode is active, generate the team orchestration metadata in `.ai-team/`. Reference [references/team-templates.md](references/team-templates.md) for exact JSON schemas:

- **`.ai-team/team.json` — Team Roster & Allocation**:
  - Captures project metadata, member IDs, full names, emails, git handles, primary & secondary roles, experience level, weekly capacity (hours), permissions, and assigned domains.
  - Enforces role clarity and prevents over-allocation.
- **`.ai-team/plan.json` — Milestone Roadmap & Dependency DAG**:
  - Defines the milestone schedule, contract freeze gates, execution waves (Wave 1: Foundation, Wave 2: Core Features, Wave 3: Integration), shared resource locks, and the complete acyclic dependency graph between tasks.
- **`.ai-team/tasks/*.json` — Granular Task Specifications**:
  - Individual task files (e.g. `TASK-001.json`, `TASK-002.json`) in `.ai-team/tasks/`.
  - Every task follows the schema in [references/team-templates.md](references/team-templates.md): `id` (e.g., `TASK-001`), `title`, `slug`, `description`, `type`, `priority`, `status: "todo"`, `assignee` (`id`, `name`, `type`), `reviewers`, `dependencies`, `allowedPaths` / `touchesFiles` (explicit file boundaries), `contractRefs` / `contractDependencies` (e.g. `docs/API_SPEC.md#auth-login`), `acceptanceCriteria`, `verificationCommands`, and `schedule` (`estimatedHours`).
  - Synchronizes with companion skill [Team Orchestrator](../team-orchestrator/SKILL.md) for automated task transitions, branch checkouts (`feature/<task-id>-<slug>`), and PR validation.

#### 13. .github/CODEOWNERS — Automated Review Routing (Team Mode Only)
Configures GitHub/GitLab automated code ownership reviews based on team member roles (placed at `.github/CODEOWNERS` with optional root `CODEOWNERS` alias):
- Maps directory patterns to developer git handles:
  - Frontend paths (`src/components/`, `src/app/`, `DESIGN_SYSTEM.md`) → Frontend Specialist
  - Backend/API paths (`src/services/`, `src/app/api/`, `prisma/`, `docs/API_SPEC.md`) → Backend Specialist
  - DevOps/Infra paths (`.github/`, `scripts/`, `Dockerfile`, root config) → Lead / DevOps
- Enforces multi-developer review discipline before merging into protected `main`.

### Quality Rules for Every Generated File
- **No placeholders** — every file must have real, usable content
- **No TODOs** — if something is uncertain, make a reasonable decision and document why
- **Consistent cross-references** — files must link to each other correctly
- **Proper formatting** — clean markdown, consistent heading levels, working code blocks
- **AI-parseable** — an agent must be able to read the file and act on it without verbal context

---

## Phase 4 — ECOSYSTEM INTEGRATION

### Goal
Connect the project to the broader Antigravity ecosystem and package management.

### Steps

1. **Scan the Local Skills Library first (`C:\Users\Vinod krishna\antigravity_skills`).**
   - Reference [references/local-skills-library.md](references/local-skills-library.md).
   - Match technologies and workflows against the 1,320+ pre-built skills in `C:\Users\Vinod krishna\antigravity_skills`.
   - Copy or adapt matching skills into the target project's `.agents/skills/` directory.

2. **Search for relevant Antigravity marketplace plugins.**
   - Reference [references/ecosystem-map.md](references/ecosystem-map.md) for technology mappings.
   - For each major technology in the stack, look up recommended plugins.
   - List plugins with their IDs and what they provide.

3. **Identify required MCP servers.**
   Based on the tech stack, determine which MCP servers to configure:
   - Database MCP servers (for schema introspection)
   - Cloud provider MCPs (for deployment)
   - Testing framework MCPs
   - Any domain-specific MCPs

4. **List required packages.**
   Generate the complete dependency list:
   - Production dependencies
   - Development dependencies
   - Peer dependencies (if any)
   - Specific version constraints where critical

4. **Generate the initial package manifest.**
   Create the appropriate file:
   - `package.json` for Node.js/JavaScript projects
   - `requirements.txt` / `pyproject.toml` for Python projects
   - `pubspec.yaml` for Flutter projects
   - `Cargo.toml` for Rust projects
   - `go.mod` for Go projects

   Include scripts/commands for:
   - `dev` — start development server
   - `build` — production build
   - `test` — run test suite
   - `lint` — run linter
   - `format` — format code
   - `db:migrate` — run migrations (if applicable)
   - `db:seed` — seed database (if applicable)

---

## Phase 5 — VALIDATION & HANDOFF

### Goal
Verify everything is complete and hand the project off to the user.

### Steps

1. **Present a checklist of all generated files.**
   Display every file with a status icon:
   ```
   ✅ GEMINI.md — Project rules and AI context
   ✅ AGENTS.md — Agent behavior configuration
   ✅ DESIGN_SYSTEM.md — Visual design standards
   ✅ README.md — Project overview and quick start
   ✅ .agents/skills/feature-development/SKILL.md
   ✅ .agents/skills/testing/SKILL.md
   ✅ .agents/hooks.json — Lifecycle automation
   ✅ .agents/mcp_config.json — Tool integrations
   ✅ docs/ARCHITECTURE.md — System architecture
   ✅ docs/API_SPEC.md — API specification (FROZEN in Team Mode)
   ✅ docs/DATABASE_SCHEMA.md — Database schema (FROZEN in Team Mode)
   ✅ docs/DEPLOYMENT.md — Deployment guide
   ✅ package.json — Dependencies and scripts
   [When Team Mode is active]
   ✅ .ai-team/team.json — Team roster, roles, and capacity
   ✅ .ai-team/plan.json — Milestone schedule & dependency DAG
   ✅ .ai-team/tasks/*.json — Granular task specifications
   ✅ .github/CODEOWNERS — Automated reviewer routing
   ```

2. **Run the self-check.**
   Ask yourself: *"Can an AI agent read these files and build features with zero verbal context?"*
   - Verify GEMINI.md contains all project rules
   - Verify AGENTS.md defines agent boundaries
   - Verify each skill has actionable step-by-step instructions
   - Verify docs reference each other correctly
   - Verify all configuration files are valid JSON/YAML
   - **Team Mode checks**:
     - Verify `.ai-team/` files validate against schemas in [references/team-templates.md](references/team-templates.md)
     - Verify task dependencies in `.ai-team/plan.json` form a strictly Directed Acyclic Graph (DAG) with zero circular dependencies
     - Verify each task in `.ai-team/tasks/*.json` defines explicit `allowedPaths` / `touchesFiles` boundary restrictions
     - Verify total assigned task hours do not exceed any team member's weekly availability limit in `team.json`
     - Verify git handles in `.github/CODEOWNERS` match registered members in `team.json`
     - Verify `docs/API_SPEC.md` and `docs/DATABASE_SCHEMA.md` are marked `Status: FROZEN (v1.0-CONTRACT)`

3. **Offer targeted regeneration.**
   Tell the user:
   > *"All files are generated. If you'd like me to adjust or regenerate any specific file, just tell me which one and what to change."*

4. **Present the "Start Building" call-to-action.**
   ```
   🎮 Game Dojo Setup Complete!

   Your project is fully configured. Here's what to do next:

   1. Run `npm install` (or equivalent) to install dependencies
   2. Run `npm run dev` to start the development server
   3. Start building! Try: "Implement the user authentication feature"
      [In Team Mode]: Run "Switch to TASK-001" (git checkout feature/TASK-001-*) or let the team-orchestrator assign active tasks.

   The AI agent now has full context about your project.
   Happy building! 🚀
   ```

---

## Phase 6 — PROJECT SKELETON (New in 2.0)

### Goal
Generate actual runnable code — not just documentation. After this phase, `npm install && npm run dev` should work.

### Steps

1. **Activate the project-skeleton skill.**
   Read `.agents/skills/project-skeleton/SKILL.md` for tech-stack-specific instructions.

2. **Generate the package manifest** (`package.json`, `requirements.txt`, `pubspec.yaml`, etc.) with all dependencies.

3. **Generate configuration files** (`tsconfig.json`, eslint, prettier, `.env.example`, `.gitignore`, Docker, CI/CD).

4. **Generate setup scripts** (`scripts/setup.ps1` for Windows, `scripts/setup.sh` for Unix).
   - In Team Mode: Include environment verification (checks local `git config user.email` against `.ai-team/team.json`), dependency installation, and helper commands for checking out assigned task branches.

5. **Generate starter code** — minimal but functional code for each core feature.
   - In Team Mode: Starter code must strictly adhere to frozen API and database contracts in `docs/API_SPEC.md` and `docs/DATABASE_SCHEMA.md`.

6. **Initialize git repository and pre-create task branches (Team Mode).**
   - Initialize git repository if not already initialized (`git init`).
   - Stage and commit the baseline project code, configs, `.ai-team/` directory, and `.github/CODEOWNERS` to the `main` branch.
   - **Pre-Create Task Branches (When Team Mode is active)**:
     - Read `.ai-team/plan.json` to identify all Wave 1 (unblocked foundation) tasks.
     - Pre-create dedicated git branches for every Wave 1 task:
       ```powershell
       git branch feature/<task-id>-<slug>
       ```
       *(e.g., `git branch feature/TASK-001-db-baseline`, `git branch feature/TASK-002-api-mocks`, `git branch feature/TASK-003-ui-shell`)*
     - Ensure the repository remains checked out on `main` with all task branches anchored at the initial baseline commit.
     - Team members or parallel subagents can immediately switch to their assigned branch (`git checkout feature/<task-id>-<slug>`) and work simultaneously without merge conflicts.

---

## Phase 7 — AUTONOMOUS IMPROVEMENT (New in 2.0)

### Goal
Continuously improve the generated project until it reaches a quality score of 95/100.

### Steps

1. **Activate the ratchet-loop skill.**
   Read `.agents/skills/ratchet-loop/SKILL.md` for the full improvement procedure.

2. **Run the comprehension test** as the baseline AI readability score.
   Read `.agents/skills/comprehension-test/SKILL.md`.

3. **Enter the ratchet loop:**
   - Score → Identify weakest area → Fix → Re-score → Keep or discard
   - Continue until score > 95 or time budget exhausted

4. **Run self-healing** to catch any remaining issues.
   Read `.agents/skills/self-healing/SKILL.md`.

---

## Phase 8 — MEMORY & HANDOFF (New in 2.0)

### Goal
Record this session for future improvement and present the final results.

### Steps

1. **Record to adaptive memory.**
   Activate `.agents/skills/adaptive-memory/SKILL.md` and log:
   - Project spec, tech stack, Project Mode (Solo vs Team), team roster size, roles, quality scores, skills used, user edits

2. **Generate the final report** showing:
   - All files created with quality scores
   - Ratchet loop improvement history
   - Comprehension test results
   - Recommended next steps
   - Areas where human judgment is needed

3. **Present the "Start Building" call-to-action** with working commands.

---

## Behavioral Guidelines

- **Be opinionated but flexible.** Make strong default recommendations, but always accept user overrides.
- **Explain your reasoning.** When you choose a technology or pattern, briefly say why.
- **Never generate placeholder content.** Every line in every file must be real and usable.
- **Maintain consistency.** File naming, code style, and conventions must be uniform across all generated files.
- **Think about the AI consumer.** Every file you generate will be read by AI agents. Optimize for machine-parseability alongside human readability.
- **Be incremental.** After generating files, the user should be able to start building immediately without a "setup phase."
- **Improve autonomously.** Don't stop after generation. Enter the ratchet loop to push quality higher.
- **Generate executable code.** Documentation alone is not enough. The project must actually run.
- **Remember and learn.** Record every session. Use past patterns to improve future bootstraps.
- **Test your own work.** Run the comprehension test on every project. If a fresh agent can't understand it, neither can a new team member.
