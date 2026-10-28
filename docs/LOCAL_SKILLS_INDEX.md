# 📚 Local Skills Library Index & Reference

> **Location:** `C:\Users\Vinod krishna\antigravity_skills`  
> **Repository Size:** 1,326 specialized skills  
> **Integration:** Registered as a primary reference source for Game Dojo

---

## 🎯 Purpose

Game Dojo is equipped to reference and import skills from the local skills archive at `C:\Users\Vinod krishna\antigravity_skills`. This local collection contains battle-tested, pre-built skills spanning almost every software engineering, cloud, security, design, and automation domain.

---

## 🧭 How to Query the Local Library

Agents and developers can search the local skill index using simple shell commands:

### Search by Keyword
```powershell
Get-ChildItem -Path "C:\Users\Vinod krishna\antigravity_skills" -Directory | Where-Object { $_.Name -like "*<keyword>*" } | Select-Object Name
```

### Read Frontmatter of a Candidate Skill
```powershell
Get-Content -Path "C:\Users\Vinod krishna\antigravity_skills\<skill-name>\SKILL.md" -Head 15
```

### Import Skill into a Project
```powershell
Copy-Item -Path "C:\Users\Vinod krishna\antigravity_skills\<skill-name>" -Destination "d:\<project-path>\.agents\skills\<skill-name>" -Recurse
```

---

## 📂 Key Domains & Representative Skills

| Category | Typical Scenarios | Representative Skills |
|---|---|---|
| **Web & Frontend** | React, Next.js, Vue, Tailwind, UI/UX, State Management | `zustand-store-ts`, `zod-validation-expert`, `3d-web-experience`, `accessibility-compliance-accessibility-audit` |
| **Backend & APIs** | REST, GraphQL, Auth, Microservices | `api-development`, `jwt-auth`, `fastapi-backend`, `express-rest` |
| **Databases** | Schema design, migrations, indexing, ORMs | `prisma-schema`, `postgres-optimizer`, `mongo-aggregations`, `redis-cache` |
| **DevOps & Cloud** | CI/CD, Containerization, Infrastructure as Code | `docker-compose`, `kubernetes-ops`, `terraform-setup`, `aws-infra`, `ci-cd-pipelines` |
| **AI & LLMs** | Agent systems, RAG, prompt engineering, memory | `ai-agent-development`, `ai-engineer`, `agent-orchestrator`, `agent-memory-mcp`, `agent-tool-builder` |
| **Testing & Quality** | E2E, Unit tests, A/B testing, Acceptance testing | `ab-test-setup`, `acceptance-orchestrator`, `playwright-e2e`, `jest-unit-tests` |
| **Security** | Audits, penetration testing, compliance | `zeroize-audit`, `xss-html-injection`, `active-directory-attacks` |
| **Workflows** | Background jobs, automation, orchestration | `workflow-automation`, `workflow-orchestration-patterns`, `task-automation` |

---

## 🔗 Integrated Skills in Game Dojo

The following Game Dojo skills actively consult this local repository:
* [game-dojo-bootstrap](file:///d:/Game_dojo/.agents/skills/game-dojo-bootstrap/SKILL.md) — Checks local library during Phase 3 & 4.
* [ecosystem-scanner](file:///d:/Game_dojo/.agents/skills/ecosystem-scanner/SKILL.md) — Discovers matching local skills before querying marketplace.
* [skill-crafter](file:///d:/Game_dojo/.agents/skills/skill-crafter/SKILL.md) — Adapts existing local skills instead of writing from scratch.
