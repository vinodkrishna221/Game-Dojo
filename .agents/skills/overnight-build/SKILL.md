---
name: overnight-build
description: "Executes the complete Game Dojo pipeline autonomously without human intervention — from project description to fully built, tested, and validated project. Designed for /goal mode where the user describes their idea and reviews results hours later. Use this skill when the user wants maximum autonomy and is willing to wait for a comprehensive result."
---

# Overnight Build

## Overview

The Overnight Build is the culmination of all Game Dojo 2.0 capabilities. It chains together every phase — interview, analysis, generation, validation, and improvement — into a single autonomous pipeline that runs for hours if needed.

The user describes their idea, walks away, and comes back to a fully bootstrapped, validated, and documented project with actual runnable code, passing tests, and a comprehensive morning report.

---

## The 14-Step Pipeline

### Phase A — Understanding (Steps 1-2)

#### Step 1: Auto-Interview

Accept the project description from the user. Use the question-bank from `game-dojo-bootstrap` to identify information gaps.

**Critical rule:** For ANY gap, **apply the smart default** rather than asking the user. The user is not available — this is autonomous mode.

Log all defaults that were applied:

```
## Auto-Interview Defaults Applied
- Primary language: TypeScript (default — user didn't specify)
- Frontend framework: Next.js (default for web apps — user said "website")
- Database: PostgreSQL with Prisma (default for relational data — user mentioned "users")
- Auth: NextAuth.js (default — user mentioned "login")
- Hosting: Vercel (default for Next.js projects)
- Styling: Tailwind CSS (default — no preference stated)
```

#### Step 2: Architecture Analysis

Run the full analysis phase from `game-dojo-bootstrap`:

1. Determine the optimal tech stack based on project type and requirements
2. Choose architecture pattern (monolith, microservices, serverless, etc.)
3. Map features to technical components
4. Identify integration points and external dependencies
5. Create the **Project Specification Document** — the single source of truth for all subsequent phases

---

### Phase B — Generation (Steps 3-6)

#### Step 3: Launch Agent Swarm

Activate the `agent-swarm` skill to generate all project files in parallel:

- Research Agent → finds relevant skills, plugins, MCP servers
- Doc Generator Agent → creates all documentation
- Skill Builder Agent → creates all SKILL.md files
- Integration Agent → creates hooks.json, mcp_config.json, plugin.json

See the `agent-swarm` skill for full orchestration details.

#### Step 4: Merge Results

The Architect Agent merges all specialist outputs:

1. Collect deliverables from all agents
2. Check naming consistency across all files
3. Verify cross-references resolve correctly
4. Resolve any conflicts (Project Specification is the source of truth)
5. Commit the merged result to git

#### Step 5: Generate Project Skeleton

Beyond documentation and configuration, generate actual **runnable code**:

| File Category | Examples |
|---|---|
| **Package manifest** | `package.json` with all dependencies and scripts |
| **Folder structure** | `src/`, `tests/`, `public/`, `prisma/`, etc. with index files |
| **TypeScript config** | `tsconfig.json` with strict mode and path aliases |
| **Linting/formatting** | `.eslintrc.js`, `.prettierrc`, `.editorconfig` |
| **Styling config** | `tailwind.config.js`, `postcss.config.js` (if applicable) |
| **Database schema** | `prisma/schema.prisma` or SQL migration files |
| **Environment config** | `.env.example` with all required variables documented |
| **CI/CD workflows** | `.github/workflows/ci.yml` with build, lint, and test steps |
| **Docker files** | `Dockerfile`, `docker-compose.yml` (if applicable) |
| **Git config** | `.gitignore` tailored to the tech stack |

Every generated file must be **complete and valid** — no TODOs, no placeholders, no stubs.

#### Step 6: Install Dependencies

Run the package manager to install all dependencies:

```powershell
npm install
```

If installation fails:
1. Check `package.json` for version conflicts
2. Fix any invalid package names or versions
3. Retry installation
4. If still failing, log the error and continue (the user can resolve dependency issues manually)

---

### Phase C — Building (Steps 7-9)

#### Step 7: Build Core Features

For each MVP feature identified during the analysis phase:

1. **Read the relevant skill** for guidance on implementation patterns
2. **Generate the feature's files:**
   - UI components (pages, layouts, shared components)
   - API routes or server actions
   - Database models and migrations
   - Type definitions and interfaces
   - Utility functions and helpers
3. **Write at least one test per feature:**
   - Unit tests for business logic
   - Integration tests for API routes
   - Component tests for UI (if testing library is configured)

**Feature generation order:** Build foundational features first (auth, database connection, layout), then feature-specific functionality.

#### Step 8: Run Tests

Execute the full test suite:

```powershell
npm test
```

For each failing test:
1. Read the error message and stack trace
2. Identify the root cause (missing import, wrong type, logic error)
3. Fix the issue in the source code
4. Re-run the failing test to confirm the fix
5. Repeat until all tests pass

**Maximum test-fix iterations:** 10 per feature. If a test cannot be fixed after 10 attempts, log the failure and move on.

#### Step 9: Build Verification

Ensure the project compiles and builds without errors:

```powershell
npm run build
```

For build failures:
1. Read the build error output
2. Fix TypeScript errors, missing imports, or configuration issues
3. Re-run the build
4. Repeat until the build succeeds

**Maximum build-fix iterations:** 15. If the build cannot be fixed, log all errors for the user's review.

---

### Phase D — Quality Assurance (Steps 10-12)

#### Step 10: Run Comprehension Test

Activate the `comprehension-test` skill:

1. Spawn a fresh subagent with access to ONLY the project files
2. Ask all 5 test questions (Project Identity, Tech Stack, Feature Implementation, Architecture, Deployment)
3. Score each answer against the Project Specification ground truth
4. Record the comprehension score and identify any gaps

#### Step 11: Enter Ratchet Loop

Activate the `ratchet-loop` skill with an extended configuration for overnight mode:

| Parameter | Overnight Value |
|---|---|
| Time budget | 2 hours |
| Target score | 95/100 |
| Max attempts | 50 |
| Max consecutive failures | 5 |

The ratchet loop will autonomously improve any areas scoring below 90%:
- Regenerate weak documentation
- Add missing skills
- Fix broken cross-references
- Improve AI readability of core docs
- Each improvement is individually git-committed for audit trail

#### Step 12: Final Validation

Run the `project-validator` one last time to get the definitive quality score. This score is reported in the morning report.

---

### Phase E — Handoff (Steps 13-14)

#### Step 13: Generate Morning Report

Create a comprehensive summary artifact at `docs/MORNING_REPORT.md`:

```markdown
# 🌅 Morning Report — [Project Name]

**Generated:** [timestamp]
**Total Duration:** [time elapsed]
**Final Quality Score:** [score]/100

## What Was Built

### Documentation ([count] files)
- ✅ GEMINI.md — Project rules and conventions
- ✅ AGENTS.md — Agent behavioral rules
- ✅ README.md — Project overview and setup guide
- ... (list all docs)

### Skills ([count] skills)
- ✅ feature-development — Step-by-step feature workflow
- ✅ testing-strategy — Testing patterns and conventions
- ... (list all skills)

### Code ([count] files)
- ✅ src/app/page.tsx — Home page
- ✅ src/app/api/auth/route.ts — Auth API endpoint
- ... (list key code files)

### Tests ([count] tests)
- ✅ [pass count] passing
- ❌ [fail count] failing (details below)

## Decisions Made

| Decision | Choice | Reasoning |
|----------|--------|-----------|
| Frontend framework | Next.js 14 | Best fit for SSR + API routes in one package |
| Database | PostgreSQL + Prisma | User mentioned relational data; Prisma has best DX |
| ... | ... | ... |

## Quality Scores

| Metric | Before Ratchet | After Ratchet |
|--------|----------------|---------------|
| Completeness | 72/100 | 95/100 |
| Validity | 85/100 | 100/100 |
| Cross-References | 60/100 | 92/100 |
| Coverage | 68/100 | 90/100 |
| AI Readability | 75/100 | 93/100 |
| **Composite** | **72/100** | **94/100** |

## Comprehension Test Results

| Question | Score | Notes |
|----------|-------|-------|
| Project Identity | 20/20 | ✅ Perfect |
| Tech Stack | 18/20 | Minor: missed PostCSS version |
| Feature Implementation | 17/20 | Good, but naming convention details thin |
| Architecture | 20/20 | ✅ Perfect |
| Deployment | 15/20 | CI/CD described but Docker setup missing |

## Defaults Applied

These decisions were made automatically because no user preference was stated:
- [list all auto-interview defaults]

## What to Review First

1. **`GEMINI.md`** — Verify the coding conventions match your preferences
2. **`docs/ARCHITECTURE.md`** — Confirm the architecture decisions
3. **`package.json`** — Check dependency versions
4. **`.env.example`** — Review required environment variables

## Suggested Next Steps

1. Copy `.env.example` to `.env` and fill in real values
2. Run `npm run dev` to start the development server
3. Review and customize the design system in `DESIGN_SYSTEM.md`
4. Start building features — the `feature-development` skill will guide you
```

#### Step 14: Notify User

Present the morning report artifact to the user. Highlight the most important items that need human review:
- Any decisions where the smart default might not match user intent
- Any failing tests that couldn't be auto-fixed
- Any quality score areas below 90%

---

## Time Budget Allocation

For an 8-hour overnight run:

| Phase | Duration | Percentage |
|---|---|---|
| **A — Understanding** | ~5 minutes | 1% |
| **B — Generation** | ~15-30 minutes | 5% |
| **C — Building** | ~2-4 hours | 40% |
| **D — Quality Assurance** | ~1-2 hours | 20% |
| **E — Handoff** | ~5 minutes | 1% |
| **Remaining** | ~2-4 hours | 33% |

Remaining time is allocated to additional ratchet loop iterations, fixing edge cases, and improving test coverage.

---

## Safety Rails

These rules are **non-negotiable** and cannot be overridden:

1. **Never deploy to production** without explicit human approval. The overnight build generates deployment *configurations* but never *executes* deployments.

2. **Never delete existing files** that weren't created by Game Dojo. If the project directory already contains files, preserve them. Only create new files or modify files that Game Dojo generated.

3. **Always use git** for full audit trail and easy rollback. Every phase creates commits. The user can `git log` to see exactly what happened and `git reset` to undo anything.

4. **Log everything.** Every decision, every file change, every test result, every ratchet attempt. The morning report must account for every action taken.

5. **Stop gracefully** on repeated failures. If the ratchet loop hits 5 consecutive failed attempts on the same issue, skip that issue and move on. Do not loop infinitely.

6. **Never install global packages** or modify system-level configuration. All installations are local to the project directory.

7. **Never expose secrets.** Generated `.env.example` files contain placeholder values only. Real secrets are never generated or committed.

8. **Respect file system boundaries.** Only write files within the project directory (`d:\Game_dojo` or the user's specified path). Never write to system directories, home directories, or other projects.

---

## Activation Triggers

The overnight build activates when:

- The user uses the `/goal` slash command
- The user says "build this overnight"
- The user says "I'll review in the morning"
- The user says "go autonomous"
- The user says "run the overnight build pipeline"
- The user says "full auto" or "hands-off mode"

When activated, confirm the project description with the user one final time, then proceed autonomously through all 14 steps.

---

## Failure Recovery

If the pipeline encounters a critical failure at any step:

1. **Log the failure** with full error details
2. **Commit the current state** to git with a descriptive message
3. **Skip to Step 13** (Generate Morning Report) and include the failure details
4. **Present whatever was completed** — a partial result is better than no result
5. **Suggest manual fixes** the user can apply to complete the build

The pipeline should never crash silently. The user must always receive a morning report, even if it reports "Phase C failed — here's what we have so far."
