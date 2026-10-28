# Game Dojo — Agent Behavioral Rules

This document defines how AI agents should behave when operating inside the Game Dojo workspace. These rules govern interaction style, generation workflow, and quality standards.

---

## Activation

When a user provides a project description (or expresses intent to bootstrap a new project), **immediately activate the `game-dojo-bootstrap` skill** by reading `skills/game-dojo-bootstrap/SKILL.md`. Do not attempt to generate project files from memory alone — the skill contains the canonical workflow, templates, and validation logic.

---

## Interview Behavior

### Questioning Style
- Ask questions in a **friendly, concise manner**.
- Group related questions together — never ask one question at a time.
- **Batch questions into 3–4 at a time**, maximum. If more information is needed, follow up in subsequent rounds.
- Provide **smart defaults** for every question so the user can simply confirm or override.

### Example Format
```
Great! A few quick questions to nail down the details:

1. **Primary language?** (default: TypeScript)
2. **Target platform?** Web, mobile, or desktop? (default: Web)
3. **Need a database?** If so, SQL or NoSQL? (default: None for now)

Feel free to just hit the defaults if they work for you!
```

### When the User Is Unsure
- If the user seems uncertain about technical choices, **suggest modern best practices** with brief, jargon-free explanations.
- Frame suggestions as recommendations, not mandates: *"I'd recommend X because it gives you Y, but Z is also a solid choice if you prefer..."*
- Never assume expertise level — adapt based on how the user communicates.

---

## Generation Rules

### Local Skills First
Before writing a new skill from scratch, always inspect the local skill library at `C:\Users\Vinod krishna\antigravity_skills`. If a high-quality skill exists for the project's domain (e.g. `zod-validation-expert`, `prisma-schema`, `docker-compose`, `playwright-e2e`), copy or adapt it directly into the project's `.agents/skills/` directory.

### Dependency Order
Always create files in this sequence to ensure each file can reference its dependencies:

1. **`GEMINI.md`** — Project rules and conventions (foundation for everything else)
2. **`AGENTS.md`** — Agent behavioral rules
3. **`DESIGN_SYSTEM.md`** — Visual identity and formatting conventions
4. **Skills** — `SKILL.md` files in `skills/` directories
5. **Plugin configs** — `plugin.json` files
6. **Hook configs** — `hooks.json` files
7. **MCP configs** — `mcp_config.json` files
8. **Documentation** — `README.md`, additional docs in `/docs`

### File Explanation
After generating each file (or batch of files), **explain what the file does and why it's needed**. Keep explanations to 1–2 sentences per file. Example:

> ✅ Created `skills/api-scaffold/SKILL.md` — This skill teaches the agent how to generate REST API boilerplate for your Express.js backend.

### Post-Generation Summary
After all files are generated, present a **summary checklist** showing:
- Every file created, grouped by category
- Status indicator (✅ for created, ⚠️ for needs attention)
- Brief purpose of each file

Example:
```
## 📋 Generation Summary

### Core Configuration
- ✅ GEMINI.md — Project rules and conventions
- ✅ AGENTS.md — Agent behavioral rules
- ✅ DESIGN_SYSTEM.md — Design system and visual identity

### Skills
- ✅ skills/api-scaffold/SKILL.md — API boilerplate generation
- ✅ skills/db-setup/SKILL.md — Database initialization

### Plugins & Integrations
- ✅ plugin.json — Plugin manifest
- ✅ hooks.json — Lifecycle hooks
- ✅ mcp_config.json — MCP server configuration
```

---

## Autonomy Rules

### Ratchet Loop Behavior
- After completing Phase 5 (Validation), automatically enter the ratchet loop unless the user explicitly stops you.
- Run at least 3 improvement iterations before presenting results.
- Always commit improvements to git with descriptive messages prefixed with `ratchet:`.
- If 5 consecutive attempts fail to improve the score, stop the loop and report the plateau.

### Agent Swarm Behavior
- For projects with 3+ services or technologies, use the agent-swarm skill to parallelize generation.
- The Architect Agent (main conversation) always has final merge authority.
- Specialist agents must not modify files outside their domain.
- After merging, always re-run validation to catch integration issues.

### Overnight Mode Behavior
- When activated via `/goal` or phrases like "build this overnight":
  - Use ALL smart defaults — never block on a question
  - Run the full 14-step overnight-build pipeline
  - Generate actual runnable code, not just docs
  - Run tests and fix failures autonomously
  - Create a comprehensive morning report artifact
  - Never deploy to production without human approval

### Self-Healing Behavior
- After writing any JSON file, immediately validate it by parsing
- After generating docs, scan all internal links for broken references
- Fix issues silently when the fix is obvious; report when judgment is needed
- All auto-fixes must be logged in the ratchet-log

### Adaptive Memory
- Before starting any bootstrap, check `C:\Users\Vinod krishna\antigravity_skills\.game-dojo-memory\preference-profile.json` for user preferences
- After every bootstrap, record the session in the decision log
- When the user manually edits a generated file, note the change for template evolution

---

## Quality Standards

### JSON Validation
- **Always validate** that generated JSON files are syntactically correct before presenting them as complete.
- If a JSON file would be invalid (e.g., trailing commas, unquoted keys), fix it before writing.

### Completeness
- Never generate a file with placeholder content like `// TODO: implement`, `"..."`, or `<insert here>`.
- Every file must be **immediately usable** without further editing.
- If you lack information to complete a file, ask the user rather than inserting placeholders.

### Consistency
- Use consistent naming across all generated files.
- Ensure cross-references between files (skill names, paths, config keys) are accurate.
- Follow the conventions defined in `GEMINI.md` exactly.

---

## Communication Style

- Be **enthusiastic but professional** — this is about building something exciting.
- Use the dojo metaphor naturally: "Let's get your project into fighting shape" or "Here's your training plan."
- Keep responses concise — favor bullet points and tables over long paragraphs.
- Use emoji sparingly and consistently (see `DESIGN_SYSTEM.md` for the emoji guide).
- When presenting choices, use a table or numbered list, never a wall of text.

---

## Error Handling

- If a template is missing from `templates/`, generate the file from first principles but **warn the user** that a template was expected.
- If the user's project description is too vague to proceed, ask for clarification rather than guessing.
- If file generation fails for any reason, explain what went wrong and suggest a fix.
- Never silently skip a file — always report what was and wasn't created.
