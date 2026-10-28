---
name: adaptive-memory
description: "Maintains a persistent memory of past project bootstraps — what worked, what didn't, user preferences, and quality patterns. Learns from every bootstrap to make smarter defaults, skip unnecessary questions, and evolve templates over time. Use this skill to access historical project data and improve future bootstraps."
---

# Adaptive Memory System

This skill maintains a persistent, cross-project memory that improves Game Dojo's bootstrapping quality over time. Every bootstrap session is recorded, analyzed, and used to make future bootstraps faster, smarter, and more aligned with user preferences.

The memory system operates on a simple principle: **observe what works, remember it, and apply it next time.**

---

## When to Use

Activate this skill:
- **Before every bootstrap** — Read memory to load smart defaults and skip redundant questions
- **After every bootstrap** — Write memory to record decisions, quality scores, and user edits
- **During template evolution** — When detecting that users consistently modify generated files
- **When recommending tech stacks** — Use historical quality scores to guide recommendations

---

## Memory Storage

All memory files are stored at:
```
C:\Users\Vinod krishna\antigravity_skills\.game-dojo-memory\
```

The agent must create this directory if it does not exist.

### Files Maintained

| File | Format | Purpose |
|---|---|---|
| `decision-log.jsonl` | JSON Lines | One entry per bootstrap session — full record of decisions made |
| `template-patches.jsonl` | JSON Lines | User-initiated improvements to generated templates |
| `preference-profile.json` | JSON | Accumulated user preferences across all sessions |
| `stack-performance.json` | JSON | Quality scores indexed by tech stack combination |

---

## Reading Memory (Pre-Bootstrap)

Before starting any new bootstrap, execute this sequence:

### Step 1: Check for Existing Memory

```
if (file exists: C:\Users\Vinod krishna\antigravity_skills\.game-dojo-memory\preference-profile.json)
  → Load preferences and use as smart defaults
else
  → This is a first-time bootstrap; use built-in defaults
```

### Step 2: Load Preference Profile

Read `preference-profile.json` and extract the user's accumulated preferences:

```json
{
  "preferredLanguage": "TypeScript",
  "preferredFramework": "Next.js",
  "preferredDatabase": "PostgreSQL",
  "preferredORM": "Prisma",
  "preferredStyling": "Tailwind CSS",
  "preferredTestFramework": "Jest + Playwright",
  "preferredPackageManager": "npm",
  "teamSize": "solo",
  "deploymentTarget": "Vercel",
  "preferredAuthSolution": "NextAuth.js",
  "preferredStateManagement": "Zustand",
  "questionsAlwaysSkipped": ["domain-name", "monitoring-tool"],
  "customRules": [
    "always use strict TypeScript",
    "prefer Prisma over raw SQL",
    "include Docker setup by default"
  ],
  "lastUpdated": "2026-10-28T12:00:00Z"
}
```

**Usage during interview:**
- Pre-fill every question's default with the user's preferred choice
- If a question topic appears in `questionsAlwaysSkipped`, do not ask it — use the last known answer
- Present defaults with a note: *"Based on your previous projects, I'm defaulting to X. Change it if you'd like!"*

### Step 3: Load Stack Performance Data

Read `stack-performance.json` to identify the highest-performing configurations:

```json
{
  "stacks": [
    {
      "key": "nextjs-postgresql-prisma-tailwind",
      "components": {
        "frontend": "Next.js 14",
        "database": "PostgreSQL",
        "orm": "Prisma",
        "styling": "Tailwind CSS"
      },
      "bootstrapCount": 5,
      "averageQualityScore": 92,
      "averageComprehensionScore": 89,
      "averageRatchetIterations": 6,
      "commonSkillsImported": [
        "zod-validation-expert",
        "prisma-schema",
        "docker-compose"
      ],
      "commonIssues": [
        "Prisma schema needs manual relation tuning for complex models"
      ]
    },
    {
      "key": "nextjs-mongodb-mongoose-tailwind",
      "components": {
        "frontend": "Next.js 14",
        "database": "MongoDB",
        "orm": "Mongoose",
        "styling": "Tailwind CSS"
      },
      "bootstrapCount": 2,
      "averageQualityScore": 85,
      "averageComprehensionScore": 88,
      "averageRatchetIterations": 9,
      "commonSkillsImported": [
        "zod-validation-expert",
        "docker-compose"
      ],
      "commonIssues": [
        "Mongoose schema types need more explicit validation",
        "MongoDB connection handling in serverless needs special config"
      ]
    }
  ]
}
```

**Usage during analysis:**
- When the user's chosen stack matches or is close to a recorded stack, load the associated configuration as the starting point
- If a stack has known `commonIssues`, proactively address them during generation
- If a stack consistently scores lower, mention this to the user and suggest alternatives: *"In my experience, this PostgreSQL + Prisma combo tends to produce cleaner results than MongoDB + Mongoose for this type of project."*

### Step 4: Pre-Load Proven Skills

Check which skills were imported in previous projects with similar tech stacks:

```
For the user's chosen stack:
  1. Find the closest matching stack in stack-performance.json
  2. Read its commonSkillsImported array
  3. For each skill, check if it exists in the local skills library
  4. Auto-import skills that were used in 3+ projects with the same stack
  5. Suggest (but don't auto-import) skills used in 1-2 projects
```

---

## Writing Memory (Post-Bootstrap)

After every bootstrap completes successfully, execute this sequence:

### Step 1: Append to Decision Log

Create a new entry in `decision-log.jsonl` (append, one JSON object per line):

```json
{
  "timestamp": "2026-10-28T12:00:00Z",
  "projectName": "recipe-app",
  "projectType": "web-app",
  "projectPath": "d:\\projects\\recipe-app",
  "techStack": {
    "frontend": "Next.js 14",
    "backend": "Next.js API Routes",
    "database": "PostgreSQL",
    "orm": "Prisma",
    "styling": "Tailwind CSS",
    "auth": "NextAuth.js",
    "deployment": "Vercel",
    "packageManager": "npm",
    "testFramework": "Jest + Playwright"
  },
  "interviewData": {
    "questionsAsked": 12,
    "questionsSkipped": 4,
    "questionTopicsSkipped": ["domain-name", "monitoring-tool", "team-branching", "ci-provider"],
    "defaultsAccepted": ["team-size:solo", "git-strategy:github-flow", "styling:tailwind"],
    "defaultsOverridden": ["database:sqlite→postgresql"]
  },
  "generationData": {
    "filesGenerated": 24,
    "skillsGenerated": 6,
    "skillsImportedFromLibrary": 3,
    "skillsImported": ["zod-validation-expert", "docker-compose", "prisma-schema"],
    "documentsGenerated": ["GEMINI.md", "AGENTS.md", "DESIGN_SYSTEM.md", "ARCHITECTURE.md", "REQUIREMENTS.md", "IMPLEMENTATION_PLAN.md", "API_SPEC.md", "DATA_MODEL.md"]
  },
  "qualityData": {
    "initialScore": 72,
    "finalScore": 94,
    "ratchetIterations": 8,
    "comprehensionScore": 91,
    "selfHealingFixes": 4,
    "issuesFoundByValidator": 12,
    "issuesAutoFixed": 10,
    "issuesManuallyFixed": 2
  },
  "userEdits": [
    {
      "file": "GEMINI.md",
      "description": "Added custom error handling pattern",
      "linesChanged": 15
    },
    {
      "file": "skills/testing-strategy/SKILL.md",
      "description": "Added snapshot testing section",
      "linesChanged": 28
    }
  ],
  "duration": "18 minutes",
  "userSatisfactionSignal": "positive"
}
```

**Fields Explained:**

- `timestamp` — ISO 8601 timestamp when the bootstrap completed
- `projectName` — Name of the bootstrapped project
- `projectType` — Classification: web-app, api, mobile-app, cli-tool, library, monorepo
- `techStack` — Complete tech stack as chosen during the interview
- `interviewData` — Metrics about the interview phase
- `generationData` — What was generated
- `qualityData` — Quality scores and ratchet loop metrics
- `userEdits` — Files the user manually edited after generation (detected by comparing generated content to final content)
- `duration` — Total bootstrap time
- `userSatisfactionSignal` — Inferred from user behavior: "positive" (accepted without changes), "neutral" (minor edits), "negative" (major rework or complaints)

### Step 2: Update Preference Profile

After appending the decision log, update `preference-profile.json`:

```
For each tech stack choice in the new bootstrap:
  1. Compare to the current preference profile
  2. If the choice matches the existing preference: increment confidence (no change needed)
  3. If the choice differs from the existing preference:
     a. Check the last 5 decision log entries
     b. If the new choice appears in 3+ of the last 5: update the preference
     c. Otherwise: keep the existing preference (one-off override, not a trend)
  4. Update questionsAlwaysSkipped:
     a. If a question was skipped in 3+ consecutive sessions: add to the list
     b. If a previously-skipped question was asked in the last session: remove from the list
  5. Update customRules:
     a. If the user added the same GEMINI.md pattern in 2+ projects: add as a custom rule
  6. Set lastUpdated to current timestamp
```

**Preference Update Algorithm:**
```
function updatePreference(field, newValue, decisionLog):
  recentEntries = last 5 entries from decisionLog
  countOfNewValue = count(entry.techStack[field] == newValue for entry in recentEntries)

  if countOfNewValue >= 3:
    preferenceProfile[field] = newValue  // Trend confirmed
  // else: keep existing preference
```

### Step 3: Update Stack Performance

After updating preferences, update `stack-performance.json`:

```
1. Generate a stack key from the tech stack (sorted, kebab-case):
   e.g., "nextjs-postgresql-prisma-tailwind"

2. Find existing entry with matching key in stack-performance.json
   a. If found: update running averages
      - averageQualityScore = (old_avg * old_count + new_score) / (old_count + 1)
      - averageComprehensionScore = same formula
      - averageRatchetIterations = same formula
      - bootstrapCount += 1
      - Merge commonSkillsImported (union of old and new)
      - Merge commonIssues (union, deduplicated)
   b. If not found: create new entry with this session's data

3. Write updated stack-performance.json
```

### Step 4: Detect Template Patches

If the user manually edited any generated files, record the diff:

```
1. For each file in userEdits:
   a. Compare the originally generated content to the final file content
   b. Record the meaningful differences (ignore whitespace-only changes)
   c. Append to template-patches.jsonl:
```

```json
{
  "timestamp": "2026-10-28T12:00:00Z",
  "projectName": "recipe-app",
  "file": "GEMINI.md",
  "section": "Coding Standards",
  "changeType": "addition",
  "description": "Added custom error handling pattern requiring all API routes to use a standardized error response format",
  "patch": "+ ## Error Handling\n+ All API routes must use the `ApiError` class...",
  "techStack": "nextjs-postgresql-prisma-tailwind",
  "applied": false
}
```

**Template Evolution Logic:**

After recording patches, check if a pattern has emerged:
```
1. Group all patches by file + section
2. For each group:
   a. If 3+ patches modify the same section in the same way:
      → Flag for template update
      → Set applied: true on all matching patches
      → Log: "Template evolution detected: GEMINI.md 'Coding Standards' section
              has been manually updated in 3 projects with similar changes.
              Recommend updating the base template."
   b. If 2 patches: log as "emerging pattern" but don't act yet
   c. If 1 patch: just record it
```

---

## How Memory Improves Future Bootstraps

### 1. Smarter Defaults

**Mechanism:** Pre-fill interview defaults from `preference-profile.json`.

**Example:**
```
Without memory:
  "Primary language? (default: TypeScript)"

With memory (after 5 TypeScript projects):
  "Primary language? (default: TypeScript — you've used this in all 5 previous projects)"
```

### 2. Skip Redundant Questions

**Mechanism:** Questions in `questionsAlwaysSkipped` are auto-answered with their last known value.

**Example:**
```
Without memory:
  "What domain name will you use? (default: none)"
  → User: "skip"  (for the 6th time)

With memory:
  Question is silently skipped, logged as:
  "ℹ️ Skipped 'domain-name' question (always skipped in past sessions)"
```

### 3. Import Proven Skills

**Mechanism:** Skills that appear in `commonSkillsImported` for the matching stack are auto-imported.

**Example:**
```
Without memory:
  Agent searches the skill library, evaluates 50+ skills, imports 3.

With memory:
  Agent immediately imports the 3 skills that worked in the last 5 similar projects,
  then checks for any new skills that might also be relevant.
```

### 4. Template Evolution

**Mechanism:** When `template-patches.jsonl` shows a repeated pattern, the agent proposes updating the base template.

**Example:**
```
"🧬 Template Evolution Detected:
 In your last 3 Next.js projects, you added the same error handling pattern
 to GEMINI.md. Would you like me to make this part of the default template
 so future projects include it automatically?"
```

### 5. Stack-Specific Tuning

**Mechanism:** Use `stack-performance.json` to recommend configurations that historically produce higher quality scores.

**Example:**
```
"📊 Based on your bootstrap history:
 - PostgreSQL + Prisma projects average a 92 quality score
 - MongoDB + Mongoose projects average an 85 quality score
 Both are great choices, but Prisma tends to produce cleaner generated code
 for this type of project."
```

---

## Memory Hygiene

### Data Retention
- Keep all decision log entries indefinitely (they're small, ~2KB each)
- Template patches older than 12 months with `applied: false` can be archived
- Stack performance data is always kept (it's aggregated, not per-session)

### Privacy
- Memory files are stored locally on the user's machine
- No data is transmitted externally
- The user can delete the entire `.game-dojo-memory/` directory to reset all memory
- Individual entries can be removed from JSONL files by deleting the corresponding line

### Conflict Resolution
- If `preference-profile.json` becomes corrupted, regenerate it from `decision-log.jsonl` by replaying all entries
- If `stack-performance.json` becomes corrupted, regenerate it from `decision-log.jsonl` by re-aggregating
- The decision log is the source of truth; all other files are derived from it

### Initialization

When starting the very first bootstrap (no memory exists):

1. Create the `.game-dojo-memory/` directory
2. Create an empty `decision-log.jsonl` file
3. Create an empty `template-patches.jsonl` file
4. Create `preference-profile.json` with all fields set to `null` (indicating no preference yet)
5. Create `stack-performance.json` with an empty `stacks` array

```json
// Initial preference-profile.json
{
  "preferredLanguage": null,
  "preferredFramework": null,
  "preferredDatabase": null,
  "preferredORM": null,
  "preferredStyling": null,
  "preferredTestFramework": null,
  "preferredPackageManager": null,
  "teamSize": null,
  "deploymentTarget": null,
  "preferredAuthSolution": null,
  "preferredStateManagement": null,
  "questionsAlwaysSkipped": [],
  "customRules": [],
  "lastUpdated": null
}
```

```json
// Initial stack-performance.json
{
  "stacks": []
}
```

---

## Integration with Other Skills

| Skill | Integration Point |
|---|---|
| **game-dojo-bootstrap** | Reads memory before interview, writes memory after completion |
| **doc-generator** | Uses preference data to pre-fill document templates |
| **project-skeleton** | Uses stack performance data to choose optimal configurations |
| **ecosystem-scanner** | Uses `commonSkillsImported` to prioritize search results |
| **skill-crafter** | Uses template patches to evolve skill templates |
| **self-healing** | Quality data from memory helps predict which fixes will be needed |
| **project-validator** | Historical quality scores set the bar for validation thresholds |
