# Local Skills Library Reference Guide

> **Path:** `C:\Users\Vinod krishna\antigravity_skills`
> **Total Available Skills:** 1,320+ pre-built skills
> **Manifest:** `C:\Users\Vinod krishna\antigravity_skills\.antigravity-install-manifest.json`

---

## 🌟 Overview

Game Dojo has direct access to an extensive local repository of 1,320+ pre-engineered Antigravity skills located at `C:\Users\Vinod krishna\antigravity_skills`.

Instead of only relying on downloading skills from the marketplace or writing generic skills from scratch, **Game Dojo scans this local library first** to identify and import high-quality, pre-tested skills into any bootstrapped project.

---

## 📂 Category Breakdown

Analysis of the 1,320+ local skills by major domain:

| Domain | Skill Count | Examples |
|---|---|---|
| **DevOps & Cloud** | ~155 | `docker-compose`, `kubernetes-ops`, `aws-infra`, `terraform-setup`, `ci-cd-pipelines` |
| **Workflow & Automation** | ~125 | `workflow-automation`, `orchestrator`, `zapier-make-patterns`, `task-automation` |
| **AI & Agent Systems** | ~113 | `ai-agent-development`, `ai-engineer`, `agent-orchestrator`, `prompt-engineering`, `rag-system` |
| **Security & Auditing** | ~62 | `accessibility-compliance`, `active-directory-attacks`, `zeroize-audit`, `xss-html-injection` |
| **Backend & APIs** | ~56 | `api-development`, `fastapi-backend`, `express-rest`, `graphql-schema`, `jwt-auth` |
| **Frontend & Web** | ~55 | `react-best-practices`, `nextjs-app-router`, `tailwind-system`, `3d-web-experience`, `zustand-store-ts` |
| **Testing & QA** | ~43 | `ab-test-setup`, `acceptance-orchestrator`, `playwright-e2e`, `jest-unit-tests` |
| **Database & Storage** | ~42 | `postgres-optimizer`, `prisma-schema`, `mongo-aggregations`, `redis-cache` |
| **Mobile Development** | ~19 | `flutter-architecture`, `react-native-patterns`, `mobile-offline-first` |

---

## 🔍 How Game Dojo Discovers & Evaluates Local Skills

During **Phase 4 (Ecosystem Integration)** and **Phase 3 (Document & Skill Generation)**:

### 1. Keyword & Technology Matching
Given a project's stack (e.g., `Next.js`, `PostgreSQL`, `Tailwind`, `Playwright`):
1. Scan folder names in `C:\Users\Vinod krishna\antigravity_skills` matching the tech or domain keywords.
2. Example search queries:
   ```powershell
   Get-ChildItem -Path "C:\Users\Vinod krishna\antigravity_skills" -Directory | Where-Object { $_.Name -match "next|tailwind|postgres|auth|playwright" }
   ```

### 2. Inspecting the `SKILL.md`
For matching candidates, inspect `C:\Users\Vinod krishna\antigravity_skills\<candidate>\SKILL.md` to review:
* The YAML frontmatter (`name` and `description`).
* The step-by-step procedures to ensure compatibility with the project architecture.

### 3. Importing into Target Project
Once approved, the skill folder can be imported into the target project's `.agents/skills/` directory:
```powershell
Copy-Item -Path "C:\Users\Vinod krishna\antigravity_skills\<skill-name>" -Destination "<target-project>\.agents\skills\<skill-name>" -Recurse
```

---

## 🎯 Recommended Skill Bundles by Stack

### 1. Modern Web App (Next.js + TypeScript + Tailwind + Prisma)
Recommended local skills to copy/reference:
* `nextjs-app-router` (or `react-best-practices`)
* `tailwind-system`
* `prisma-schema` / `postgres-optimizer`
* `zod-validation-expert`
* `zustand-store-ts`
* `playwright-e2e` / `testing`

### 2. Full-Stack Python (FastAPI + PostgreSQL + React)
Recommended local skills to copy/reference:
* `fastapi-backend`
* `postgres-optimizer`
* `docker-compose`
* `ai-agent-development` (if AI features are involved)

### 3. Mobile App (Flutter / React Native)
Recommended local skills to copy/reference:
* `flutter-architecture` or `react-native-patterns`
* `acceptance-orchestrator`
* `mobile-offline-first`

### 4. AI / Agent Application
Recommended local skills to copy/reference:
* `ai-agent-development`
* `agent-orchestrator`
* `agent-memory-mcp`
* `prompt-forge` (from global config)

---

## ⚙️ Precedence & Integration Rules

1. **Local Library First:** When a skill is needed, check `C:\Users\Vinod krishna\antigravity_skills` before creating a generic one or searching the marketplace.
2. **Custom Crafting Fallback:** If no local skill matches the specific nuance of the project, use `skill-crafter` to generate a dedicated skill.
3. **Preserve Frontmatter:** Ensure any imported skill has clean YAML frontmatter that integrates smoothly with Antigravity's progressive disclosure mechanism.
