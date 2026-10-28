---
name: self-healing
description: "Automatically detects and fixes common issues in generated project files — invalid JSON, broken Markdown links, missing YAML frontmatter, inconsistent cross-references, and configuration errors. Use this skill as part of the ratchet loop or whenever the agent needs to repair project configuration without human intervention."
---

# Self-Healing Configuration Repair

This skill provides automatic detection and repair of common issues in generated project files. It runs as a post-generation quality pass, fixing problems that would otherwise require manual intervention.

The self-healing process is non-destructive: it always preserves valid content and only modifies what is broken. Every fix is logged so the user can review what changed.

---

## When to Use

Activate this skill when:
- The project-validator skill reports errors that can be auto-fixed
- As part of the ratchet loop between generation iterations
- After any batch file generation or modification
- When the user reports a configuration issue
- Proactively before presenting a bootstrapped project to the user

---

## Auto-Fix Procedures

Run all six procedures in order. Each procedure operates independently and produces its own fix count.

---

### 1. JSON Repair

**Scope:** All `.json` files in the project workspace.

**Detection:**
```powershell
Get-ChildItem -Path "<project-root>" -Recurse -Filter "*.json" | ForEach-Object {
    try {
        $content = Get-Content $_.FullName -Raw
        $null = $content | ConvertFrom-Json -ErrorAction Stop
        # File is valid
    } catch {
        # File needs repair — record path and error message
    }
}
```

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Trailing commas | `,\s*[}\]]` | Remove the trailing comma |
| Unquoted keys | `{\s*\w+\s*:` without quotes | Wrap key in double quotes |
| Single-quoted strings | `'value'` | Replace with `"value"` |
| Missing closing bracket | Unmatched `{` or `[` | Append the missing bracket |
| Comments in JSON | `//` or `/* */` lines | Remove comment lines |
| Trailing content after root | Valid JSON followed by extra text | Remove trailing content |

**Fix Process:**
1. Read the raw file content as a string
2. Apply regex-based fixes for each known issue pattern
3. Attempt to parse the fixed content with `ConvertFrom-Json`
4. If parsing succeeds, write the fixed content back to the file
5. If parsing still fails, log the error and skip (do not corrupt the file further)
6. After writing, re-parse one final time to confirm the fix

**Important:** Never overwrite a file with content that doesn't parse. If the fix doesn't resolve the issue, leave the original file intact and log it as "unfixable — requires manual review."

---

### 2. YAML Frontmatter Repair

**Scope:** All `SKILL.md` files in the project workspace.

**Detection:**
Scan each `SKILL.md` for the frontmatter pattern:
```
---
name: <value>
description: <value>
---
```

**Required Fields:**
- `name` — Must be a non-empty string in `lowercase-kebab-case`
- `description` — Must be a non-empty string, typically in quotes

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Missing frontmatter entirely | File doesn't start with `---` | Generate frontmatter from folder name and file content |
| Missing `name` field | Frontmatter exists but no `name:` line | Infer from parent folder name (e.g., `api-scaffold` → `name: api-scaffold`) |
| Missing `description` field | Frontmatter exists but no `description:` line | Generate from the first heading or first paragraph of the file |
| Unquoted description with special chars | `description: value with: colons` | Wrap in double quotes: `description: "value with: colons"` |
| Name not in kebab-case | `name: My Skill` | Convert to `name: my-skill` |
| Missing closing `---` | Only one `---` delimiter found | Add closing `---` after the last frontmatter field |
| Empty values | `name:` with no value | Infer appropriate value |

**Fix Process:**
1. Read the file content
2. Check if frontmatter delimiters exist
3. If no frontmatter: prepend generated frontmatter
4. If partial frontmatter: fill in missing fields
5. If malformed frontmatter: fix the specific issue
6. Write the corrected file
7. Re-read and validate the frontmatter

---

### 3. Markdown Link Repair

**Scope:** All `.md` files in the project workspace.

**Detection:**
Extract all links using regex patterns:
- Standard links: `\[([^\]]+)\]\(([^)]+)\)`
- File protocol links: `\[([^\]]+)\]\(file:///([^)]+)\)`
- Reference links: `\[([^\]]+)\]\[([^\]]+)\]`

For each extracted link:
1. If the target is a URL (starts with `http://` or `https://`), skip it (external links are not validated)
2. If the target is a file path, resolve it relative to the markdown file's directory
3. Check if the resolved path exists on disk

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Wrong relative path depth | File exists but at different depth | Recalculate the correct relative path |
| Case mismatch | `readme.md` vs `README.md` | Fix casing to match actual file name |
| Missing file extension | `[link](ARCHITECTURE)` | Add `.md` extension if the `.md` file exists |
| Forward/backslash mismatch | `docs\file.md` on a path expecting `/` | Normalize to forward slashes |
| Moved file | File was renamed or moved | Search by filename in the project tree and update path |
| Anchor link to missing heading | `#section-name` doesn't match any heading | Find closest matching heading by Levenshtein distance |

**Fix Process:**
1. Collect all links from all markdown files
2. Classify each link as: valid, broken-path, broken-anchor, or external
3. For each broken-path link:
   a. Search the project tree for a file with the same basename
   b. If exactly one match: fix the path
   c. If multiple matches: pick the one in the closest directory
   d. If no matches: remove the link markup (keep the text, remove the URL)
4. For each broken-anchor link:
   a. Collect all headings from the target file
   b. Find the closest match by normalized comparison
   c. Fix if confidence is high; otherwise leave and log a warning
5. Write all fixes back to the files

---

### 4. Cross-Reference Consistency

**Scope:** All project configuration and documentation files.

**Build the Reference Map:**
1. Scan all `SKILL.md` files and extract the `name` field from frontmatter → `skillNames[]`
2. Scan `hooks.json` for hook names → `hookNames[]`
3. Scan `plugin.json` for the plugin name → `pluginName`
4. Scan `mcp_config.json` for server names → `mcpServerNames[]`

**Check References In:**
- `GEMINI.md` — References to skills, plugins, hooks
- `AGENTS.md` — References to skills and workflows
- `docs/ARCHITECTURE.md` — References to tech stack components
- `docs/IMPLEMENTATION_PLAN.md` — References to skills and phases
- `README.md` — References to scripts, commands, and file paths

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Reference to non-existent skill | Skill name in docs not in `skillNames[]` | Remove the reference and log a warning; OR create a stub skill if the name suggests clear intent |
| Typo in skill name | Close match in `skillNames[]` (edit distance ≤ 2) | Replace with the correct skill name |
| Orphan skill | Skill exists but is never referenced | Log as informational (not auto-fixed — it may be intentional) |
| Stale file path in docs | Path reference to a file that doesn't exist | Search for the file and update the path |
| Inconsistent project name | Different names used across files | Standardize to the name in `GEMINI.md` or `package.json` |

**Fix Process:**
1. Build the complete reference map
2. Scan all documentation files for references
3. Cross-check every reference against the map
4. Apply fixes for clear mismatches
5. Log ambiguous cases for manual review

---

### 5. Configuration Schema Validation

**Scope:** `hooks.json`, `mcp_config.json`, `plugin.json`

#### `hooks.json` Validation

Required structure:
```json
{
  "hooks": [
    {
      "name": "string (required)",
      "event": "string (required, must be a valid event type)",
      "matcher": "string (glob pattern or regex)",
      "action": "string (required)"
    }
  ]
}
```

Valid event types:
- `onFileCreate`, `onFileChange`, `onFileDelete`
- `onBuild`, `onBuildSuccess`, `onBuildError`
- `onTest`, `onTestSuccess`, `onTestError`
- `onCommit`, `onPush`, `onPR`
- `onCommand`

Fixes:
- Missing `hooks` wrapper array → wrap existing content in `{ "hooks": [...] }`
- Missing `name` field → generate from `event` + `matcher`
- Invalid event type → suggest closest valid event type
- Missing `action` field → log error (cannot auto-fix without intent)

#### `mcp_config.json` Validation

Required structure:
```json
{
  "mcpServers": {
    "<server-name>": {
      "command": "string",
      "args": ["array", "of", "strings"]
    }
  }
}
```

Or for URL-based servers:
```json
{
  "mcpServers": {
    "<server-name>": {
      "url": "string"
    }
  }
}
```

Fixes:
- Missing `mcpServers` wrapper → wrap content in `{ "mcpServers": {...} }`
- Server entry missing both `command` and `url` → log error
- `args` is a string instead of array → wrap in array: `"args": ["value"]`
- `command` path uses backslashes → normalize to forward slashes

#### `plugin.json` Validation

Required structure:
```json
{
  "name": "string (required)",
  "version": "string",
  "description": "string"
}
```

Fixes:
- Missing `name` field → infer from project name or directory name
- Missing `version` → add `"version": "1.0.0"`
- Missing `description` → generate from project brief or README

---

### 6. Encoding & Line Ending Fixes

**Scope:** All text files in the project workspace.

**Detection and Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| BOM character | First bytes are `EF BB BF` (UTF-8 BOM) | Read content, strip BOM bytes, rewrite without BOM |
| Mixed line endings | File contains both `\r\n` and `\n` | Normalize all to `\n` (LF) or `\r\n` (CRLF) based on project config |
| Trailing whitespace | Lines ending with spaces or tabs | Remove trailing whitespace from each line |
| Missing final newline | File doesn't end with `\n` | Append a newline character |
| Multiple trailing newlines | File ends with `\n\n\n...` | Reduce to single trailing newline |

**Fix Process:**
1. Read each file as raw bytes to detect encoding issues
2. Apply BOM removal if detected
3. Normalize line endings according to project configuration (check `.editorconfig` or `.prettierrc` for the `endOfLine` setting; default to LF)
4. Fix trailing whitespace on each line
5. Ensure exactly one trailing newline
6. Write back only if changes were made

---

## Reporting

After running all auto-fix procedures, generate a structured report.

### Report Format

```
🩹 Self-Healing Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 JSON files checked: <N> | fixed: <N> (<details>)
📝 YAML frontmatter checked: <N> | fixed: <N> (<details>)
🔗 Markdown links checked: <N> | fixed: <N> (<details>)
🔄 Cross-references checked: <N> | fixed: <N> (<details>)
⚙️ Config schemas validated: <N> | fixed: <N> (<details>)
📐 Encoding/line endings checked: <N> | fixed: <N> (<details>)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total files scanned: <N>
Total fixes applied: <N>
Unfixable issues: <N> (requires manual review)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Detail Lines

When fixes are applied, include specifics:
```
📄 JSON files checked: 5 | fixed: 2
   └─ hooks.json: removed trailing comma on line 14
   └─ mcp_config.json: wrapped args string in array for "firebase" server
```

### Unfixable Issues

When an issue cannot be auto-fixed, clearly explain what's wrong and what the user should do:
```
⚠️ Unfixable issues (1):
   └─ hooks.json: hook "on-deploy" is missing an "action" field — please specify what should happen when this hook fires
```

---

## Integration Points

### Ratchet Loop Integration

The self-healing skill is designed to run in the ratchet loop between validation passes:

```
Generate → Validate → Self-Heal → Re-Validate → (repeat until clean)
```

Each iteration should fix more issues until the validation pass returns zero errors.

### Pre-Presentation Check

Always run self-healing before presenting the bootstrapped project to the user. The user should never see a project with fixable issues.

### Idempotency

Self-healing must be idempotent: running it twice on the same files should produce the same result. The second run should report zero fixes needed. If self-healing creates new issues, that is a bug in the self-healing logic.

---

## Safety Rules

1. **Never delete files** — Only modify content within existing files
2. **Never change semantics** — Fixes must preserve the intended meaning (e.g., fixing a typo in a skill name, not renaming the skill)
3. **Always back up before modifying** — Before writing any fix, ensure the original content could be recovered (log the original value in the report)
4. **Stop on cascading failures** — If fixing one file causes another file's validation to fail, stop and report the conflict
5. **Respect `.gitignore`** — Do not scan or modify files that would be gitignored (e.g., `node_modules/`, `dist/`)
