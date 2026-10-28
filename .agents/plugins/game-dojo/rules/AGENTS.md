# Game Dojo Plugin Rules

These rules activate when the Game Dojo plugin is enabled and govern all project scaffolding behavior.

---

## Skill Priority

- **Always prioritize the `game-dojo-bootstrap` skill** for any project scaffolding, initialization, or workspace setup request. Read its `SKILL.md` before executing any scaffolding workflow.
- If the user's request is ambiguous, assume they want a full project bootstrap unless they explicitly ask for a single file or partial setup.

## Workflow Enforcement

Follow the **5-phase workflow** strictly and in order. Do not skip or reorder phases:

1. **Discovery** — Conduct the structured interview to gather project requirements. Do not proceed until the user has confirmed their answers.
2. **Analysis** — Analyze the gathered requirements to determine tech stack, architecture patterns, and project structure. Use sequential-thinking for complex trade-offs.
3. **Generation** — Produce all project files using the template engine. Follow the dependency order specified below.
4. **Validation** — Verify all generated files for completeness, consistency, and correctness. Check cross-references, required sections, and structural integrity.
5. **Presentation** — Present the bootstrapped workspace to the user with a summary of what was created and suggested next steps.

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
