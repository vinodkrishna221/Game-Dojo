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
- When Team Mode artifacts (.ai-team/, CODEOWNERS) contain schema defects, broken branch slugs, cyclic task dependencies, or conflicting un-sequenced file collisions

---

## Auto-Fix Procedures

Run all seven procedures in order. Each procedure operates independently and produces its own fix count.

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
      "description": "string (optional)",
      "trigger": "string (required: PreToolUse | PostToolUse | PostToolUseFailure | SessionStart | SessionEnd | PostInvocation)",
      "matcher": {
        "toolName": "string or regex (optional)"
      },
      "handler": {
        "command": ["array", "of", "command", "arguments"],
        "timeout": 10000
      }
    }
  ]
}
```

Valid triggers:
- `PreToolUse` — Fires before a tool runs
- `PostToolUse` — Fires after a tool completes
- `PostToolUseFailure` — Fires when a tool fails
- `SessionStart` — Fires when a new agent session begins
- `SessionEnd` — Fires when an agent session ends
- `PostInvocation` — Fires after each agent interaction turn

Fixes:
- Missing `hooks` wrapper array → wrap existing content in `{ "hooks": [...] }`
- Missing `name` field → generate descriptive name from `trigger` + matcher
- Missing `trigger` field → infer from toolName or handler command
- Missing `handler.command` → log error (cannot auto-fix without script intent)
- Missing `timeout` → supply sensible default (10000 ms)
- Command using single string instead of array → wrap in array: `["powershell", "-File", "path"]`

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

### 7. Team Mode Configuration Repair

**Scope:** `.ai-team/team.json`, `.ai-team/plan.json`, `.ai-team/tasks/*.json`, root `CODEOWNERS`, and `.github/CODEOWNERS`.

When Team Mode is active, multi-agent development and human collaboration require rigorous metadata coordination to avoid branch collisions, dependency deadlocks, un-sequenced file edit conflicts, and orphan ownership mappings. This procedure enforces schema contracts, detects and breaks dependency cycles, validates branch naming conventions, eliminates concurrent file collisions (including glob overlaps), and reconciles CODEOWNERS with the team roster.

#### A. Schema Validation for `.ai-team/*.json`

**Scope:** `.ai-team/team.json`, `.ai-team/plan.json`, and `.ai-team/tasks/*.json`.

**Detection:**
1. Validate `.ai-team/team.json`:
   - Root fields: `teamId` (string), `teamName` (string), `lead` (string), `members` (array with ≥ 1 member).
   - Member fields: `id` (lowercase kebab-case), `name` (string), `role` (string), `gitUser` or `githubUsername` (string starting with `@`), `availability` (`"active"` | `"idle"` | `"busy"` | `"offline"`), `capabilities` (array), `maxConcurrentTasks` (integer ≥ 1), `assignedTaskIds` or `activeTasks` (array).
2. Validate `.ai-team/plan.json`:
   - Root fields: `planId` (string), `currentMilestone` (string), `milestones` (array), `taskIndex` (array).
   - Milestone fields: `id`, `title`, `description`, `status` (`"todo"` | `"in_progress"` | `"done"` | `"completed"`), `targetDate`, `tasks` or `taskIds` (array of task IDs).
   - `taskIndex` fields: `id`, `title`, `slug`, `milestoneId`, `assignedTo` (or `assignee`), `status`, `branch`.
3. Validate each `.ai-team/tasks/<task-id>.json`:
   - Required fields: `id`, `title`, `slug`, `milestoneId`, `assignedTo` (or `assignee`), `ownerGit` (or `gitUser`), `status` (`"todo"` | `"in_progress"` | `"in_review"` | `"done"` | `"completed"` | `"blocked"`), `branch`, `dependencies` (or `blockedBy` array), `touchesFiles` (or `allowedPaths` array), `description`, `acceptanceCriteria` (array with ≥ 1 criteria).
   - Ensure filename basename matches `id` (e.g. `task-003.json` must declare `"id": "task-003"`).

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Null or missing array fields | `dependencies: null`, missing `touchesFiles`, or missing `capabilities` | Initialize to empty array `[]` |
| Missing member availability | `availability` field missing in `team.json` | Set default to `"idle"` |
| Missing concurrency limit | `maxConcurrentTasks` missing | Set default to `2` |
| Missing task status | `status` missing in task JSON | Set default to `"todo"` |
| Status naming discrepancy | Task uses `"completed"` where tooling expects `"done"` (or vice-versa) | Standardize or preserve acceptance of both `"done"` and `"completed"` as finished states |
| Boundary manifest alias mismatch | Task declares `allowedPaths` instead of `touchesFiles` (or vice-versa) | Synchronize both fields so tooling expecting either `touchesFiles` or `allowedPaths` succeeds |
| Assignee field variation | Task declares `assignee` as string ID or `{ id, name }` object | Ensure `assignedTo` string matches member ID, preserving nested `assignee` object |
| Handle field variation | Member declares `githubUsername` instead of `gitUser` (or vice-versa) | Synchronize both fields and ensure leading `@` prefix |
| Task ID / filename mismatch | `task-003.json` contains `"id": "task-3"` | Rewrite `"id"` in JSON to match filename basename (`task-003`) |
| Incomplete `taskIndex` in `plan.json` | Tasks exist in `.ai-team/tasks/` but absent from `taskIndex` | Rebuild `taskIndex` from all `.ai-team/tasks/*.json` files |
| Desynchronized `assignedTaskIds` | Member `assignedTaskIds` in `team.json` does not match task assignments | Recompute member `assignedTaskIds` by scanning `assignedTo` / `assignee` across all task files |

#### B. Circular Dependency Detection in Tasks

**Scope:** `.ai-team/tasks/*.json`.

**Detection:**
Tasks declare prerequisite task IDs in their `dependencies` (or `blockedBy`) array. A circular dependency (e.g., Task A depends on Task B, while Task B depends on Task A, or an indirect cycle $A \to B \to C \to A$) produces an execution deadlock where no task can begin.

**Detection Process (PowerShell):**
```powershell
$taskFiles = Get-ChildItem -Path ".ai-team/tasks" -Filter "*.json"
$tasks = $taskFiles | ForEach-Object { Get-Content $_.FullName -Raw | ConvertFrom-Json }

$graph = @{}
$taskMap = @{}
foreach ($t in $tasks) {
    $deps = @()
    if ($t.dependencies) { $deps += @($t.dependencies) }
    if ($t.blockedBy) { $deps += @($t.blockedBy) }
    $graph[$t.id] = $deps | Select-Object -Unique
    $taskMap[$t.id] = $t
}

$visited = @{}
$inStack = @{}
$detectedCycles = [System.Collections.Generic.List[string]]::new()
$missingDeps = [System.Collections.Generic.List[string]]::new()

function Test-TaskCycle($node, $path) {
    $visited[$node] = $true
    $inStack[$node] = $true
    $currentPath = @($path) + $node

    foreach ($dep in $graph[$node]) {
        if (-not $graph.ContainsKey($dep)) {
            $missingDeps.Add("$node -> missing($dep)")
            continue
        }
        if (-not $visited[$dep]) {
            Test-TaskCycle $dep $currentPath
        } elseif ($inStack[$dep]) {
            $cycleStart = [Array]::IndexOf($currentPath, $dep)
            if ($cycleStart -ge 0) {
                $cycle = ($currentPath[$cycleStart..($currentPath.Length - 1)] + $dep) -join " -> "
                $detectedCycles.Add($cycle)
            }
        }
    }
    $inStack[$node] = $false
}

foreach ($id in $graph.Keys) {
    if (-not $visited[$id]) {
        Test-TaskCycle $id @()
    }
}
```

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Self-dependency | Task includes its own `id` in `dependencies` | Remove self-reference from `dependencies` array |
| Dangling / Missing dependency | Task depends on non-existent task ID | Remove non-existent task ID from `dependencies` and log warning |
| Direct 2-task cycle (`A <-> B`) | Task A depends on B, Task B depends on A | Compare milestone order and numeric task ID. A backward dependency occurs when an earlier task depends on a future task (e.g. `task-001` depending on future `task-002`). Remove the inverted dependency from the earlier task (`task-001.dependencies`), preserving natural forward sequence (`task-001` precedes `task-002`) |
| Complex multi-task cycle | Cycle path spanning 3+ tasks (e.g. `T1 -> T2 -> T3 -> T1`) | Inspect milestone sequencing and task IDs along the cycle path. Identify the inverted back-edge where a task in an earlier milestone depends on a task in a later milestone (or lower task ID depends on higher task ID in same milestone), and remove that specific back-edge. If sequence is ambiguous, flag as unfixable with exact cycle trace |

#### C. Branch Name & Slug Convention Validation

**Scope:** `.ai-team/tasks/*.json`, `.ai-team/plan.json`, and local Git branches.

**Detection:**
Task branches must strictly conform to the format:
`feature/<task-id>-<slug>` (or `feat/<task-id>-<slug>`)
where:
- `<task-id>` matches `id` in task JSON (e.g. `task-003`)
- `<slug>` is lowercase kebab-case matching `slug` in task JSON (e.g. `auth-middleware`)

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Missing prefix | Branch is `task-003-auth-middleware` | Prepend `feature/`: `feature/task-003-auth-middleware` |
| Malformed slug in branch | Branch contains underscores or uppercase (e.g. `feature/task-003-Auth_Middleware`) | Sanitize slug to lowercase kebab-case (`feature/task-003-auth-middleware`) |
| Slug mismatch with task file | Branch slug differs from `slug` field in task JSON | Re-generate branch string as `feature/$($task.id)-$($task.slug)` |
| Local git branch has outdated name | Git branch exists with non-standard name | Rename local git branch using `git branch -m <old-name> <new-name>` |
| Branch missing from Git repository | Branch declared in task file does not exist locally | Execute `git branch <branch-name>` from current branch |

#### D. `touchesFiles` Integrity & Conflict Detection

**Scope:** `touchesFiles` (and `allowedPaths`) boundary manifests across all `.ai-team/tasks/*.json`.

**Detection:**
Every task defines the exact set of repository files it is authorized to touch (using `touchesFiles` or `allowedPaths`). Two integrity checks are performed:

1. **Path Normalization & Scope:**
   - Detect backward slashes `\` or leading `./`.
   - Ensure paths do not target `.git/`, `node_modules/`, `dist/`, or paths escaping the project root (`../`).
   - Verify each file is either an existing file on disk or a planned file declared in the architecture specification.

2. **Un-sequenced Concurrent Conflict Detection (including globs):**
   - Scan every pair of active tasks $(T_A, T_B)$ where neither task is finished (`"done"` or `"completed"`).
   - Identify overlapping file paths:
     • Exact normalized path equality (e.g. `src/lib/auth.ts` vs `src/lib/auth.ts`).
     • Directory or wildcard containment (e.g. `src/components/**` contains `src/components/dashboard/Card.tsx`, or `src/api/` contains `src/api/users.ts`).
   - Check dependency relationship: Determine if $T_B$ transitively depends on $T_A$ or $T_A$ transitively depends on $T_B$.
   - **Conflict Condition:** If two concurrent active tasks touch overlapping files without any dependency relationship, parallel execution will result in merge conflicts or race conditions.

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Non-normalized file path | Contains `\` or leading `./` (e.g. `.\src\lib\auth.ts`) | Normalize to forward slashes without leading `./`: `src/lib/auth.ts` |
| Duplicate paths in `touchesFiles` | Task lists the same file multiple times | Deduplicate array entries |
| Un-sequenced concurrent file overlap | Tasks A and B touch same file without dependency | 1. If Milestone(A) < Milestone(B), add Task A to Task B's `dependencies`.<br>2. If same milestone, order by numeric task ID: add earlier task to later task's `dependencies`.<br>3. Log sequencing fix: `Sequenced concurrent file conflict on <file> between <Task-A> and <Task-B>`. |
| Unresolvable architectural conflict | Multiple tasks have mutual file locks that cannot be sequenced | Flag as unfixable requiring architectural file splitting |

#### E. CODEOWNERS Verification

**Scope:** Root `CODEOWNERS` or `.github/CODEOWNERS`.

**Detection:**
1. Locate the active `CODEOWNERS` file (checking root `CODEOWNERS` and `.github/CODEOWNERS`).
2. Parse every rule in `CODEOWNERS` (ignoring lines starting with `#` and blank lines).
3. For each rule: `<pattern> @<gitUser1> [@<gitUser2>...]`
   - **Git Username Check:** Verify each `@<gitUser>` exists in `.ai-team/team.json` under member `gitUser` or `githubUsername`.
   - **Directory & File Existence Check:** For file/directory patterns (e.g. `/src/api/`, `/prisma/`, `/src/lib/db.ts`):
     - Strip any leading `/` or `\` so paths resolve relative to the project workspace root on Windows (`Join-Path $projectRoot $cleanPattern`) rather than the drive root.
     - Skip the catch-all global wildcard `*`.
     - Check if the target directory or file exists on disk.
     - If not on disk, check if it is declared in `touchesFiles` (or `allowedPaths`) of a task in `.ai-team/tasks/*.json`.
     - Flag obsolete directories, typos, or phantom paths.

**Common Fixes:**

| Issue | Detection | Fix |
|---|---|---|
| Missing `@` prefix on handle | Handle written as `dvance-backend` | Prepend `@`: `@dvance-backend` |
| Typo in Git handle | Handle not in `team.json`, but Levenshtein distance ≤ 2 from a valid member | Replace with closest matching member `gitUser` (e.g. `@dvance-bckend` → `@dvance-backend`) |
| Unregistered Git handle | Handle not in `team.json` and no close match | Replace with the team lead handle (`lead` from `team.json`) |
| Typo in directory path | Directory doesn't exist, but close match exists on disk (e.g. `/src/componets/`) | Update pattern to matching disk directory: `/src/components/` |
| Phantom directory pattern | Path does not exist on disk and is not in any task's `touchesFiles` | Comment out the rule: `# [Self-Healing] Path not found: <pattern>` |

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
👥 Team Mode integrity checked: <N> | fixed: <N> (<details>)

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
👥 Team Mode integrity checked: 8 | fixed: 3
   └─ .ai-team/tasks/task-003.json: injected task-002 dependency to resolve concurrent file conflict on src/lib/auth.ts
   └─ .ai-team/tasks/task-004.json: normalized branch to feature/task-004-dashboard-shell
   └─ CODEOWNERS: corrected @dvance-bckend to @dvance-backend
```

### Unfixable Issues

When an issue cannot be auto-fixed, clearly explain what's wrong and what the user should do:
```
⚠️ Unfixable issues (1):
   └─ hooks.json: hook "post-build" is missing a "handler.command" field — please specify what command should run when this hook triggers
   └─ .ai-team/tasks: circular dependency detected along cycle path task-002 -> task-005 -> task-002 — please adjust task sequencing
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
6. **Preserve task identity and assignment** — Never delete tasks or reassign them to different owners during self-healing; only repair schemas, branch strings, path formatting, and dependency sequencing
