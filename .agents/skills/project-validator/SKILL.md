---
name: project-validator
description: "Validates a bootstrapped project's configuration files for completeness and correctness. Use this skill after document generation to verify that all files are properly formatted, all JSON is valid, all YAML frontmatter is correct, all cross-references resolve, and the project is ready for development."
---

# Project Validator Skill

Validate that a bootstrapped project is complete, correct, and ready for development. Run this skill after document generation to catch errors before the developer starts working.

## Validation Checklist

Run every check in order. Report results using ✅ (pass) or ❌ (fail with details).

### Check 1: GEMINI.md Exists and Contains Project-Specific Rules

**What to verify:**
- File exists at project root (`GEMINI.md` or `.gemini/GEMINI.md`).
- Contains at least 3 sections with `##` headings.
- Mentions the project's specific language (e.g., "TypeScript", "Python") — not just generic "use best practices."
- Mentions the project's specific framework (e.g., "Express", "React", "FastAPI").
- Contains at least one concrete coding convention (naming, file structure, error handling pattern).
- References the design system file if the project has a UI.

**How to check:**
1. Read the file contents.
2. Search for technology-specific keywords from the project spec.
3. Count `##` headings — must be ≥ 3.
4. Scan for generic filler phrases: "use best practices", "follow conventions", "write clean code" without specifics. Flag if these appear without accompanying concrete rules.

**Auto-fix:** Cannot auto-fix — this requires project-specific knowledge. Report what's missing and prompt for regeneration using the doc-generator skill.

### Check 2: AGENTS.md Exists and Has Behavioral Guidelines

**What to verify:**
- File exists at project root or in `.gemini/`.
- Contains a "Guidelines" or "Behavior" section.
- Specifies at least 3 concrete behavioral rules.
- References other project documentation files.

**How to check:**
1. Read the file.
2. Search for headings containing "guideline", "behavior", "rule", or "convention" (case-insensitive).
3. Count bullet points or numbered items under those headings.

**Auto-fix:** If the file exists but is thin, flag for regeneration. If missing entirely, flag as critical.

### Check 3: All SKILL.md Files Have Valid YAML Frontmatter

**What to verify:**
- Every `SKILL.md` file under `.agents/skills/` has YAML frontmatter.
- Frontmatter is enclosed between `---` delimiters.
- Frontmatter contains both `name` (string) and `description` (string) fields.
- `name` matches the parent directory name.
- `description` is at least 20 characters and describes when to use the skill.

**How to check:**
1. List all directories under `.agents/skills/`.
2. For each, check for `SKILL.md`.
3. Parse the YAML frontmatter between the first two `---` lines.
4. Validate `name` and `description` fields.

**Auto-fix:**
- If frontmatter is missing but the file has content, prepend frontmatter derived from the directory name and first paragraph.
- If `name` doesn't match directory, fix it to match.

### Check 4: hooks.json Is Valid JSON with Correct Schema

**What to verify:**
- File exists at `.gemini/hooks.json` or project root.
- Parses as valid JSON.
- Top-level structure has an array or object of hook definitions.
- Each hook has required fields: `type`, `command` or `action`, and a trigger condition.
- No duplicate hook names or conflicting triggers.

**How to check:**
1. Read the file.
2. Parse with JSON parser — catch and report any syntax errors with line numbers.
3. Validate each hook object against the expected schema.

**Auto-fix:**
- Fix common JSON errors: trailing commas, missing quotes on keys.
- Pretty-print the JSON with consistent 2-space indentation.

### Check 5: mcp_config.json Is Valid JSON with Proper Server Configurations

**What to verify:**
- File exists at `.gemini/mcp_config.json` or project root.
- Parses as valid JSON.
- Has a `mcpServers` top-level key (object).
- Each server entry has `command` (string) and `args` (array of strings).
- `command` values are valid executables (`npx`, `node`, `python`, `docker`).
- No placeholder values remain (e.g., `your-project-id`, `YOUR_API_KEY`).

**How to check:**
1. Read and parse the JSON.
2. Iterate over `mcpServers` entries.
3. Validate each field's type and content.
4. Scan string values for common placeholder patterns.

**Auto-fix:**
- Fix JSON syntax errors.
- Wrap bare placeholder values in environment variable references: `${ENV_VAR_NAME}`.

### Check 6: README.md Has All Required Sections

**What to verify:**
- File exists at project root.
- Has a top-level `#` heading matching or referencing the project name.
- Contains these sections (by heading text, case-insensitive):
  - Overview or Description or About
  - Prerequisites or Requirements
  - Getting Started or Setup or Installation
  - Usage or Development
  - Project Structure or Directory Structure
  - Contributing or Development Guide

**How to check:**
1. Read the file.
2. Extract all `##` headings.
3. Match against the required section list using fuzzy matching (e.g., "Getting Started" matches "Quick Start").
4. Report missing sections by name.

**Auto-fix:** Cannot fully auto-fix. Report which sections are missing and suggest using the doc-generator skill to add them.

### Check 7: Architecture Docs Contain Valid Mermaid Diagrams

**What to verify:**
- `ARCHITECTURE.md` (or equivalent) exists.
- Contains at least one fenced Mermaid code block (` ```mermaid `).
- Each Mermaid block uses a supported diagram type: `graph`, `flowchart`, `sequenceDiagram`, `stateDiagram`, `classDiagram`, `erDiagram`, `xychart-beta`.
- No syntax errors in Mermaid content:
  - All node IDs are defined before being referenced in edges.
  - No unmatched brackets or parentheses in labels.
  - No HTML tags in labels.

**How to check:**
1. Read the file.
2. Extract all content between ` ```mermaid ` and ` ``` ` fences.
3. Parse the first line for diagram type.
4. Validate node definitions and edge references.

**Auto-fix:**
- Quote unquoted labels containing special characters.
- Remove HTML tags from labels, replacing with `<br/>` where appropriate.
- Add missing diagram type declarations.

### Check 8: No Files Contain TODO, FIXME, or Placeholder Text

**What to verify:**
- No generated documentation or configuration file contains: `TODO`, `FIXME`, `HACK`, `XXX`, `PLACEHOLDER`, `CHANGEME`.
- No `{{PLACEHOLDER}}` template variables remain unsubstituted.
- No `lorem ipsum` or dummy text.

**How to check:**
1. Scan all `.md`, `.json`, and `.yaml`/`.yml` files in the project root and `.gemini/`/`.agents/` directories.
2. Search for the forbidden patterns (case-insensitive).
3. Report each occurrence with file name and line number.

**Auto-fix:**
- Remove lines that are purely placeholder comments.
- For template variables, flag for regeneration — do not guess values.

### Check 9: All Internal File References and Links Are Valid

**What to verify:**
- Every Markdown link `[text](./path/to/file)` or `[text](path/to/file)` points to a file that exists.
- Every Markdown link to a heading `[text](#heading)` points to a heading that exists in the same file.
- Cross-file heading references `[text](./file.md#heading)` resolve correctly.

**How to check:**
1. Scan all `.md` files for link patterns: `[...](...)`.
2. Separate internal links (no `http://` or `https://` prefix) from external links.
3. For file links, verify the target file exists relative to the linking file's directory.
4. For heading links, read the target file and verify the heading exists (convert heading to anchor: lowercase, replace spaces with hyphens, remove special characters).

**Auto-fix:**
- Fix common path errors (wrong relative path depth).
- Remove broken links and replace with the link text as plain text, flagging for manual review.

### Check 10: Design System Is Referenced in GEMINI.md

**What to verify:**
- If a `DESIGN_SYSTEM.md` file exists anywhere in the project, `GEMINI.md` must reference it.
- The reference should be a file link or an explicit mention of the design system file name.

**How to check:**
1. Check if `DESIGN_SYSTEM.md` exists (search root, `.gemini/`, `docs/`).
2. If it exists, read `GEMINI.md` and search for `DESIGN_SYSTEM.md` or `design system`.
3. If the project has no UI component (pure API, CLI without TUI), this check can be skipped — mark as N/A.

**Auto-fix:** Add a reference line to `GEMINI.md` under the appropriate section: `- Follow the design system defined in [DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md)`.

## Running the Full Validation

Execute all 10 checks and compile a summary report.

### Report Format

```markdown
# Project Validation Report

**Project:** {{PROJECT_NAME}}
**Date:** {{DATE}}
**Result:** {{PASS_COUNT}}/10 checks passed

## Results

| # | Check | Result | Details |
|---|---|---|---|
| 1 | GEMINI.md has project-specific rules | ✅ Pass | Contains TypeScript, Express, and 5 coding conventions |
| 2 | AGENTS.md has behavioral guidelines | ✅ Pass | 7 behavioral rules defined |
| 3 | SKILL.md frontmatter valid | ✅ Pass | 4/4 skills have valid frontmatter |
| 4 | hooks.json valid | ❌ Fail | Trailing comma on line 23 |
| 5 | mcp_config.json valid | ✅ Pass | 2 servers configured correctly |
| 6 | README.md has required sections | ❌ Fail | Missing: Contributing, Project Structure |
| 7 | Architecture has valid Mermaid | ✅ Pass | 1 diagram, valid flowchart |
| 8 | No TODOs or placeholders | ✅ Pass | 0 occurrences found |
| 9 | Internal links valid | ✅ Pass | 12/12 links resolve |
| 10 | Design system referenced | N/A | No UI components in project |

## Issues to Fix

### ❌ Check 4: hooks.json — Trailing Comma
**File:** `.gemini/hooks.json` **Line:** 23
**Issue:** Trailing comma after last array element.
**Auto-fix available:** Yes

### ❌ Check 6: README.md — Missing Sections
**File:** `README.md`
**Issue:** Missing required sections: "Contributing", "Project Structure"
**Auto-fix available:** No — use doc-generator skill to add these sections.
```

### Pass/Fail Thresholds

- **All 10 pass (or N/A):** Project is ready for development.
- **8-9 pass:** Project is usable but has minor issues. List fixes needed.
- **Below 8:** Project needs significant rework. Prioritize fixes by check number.

## The AI Readability Test

After all technical checks pass, perform a final qualitative assessment:

> **Can an AI agent fully understand this project from its documentation alone?**

Evaluate by asking these questions about the generated docs:

1. **Can the agent determine what this project does?** — Check README.md overview.
2. **Can the agent set up the project from scratch?** — Check README.md prerequisites and setup steps.
3. **Can the agent write code that follows project conventions?** — Check GEMINI.md for specific patterns.
4. **Can the agent understand the system architecture?** — Check ARCHITECTURE.md diagrams and descriptions.
5. **Can the agent run tests and verify their work?** — Check for testing instructions.
6. **Can the agent deploy the project?** — Check for deployment instructions.

If any answer is "no" or "partially," report it as a documentation gap with a specific recommendation for what to add.

## Auto-Fix Summary

After running all checks, if auto-fixes are available:

1. List all auto-fixable issues.
2. Apply fixes.
3. Re-run the affected checks to confirm they now pass.
4. Report the before/after status.

Never auto-fix issues that require project-specific knowledge (content generation). Only auto-fix structural and syntactic issues (JSON formatting, frontmatter structure, link paths, label quoting).
