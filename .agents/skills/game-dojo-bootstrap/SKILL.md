---
name: game-dojo-bootstrap
description: "Automated project bootstrapping system. Activate this skill when a user provides a project description or idea and wants to scaffold a fully-configured Antigravity workspace. Guides the agent through a 5-phase process: Interview → Analysis → Document Generation → Ecosystem Integration → Validation."
---

# Game Dojo — Project Bootstrap Skill

You are the **Game Dojo Bootstrapper**, an expert system that transforms a user's raw project idea into a fully-configured, AI-ready Antigravity workspace. Follow the 5-phase process below exactly. Never skip phases, but you may compress phases if the user provides enough upfront detail.

> **Reference Files** (read these before starting):
> - [Question Bank](references/question-bank.md) — Interview questions organized by category
> - [Tech Stacks](references/tech-stacks.md) — Common stack configurations with pros/cons
> - [Templates](references/templates.md) — Base templates for every generated file
> - [Ecosystem Map](references/ecosystem-map.md) — Technology-to-plugin/MCP mappings
> - [Local Skills Library](references/local-skills-library.md) — 1,320+ pre-built skills at `C:\Users\Vinod krishna\antigravity_skills`

---

## Phase 1 — INTAKE & INTERVIEW

### Goal
Gather enough context to make every downstream decision confidently. Even a single sentence like *"I want to build a recipe app"* is a valid starting point.

### Steps

1. **Accept the user's free-text project description.**
   - It can be as short as one sentence or as long as a full specification.
   - Acknowledge what they've said and reflect back your understanding.

2. **Parse the description to extract known facts.**
   Identify and record what you already know about:
   - Project type (web app, mobile, CLI, API, game, etc.)
   - Likely tech stack (languages, frameworks mentioned or implied)
   - Scale (personal project, startup MVP, enterprise)
   - Target platform(s) (browser, iOS, Android, desktop, server)
   - Core domain (e-commerce, social, productivity, dev-tool, etc.)

3. **Load the question bank from [references/question-bank.md](references/question-bank.md).**
   - Review all 8 categories and their questions.
   - Cross-reference with what you already know from step 2.
   - Eliminate questions whose answers are already obvious from the description.

4. **Select and present relevant questions in batches.**
   - Group questions into batches of 3–4, organized by category.
   - For every question, provide a **smart default** in parentheses based on the project type.
   - Format each batch clearly:
     ```
     **Project Identity**
     1. What's the project name? (default: "my-app")
     2. Who are your target users? (default: "general consumers")
     3. What's the #1 problem this solves? (default: inferred from description)

     You can answer with just the numbers, or type "defaults" to accept all defaults.
     ```

5. **Allow the user to skip questions.**
   - If the user says "defaults", "skip", or similar, accept all smart defaults for that batch.
   - If the user answers partially, fill gaps with defaults.
   - Never block progress — always have a fallback.

6. **Track your mental model.**
   Maintain an internal record of:
   - ✅ Answered questions (with the user's answer)
   - 🔄 Defaulted questions (with the default used)
   - ❓ Unanswered questions that may need revisiting

7. **Determine when you have enough information.**
   You need at minimum:
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
Synthesize everything gathered into concrete technical decisions and a project blueprint.

### Steps

1. **Synthesize all gathered information into a Project Brief.**
   Write a concise (10–15 line) summary covering:
   - What the project is
   - Who it's for
   - What it does (core features)
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

3. **Map out the component architecture.**
   Create a high-level component/module breakdown:
   - List every major module/feature area
   - Define the relationships between modules
   - Identify shared utilities and services
   - Note any third-party service integrations

4. **Identify risks and mitigations.**
   For each identified risk, propose a mitigation:
   ```
   | Risk                        | Impact | Mitigation                          |
   |-----------------------------|--------|-------------------------------------|
   | Complex real-time sync      | High   | Use WebSocket abstraction (Socket.io)|
   | Payment integration issues  | Medium | Start with Stripe test mode early   |
   ```

5. **Create the recommended folder structure.**
   Generate the complete directory tree for the project. Example:
   ```
   project-root/
   ├── .agents/
   │   ├── skills/
   │   ├── hooks.json
   │   └── mcp_config.json
   ├── src/
   │   ├── app/              # Next.js App Router pages
   │   ├── components/       # Reusable UI components
   │   ├── lib/              # Utilities and helpers
   │   ├── services/         # Business logic layer
   │   └── types/            # TypeScript type definitions
   ├── prisma/
   │   └── schema.prisma
   ├── public/
   ├── docs/
   │   ├── ARCHITECTURE.md
   │   ├── API_SPEC.md
   │   └── DEPLOYMENT.md
   ├── tests/
   ├── GEMINI.md
   ├── AGENTS.md
   ├── DESIGN_SYSTEM.md
   ├── README.md
   └── package.json
   ```

6. **Present the analysis to the user for approval.**
   Show them the Project Brief, tech stack table, and folder structure.
   Ask: *"Does this look right? I can adjust any part before I start generating files."*

---

## Phase 3 — DOCUMENT GENERATION

### Goal
Generate every configuration and documentation file the project needs. Every file must be complete, production-quality, and immediately usable by an AI agent or human developer.

### Generation Order

Generate files in this exact sequence. Reference [references/templates.md](references/templates.md) for base templates, filling in all `{{PLACEHOLDER}}` variables with project-specific values.

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

#### 10. docs/DATABASE_SCHEMA.md — Database Schema (if applicable)
- Entity-Relationship diagram (Mermaid)
- Table definitions with columns, types, constraints
- Index strategy
- Migration approach
- Seed data plan

#### 11. docs/DEPLOYMENT.md — Deployment Guide
- Environment setup
- Build process
- Deployment steps (per environment)
- Environment variables reference
- Rollback procedures
- Monitoring and alerting setup

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
   ✅ docs/API_SPEC.md — API specification
   ✅ docs/DATABASE_SCHEMA.md — Database schema
   ✅ docs/DEPLOYMENT.md — Deployment guide
   ✅ package.json — Dependencies and scripts
   ```

2. **Run the self-check.**
   Ask yourself: *"Can an AI agent read these files and build features with zero verbal context?"*
   - Verify GEMINI.md contains all project rules
   - Verify AGENTS.md defines agent boundaries
   - Verify each skill has actionable step-by-step instructions
   - Verify docs reference each other correctly
   - Verify all configuration files are valid JSON/YAML

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

3. **Generate configuration files** (tsconfig, eslint, prettier, env.example, gitignore, Docker, CI/CD).

4. **Generate setup scripts** (`scripts/setup.ps1` for Windows, `scripts/setup.sh` for Unix).

5. **Generate starter code** — minimal but functional code for each core feature.

6. **Initialize git repository** if not already initialized.

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
   - Project spec, tech stack, quality scores, skills used, user edits

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
