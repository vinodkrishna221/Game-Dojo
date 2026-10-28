# BroTel: Gym Bro Hotel Tycoon — Agent Behavioral Rules

This document governs how AI agents behave when assisting human developers in the BroTel workspace.

---

## 1. Team Boundary Protocol

When an AI agent is activated in this workspace:

1. **Identity & Context Discovery**:
   - Inspect active branch: `git branch --show-current` or `git rev-parse --abbrev-ref HEAD`.
   - Extract `<task-id>` from branch name pattern (`feature/<task-id>-*`).
   - Locate and read the corresponding task manifest at `.ai-team/tasks/<task-id>.json`.
2. **Strict Scope Bounding (`touchesFiles` / `allowedPaths`)**:
   - Confine all file creations, edits, and deletions strictly to the paths enumerated in the task's `touchesFiles` and `allowedPaths` arrays.
   - Refuse to modify or refactor any file outside the assigned task boundaries.
3. **Cross-Member File Protection**:
   - Inspect other task manifests in `.ai-team/tasks/*.json` having status `in_progress` or `todo`.
   - Never modify files owned by another teammate's active task.
4. **Contract-First Verification**:
   - Before modifying any API, interface, or game state serialization, inspect shared contracts in `docs/contracts/`.
   - Agents must NOT introduce breaking changes to frozen contracts (`Status: FROZEN`).
5. **PR Submission**:
   - Prior to PR submission, run deep verification (`powershell ./scripts/verify-project.ps1`).
   - Update task status in `.ai-team/tasks/<task-id>.json` from `in_progress` to `in_review`.
   - Format git commits with `feat(<task-id>): <summary>` or `fix(<task-id>): <summary>`.
   - Never push directly to `main`. Notify `@lead` for PR review and merge.

---

## 2. Quality Standards

- **Zero Placeholders**: Never generate files with `// TODO: implement`, `"..."`, or stubbed methods. Every file must be complete, compilable, and functional.
- **Syntactic Correctness**: Validate all JSON, C#, JavaScript, and Markdown files prior to completion.
- **CrazyGames Compliance**: Respect 3-minute midgame ad intervals, verify AdBlock safety, and ensure `AudioListener.pause` and `Time.timeScale` are handled properly.
