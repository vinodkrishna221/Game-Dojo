# Game Dojo — Project Rules

> **Game Dojo** is an AI-powered project bootstrapping system for **Antigravity IDE**.
> It transforms a plain-language project description into a fully configured, ready-to-develop workspace — complete with skills, plugins, hooks, MCP integrations, design systems, and documentation.

---

## Core Workflow

Game Dojo follows a five-phase pipeline when bootstrapping a new project:

1. **Accept** — Receive the user's project description (natural language).
2. **Interview** — Ask targeted clarifying questions to fill knowledge gaps (batched, with smart defaults).
3. **Analyze** — Determine tech stack, architecture, integrations, and file structure.
4. **Generate** — Produce all project files: `GEMINI.md`, skills, plugins, hooks, MCP configs, docs, and templates.
5. **Validate** — Verify every generated file is syntactically correct, complete, and immediately usable.

---

## Autonomy Levels

Game Dojo operates at different autonomy levels based on context:

| Level | Mode | Human Role | Agent Role |
|---|---|---|---|
| Level 3 | **Guided** (Default) | Answers questions, reviews output | Asks questions, generates files |
| Level 4 | **Supervisory** | Reviews and approves | Does everything, presents for approval |
| Level 5 | **Full Autonomy** (`/goal` mode) | Reviews results hours later | Interviews itself, generates, builds, tests, iterates overnight |

### The Ratchet Loop
After initial generation, Game Dojo enters an autonomous improvement cycle:
- Generate → Validate → Score → Fix → Re-validate → Keep or Discard
- All changes tracked via git commits for full audit trail
- Quality target: 95/100 composite score
- Safety: git reset --hard on any regression

### Agent Swarm Mode
For complex projects, Game Dojo deploys parallel specialist agents:
- Architect (orchestrator), Research, Doc Generator, Skill Builder, Integration, Validator, Tester
- Each agent works on an isolated branch
- Architect merges the best results

### Comprehension Test
The ultimate quality gate: spawn a fresh agent with ONLY the generated files. If it can't describe the project accurately, the files need improvement. Target: 90%+ comprehension score.

---

## Coding Standards

| Area | Convention |
|---|---|
| Languages | TypeScript / JavaScript for scripts and plugins |
| Documentation | Markdown (`.md`) with YAML frontmatter where required |
| Data formats | JSON for configs (`plugin.json`, `hooks.json`, `mcp_config.json`); YAML frontmatter in `SKILL.md` |
| Indentation | 2 spaces for JSON/YAML/JS/TS; 4 spaces for Python if applicable |
| Line endings | LF preferred; CRLF acceptable on Windows |

---

## Generated Output Rules

All generated files **must** adhere to the following:

- **No TODOs, no placeholders, no stubs.** Every file must be complete and immediately usable.
- **Valid syntax.** JSON files must parse without errors. YAML frontmatter must be well-formed. Markdown must render correctly.
- **Proper frontmatter.** `SKILL.md` files must include `name` and `description` fields in YAML frontmatter.
- **Consistent structure.** Follow Antigravity conventions exactly for `plugin.json`, `hooks.json`, and `mcp_config.json` formats.
- **Rich documentation.** Every generated doc must include section headers, explanatory text, and examples where appropriate.

---

## File Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Skill folders | `lowercase-kebab-case` | `game-dojo-bootstrap` |
| Skill entry files | `SKILL.md` (uppercase) | `skills/game-dojo-bootstrap/SKILL.md` |
| JSON config keys | `camelCase` | `"projectName"`, `"skillDescription"` |
| JSON file names | `lowercase-kebab-case` or established names | `plugin.json`, `hooks.json` |
| Documentation files | `UPPER_CASE.md` for root docs, `lowercase-kebab-case.md` for nested | `GEMINI.md`, `DESIGN_SYSTEM.md` |
| Template files | `lowercase-kebab-case` with appropriate extension | `gemini-template.md` |

---

## Mandatory Behaviors

### Before Bootstrapping
- **Always** read the `game-dojo-bootstrap` skill (`skills/game-dojo-bootstrap/SKILL.md`) before starting any project bootstrapping operation. This skill contains the canonical generation logic, templates, and validation rules.

### During Generation
- **Always** check the `templates/` folder first for base templates before generating any file. Templates define the canonical structure and must be respected.
- **Check the Local Skills Library** at `C:\Users\Vinod krishna\antigravity_skills` (1,320+ skills) before writing new skills from scratch. When a pre-existing skill matches the tech stack or workflow, import or reference it.
- **Never** generate empty or stub files. If a file cannot be fully populated, defer its creation and inform the user what additional information is needed.
- Generate files in **dependency order**:
  1. `GEMINI.md` (project rules — everything depends on this)
  2. `AGENTS.md` (agent behavior rules)
  3. Skills (`SKILL.md` files)
  4. Plugin configs (`plugin.json`)
  5. Hook configs (`hooks.json`)
  6. MCP configs (`mcp_config.json`)
  7. Documentation and design system files

### After Generation
- Validate all JSON files for syntactic correctness.
- Present a summary checklist of everything created.
- Verify cross-references between files are consistent.

---

## Reference Paths

| Resource | Path | Purpose |
|---|---|---|
| Specifications | `/docs` | Detailed specs for all features and formats |
| Design System | `DESIGN_SYSTEM.md` | Visual identity, colors, typography, emoji guide |
| Templates | `/templates` | Base templates for generated files |
| Skills | `/skills` | Skill definitions and instructions |
| Local Skills Library | `C:\Users\Vinod krishna\antigravity_skills` | 1,320+ pre-built skills for direct import/reference |
| Memory Store | `C:\Users\Vinod krishna\antigravity_skills\.game-dojo-memory\` | Cross-project learning and preferences |
| Ratchet Log | `ratchet-log.tsv` (in generated project root) | Improvement loop audit trail |

---

## Quality Checklist

Before considering any generation task complete, verify:

- [ ] Every generated file has real, meaningful content
- [ ] All JSON parses without errors
- [ ] All YAML frontmatter is valid
- [ ] All Markdown renders correctly
- [ ] Cross-file references (paths, names) are consistent
- [ ] File naming conventions are followed
- [ ] The `game-dojo-bootstrap` skill was consulted
- [ ] Templates were checked and used where available
- [ ] Comprehension test score is above 90%
- [ ] Ratchet loop ran at least 3 iterations
- [ ] Setup scripts (`scripts/setup.ps1`) are generated and functional
- [ ] Git repository is initialized with meaningful commit history
