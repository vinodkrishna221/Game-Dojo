---
name: agent-swarm
description: "Orchestrates parallel subagents for faster, higher-quality project bootstrapping. Instead of one agent doing everything sequentially, this skill coordinates specialized agents (Researcher, Doc Writer, Skill Builder, Integration Engineer, Validator, Tester) working simultaneously on isolated branches. Use this skill when bootstrapping complex projects that benefit from parallel generation."
---

# Agent Swarm

## The Swarm Architecture

Game Dojo uses a **Shepherd/Search Agent pattern** inspired by autonomous research systems. One Architect Agent coordinates multiple specialist agents working in parallel.

---

### Tier 1 — Architect Agent (Shepherd)

The Architect Agent is the main conversation agent. It has sole authority over:

- **Project Specification:** Holds the complete spec gathered during the interview phase
- **Architectural Decisions:** Makes all high-level tech stack and structure choices
- **Conflict Resolution:** Resolves inconsistencies between specialist agent outputs
- **Final Merge:** Performs the merge of all agent outputs into a coherent project
- **Quality Review:** Runs the final validation and comprehension test

The Architect Agent never generates files directly when swarm mode is active — it delegates all generation work to specialists and focuses on orchestration.

---

### Tier 2 — Specialist Agents (Search/Worker)

Each specialist operates in an **isolated context** to prevent cross-contamination. They receive the Project Specification as input and return their deliverables to the Architect.

#### 1. Research Agent

**Mission:** Discover and recommend existing skills, plugins, and MCP servers for the project's tech stack.

**Inputs:**
- Project Specification (tech stack, frameworks, tools)
- Local skills library path: `C:\Users\Vinod krishna\antigravity_skills`

**Process:**
1. Scan the local skills library for skills matching the tech stack
2. Search the Antigravity marketplace for relevant plugins
3. Identify appropriate MCP servers for the project's tooling needs
4. Evaluate each recommendation for relevance and quality

**Returns:**
- List of recommended local skills (with paths and justifications)
- List of recommended marketplace plugins (with install commands)
- List of recommended MCP servers (with configuration snippets)
- Priority ranking (must-have vs. nice-to-have)

---

#### 2. Doc Generator Agent

**Mission:** Generate all project documentation files.

**Inputs:**
- Project Specification
- Templates from `references/templates.md`
- Design system conventions

**Process:**
1. Load templates for each document type
2. Fill templates with project-specific content from the specification
3. Add cross-references between documents
4. Ensure all sections are complete and substantive

**Returns:**
- `GEMINI.md` — Project rules and conventions
- `AGENTS.md` — Agent behavioral rules
- `DESIGN_SYSTEM.md` — Visual identity and formatting
- `README.md` — Project overview and setup guide
- `docs/PROJECT_BRIEF.md` — Foundation document
- `docs/REQUIREMENTS.md` — Functional and non-functional requirements
- `docs/ARCHITECTURE.md` — System architecture and deployment
- `docs/DESIGN_SYSTEM.md` — Detailed design specifications
- `docs/IMPLEMENTATION_PLAN.md` — Phased build plan
- `docs/API_SPEC.md` — API endpoints and contracts (if applicable)
- `docs/DATA_MODEL.md` — Database schema and relationships (if applicable)

---

#### 3. Skill Builder Agent

**Mission:** Create all project-specific SKILL.md files.

**Inputs:**
- Project Specification (tech stack, workflows, features)
- Local skills library for import candidates
- Skill-crafter skill instructions

**Process:**
1. Identify all required skills based on the project's workflows
2. Check the local library (`C:\Users\Vinod krishna\antigravity_skills`) for importable skills
3. For each importable skill: copy and adapt it to the project's conventions
4. For each novel skill: craft it from scratch using the skill-crafter methodology
5. Ensure every skill has proper YAML frontmatter, clear instructions, and examples

**Returns:**
- Complete set of SKILL.md files in `.agents/skills/`
- A manifest listing all created skills with descriptions

---

#### 4. Integration Agent

**Mission:** Configure all integration and automation files.

**Inputs:**
- Project Specification (tech stack, deployment targets, CI/CD needs)
- Research Agent's MCP server recommendations (if available; otherwise, make independent choices)
- List of generated skills (if available; otherwise, use expected skill names from specification)

**Process:**
1. Create `hooks.json` with lifecycle automation for the project
2. Create `mcp_config.json` with appropriate MCP server connections
3. Create `plugin.json` with the plugin manifest
4. Configure pre-commit hooks, build triggers, and deployment hooks
5. Ensure all referenced paths and skill names will resolve correctly

**Returns:**
- `.agents/hooks.json` — Lifecycle hooks configuration
- `.agents/mcp_config.json` — MCP server configuration
- `.agents/plugins/*/plugin.json` — Plugin manifest
- Any additional config files (`.env.example`, CI/CD workflows)

---

#### 5. Validator Agent

**Mission:** Validate the merged project output for completeness and correctness.

**Inputs:**
- All merged project files from agents 1-4

**Process:**
1. Run the `project-validator` skill on the complete output
2. Check JSON syntax validity for all `.json` files
3. Check YAML frontmatter validity for all SKILL.md files
4. Verify all cross-references resolve (file links, skill names, config paths)
5. Check completeness against the required files checklist
6. Score each quality dimension

**Returns:**
- Quality report with composite score (0-100)
- Per-dimension sub-scores (completeness, validity, cross-references, coverage, readability)
- List of specific issues found, ordered by severity
- Recommended fixes for each issue

---

#### 6. Test Agent

**Mission:** Run the comprehension test on the final output.

**Inputs:**
- All project files (clean context — no conversation history)

**Process:**
1. Follow the `comprehension-test` skill procedure exactly
2. Answer all 5 test questions using ONLY the project files
3. Self-score each answer against the Project Specification ground truth
4. Identify gaps and generate improvement recommendations

**Returns:**
- Comprehension score (0-100)
- Per-question scores and ratings
- Gap analysis with specific file-level recommendations
- Overall readability rating

---

## Orchestration Protocol

### Step 1 — Specification Broadcast

The Architect Agent creates a structured **Project Specification Document** containing:
- Project name, description, and target audience
- Complete tech stack with versions
- Architecture pattern and component list
- Feature list with priorities
- Deployment targets and CI/CD requirements
- Design system preferences

This document is shared with all specialist agents as their sole source of truth.

### Step 2 — Parallel Execution

Launch agents 1-4 **simultaneously** using `send_message`. They do not depend on each other's output to begin work.

```
┌─────────────┐
│  Architect   │
│  (Shepherd)  │
└──────┬───────┘
       │ broadcasts Project Specification
       ├──────────────┬──────────────┬──────────────┐
       ▼              ▼              ▼              ▼
┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
│  Research   │ │ Doc Writer │ │   Skill    │ │Integration │
│   Agent     │ │   Agent    │ │  Builder   │ │   Agent    │
└────────────┘ └────────────┘ └────────────┘ └────────────┘
```

### Step 3 — Collection Point

Wait for all 4 agents to complete. Set a timer to check progress if any agent takes longer than expected. Collect all deliverables.

### Step 4 — Merge

The Architect Agent reviews all outputs and checks for:

1. **Naming Consistency:** Do all files reference the same project name, same framework names, same directory paths?
2. **Cross-Reference Accuracy:** Do docs link to skills that actually exist? Do configs reference servers that are configured?
3. **Architectural Alignment:** Do all files reflect the same tech stack decisions? No contradictions between ARCHITECTURE.md and package.json?
4. **Completeness:** Did every agent deliver all expected files?

Fix any inconsistencies found during merge. This is the Architect's most critical responsibility.

### Step 5 — Validation

Launch the **Validator Agent** (agent 5) on the merged output. Review the quality report.

### Step 6 — Testing

Launch the **Test Agent** (agent 6) for the comprehension test. Review the comprehension score.

### Step 7 — Ratchet (if needed)

If the combined quality score is below 95, enter the `ratchet-loop` skill to autonomously improve the weakest areas.

---

## When to Use Swarm Mode

| Project Complexity | Agent Count | Recommendation |
|---|---|---|
| **Simple** (1 framework, basic CRUD, few pages) | 1 | Skip swarm — use sequential generation. Overhead isn't worth it. |
| **Medium** (2-3 services, auth, database, API) | 3-4 | Use Doc Generator + Skill Builder + Integration agents in parallel. |
| **Complex** (microservices, multiple databases, real-time, CI/CD) | 6 | Use full swarm with all specialist agents. |
| **Overnight mode** (`/goal`) | 6 | Always use full swarm + ratchet loop for maximum quality. |

### Complexity Heuristic

Count the following indicators to determine complexity:
- Number of distinct services/processes: +1 each
- Database present: +1
- Authentication required: +1
- Real-time features (WebSocket, SSE): +1
- CI/CD pipeline needed: +1
- Multiple deployment targets: +1
- External API integrations: +1 each

**Score 1-3:** Simple | **Score 4-6:** Medium | **Score 7+:** Complex

---

## Error Handling

### Agent Failure Recovery

If any specialist agent fails (crashes, times out, or returns incomplete output):

1. **First attempt:** Retry the failed agent with the same inputs
2. **Second attempt:** Retry with simplified instructions (fewer deliverables)
3. **Fallback:** The Architect generates that component sequentially, without delegation

### Branch Safety

All agent outputs are committed to **separate git branches** before merging:

```
main
├── swarm/research      ← Research Agent output
├── swarm/docs          ← Doc Generator output
├── swarm/skills        ← Skill Builder output
├── swarm/integration   ← Integration Agent output
└── swarm/merged        ← Architect's merged result
```

This ensures nothing is lost even if the merge encounters conflicts.

### Conflict Resolution

If two agents produce conflicting outputs (e.g., Doc Generator references a different database than Integration Agent configured):

1. The **Project Specification is the source of truth** — whichever agent matches the spec is correct
2. If both deviate from the spec, the Architect corrects both to match the spec
3. All conflict resolutions are logged for the user's review

---

## Communication Protocol

All inter-agent communication uses `send_message` with structured payloads:

**Architect → Specialist (task assignment):**
```
TASK: [agent role]
SPECIFICATION: [full project spec]
DELIVERABLES: [list of expected outputs]
CONSTRAINTS: [any specific rules or conventions]
```

**Specialist → Architect (task completion):**
```
STATUS: COMPLETE
FILES_CREATED: [list of file paths]
NOTES: [any decisions made, assumptions, or concerns]
```

**Specialist → Architect (task failure):**
```
STATUS: FAILED
ERROR: [description of what went wrong]
PARTIAL_OUTPUT: [any files that were successfully created]
SUGGESTION: [recommended recovery approach]
```
