---
name: comprehension-test
description: "Verifies that generated project files are self-explanatory by spawning a fresh agent context with only the project files and testing if it can accurately describe the project. Use this skill as the ultimate validation step after document generation to ensure AI readability and completeness."
---

# Comprehension Test

## Overview

The Comprehension Test is the gold standard for project documentation quality. It answers one question: **"If a brand-new AI agent is dropped into this project with ZERO verbal context, can it understand everything it needs to build features?"**

This is not a test of the agent's intelligence — it is a test of the project's self-documentation. If the agent fails, the project files are incomplete or unclear, and they need improvement.

---

## The Test Procedure

### Step 1 — Prepare the Test Context

Gather all generated project files that a fresh agent would have access to:

- `GEMINI.md`
- `AGENTS.md`
- `DESIGN_SYSTEM.md`
- `README.md`
- All files in `docs/` (ARCHITECTURE.md, REQUIREMENTS.md, API_SPEC.md, DATA_MODEL.md, IMPLEMENTATION_PLAN.md, etc.)
- All files in `.agents/skills/` (every SKILL.md)
- `.agents/plugins/*/plugin.json`
- `.agents/hooks.json`
- `.agents/mcp_config.json`
- Project skeleton files (`package.json`, `tsconfig.json`, etc.)

Create a clean context with **ONLY** these files — no conversation history, no verbal instructions, no memory of the interview phase.

### Step 2 — Ask the Test Questions

Pose these 5 questions to a subagent that has access to **ONLY** the project files. Each question is worth 20 points.

---

#### Q1 — Project Identity (20 pts)

> "What is this project? What problem does it solve? Who is it for?"

**Scoring rubric:**
- **20/20:** Agent correctly identifies the project name, purpose, target audience, and core value proposition — matching the original Project Specification exactly.
- **15/20:** Agent gets the project name and general purpose right but misses the target audience or value proposition nuance.
- **10/20:** Agent understands it's a software project and gets the broad domain right but is confused about specifics.
- **5/20:** Agent misidentifies the project type or purpose fundamentally.
- **0/20:** Agent cannot determine what the project is.

**Ground truth source:** Project Specification Document, `README.md`, `docs/PROJECT_BRIEF.md`

---

#### Q2 — Tech Stack (20 pts)

> "What technologies does this project use? List the full stack with versions."

**Scoring rubric:**
- **20/20:** Agent lists every framework, library, database, and tool with correct versions. Nothing missing, nothing fabricated.
- **15/20:** Agent lists all major technologies correctly but misses minor tools or exact version numbers.
- **10/20:** Agent identifies the primary framework but misses significant stack components (e.g., knows it's React but misses the database or API layer).
- **5/20:** Agent identifies the language but gets frameworks wrong.
- **0/20:** Agent cannot determine the tech stack.

**Ground truth source:** `GEMINI.md`, `package.json`, `docs/ARCHITECTURE.md`

---

#### Q3 — Feature Implementation (20 pts)

> "Walk me through step-by-step how you would add a new feature to this project."

**Scoring rubric:**
- **20/20:** Agent describes a complete workflow that follows the project's conventions: correct file locations, naming patterns, import styles, testing approach, and PR process.
- **15/20:** Agent gets the general workflow right but misses specific conventions (e.g., correct directory but wrong naming pattern).
- **10/20:** Agent describes a generic feature development process that would work but doesn't follow the project's specific conventions.
- **5/20:** Agent suggests an approach that would conflict with the project's architecture.
- **0/20:** Agent has no idea how to add features to this project.

**Ground truth source:** `GEMINI.md`, `.agents/skills/*/SKILL.md` (especially feature-development or similar skills)

---

#### Q4 — Architecture (20 pts)

> "Describe the project's architecture. What are the main components and how do they interact?"

**Scoring rubric:**
- **20/20:** Agent accurately describes the architecture pattern (monolith, microservices, serverless, etc.), identifies all major components, and explains their interactions correctly.
- **15/20:** Agent gets the architecture pattern and major components right but misses interaction details or secondary services.
- **10/20:** Agent identifies some components but misunderstands how they interact.
- **5/20:** Agent describes a generic architecture that doesn't match the project.
- **0/20:** Agent cannot describe the architecture.

**Ground truth source:** `docs/ARCHITECTURE.md`, `GEMINI.md`

---

#### Q5 — Deployment (20 pts)

> "How would you deploy this project to production?"

**Scoring rubric:**
- **20/20:** Agent describes the exact deployment process: build commands, hosting platform, environment variables, CI/CD pipeline, and any pre-deployment checks.
- **15/20:** Agent gets the hosting platform and basic deployment right but misses CI/CD or environment configuration.
- **10/20:** Agent suggests a reasonable deployment approach but it doesn't match the project's actual setup.
- **5/20:** Agent suggests a deployment approach that would fail.
- **0/20:** Agent has no idea how to deploy this project.

**Ground truth source:** `docs/ARCHITECTURE.md` (deployment section), CI/CD config files, `Dockerfile`/`docker-compose.yml`

---

### Step 3 — Score Each Answer

For each of the 5 questions, compare the subagent's response against the ground truth sources listed above. Assign a score using the rubric provided.

Be strict but fair:
- Do not penalize the agent for phrasing differences — focus on factual accuracy
- Do not give credit for correct guesses that aren't supported by the project files
- If the project files genuinely don't contain the information needed to answer, that's a documentation failure (the agent gets a pass but the project gets flagged for improvement)

### Step 4 — Calculate Total Score

```
Total = Q1 + Q2 + Q3 + Q4 + Q5  (max 100)
```

### Step 5 — Identify Gaps

For any question scoring **below 15**, identify:
1. **Which specific files** are lacking information
2. **What specific information** is missing
3. **Where that information should be added**

### Step 6 — Generate Improvement Recommendations

For each gap, produce an actionable recommendation:

```
❌ Q3 scored 10/20 — Feature implementation unclear
   → GEMINI.md is missing: coding conventions, file naming patterns, import style
   → No skill exists for 'feature-development' workflow
   → Fix: Generate feature-development skill with step-by-step instructions

❌ Q5 scored 5/20 — Deployment process unknown
   → No deployment documentation exists
   → No CI/CD workflow files found
   → Fix: Add deployment section to ARCHITECTURE.md, generate .github/workflows/ci.yml
```

---

## Scoring Thresholds

| Score Range | Rating | Action |
|---|---|---|
| **90-100** | 🟢 Excellent | Project is fully self-documenting. No action needed. |
| **75-89** | 🟡 Good | Minor improvements needed. Targeted fixes will close gaps. |
| **50-74** | 🟠 Needs Work | Significant gaps in documentation. Multiple files need expansion. |
| **Below 50** | 🔴 Critical | Project is not self-explanatory. Major regeneration needed. |

---

## Integration Points

- **Automatic:** Called at the end of Phase 5 (Validation) in the bootstrap process
- **Ratchet Loop:** Called by `ratchet-loop` to measure the AI Readability sub-score (20 points of the composite quality score)
- **Manual:** Can be invoked by the user with "run the comprehension test" or "test AI readability"
- **Overnight Build:** Called during Phase D (Quality Assurance) of the overnight pipeline

---

## Output Format

Present results in this format:

```
## 🧪 Comprehension Test Results

**Total Score: 78/100** — 🟡 Good

| Question | Topic | Score | Rating |
|----------|-------|-------|--------|
| Q1 | Project Identity | 20/20 | 🟢 |
| Q2 | Tech Stack | 18/20 | 🟢 |
| Q3 | Feature Implementation | 12/20 | 🟠 |
| Q4 | Architecture | 18/20 | 🟢 |
| Q5 | Deployment | 10/20 | 🟠 |

### Gaps Identified

**Q3 — Feature Implementation (12/20):**
- Missing: `GEMINI.md` does not specify file naming conventions
- Missing: No `feature-development` skill exists
- Recommendation: Create a `feature-development` skill with step-by-step workflow

**Q5 — Deployment (10/20):**
- Missing: No deployment documentation
- Missing: No CI/CD configuration files
- Recommendation: Add deployment section to ARCHITECTURE.md
```

---

## Best Practices

- **Run the comprehension test BEFORE showing results to the user.** It's better to catch gaps proactively than have the user discover them.
- **Use the same scoring rubric every time.** Consistency matters for tracking improvement over ratchet loop iterations.
- **Don't coach the test agent.** The whole point is to test cold-start understanding. If you give hints, the test is worthless.
- **Treat low scores as documentation bugs, not agent bugs.** The agent is the measuring instrument; the project files are what's being measured.
