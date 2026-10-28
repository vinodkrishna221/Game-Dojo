# Game Dojo Architecture

## System Overview

Game Dojo is a project bootstrapping system that transforms a user's project idea into a fully scaffolded workspace through a structured 5-phase pipeline. It operates as an Antigravity skill/plugin that leverages AI-driven interviews, template engines, and validation to produce production-ready project documentation and configuration.

### Pipeline Overview

```mermaid
flowchart LR
    A["Phase 1\nDiscovery"] --> B["Phase 2\nAnalysis"]
    B --> C["Phase 3\nGeneration"]
    C --> D["Phase 4\nValidation"]
    D --> E["Phase 5\nPresentation"]

    style A fill:#4a90d9,color:#fff
    style B fill:#7b68ee,color:#fff
    style C fill:#50c878,color:#fff
    style D fill:#ffa500,color:#fff
    style E fill:#e74c3c,color:#fff
```

| Phase | Input | Output | Key Responsibility |
|-------|-------|--------|-------------------|
| Discovery | User's project idea (free text) | Structured requirements JSON | Conduct interview, gather preferences |
| Analysis | Structured requirements | Architecture decisions, tech stack | Evaluate trade-offs, resolve conflicts |
| Generation | Architecture decisions + templates | Project files | Render templates, write files in order |
| Validation | Generated file tree | Validation report | Check completeness, consistency, references |
| Presentation | Validated workspace | Summary + next steps | Present results, suggest marketplace plugins |

---

## Component Architecture

```mermaid
flowchart TD
    subgraph UserLayer["User Interface"]
        UI["Chat Interface"]
    end

    subgraph CoreEngine["Core Engine"]
        IE["Interview Engine"]
        AE["Analysis Engine"]
        TE["Template Engine"]
        FW["File Writer"]
        VE["Validation Engine"]
    end

    subgraph SkillLayer["Skills & Plugins"]
        BS["game-dojo-bootstrap\n(Primary Skill)"]
        PT["Project Templates"]
        QC["Question Catalog"]
    end

    subgraph InfraLayer["Infrastructure"]
        MCP["MCP Servers\n(sequential-thinking)"]
        FS["File System"]
        HK["Lifecycle Hooks"]
    end

    UI --> IE
    IE --> AE
    AE --> TE
    TE --> FW
    FW --> VE

    BS --> IE
    BS --> AE
    BS --> TE
    QC --> IE
    PT --> TE
    MCP --> AE
    FW --> FS
    HK --> FW
    HK --> VE
```

### Component Descriptions

#### Interview Engine
Drives the structured discovery conversation with the user. Loads questions from the Question Catalog, adapts follow-up questions based on previous answers, and produces a normalized requirements object.

**Responsibilities:**
- Present categorized questions (project type, audience, features, tech preferences)
- Handle free-form answers and map them to structured data
- Detect ambiguity and ask clarifying follow-ups
- Produce a complete requirements specification

#### Analysis Engine
Transforms raw requirements into concrete architectural decisions. Uses sequential-thinking MCP for complex trade-off analysis.

**Responsibilities:**
- Select optimal tech stack based on requirements
- Determine architecture pattern (monolith, microservices, serverless)
- Resolve conflicts between user preferences and best practices
- Define the file generation manifest (what files to create, in what order)

#### Template Engine
Renders project files from reference templates, filling in content derived from the analysis phase.

**Responsibilities:**
- Load templates from `references/` directory
- Interpolate project-specific values into templates
- Handle conditional sections (e.g., API docs only for projects with backends)
- Maintain template section structure and frontmatter

#### File Writer
Writes generated content to the file system in dependency order.

**Responsibilities:**
- Create directory structure
- Write files atomically
- Trigger PostToolUse hooks (markdown linting)
- Track which files were created for the validation phase

#### Validation Engine
Verifies the generated workspace for completeness and consistency.

**Responsibilities:**
- Check all required files exist
- Validate cross-references between documents
- Ensure required sections are present in each document
- Verify frontmatter fields are populated
- Report warnings and errors

---

## Data Flow

```mermaid
flowchart TD
    Input["User Input\n'Build me a recipe sharing app'"]

    Input --> Interview["Interview Engine\nStructured Q&A"]
    Interview --> Requirements["Requirements Object\n{type, audience, features, tech}"]

    Requirements --> Analysis["Analysis Engine\nTrade-off evaluation"]
    Analysis --> Decisions["Architecture Decisions\n{stack, pattern, structure}"]

    Decisions --> Templates["Template Engine\nTemplate rendering"]
    Templates --> Files["File Content\n{path, content, metadata}"]

    Files --> Writer["File Writer\nOrdered file creation"]
    Writer --> Workspace["Generated Workspace\ndocs/, .agents/, src/"]

    Workspace --> Validator["Validation Engine\nConsistency checks"]
    Validator --> Report["Validation Report\n{passed, warnings, errors}"]

    style Input fill:#f0f0f0,color:#333
    style Requirements fill:#e8f4fd,color:#333
    style Decisions fill:#f0e8fd,color:#333
    style Files fill:#e8fde8,color:#333
    style Workspace fill:#fdf0e8,color:#333
    style Report fill:#fde8e8,color:#333
```

### Data Schema Overview

**Requirements Object** (output of Discovery):
```
{
  projectName, projectType, description,
  audience: { primary, secondary },
  features: [ { name, priority, description } ],
  techPreferences: { frontend, backend, database, hosting },
  constraints: { budget, timeline, team_size }
}
```

**Architecture Decisions** (output of Analysis):
```
{
  stack: { frontend, backend, database, auth, hosting },
  pattern: "monolith" | "microservices" | "serverless",
  structure: { directories[], files[] },
  generationOrder: [ { path, template, dependencies[] } ]
}
```

---

## Skill Dependency Graph

```mermaid
flowchart TD
    Bootstrap["game-dojo-bootstrap\n(Primary Skill)"]

    Bootstrap --> Interview["Interview\nModule"]
    Bootstrap --> Analysis["Analysis\nModule"]
    Bootstrap --> Generation["Generation\nModule"]
    Bootstrap --> Validation["Validation\nModule"]

    Analysis --> SeqThink["sequential-thinking\n(MCP Server)"]
    Generation --> Templates["Reference Templates\n(references/)"]
    Generation --> Hooks["Lifecycle Hooks\n(hooks.json)"]
    Validation --> Hooks

    Hooks --> LintScript["lint-markdown.ps1"]
    Hooks --> WelcomeScript["welcome.ps1"]
    Hooks --> ReminderScript["validation-reminder.ps1"]

    style Bootstrap fill:#4a90d9,color:#fff
    style SeqThink fill:#7b68ee,color:#fff
    style Templates fill:#50c878,color:#fff
    style Hooks fill:#ffa500,color:#fff
```

---

## Extension Points

Game Dojo is designed to be extended without modifying core logic. Here are the primary extension surfaces:

### Adding New Templates

1. Create a new `.md` template in the `references/` directory
2. Include YAML frontmatter with `name`, `description`, and `requiredSections`
3. Use `{{placeholder}}` syntax for values the Template Engine should fill
4. Add the template to the generation manifest in the bootstrap skill
5. The Template Engine will automatically discover and use it

**Example:**
```markdown
---
name: SECURITY_PLAN
description: Security considerations and threat model
requiredSections: [threat-model, auth-strategy, data-protection]
---
# Security Plan
## Threat Model
{{threat_model_content}}
...
```

### Adding New Question Categories

1. Define a new category in the Question Catalog (JSON format)
2. Each question needs: `id`, `category`, `text`, `type` (text/select/multi), `options` (if applicable), `followUps`
3. Map the question's output field to the Requirements Object schema
4. The Interview Engine dynamically loads all categories at runtime

**Example:**
```json
{
  "id": "accessibility_level",
  "category": "accessibility",
  "text": "What level of accessibility compliance do you need?",
  "type": "select",
  "options": ["WCAG A", "WCAG AA", "WCAG AAA", "Not sure"],
  "mapsTo": "constraints.accessibility"
}
```

### Adding New Tech Stacks

1. Create a stack definition file in the skill's `stacks/` directory
2. Define the stack's components, default configurations, and file templates
3. Register the stack in the Analysis Engine's stack registry
4. Add any stack-specific templates to `references/`

**Stack definition format:**
```json
{
  "name": "nextjs-supabase",
  "displayName": "Next.js + Supabase",
  "components": {
    "frontend": { "framework": "Next.js", "version": "14+" },
    "backend": { "type": "serverless", "provider": "Vercel" },
    "database": { "engine": "PostgreSQL", "host": "Supabase" },
    "auth": { "provider": "Supabase Auth" }
  },
  "templates": ["nextjs-config", "supabase-schema", "vercel-config"],
  "scaffoldDirs": ["src/app", "src/components", "src/lib", "supabase/migrations"]
}
```

### Adding Lifecycle Hooks

1. Add a new hook entry to `.agents/hooks.json`
2. Create the corresponding script in `.agents/scripts/`
3. Scripts must output valid JSON matching the hook's expected response schema
4. See existing hooks for reference implementations

### Creating Plugins

1. Create a directory under `.agents/plugins/<plugin-name>/`
2. Add a `plugin.json` with at minimum `{ "name": "<plugin-name>" }`
3. Add rules in `rules/AGENTS.md` for plugin-specific behavior
4. Optionally add skills in `skills/` with `SKILL.md` instruction files

---

## Game Dojo 2.0 — Autonomous Architecture

### Autonomy Pipeline

```mermaid
flowchart TD
    A["User describes project"] --> B["Phase 1: Auto-Interview\n(smart defaults for gaps)"]
    B --> C["Phase 2: Architecture Analysis"]
    C --> D["Phase 3-4: Agent Swarm\n(parallel generation)"]
    D --> E["Phase 5: Validation"]
    E --> F["Phase 6: Project Skeleton\n(actual runnable code)"]
    F --> G["Phase 7: Ratchet Loop\n(autonomous improvement)"]
    G --> H["Phase 8: Comprehension Test"]
    H --> I{"Score > 95?"}
    I -->|No| G
    I -->|Yes| J["Memory & Handoff"]
    J --> K["🚀 Ready to Build"]

    style A fill:#1a1a2e,color:#e94560
    style K fill:#0f3460,color:#e94560
    style G fill:#16213e,color:#e94560
```

### The Ratchet Loop Detail

```mermaid
flowchart LR
    S["Score\n(0-100)"] --> A["Analyze\nweakest area"]
    A --> F["Fix\n(regenerate file)"]
    F --> C["Git Commit"]
    C --> R["Re-Score"]
    R --> D{"Improved?"}
    D -->|Yes ✅| K["Keep\n(ratchet forward)"]
    D -->|No ❌| X["Discard\n(git reset)"]
    K --> S
    X --> A

    style K fill:#0f3460,color:#fff
    style X fill:#e94560,color:#fff
```

### Agent Swarm Topology

```mermaid
flowchart TD
    Arch["🏛️ ARCHITECT\n(Orchestrator)"]

    Arch --> R["🔍 Research"]
    Arch --> DG["📝 Doc Generator"]
    Arch --> SB["🛠️ Skill Builder"]
    Arch --> IA["🔌 Integration"]

    R --> M["📦 Merge Point"]
    DG --> M
    SB --> M
    IA --> M

    M --> V["✅ Validator"]
    V --> T["🧪 Comprehension Test"]
    T --> RL["🔄 Ratchet Loop"]
    RL --> Final["🎉 Final Output"]

    style Arch fill:#e94560,color:#fff
    style Final fill:#0f3460,color:#fff
```

### Memory Architecture

```mermaid
flowchart LR
    B1["Bootstrap 1"] --> ML["Memory Layer\n(decision-log.jsonl)"]
    B2["Bootstrap 2"] --> ML
    B3["Bootstrap 3"] --> ML
    ML --> PP["Preference Profile\n(accumulated defaults)"]
    ML --> SP["Stack Performance\n(quality by tech combo)"]
    ML --> TP["Template Patches\n(user improvements)"]
    PP --> NB["Next Bootstrap\n(smarter defaults)"]
    SP --> NB
    TP --> NB

    style ML fill:#16213e,color:#e94560
    style NB fill:#0f3460,color:#fff
```

---

## Team Mode & Contract-First Architecture

Team Mode extends Game Dojo from single-developer autonomy to multi-developer human+AI squads. In Team Mode, multiple engineers operate separate local Antigravity IDE instances, coordinating asynchronously over Git via locked interface contracts and explicit task manifests.

### Coordination Topology

```mermaid
flowchart TD
    subgraph RemoteRepo["Central Git Repository (Origin / GitHub)"]
        MainBranch["main branch\n(Protected trunk)"]
        Contracts["docs/contracts/\n- api-spec.json (OpenAPI)\n- data-model.prisma (Schemas)"]
        TeamDir[".ai-team/\n- team.json (Roster & Roles)\n- tasks/*.json (Task Manifests)"]
        Codeowners[".github/CODEOWNERS\n(Domain Mapping)"]
    end

    subgraph DevA["Developer A Workstation (Frontend Stream)"]
        IDE_A["Antigravity IDE\n(Local AI Agent)"]
        Branch_A["git branch:\nfeature/task-101-dashboard"]
        Scope_A["Task Scope (touchesFiles):\nsrc/components/dashboard/*\nsrc/styles/dashboard.css"]
    end

    subgraph DevB["Developer B Workstation (Backend Stream)"]
        IDE_B["Antigravity IDE\n(Local AI Agent)"]
        Branch_B["git branch:\nfeature/task-201-metrics"]
        Scope_B["Task Scope (touchesFiles):\nsrc/api/metrics/*\ntests/api/metrics.test.ts"]
    end

    MainBranch -->|git clone / pull trunk| IDE_A
    MainBranch -->|git clone / pull trunk| IDE_B
    TeamDir -->|Read task bounds & roster| IDE_A
    TeamDir -->|Read task bounds & roster| IDE_B

    IDE_A -->|Reads branch & task ID| Scope_A
    Scope_A -->|Confines file edits| Branch_A
    Branch_A -->|Pull Request + CI Verification| MainBranch

    IDE_B -->|Reads branch & task ID| Scope_B
    Scope_B -->|Confines file edits| Branch_B
    Branch_B -->|Pull Request + CI Verification| MainBranch

    Contracts -.->|Validates API interfaces| IDE_A
    Contracts -.->|Validates API interfaces| IDE_B

    style RemoteRepo fill:#161B22,stroke:#30363D,color:#E6EDF3
    style DevA fill:#1A1F25,stroke:#58A6FF,color:#E6EDF3
    style DevB fill:#1A1F25,stroke:#3FB950,color:#E6EDF3
    style Contracts fill:#0D1117,stroke:#D29922,color:#E6EDF3
    style TeamDir fill:#0D1117,stroke:#E05252,color:#E6EDF3
    style MainBranch fill:#0D1117,stroke:#30363D,color:#E6EDF3
```

### Core Architectural Principles

1. **Decentralized Workstations**:
   - Every human developer runs an independent Antigravity IDE instance on their workstation.
   - The local AI agent assumes the persona and boundaries corresponding to the developer's assigned role and active git branch.
2. **Contract-First Decoupling**:
   - Shared data models (`docs/contracts/data-model.*`) and API contracts (`docs/contracts/api-spec.*`) are established and frozen before parallel feature coding begins.
   - Frontends mock against the contract; backends validate against the contract. This prevents inter-stream blocking and cross-team interface drift.
3. **Declarative Task Boundaries (`touchesFiles` / `allowedPaths`)**:
   - Each task defined in `.ai-team/tasks/<task-id>.json` contains a strict list of `touchesFiles` (and optional `allowedPaths`).
   - The local AI agent inspects this list upon activation and refuses to modify files outside the declared boundaries without explicit human override.
4. **Git as Synchronization Bus**:
   - Coordination requires no centralized proprietary broker or persistent socket. The team synchronizes through standard Git branches (`feature/<task-id>-<slug>` or `feat/<task-id>-<slug>`), PR status checks, and task status files.
5. **Ownership & Governance (`CODEOWNERS`)**:
   - GitHub-native `.github/CODEOWNERS` (or root `CODEOWNERS`) enforces that code reviews are automatically routed to the designated domain owner before merging to `main`.

### Data Schemas

#### 1. Team Roster (`.ai-team/team.json`)
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "teamId": "team-recipehub-core",
  "teamName": "RecipeHub Core Team",
  "version": "1.0.0",
  "lead": "vinod",
  "members": [
    {
      "id": "vinod",
      "name": "Vinod Krishna",
      "email": "vinod@example.com",
      "gitUser": "@vinod-dev",
      "role": "frontend-lead",
      "type": "human",
      "availability": "active",
      "maxConcurrentTasks": 2,
      "assignedTaskIds": [
        "task-101"
      ],
      "activeTasks": [
        "task-101"
      ],
      "assignedDomains": [
        "src/components",
        "src/pages",
        "src/styles"
      ],
      "capabilities": [
        "react",
        "typescript",
        "tailwind",
        "ui-testing"
      ]
    },
    {
      "id": "alex",
      "name": "Alex Chen",
      "email": "alex@example.com",
      "gitUser": "@alex-backend",
      "role": "backend-lead",
      "type": "human",
      "availability": "active",
      "maxConcurrentTasks": 2,
      "assignedTaskIds": [
        "task-201"
      ],
      "activeTasks": [
        "task-201"
      ],
      "assignedDomains": [
        "src/api",
        "src/services",
        "prisma"
      ],
      "capabilities": [
        "nodejs",
        "express",
        "prisma",
        "postgresql",
        "rest-api"
      ]
    }
  ],
  "policies": {
    "requireContractConformance": true,
    "enforceTouchesFiles": true,
    "requireReviewForContractChanges": true
  }
}
```

#### 2. Task Manifest (`.ai-team/tasks/<task-id>.json`)
```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "id": "task-101",
  "title": "Build Dashboard Recipe Feed Component",
  "slug": "dashboard-feed",
  "milestoneId": "m2-ui-features",
  "description": "Render paginated recipe cards with like counter and filtering by tag",
  "assignedTo": "vinod",
  "assignee": "vinod",
  "ownerGit": "@vinod-dev",
  "status": "in_progress",
  "stream": "frontend",
  "priority": "high",
  "branch": "feature/task-101-dashboard-feed",
  "dependencies": [],
  "blockedBy": [],
  "touchesFiles": [
    "src/components/dashboard/RecipeFeed.tsx",
    "src/components/dashboard/RecipeCard.tsx",
    "src/styles/dashboard.module.css",
    "tests/components/RecipeFeed.test.tsx"
  ],
  "allowedPaths": [
    "src/components/dashboard/**",
    "src/styles/dashboard.module.css",
    "tests/components/RecipeFeed.test.tsx"
  ],
  "contractDependencies": [
    "docs/contracts/api-spec.json#/paths/~1recipes~1feed"
  ],
  "acceptanceCriteria": [
    "RecipeFeed renders paginated list of cards consuming API contract",
    "Tag filter chips dynamically update displayed recipe cards",
    "All unit and component tests pass with 100% assertions satisfied"
  ],
  "verificationCommand": "npm test -- tests/components/RecipeFeed.test.tsx",
  "verification": {
    "testCommand": "npm test -- tests/components/RecipeFeed.test.tsx",
    "lintCommand": "npm run lint -- src/components/dashboard"
  }
}
```

### Boundary & Safety Invariants

| Invariant | Rule | Enforcement Mechanism |
|---|---|---|
| **Containment** | Agent edits must stay inside task `touchesFiles` / `allowedPaths` | Local Antigravity prompt & PreToolUse boundary check |
| **Contract Immutability** | Shared contracts cannot change without multi-owner PR | Git branch protection and CODEOWNERS |
| **Acyclicity** | Task dependency graph must remain a DAG (no deadlocks) | Game Dojo Phase 5 Validator / Self-Healing (`.agents/scripts/validate-dag.ps1`) |
| **Clean Handoff** | Tasks move to `done` / `completed` only upon successful PR merge | CI automated task status update action |

