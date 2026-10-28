---
name: ecosystem-scanner
description: "Scans for and recommends Antigravity plugins, MCP servers, and development tools based on a project's tech stack. Use this skill when the agent needs to find relevant marketplace plugins, configure MCP servers, or recommend package dependencies for a specific technology stack."
---

# Ecosystem Scanner Skill

Discover and recommend Antigravity plugins, MCP server configurations, and package dependencies tailored to a project's technology stack.

## Overview

After gathering a project's tech stack, use this skill to:
1. Scan the **Local Skills Library** (`C:\Users\Vinod krishna\antigravity_skills`) for matching pre-built skills.
2. Search the Antigravity marketplace for relevant plugins.
3. Map technologies to MCP server configurations.
4. Recommend essential and optional package dependencies.
5. Generate ready-to-use `mcp_config.json` entries.
6. Check what's already installed to avoid duplicates.

---

## 📦 Scanning the Local Skills Library

The workspace has access to **1,320+ pre-built skills** at:
`C:\Users\Vinod krishna\antigravity_skills`

Always scan this local directory first before searching external sources or generating new skills from scratch.

### Local Search Procedure
1. Search folder names matching the project's tech keywords:
   ```powershell
   Get-ChildItem -Path "C:\Users\Vinod krishna\antigravity_skills" -Directory | Where-Object { $_.Name -like "*<keyword>*" }
   ```
2. Inspect the candidate skill's `SKILL.md` header:
   ```powershell
   Get-Content "C:\Users\Vinod krishna\antigravity_skills\<skill-name>\SKILL.md" -Head 15
   ```
3. If it fits the project's requirements, copy it into the project's `.agents/skills/` folder:
   ```powershell
   Copy-Item -Path "C:\Users\Vinod krishna\antigravity_skills\<skill-name>" -Destination "<project_root>\.agents\skills\<skill-name>" -Recurse
   ```

---

## Searching the Marketplace

Use the `search_marketplace` tool (if available) to find Antigravity plugins.

### Search Strategy

For each major technology in the stack, run a targeted search:

```
search_marketplace("react")          → UI component plugins
search_marketplace("postgresql")     → Database management plugins
search_marketplace("testing")        → Test runner plugins
search_marketplace("deployment")     → CI/CD and deploy plugins
search_marketplace("documentation")  → Doc generation plugins
```

### Search Categories by Project Type

| Project Type | Search Terms |
|---|---|
| Web API | `rest`, `graphql`, `openapi`, `swagger`, `postman`, `api-testing` |
| Web App (React) | `react`, `nextjs`, `tailwind`, `storybook`, `component`, `css` |
| Web App (Vue) | `vue`, `nuxt`, `vuetify`, `pinia` |
| Mobile (React Native) | `react-native`, `expo`, `mobile`, `device` |
| Mobile (Flutter) | `flutter`, `dart`, `firebase`, `mobile` |
| CLI Tool | `cli`, `terminal`, `shell`, `commander` |
| AI/ML | `python`, `jupyter`, `tensorflow`, `pytorch`, `ml`, `data` |
| Game Dev | `unity`, `godot`, `unreal`, `blender`, `3d`, `game` |

### Evaluating Results

For each plugin found, assess:
1. **Relevance** — Does it directly support a technology in the stack?
2. **Maintenance** — Is it actively maintained (check last update)?
3. **Popularity** — How many installs/stars does it have?
4. **Overlap** — Does it duplicate functionality of another recommended plugin?

Only recommend plugins that score well on relevance. Present results with a one-line justification.

## Mapping Tech Stacks to MCP Servers

MCP servers extend the agent's capabilities with specialized tools. Map each technology to its corresponding MCP server.

### Database MCP Configurations

#### PostgreSQL

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://user:password@localhost:5432/dbname"],
      "env": {}
    }
  }
}
```

**Capabilities**: Query execution, schema inspection, table management, migration support.

#### MongoDB

```json
{
  "mcpServers": {
    "mongodb": {
      "command": "npx",
      "args": ["-y", "mcp-mongo-server", "mongodb://localhost:27017/dbname"],
      "env": {}
    }
  }
}
```

**Capabilities**: Document queries, collection management, aggregation pipelines, index management.

#### SQLite

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./data/database.sqlite"],
      "env": {}
    }
  }
}
```

**Capabilities**: Local database queries, schema management, lightweight data storage.

#### Redis

```json
{
  "mcpServers": {
    "redis": {
      "command": "npx",
      "args": ["-y", "mcp-redis-server"],
      "env": {
        "REDIS_URL": "redis://localhost:6379"
      }
    }
  }
}
```

**Capabilities**: Key-value operations, pub/sub, cache management, session storage.

### Cloud Service MCP Configurations

#### AWS

```json
{
  "mcpServers": {
    "aws": {
      "command": "npx",
      "args": ["-y", "mcp-aws-server"],
      "env": {
        "AWS_REGION": "us-east-1",
        "AWS_PROFILE": "default"
      }
    }
  }
}
```

#### Firebase

```json
{
  "mcpServers": {
    "firebase": {
      "command": "npx",
      "args": ["-y", "mcp-firebase-server"],
      "env": {
        "FIREBASE_PROJECT_ID": "your-project-id"
      }
    }
  }
}
```

#### Supabase

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "mcp-supabase-server"],
      "env": {
        "SUPABASE_URL": "https://your-project.supabase.co",
        "SUPABASE_KEY": "your-anon-key"
      }
    }
  }
}
```

### Development Tool MCP Configurations

#### Playwright (Browser Testing)

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp-server"],
      "env": {}
    }
  }
}
```

#### Docker

```json
{
  "mcpServers": {
    "docker": {
      "command": "npx",
      "args": ["-y", "mcp-docker-server"],
      "env": {}
    }
  }
}
```

#### Git

```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git", "--repository", "."],
      "env": {}
    }
  }
}
```

## Tech Stack → MCP Server Mapping Reference

| Technology | MCP Server | Priority |
|---|---|---|
| PostgreSQL | `postgres` | Required |
| MySQL | `mysql` | Required |
| MongoDB | `mongodb` | Required |
| SQLite | `sqlite` | Required |
| Redis | `redis` | Recommended |
| AWS (S3, Lambda, etc.) | `aws` | Required |
| Firebase | `firebase` | Required |
| Supabase | `supabase` | Required |
| Docker | `docker` | Recommended |
| Playwright / E2E testing | `playwright` | Recommended |
| Git (advanced ops) | `git` | Optional |
| Blender / 3D | `blender` | Required |
| Chrome DevTools | `chrome-devtools-mcp` | Recommended (web apps) |

**Priority levels**:
- **Required** — The project directly uses this technology; the MCP server is essential.
- **Recommended** — The MCP server significantly improves the development workflow.
- **Optional** — Nice to have but not critical.

## Identifying Package Dependencies

Based on the project's tech stack, recommend essential packages.

### Node.js / TypeScript Projects

| Category | Packages | When to Recommend |
|---|---|---|
| Framework | `express`, `fastify`, `nestjs`, `koa` | Based on user choice |
| ORM | `prisma`, `drizzle-orm`, `typeorm`, `sequelize` | When using SQL database |
| ODM | `mongoose`, `mongodb` | When using MongoDB |
| Validation | `zod`, `joi`, `yup` | Always for APIs |
| Auth | `passport`, `jsonwebtoken`, `bcrypt` | When auth is needed |
| Testing | `vitest`, `jest`, `supertest` | Always |
| Linting | `eslint`, `prettier` | Always |
| Environment | `dotenv`, `cross-env` | Always |
| Logging | `winston`, `pino` | Production APIs |
| HTTP Client | `axios`, `node-fetch` | When calling external APIs |

### Python Projects

| Category | Packages | When to Recommend |
|---|---|---|
| Framework | `fastapi`, `flask`, `django` | Based on user choice |
| ORM | `sqlalchemy`, `tortoise-orm` | When using SQL database |
| Validation | `pydantic` | Always with FastAPI; recommended otherwise |
| Testing | `pytest`, `pytest-cov`, `httpx` | Always |
| Linting | `ruff`, `black`, `mypy` | Always |
| Environment | `python-dotenv` | Always |
| Async | `uvicorn`, `gunicorn` | Production APIs |
| ML/AI | `numpy`, `pandas`, `scikit-learn`, `torch` | AI/ML projects |

### Frontend Projects

| Category | Packages | When to Recommend |
|---|---|---|
| State Management | `zustand`, `redux-toolkit`, `pinia` | Complex state needs |
| Routing | `react-router`, `vue-router` | SPAs |
| Styling | `tailwindcss`, `styled-components`, `sass` | Based on user choice |
| UI Library | `shadcn/ui`, `radix-ui`, `headlessui` | When rapid UI needed |
| Forms | `react-hook-form`, `formik` | Form-heavy apps |
| Data Fetching | `tanstack-query`, `swr`, `axios` | API-consuming apps |
| Testing | `vitest`, `testing-library`, `playwright` | Always |

## Checking Installed Plugins

Before recommending a plugin, check if it's already installed:

1. Read the current `mcp_config.json` if it exists — any server listed there is already configured.
2. Check `plugin.json` or the Antigravity plugin registry for installed plugins.
3. Scan `package.json` (Node) or `requirements.txt` / `pyproject.toml` (Python) for installed packages.

If a recommended item is already installed, mark it with ✅ and skip the installation instruction.

## Presenting Recommendations

Format recommendations as a prioritized list with one-line justifications:

### Example Output Format

```markdown
## Recommended MCP Servers

| Server | Status | Justification |
|---|---|---|
| `postgres` | 🔧 Configure | Direct database access for schema inspection and queries |
| `playwright` | 📦 Install | End-to-end testing for your React frontend |
| `docker` | 💡 Optional | Container management if you adopt Docker for deployment |

## Recommended Plugins

| Plugin | Status | Justification |
|---|---|---|
| `prisma-helper` | 📦 Install | Schema visualization and migration management for Prisma ORM |
| `tailwind-intellisense` | ✅ Installed | Already configured |

## Recommended Packages

### Production Dependencies
- `express` — HTTP server framework (your chosen framework)
- `prisma` — Type-safe ORM for PostgreSQL
- `zod` — Runtime schema validation for API inputs

### Dev Dependencies
- `vitest` — Fast unit test runner with native TypeScript support
- `eslint` — Code linting with auto-fixable rules
- `prettier` — Consistent code formatting
```

## Generating the mcp_config.json

When generating the final `mcp_config.json`:

1. Start with an empty `{ "mcpServers": {} }` object.
2. Add each recommended MCP server using the templates above.
3. Replace placeholder values (database URLs, project IDs, API keys) with environment variable references or sensible defaults with comments.
4. Validate the resulting JSON is syntactically correct.
5. Write the file to the project root or `.gemini/` directory as appropriate.

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost:5432/myapp_dev"],
      "env": {}
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp-server"],
      "env": {}
    }
  }
}
```

## Reference

For the full ecosystem mapping of technologies to tools, consult:

```
.agents/skills/game-dojo-bootstrap/references/ecosystem-map.md
```

That file contains the comprehensive mapping of every supported technology to its recommended plugins, MCP servers, and packages.
