# 🥋 Team Mode Templates

Base configuration and task templates for multi-member human+AI teams in Game Dojo workspaces. When Team Mode is activated (via `--team` flag, team size > 1, or team-orchestrator skill), these templates generate the `.ai-team/` directory and `CODEOWNERS` file to establish boundaries, roles, task contracts, and review workflows.

Every template uses `{{PLACEHOLDER}}` variables that are populated during workspace bootstrapping or task creation. Every placeholder is surrounded by double curly braces and must be replaced with concrete values.

---

## 1. `.ai-team/team.json` Template

This file defines team membership, roles, module ownership, permissions, and communication protocols. It is the single source of truth for who can touch what in the codebase.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "project": {
    "name": "{{PROJECT_NAME}}",
    "slug": "{{PROJECT_SLUG}}",
    "description": "{{PROJECT_DESCRIPTION}}",
    "repository": "{{REPOSITORY_URL}}",
    "defaultBranch": "{{DEFAULT_BRANCH}}"
  },
  "teamName": "{{PROJECT_NAME}} Team",
  "version": "1.0.0",
  "lead": "{{LEAD_MEMBER_ID}}",
  "createdAt": "{{CREATED_DATE}}",
  "updatedAt": "{{UPDATED_DATE}}",
  "policies": {
    "enforceTouchesFiles": true,
    "requireContractConformance": true,
    "requireReviewForContractChanges": true,
    "requirePrForMain": true,
    "minPrApprovals": {{MIN_PR_APPROVALS}},
    "requireTestsPassing": true,
    "requireCodeownersReview": true,
    "autoAssignCodeowners": true,
    "taskBranchPrefix": "feat/",
    "allowDirectMainCommits": false
  },
  "settings": {
    "enforceTaskBoundaries": true,
    "requirePrForMain": true,
    "minPrApprovals": {{MIN_PR_APPROVALS}},
    "requireTestsPassing": true,
    "requireCodeownersReview": true,
    "autoAssignCodeowners": true,
    "taskBranchPrefix": "feat/",
    "allowDirectMainCommits": false
  },
  "roles": {
    "lead": {
      "title": "Technical Lead / Architect",
      "description": "Responsible for overall architecture, plan approvals, schema migrations, and merging to main.",
      "permissions": {
        "canEditPlan": true,
        "canCreateTasks": true,
        "canAssignTasks": true,
        "canModifySharedConfigs": true,
        "canApprovePRs": true,
        "canMergeToMain": true
      }
    },
    "engineer": {
      "title": "Software Engineer",
      "description": "Responsible for implementing features and bugfixes within assigned task boundaries.",
      "permissions": {
        "canEditPlan": false,
        "canCreateTasks": true,
        "canAssignTasks": false,
        "canModifySharedConfigs": false,
        "canApprovePRs": true,
        "canMergeToMain": false
      }
    },
    "ai_agent": {
      "title": "AI Pair Programmer / Coding Worker",
      "description": "Autonomous or guided AI agent executing assigned tasks strictly within designated allowedPaths.",
      "permissions": {
        "canEditPlan": false,
        "canCreateTasks": false,
        "canAssignTasks": false,
        "canModifySharedConfigs": false,
        "canApprovePRs": false,
        "canMergeToMain": false
      }
    },
    "qa": {
      "title": "Quality Assurance / Test Engineer",
      "description": "Responsible for test suites, end-to-end scenarios, verification commands, and release sign-off.",
      "permissions": {
        "canEditPlan": false,
        "canCreateTasks": true,
        "canAssignTasks": false,
        "canModifySharedConfigs": false,
        "canApprovePRs": true,
        "canMergeToMain": false
      }
    }
  },
  "members": [
    {
      "id": "{{LEAD_MEMBER_ID}}",
      "name": "{{LEAD_MEMBER_NAME}}",
      "email": "{{LEAD_MEMBER_EMAIL}}",
      "githubUsername": "{{LEAD_GITHUB_USERNAME}}",
      "role": "lead",
      "type": "human",
      "weeklyHours": {{LEAD_WEEKLY_HOURS}},
      "experienceLevel": "{{LEAD_EXPERIENCE_LEVEL}}",
      "timezone": "{{LEAD_TIMEZONE}}",
      "status": "active",
      "assignedDomains": [
        "architecture",
        "infra",
        "core",
        "contracts"
      ],
      "activeTasks": []
    },
    {
      "id": "{{DEV1_MEMBER_ID}}",
      "name": "{{DEV1_MEMBER_NAME}}",
      "email": "{{DEV1_MEMBER_EMAIL}}",
      "githubUsername": "{{DEV1_GITHUB_USERNAME}}",
      "role": "engineer",
      "type": "human",
      "weeklyHours": {{DEV1_WEEKLY_HOURS}},
      "experienceLevel": "{{DEV1_EXPERIENCE_LEVEL}}",
      "timezone": "{{DEV1_TIMEZONE}}",
      "status": "active",
      "assignedDomains": [
        "{{DEV1_PRIMARY_DOMAIN}}"
      ],
      "activeTasks": []
    },
    {
      "id": "{{DEV2_MEMBER_ID}}",
      "name": "{{DEV2_MEMBER_NAME}}",
      "email": "{{DEV2_MEMBER_EMAIL}}",
      "githubUsername": "{{DEV2_GITHUB_USERNAME}}",
      "role": "engineer",
      "type": "human",
      "weeklyHours": {{DEV2_WEEKLY_HOURS}},
      "experienceLevel": "{{DEV2_EXPERIENCE_LEVEL}}",
      "timezone": "{{DEV2_TIMEZONE}}",
      "status": "active",
      "assignedDomains": [
        "{{DEV2_PRIMARY_DOMAIN}}"
      ],
      "activeTasks": []
    },
    {
      "id": "{{AI_AGENT_ID}}",
      "name": "{{AI_AGENT_NAME}}",
      "email": "{{AI_AGENT_EMAIL}}",
      "githubUsername": "{{AI_AGENT_GITHUB_USERNAME}}",
      "role": "ai_agent",
      "type": "agent",
      "weeklyHours": 168,
      "experienceLevel": "autonomous-agent",
      "timezone": "UTC",
      "status": "active",
      "assignedDomains": [
        "implementation",
        "refactor",
        "unit-tests"
      ],
      "activeTasks": []
    }
  ],
  "domainOwnership": {
    "frontend": {
      "paths": [
        "src/client/**",
        "src/components/**",
        "src/pages/**",
        "src/styles/**"
      ],
      "primaryOwners": [
        "{{DEV1_MEMBER_ID}}"
      ],
      "backupOwners": [
        "{{LEAD_MEMBER_ID}}"
      ]
    },
    "backend": {
      "paths": [
        "src/server/**",
        "src/api/**",
        "src/services/**",
        "src/controllers/**"
      ],
      "primaryOwners": [
        "{{DEV2_MEMBER_ID}}"
      ],
      "backupOwners": [
        "{{LEAD_MEMBER_ID}}"
      ]
    },
    "database": {
      "paths": [
        "prisma/**",
        "src/db/**",
        "migrations/**"
      ],
      "primaryOwners": [
        "{{LEAD_MEMBER_ID}}"
      ],
      "backupOwners": [
        "{{DEV2_MEMBER_ID}}"
      ]
    },
    "infra": {
      "paths": [
        ".github/**",
        "docker/**",
        "Dockerfile",
        "docker-compose.yml",
        "scripts/**"
      ],
      "primaryOwners": [
        "{{LEAD_MEMBER_ID}}"
      ],
      "backupOwners": []
    },
    "contracts": {
      "paths": [
        "docs/contracts/**",
        "contracts/**"
      ],
      "primaryOwners": [
        "{{LEAD_MEMBER_ID}}"
      ],
      "backupOwners": []
    },
    "team_governance": {
      "paths": [
        ".ai-team/**",
        "CODEOWNERS",
        "GEMINI.md",
        "AGENTS.md"
      ],
      "primaryOwners": [
        "{{LEAD_MEMBER_ID}}"
      ],
      "backupOwners": []
    }
  },
  "communication": {
    "chatChannel": "{{COMMUNICATION_CHANNEL}}",
    "notificationsUrl": "{{WEBHOOK_NOTIFICATIONS_URL}}",
    "prReviewPolicy": "All feature PRs require at least one human review before merge. AI agent PRs require review from the domain primary owner."
  }
}
```

---

## 2. `.ai-team/plan.json` Template

This file establishes the roadmap, phases, milestones, critical path, and shared resource locks across all team streams. It coordinates work to ensure team members and AI agents never trigger merge collisions or out-of-order execution.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "project": "{{PROJECT_NAME}}",
  "version": "1.0.0",
  "lastUpdated": "{{UPDATED_DATE}}",
  "status": "in_progress",
  "targetReleaseDate": "{{TARGET_RELEASE_DATE}}",
  "architectureSummary": "{{ARCHITECTURE_SUMMARY}}",
  "contractFreezeGates": [
    {
      "contract": "docs/contracts/api-spec.json",
      "status": "frozen",
      "frozenAt": "{{CREATED_DATE}}",
      "reviewers": [
        "{{LEAD_MEMBER_ID}}"
      ]
    },
    {
      "contract": "docs/contracts/data-model.json",
      "status": "frozen",
      "frozenAt": "{{CREATED_DATE}}",
      "reviewers": [
        "{{LEAD_MEMBER_ID}}"
      ]
    }
  ],
  "executionWaves": [
    {
      "wave": 1,
      "name": "Wave 1: Foundation & Project Skeleton",
      "milestoneIds": [
        "M1-SKELETON"
      ],
      "status": "completed"
    },
    {
      "wave": 2,
      "name": "Wave 2: Data Persistence & Shared Contracts",
      "milestoneIds": [
        "M2-DATA-AUTH"
      ],
      "status": "in_progress"
    },
    {
      "wave": 3,
      "name": "Wave 3: Parallel Feature Streams",
      "milestoneIds": [
        "M3-CORE-FEATURES",
        "M4-FRONTEND-UI"
      ],
      "status": "todo"
    },
    {
      "wave": 4,
      "name": "Wave 4: Hardening & Release Gate",
      "milestoneIds": [
        "M5-HARDENING"
      ],
      "status": "todo"
    }
  ],
  "phases": [
    {
      "id": "phase-1",
      "name": "Phase 1: Foundation & Project Skeleton",
      "description": "Initialize repository structure, core dependencies, linting, shared types, and baseline CI/CD pipelines.",
      "status": "completed",
      "startDate": "{{PHASE1_START_DATE}}",
      "targetEndDate": "{{PHASE1_END_DATE}}",
      "milestoneIds": [
        "M1-SKELETON"
      ]
    },
    {
      "id": "phase-2",
      "name": "Phase 2: Core Domain Models & Data Layer",
      "description": "Define database schemas, migrations, repositories, authentication contracts, and base API middleware.",
      "status": "in_progress",
      "startDate": "{{PHASE2_START_DATE}}",
      "targetEndDate": "{{PHASE2_END_DATE}}",
      "milestoneIds": [
        "M2-DATA-AUTH"
      ]
    },
    {
      "id": "phase-3",
      "name": "Phase 3: Parallel Feature Streams",
      "description": "Implement frontend user journeys, backend API endpoints, domain logic, and integrations in parallel.",
      "status": "todo",
      "startDate": "{{PHASE3_START_DATE}}",
      "targetEndDate": "{{PHASE3_END_DATE}}",
      "milestoneIds": [
        "M3-CORE-FEATURES",
        "M4-FRONTEND-UI"
      ]
    },
    {
      "id": "phase-4",
      "name": "Phase 4: Integration, Hardening & Quality Gate",
      "description": "End-to-end integration testing, performance benchmarking, security review, and ratcheting to 95+ score.",
      "status": "todo",
      "startDate": "{{PHASE4_START_DATE}}",
      "targetEndDate": "{{PHASE4_END_DATE}}",
      "milestoneIds": [
        "M5-HARDENING"
      ]
    }
  ],
  "milestones": [
    {
      "id": "M1-SKELETON",
      "title": "Workspace Skeleton & Developer Experience",
      "description": "Clean repo initialized with build tooling, test runner, git hooks, and .ai-team orchestration.",
      "phaseId": "phase-1",
      "status": "completed",
      "targetDate": "{{M1_TARGET_DATE}}",
      "progressPercentage": 100,
      "taskIds": [
        "TASK-001",
        "TASK-002"
      ],
      "deliverables": [
        "Package manifest and lockfile committed",
        "CI build and test workflow passing",
        "Base documentation and team manifests configured"
      ]
    },
    {
      "id": "M2-DATA-AUTH",
      "title": "Data Persistence & Authentication Layer",
      "description": "Database schema migrations applied, authentication middleware operational, user entity tests passing.",
      "phaseId": "phase-2",
      "status": "in_progress",
      "targetDate": "{{M2_TARGET_DATE}}",
      "progressPercentage": 40,
      "taskIds": [
        "TASK-003",
        "TASK-004",
        "TASK-005"
      ],
      "deliverables": [
        "Database schema migrations validated",
        "JWT/Session authentication endpoints active",
        "Role-based access control middleware implemented"
      ]
    },
    {
      "id": "M3-CORE-FEATURES",
      "title": "Core Business Logic & Backend Services",
      "description": "REST/GraphQL endpoints and domain service layer for primary application capabilities.",
      "phaseId": "phase-3",
      "status": "todo",
      "targetDate": "{{M3_TARGET_DATE}}",
      "progressPercentage": 0,
      "taskIds": [
        "TASK-006",
        "TASK-007"
      ],
      "deliverables": [
        "Core service methods covered by unit tests",
        "API routes validated with integration tests"
      ]
    },
    {
      "id": "M4-FRONTEND-UI",
      "title": "Responsive Client Application & Design System",
      "description": "Client UI components, view routes, state management, and API consumption hooks.",
      "phaseId": "phase-3",
      "status": "todo",
      "targetDate": "{{M4_TARGET_DATE}}",
      "progressPercentage": 0,
      "taskIds": [
        "TASK-008",
        "TASK-009"
      ],
      "deliverables": [
        "Responsive views matching design specifications",
        "Accessible forms with client-side validation",
        "End-to-end user flows working against mock/live API"
      ]
    },
    {
      "id": "M5-HARDENING",
      "title": "Production Hardening, Testing & Launch",
      "description": "Full end-to-end verification, load testing, security scan, and deployment automation.",
      "phaseId": "phase-4",
      "status": "todo",
      "targetDate": "{{M5_TARGET_DATE}}",
      "progressPercentage": 0,
      "taskIds": [
        "TASK-010"
      ],
      "deliverables": [
        "100% test pass rate across unit and integration suites",
        "Security audit passing with 0 high/critical vulnerabilities",
        "Automated deployment script verified in staging environment"
      ]
    }
  ],
  "criticalPath": [
    "TASK-001",
    "TASK-003",
    "TASK-004",
    "TASK-006",
    "TASK-008",
    "TASK-010"
  ],
  "sharedResourceLocks": {
    "package.json": {
      "lockedByTaskId": null,
      "reason": "Top-level dependencies must be coordinated. Only one task may modify dependencies at a time."
    },
    "prisma/schema.prisma": {
      "lockedByTaskId": null,
      "reason": "Database schema migrations must follow strict serial ordering to prevent migration conflicts."
    },
    "src/router.ts": {
      "lockedByTaskId": null,
      "reason": "Root route table requires atomic route registration."
    }
  }
}
```

---

## 3. `.ai-team/tasks/task-template.json` Template

This is the atomic task specification for any human or AI team member. Every branch in git corresponds to exactly one task file (`feat/<task-id>-<slug>`). The agent reads this file upon branch switch and strictly confines its actions to the defined bounds.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "id": "{{TASK_ID}}",
  "title": "{{TASK_TITLE}}",
  "slug": "{{TASK_SLUG}}",
  "description": "{{TASK_DESCRIPTION}}",
  "type": "{{TASK_TYPE}}",
  "priority": "{{TASK_PRIORITY}}",
  "status": "{{TASK_STATUS}}",
  "milestoneId": "{{MILESTONE_ID}}",
  "stream": "{{TASK_STREAM}}",
  "branch": "feat/{{TASK_ID}}-{{TASK_SLUG}}",
  "baseBranch": "{{DEFAULT_BRANCH}}",
  "creator": {
    "id": "{{CREATOR_ID}}",
    "name": "{{CREATOR_NAME}}",
    "timestamp": "{{CREATED_DATE}}"
  },
  "assignee": {
    "id": "{{ASSIGNEE_ID}}",
    "name": "{{ASSIGNEE_NAME}}",
    "type": "{{ASSIGNEE_TYPE}}"
  },
  "reviewers": [
    "{{REVIEWER_ID_1}}",
    "{{REVIEWER_ID_2}}"
  ],
  "dependencies": [
    "{{DEPENDENCY_TASK_ID}}"
  ],
  "blockedBy": [],
  "contractDependencies": [
    "docs/contracts/api-spec.json#/paths/~1{{TASK_SLUG}}"
  ],
  "touchesFiles": [
    "src/modules/{{TASK_SLUG}}/**",
    "tests/modules/{{TASK_SLUG}}/**",
    "docs/features/{{TASK_SLUG}}.md"
  ],
  "allowedPaths": [
    "src/modules/{{TASK_SLUG}}/**",
    "tests/modules/{{TASK_SLUG}}/**",
    "docs/features/{{TASK_SLUG}}.md"
  ],
  "forbiddenPaths": [
    ".ai-team/team.json",
    ".ai-team/plan.json",
    "CODEOWNERS",
    "docs/contracts/**",
    "prisma/schema.prisma",
    "package.json"
  ],
  "acceptanceCriteria": [
    "{{ACCEPTANCE_CRITERIA_1}}",
    "{{ACCEPTANCE_CRITERIA_2}}",
    "{{ACCEPTANCE_CRITERIA_3}}",
    "All unit and integration tests pass with zero warnings",
    "Code passes linter and type-checker with zero errors"
  ],
  "verification": {
    "testCommand": "npm test -- tests/modules/{{TASK_SLUG}}",
    "lintCommand": "npm run lint"
  },
  "verificationCommands": [
    "npm run lint",
    "npm run typecheck",
    "npm test -- tests/modules/{{TASK_SLUG}}"
  ],
  "schedule": {
    "estimatedHours": {{ESTIMATED_HOURS}},
    "actualHours": 0,
    "startedAt": null,
    "completedAt": null,
    "mergedAt": null
  },
  "pullRequest": {
    "number": null,
    "url": null,
    "title": "{{TASK_TYPE}}({{TASK_SLUG}}): [{{TASK_ID}}] {{TASK_TITLE}}",
    "draft": true,
    "merged": false
  },
  "blockers": [],
  "notes": "{{TASK_IMPLEMENTATION_NOTES}}",
  "changelog": [
    {
      "timestamp": "{{CREATED_DATE}}",
      "author": "{{CREATOR_ID}}",
      "action": "task_created",
      "details": "Task initialized from template"
    }
  ]
}
```

### Task Field Specifications

| Field | Type | Description |
|---|---|---|
| `id` | `string` | Unique identifier following pattern `TASK-XXX` or `<prefix>-XXX` (e.g. `TASK-003`). |
| `title` | `string` | Concise, imperative action title (e.g. "Implement user authentication middleware"). |
| `slug` | `string` | Kebab-case URL-safe identifier (e.g. `user-auth-middleware`). |
| `type` | `string` | One of: `feature`, `fix`, `refactor`, `chore`, `docs`, `test`, `security`. |
| `priority` | `string` | One of: `critical`, `high`, `medium`, `low`. |
| `status` | `string` | One of: `todo`, `in_progress`, `in_review`, `done`, `blocked`. |
| `stream` | `string` | Domain work stream (e.g. `frontend`, `backend`, `infra`, `database`). |
| `dependencies` | `array` | List of task IDs that must have status `done` before this task can start. |
| `blockedBy` | `array` | Dynamic list of current blocker identifiers or prerequisite tasks. |
| `contractDependencies` | `array` | URIs or paths to frozen interface contracts this task implements or consumes. |
| `touchesFiles` | `array` | **Canonical boundary invariant**: Strict list of file paths or glob patterns permitted to touch. |
| `allowedPaths` | `array` | Compatibility alias matching `touchesFiles`. |
| `forbiddenPaths` | `array` | Explicit blacklist of sensitive or shared paths the agent must never edit under this task. |
| `verification` | `object` | Prescribed commands (`testCommand`, `lintCommand`) for automated verification. |
| `verificationCommands` | `array` | Exact shell commands that must exit with code 0 to transition to `in_review`. |
| `changelog` | `array` | Append-only audit trail tracking every status change, blocker, or scope expansion. |

---

## 4. `CODEOWNERS` Template

GitHub-compliant code ownership configuration enforcing domain expertise reviews and protecting shared orchestration files.

```
# ==============================================================================
# CODEOWNERS — {{PROJECT_NAME}}
# Single source of truth for code ownership and mandatory pull request reviewers.
# ==============================================================================

# Global fallback owners (all files unless matched by a more specific rule below)
*       @{{DEFAULT_OWNER_GITHUB}}

# ------------------------------------------------------------------------------
# Core Architecture & Agent Governance
# ------------------------------------------------------------------------------
/GEMINI.md                  @{{LEAD_GITHUB_USERNAME}}
/AGENTS.md                  @{{LEAD_GITHUB_USERNAME}}
/DESIGN_SYSTEM.md           @{{LEAD_GITHUB_USERNAME}}
/.agents/                   @{{LEAD_GITHUB_USERNAME}}
/.ai-team/                  @{{LEAD_GITHUB_USERNAME}}
/.ai-team/team.json         @{{LEAD_GITHUB_USERNAME}}
/.ai-team/plan.json         @{{LEAD_GITHUB_USERNAME}}
/CODEOWNERS                 @{{LEAD_GITHUB_USERNAME}}

# ------------------------------------------------------------------------------
# Shared Contracts (Immutable without Tech Lead approval)
# ------------------------------------------------------------------------------
/docs/contracts/            @{{LEAD_GITHUB_USERNAME}}
/contracts/                 @{{LEAD_GITHUB_USERNAME}}

# ------------------------------------------------------------------------------
# Infrastructure, Build & CI/CD Pipelines
# ------------------------------------------------------------------------------
/.github/                   @{{LEAD_GITHUB_USERNAME}}
/docker/                    @{{LEAD_GITHUB_USERNAME}}
/Dockerfile                 @{{LEAD_GITHUB_USERNAME}}
/docker-compose*.yml        @{{LEAD_GITHUB_USERNAME}}
/package.json               @{{LEAD_GITHUB_USERNAME}}
/package-lock.json          @{{LEAD_GITHUB_USERNAME}}
/tsconfig*.json             @{{LEAD_GITHUB_USERNAME}}
/scripts/                   @{{LEAD_GITHUB_USERNAME}}

# ------------------------------------------------------------------------------
# Database Schemas & Migrations
# ------------------------------------------------------------------------------
/prisma/                    @{{DEV2_GITHUB_USERNAME}} @{{LEAD_GITHUB_USERNAME}}
/src/db/                    @{{DEV2_GITHUB_USERNAME}} @{{LEAD_GITHUB_USERNAME}}
/migrations/                @{{DEV2_GITHUB_USERNAME}} @{{LEAD_GITHUB_USERNAME}}

# ------------------------------------------------------------------------------
# Backend Services & API Endpoints
# ------------------------------------------------------------------------------
/src/server/                @{{DEV2_GITHUB_USERNAME}}
/src/api/                   @{{DEV2_GITHUB_USERNAME}}
/src/services/              @{{DEV2_GITHUB_USERNAME}}
/src/controllers/           @{{DEV2_GITHUB_USERNAME}}
/src/models/                @{{DEV2_GITHUB_USERNAME}}

# ------------------------------------------------------------------------------
# Frontend Application, Views & Styling
# ------------------------------------------------------------------------------
/src/client/                @{{DEV1_GITHUB_USERNAME}}
/src/components/            @{{DEV1_GITHUB_USERNAME}}
/src/pages/                 @{{DEV1_GITHUB_USERNAME}}
/src/views/                 @{{DEV1_GITHUB_USERNAME}}
/src/styles/                @{{DEV1_GITHUB_USERNAME}}
/src/assets/                @{{DEV1_GITHUB_USERNAME}}

# ------------------------------------------------------------------------------
# Documentation
# ------------------------------------------------------------------------------
/docs/                      @{{LEAD_GITHUB_USERNAME}} @{{DEV1_GITHUB_USERNAME}}
/README.md                  @{{LEAD_GITHUB_USERNAME}}
```

---

## 5. Usage in Project Scaffolding

When Game Dojo bootstraps a project with Team Mode:

1. **Intake Phase:** Determines team composition (`members`), roles, and technical domains.
2. **Analysis Phase:** Generates the Work Breakdown Structure (WBS) into `plan.json` milestones and initial `tasks/*.json`.
3. **Skeleton Phase:**
   - Populates `.ai-team/team.json` with team members and permission matrix.
   - Populates `.ai-team/plan.json` with phases and critical path.
   - Writes individual task files into `.ai-team/tasks/TASK-001.json`, `TASK-002.json`, etc.
   - Writes root `CODEOWNERS` mapped to GitHub handles from `team.json`.
4. **Development Phase:** The `team-orchestrator` skill enforces active task boundaries on every git branch switch.
