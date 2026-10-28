# Game Dojo Plugin Rules

These rules activate when the Game Dojo plugin is enabled and govern all project scaffolding behavior.

---

## Skill Priority

- **Always prioritize the `game-dojo-bootstrap` skill** for any project scaffolding, initialization, or workspace setup request. Read its `SKILL.md` before executing any scaffolding workflow.
- If the user's request is ambiguous, assume they want a full project bootstrap unless they explicitly ask for a single file or partial setup.

## Workflow Enforcement

Follow the **8-phase Game Dojo 2.0 workflow** in order:

1. **Discovery / Intake** — Conduct structured interview with smart defaults.
2. **Analysis & Architecture** — Determine stack, architecture pattern, and file manifest.
3. **Swarm Generation** — Deploy specialist subagents in parallel on isolated branches.
4. **Integration** — Configure hooks, MCP tools, and plugin manifests.
5. **Validation** — Verify syntactic correctness, frontmatter, and link resolution.
6. **Project Skeleton** — Generate runnable code manifests, configs, setup scripts (`setup.ps1`/`setup.sh`), and starter features.
7. **Ratchet Loop** — Autonomously improve project files with git hill-climbing until score > 95.
8. **Memory & Handoff** — Persist session to adaptive memory and present handoff summary.

## File Generation Order

Generate files in the following dependency order to ensure references resolve correctly:

1. `docs/PROJECT_BRIEF.md` — Foundation document; everything else references this
2. `docs/REQUIREMENTS.md` — Derived from the project brief
3. `docs/ARCHITECTURE.md` — Depends on requirements
4. `docs/DESIGN_SYSTEM.md` — Depends on architecture decisions
5. `docs/IMPLEMENTATION_PLAN.md` — Depends on architecture and design system
6. `docs/API_SPEC.md` — Depends on architecture (if applicable)
7. `docs/DATA_MODEL.md` — Depends on requirements and architecture
8. `.agents/` configuration files — Depends on tech stack decisions
9. Project skeleton files (`package.json`, `README.md`, etc.) — Last, depends on everything above

## Template Usage

- **Always use templates from `references/`** as starting points for generated documents. Never generate files from scratch when a template exists.
- Templates contain required section headings, frontmatter fields, and structural patterns. Preserve all template structure and fill in content based on the user's requirements.
- If a template does not exist for a needed file type, note this as a gap and generate a reasonable structure following the patterns established by existing templates.

## Marketplace Integration

- **Always offer to search the marketplace** for relevant plugins, skills, or templates before finishing the scaffolding workflow.
- Suggest plugins that match the user's chosen tech stack (e.g., a React plugin for React projects, a Firebase plugin for Firebase backends).
- Present marketplace suggestions as optional enhancements, not requirements.
