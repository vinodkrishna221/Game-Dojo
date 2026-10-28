---
name: ratchet-loop
description: "Autonomous improvement loop inspired by Karpathy's autoresearch pattern. After initial project generation, this skill drives a continuous generate → validate → fix → repeat cycle that improves project quality until a time budget is exhausted or a target quality score is reached. Use this skill when the agent should autonomously improve generated project files without human intervention."
---

# Ratchet Loop

## Overview

The Ratchet Loop is a hill-climbing algorithm for project quality. It works like this:

1. Run the project-validator to get a quality score (0-100)
2. Identify the lowest-scoring area
3. Attempt to improve it (regenerate the file, add missing content, fix broken references)
4. Re-run validation
5. If the score improved → git commit the change (ratchet forward)
6. If the score regressed or stayed the same → git reset --hard (discard)
7. Try a different improvement approach
8. Repeat until time budget exhausted or score > 95

---

## Quality Score Function

The composite quality score (0-100) is calculated from:

| Sub-Score | Points | What It Measures |
|---|---|---|
| **Completeness** | 25 | All required files exist (GEMINI.md, AGENTS.md, README.md, at least 3 skills, hooks.json, mcp_config.json, architecture docs) |
| **Validity** | 20 | All JSON files parse without errors, all YAML frontmatter is valid, all Markdown renders correctly |
| **Cross-Reference Integrity** | 15 | All internal file links resolve, all skill names referenced in other files exist, all paths in configs are valid |
| **Coverage** | 20 | Every major project workflow has a corresponding skill, every tech stack component has MCP configuration, every deployment target has documentation |
| **AI Readability** | 20 | The comprehension test score (can a fresh agent understand the project from files alone) |

---

## Step-by-Step Loop Procedure

### Step 1 — Initialize

Ensure the project has a git repository. Create a baseline commit if one does not exist.

```powershell
git init
git add -A; git commit -m "baseline: pre-ratchet state"
```

### Step 2 — Score

Run the `project-validator` skill. Record the baseline score as `baseline_score`.

### Step 3 — Analyze

Identify the component with the **lowest sub-score**. This is the highest-leverage improvement target. Rank all five sub-scores and pick the worst one.

### Step 4 — Plan Fix

Determine the specific fix needed based on the failing sub-score category:

| Failure Type | Fix Strategy |
|---|---|
| Missing file | Generate it using the `doc-generator` skill |
| Invalid JSON | Parse the file, identify the syntax error, fix it, and rewrite |
| Broken internal link | Find the correct path or anchor, update the reference |
| Missing skill coverage | Use `skill-crafter` to generate the missing skill |
| Low AI readability | Add more context, examples, and cross-references to GEMINI.md and other core docs |
| Missing MCP config | Add the appropriate MCP server entry for the tech stack component |
| Incomplete doc section | Expand the section with specific, actionable content |

### Step 5 — Execute Fix

Make exactly **one change** per iteration. Keep changes atomic so the ratchet can precisely attribute score changes to individual fixes.

### Step 6 — Git Commit

```powershell
git add -A; git commit -m "ratchet: [description of fix]"
```

### Step 7 — Re-Score

Run the `project-validator` skill again. Record the new score as `new_score`.

### Step 8 — Decision

Compare `new_score` to `baseline_score`:

- **If `new_score` > `baseline_score`** → **KEEP** the change. Log the success. Update `baseline_score = new_score`.
- **If `new_score` <= `baseline_score`** → **DISCARD** the change. Run `git reset --hard HEAD~1`. Log the failure. Move to the next improvement target.

### Step 9 — Log

Append a row to `ratchet-log.tsv` in the project root:

```
timestamp	attempt	change_description	old_score	new_score	decision
2024-01-15T10:30:00Z	1	added missing deployment skill	72	78	KEEP
2024-01-15T10:32:00Z	2	fixed broken link in ARCHITECTURE.md	78	81	KEEP
2024-01-15T10:34:00Z	3	attempted to simplify README structure	81	79	DISCARD
```

If the file does not exist, create it with the header row first:

```
timestamp	attempt	change_description	old_score	new_score	decision
```

### Step 10 — Check Budget

Evaluate the termination conditions:

- **Time budget exhausted?** → Stop and go to Step 11
- **Score >= target (95)?** → Stop and go to Step 11
- **Maximum attempts (20) reached?** → Stop and go to Step 11
- **5 consecutive DISCARD results on the same sub-score?** → Skip that sub-score, move to the next lowest
- Otherwise → return to Step 3

### Step 11 — Report

Present the final results to the user:

```
## 🔧 Ratchet Loop Complete

- **Starting score:** 68/100
- **Final score:** 92/100
- **Attempts:** 14 (10 kept, 4 discarded)
- **Time elapsed:** 7m 23s

### Improvement History
| # | Change | Score | Decision |
|---|--------|-------|----------|
| 1 | Added missing deployment skill | 68 → 74 | ✅ KEEP |
| 2 | Fixed broken link in ARCHITECTURE.md | 74 → 78 | ✅ KEEP |
| ...| ... | ... | ... |

### Git Log
All changes are individually committed for full audit trail.
```

---

## Configuration

| Parameter | Default | Description |
|---|---|---|
| Time budget | 10 minutes | Maximum wall-clock time for the loop |
| Target score | 95/100 | Score at which to stop improving |
| Max attempts | 20 | Hard cap on total improvement iterations |
| Max consecutive failures | 5 | Skip a sub-score after this many consecutive DISCARDs |
| Log file | `ratchet-log.tsv` | Tab-separated log in project root |

---

## When to Activate

- **Automatically** after Phase 5 (Validation) of the bootstrap process
- **On user request:** "improve", "optimize", "make it better", "ratchet"
- **In overnight/goal mode:** Always runs after initial generation with extended time budget
- **After manual edits:** User can request a ratchet pass to clean up after hand-editing

---

## Integration with Git

All changes are tracked in git for full audit trail and easy rollback:

```
git log --oneline
abc1234 ratchet: added missing deployment skill (score: 72 → 78)
def5678 ratchet: fixed broken link in ARCHITECTURE.md (score: 78 → 81)
ghi9012 ratchet: improved GEMINI.md with explicit error handling patterns (score: 81 → 85)
```

If the user wants to undo all ratchet changes:

```powershell
git log --oneline  # find the pre-ratchet baseline commit
git reset --hard <baseline-commit-hash>
```

---

## Anti-Patterns to Avoid

- **Do not make multiple changes per iteration.** Each commit must be atomic so regressions can be precisely attributed.
- **Do not skip the git commit step.** The ratchet mechanism depends on being able to discard individual changes.
- **Do not continue past the time budget.** Respect the user's time constraints.
- **Do not fight the score.** If a change keeps getting discarded, the validator is telling you something — try a fundamentally different approach or move on.
- **Do not modify the validator to improve scores.** The validator is the source of truth; improve the project files, not the scoring criteria.
