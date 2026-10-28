# Ecosystem Map

A mapping of technologies to their Antigravity ecosystem resources — marketplace plugins, MCP servers, recommended skills, and lifecycle hooks.

---

## 📚 Primary Resource: Local Skills Library

> **Local Path:** `C:\Users\Vinod krishna\antigravity_skills`
> **Index & Guide:** [references/local-skills-library.md](local-skills-library.md)
> **Available Skills:** 1,320+ pre-built skills across DevOps, AI, Frontend, Backend, Databases, Security, and Testing.

Before fetching external plugins or generating skills from scratch, **Game Dojo queries this local directory first** and copies or adapts matching skills directly into `.agents/skills/`.

---

## React

### Marketplace Plugins
- `antigravity/react-patterns` — React component patterns and best practices
- `antigravity/react-testing` — Testing utilities for React components
- `antigravity/storybook-integration` — Storybook setup and story generation

### MCP Servers
```json
{
  "mcpServers": {
    "browser-tools": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-browser"],
      "env": {}
    }
  }
}
```

### Skills to Generate
- `component-creation` — Creating new React components with proper patterns (props interface, default exports, co-located styles/tests)
- `state-management` — Managing application state (Context, Zustand, Redux Toolkit patterns)
- `testing` — Writing component tests with React Testing Library

### Hooks
```json
{
  "event": "post_file_create",
  "match": "src/components/**/*.tsx",
  "steps": [
    { "action": "run", "command": "npx eslint --fix {{FILE}}" }
  ]
}
```

---

## Next.js

### Marketplace Plugins
- `antigravity/nextjs-toolkit` — Next.js patterns, App Router conventions, and server component guidance
- `antigravity/react-patterns` — React component patterns
- `antigravity/seo-toolkit` — SEO optimization for Next.js pages

### MCP Servers
```json
{
  "mcpServers": {
    "browser-tools": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-browser"],
      "env": {}
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### Skills to Generate
- `feature-development` — Full-stack feature development (page → API route → database → UI)
- `api-development` — Creating API routes with validation (Zod) and error handling
- `database-changes` — Prisma schema modifications, migration workflow, and seeding
- `component-creation` — Server components vs client components decision framework
- `deployment` — Vercel deployment, environment variables, and preview deploys

### Hooks
```json
{
  "event": "pre_commit",
  "steps": [
    { "action": "run", "command": "npx next lint" },
    { "action": "run", "command": "npx tsc --noEmit" }
  ]
}
```

---

## Vue

### Marketplace Plugins
- `antigravity/vue-patterns` — Vue 3 Composition API patterns and best practices
- `antigravity/vue-testing` — Testing utilities for Vue components

### MCP Servers
```json
{
  "mcpServers": {
    "browser-tools": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-browser"],
      "env": {}
    }
  }
}
```

### Skills to Generate
- `component-creation` — Vue SFC creation with Composition API patterns
- `state-management` — Pinia store patterns and best practices
- `testing` — Component testing with Vue Test Utils and Vitest

### Hooks
```json
{
  "event": "pre_commit",
  "steps": [
    { "action": "run", "command": "npx eslint --ext .vue,.ts,.js src/" }
  ]
}
```

---

## Angular

### Marketplace Plugins
- `antigravity/angular-patterns` — Angular component, service, and module patterns
- `antigravity/angular-testing` — Angular testing setup and utilities

### MCP Servers
```json
{
  "mcpServers": {
    "browser-tools": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-browser"],
      "env": {}
    }
  }
}
```

### Skills to Generate
- `component-creation` — Angular component creation with proper module registration
- `service-creation` — Injectable services with dependency injection patterns
- `testing` — Jasmine/Karma test patterns for components and services

### Hooks
```json
{
  "event": "pre_commit",
  "steps": [
    { "action": "run", "command": "npx ng lint" },
    { "action": "run", "command": "npx tsc --noEmit" }
  ]
}
```

---

## Node.js

### Marketplace Plugins
- `antigravity/nodejs-backend` — Express/Fastify patterns and middleware best practices
- `antigravity/api-testing` — API testing with Supertest

### MCP Servers
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-filesystem", "${PROJECT_ROOT}"],
      "env": {}
    }
  }
}
```

### Skills to Generate
- `api-development` — RESTful endpoint creation with proper middleware chain
- `error-handling` — Centralized error handling with custom error classes
- `testing` — Unit testing with Jest/Vitest, integration testing with Supertest
- `deployment` — Docker containerization and deployment

### Hooks
```json
{
  "event": "pre_commit",
  "steps": [
    { "action": "run", "command": "npx eslint src/" },
    { "action": "run", "command": "npx tsc --noEmit" }
  ]
}
```

---

## Python / Django

### Marketplace Plugins
- `antigravity/django-patterns` — Django views, models, and form patterns
- `antigravity/python-testing` — pytest configuration and fixture patterns

### MCP Servers
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-filesystem", "${PROJECT_ROOT}"],
      "env": {}
    }
  }
}
```

### Skills to Generate
- `feature-development` — Django app creation (model → view → template → URL)
- `api-development` — Django REST Framework serializer and viewset creation
- `database-changes` — Django model changes and migration workflow
- `testing` — pytest-django test patterns

### Hooks
```json
{
  "event": "pre_commit",
  "steps": [
    { "action": "run", "command": "ruff check ." },
    { "action": "run", "command": "mypy ." }
  ]
}
```

---

## Python / FastAPI

### Marketplace Plugins
- `antigravity/fastapi-patterns` — FastAPI route, dependency, and Pydantic patterns
- `antigravity/python-testing` — pytest configuration and async test patterns

### MCP Servers
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-filesystem", "${PROJECT_ROOT}"],
      "env": {}
    }
  }
}
```

### Skills to Generate
- `api-development` — FastAPI endpoint creation with Pydantic schemas and dependency injection
- `database-changes` — SQLAlchemy model changes + Alembic migrations
- `testing` — pytest with httpx async test client patterns
- `deployment` — Docker + uvicorn production deployment

### Hooks
```json
{
  "event": "pre_commit",
  "steps": [
    { "action": "run", "command": "ruff check ." },
    { "action": "run", "command": "ruff format --check ." },
    { "action": "run", "command": "mypy src/" }
  ]
}
```

---

## Flutter

### Marketplace Plugins
- `antigravity/flutter-patterns` — Widget patterns, state management, and navigation
- `antigravity/flutter-testing` — Widget and integration test patterns

### MCP Servers
```json
{
  "mcpServers": {
    "firebase": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-firebase"],
      "env": {
        "FIREBASE_PROJECT_ID": "${FIREBASE_PROJECT_ID}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-filesystem", "${PROJECT_ROOT}"],
      "env": {}
    }
  }
}
```

### Skills to Generate
- `feature-development` — Flutter feature development with clean architecture layers
- `screen-creation` — New screen creation with go_router navigation integration
- `state-management` — Riverpod/Bloc provider and state patterns
- `testing` — Widget tests, unit tests, and integration test patterns
- `deployment` — App store build, signing, and submission

### Hooks
```json
{
  "event": "pre_commit",
  "steps": [
    { "action": "run", "command": "dart analyze" },
    { "action": "run", "command": "dart format --set-exit-if-changed lib/" }
  ]
}
```

---

## Firebase

### Marketplace Plugins
- `antigravity/firebase-toolkit` — Firebase service configuration and security rules patterns

### MCP Servers
```json
{
  "mcpServers": {
    "firebase": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-firebase"],
      "env": {
        "FIREBASE_PROJECT_ID": "${FIREBASE_PROJECT_ID}",
        "FIREBASE_TOKEN": "${FIREBASE_TOKEN}"
      }
    }
  }
}
```

### Skills to Generate
- `firebase-setup` — Firebase project initialization and service configuration
- `security-rules` — Firestore and Storage security rules authoring
- `cloud-functions` — Firebase Cloud Functions development and deployment
- `authentication` — Firebase Auth integration patterns

### Hooks
```json
{
  "event": "pre_push",
  "steps": [
    { "action": "run", "command": "firebase emulators:exec --only firestore 'npm test'" }
  ]
}
```

---

## PostgreSQL

### Marketplace Plugins
- `antigravity/postgres-toolkit` — PostgreSQL query optimization and schema design patterns

### MCP Servers
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### Skills to Generate
- `database-changes` — Schema modification, migration creation, and rollback procedures
- `query-optimization` — Index strategy, query analysis with EXPLAIN, and N+1 prevention
- `data-seeding` — Development and test data seeding patterns

### Hooks
```json
{
  "event": "post_file_create",
  "match": "prisma/schema.prisma",
  "steps": [
    { "action": "run", "command": "npx prisma format" }
  ]
}
```

---

## MongoDB

### Marketplace Plugins
- `antigravity/mongodb-toolkit` — MongoDB schema design patterns and aggregation pipelines

### MCP Servers
```json
{
  "mcpServers": {
    "mongodb": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-mongodb"],
      "env": {
        "MONGODB_URI": "${MONGODB_URI}"
      }
    }
  }
}
```

### Skills to Generate
- `database-changes` — Mongoose model changes and data migration scripts
- `query-optimization` — Index strategy, aggregation pipeline patterns
- `data-seeding` — Seed script development with realistic test data

### Hooks
```json
{
  "event": "pre_commit",
  "match": "src/models/**/*.ts",
  "steps": [
    { "action": "run", "command": "npx eslint src/models/" }
  ]
}
```

---

## Docker

### Marketplace Plugins
- `antigravity/docker-toolkit` — Dockerfile best practices and multi-stage build patterns

### MCP Servers
```json
{
  "mcpServers": {
    "docker": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-docker"],
      "env": {}
    }
  }
}
```

### Skills to Generate
- `containerization` — Dockerfile creation with multi-stage builds and security hardening
- `docker-compose` — Multi-service development environment configuration
- `deployment` — Container registry publishing and orchestration

### Hooks
```json
{
  "event": "pre_push",
  "steps": [
    { "action": "run", "command": "docker build -t test-build ." }
  ]
}
```

---

## AWS

### Marketplace Plugins
- `antigravity/aws-toolkit` — AWS service patterns (S3, Lambda, ECS, RDS, CloudFront)
- `antigravity/infrastructure-as-code` — CloudFormation / CDK / Terraform patterns

### MCP Servers
```json
{
  "mcpServers": {
    "aws": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-aws"],
      "env": {
        "AWS_REGION": "${AWS_REGION}",
        "AWS_PROFILE": "${AWS_PROFILE}"
      }
    }
  }
}
```

### Skills to Generate
- `deployment` — AWS deployment (ECS, Lambda, or Elastic Beanstalk depending on project type)
- `infrastructure` — Infrastructure as Code with CDK or Terraform
- `s3-management` — S3 bucket configuration, policies, and lifecycle rules
- `monitoring` — CloudWatch dashboards, alarms, and log groups

### Hooks
```json
{
  "event": "pre_push",
  "steps": [
    { "action": "run", "command": "npx cdk synth", "description": "Validate CDK stack" }
  ]
}
```

---

## GCP (Google Cloud Platform)

### Marketplace Plugins
- `antigravity/gcp-toolkit` — GCP service patterns (Cloud Run, Cloud Functions, Cloud SQL, GCS)

### MCP Servers
```json
{
  "mcpServers": {
    "gcp": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-gcp"],
      "env": {
        "GOOGLE_PROJECT_ID": "${GOOGLE_PROJECT_ID}",
        "GOOGLE_APPLICATION_CREDENTIALS": "${GOOGLE_APPLICATION_CREDENTIALS}"
      }
    }
  }
}
```

### Skills to Generate
- `deployment` — Cloud Run or App Engine deployment
- `cloud-functions` — Google Cloud Functions development
- `storage` — Cloud Storage bucket management
- `monitoring` — Cloud Monitoring and Cloud Logging setup

### Hooks
```json
{
  "event": "pre_push",
  "steps": [
    { "action": "run", "command": "gcloud builds submit --tag gcr.io/${PROJECT_ID}/test --no-push" }
  ]
}
```

---

## Vercel

### Marketplace Plugins
- `antigravity/vercel-toolkit` — Vercel deployment patterns, edge functions, and environment management

### MCP Servers
```json
{
  "mcpServers": {
    "vercel": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-vercel"],
      "env": {
        "VERCEL_TOKEN": "${VERCEL_TOKEN}"
      }
    }
  }
}
```

### Skills to Generate
- `deployment` — Vercel deployment configuration, preview deploys, and custom domains
- `edge-functions` — Vercel Edge Functions and middleware patterns
- `environment-management` — Managing environment variables across preview/production

### Hooks
```json
{
  "event": "post_push",
  "steps": [
    { "action": "notify", "message": "Vercel deployment triggered — check dashboard for status" }
  ]
}
```

---

## Supabase

### Marketplace Plugins
- `antigravity/supabase-toolkit` — Supabase client patterns, RLS policies, and Edge Functions

### MCP Servers
```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-supabase"],
      "env": {
        "SUPABASE_PROJECT_ID": "${SUPABASE_PROJECT_ID}",
        "SUPABASE_ACCESS_TOKEN": "${SUPABASE_ACCESS_TOKEN}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-postgres"],
      "env": {
        "DATABASE_URL": "${SUPABASE_DB_URL}"
      }
    }
  }
}
```

### Skills to Generate
- `database-changes` — Supabase migration workflow and RLS policy management
- `authentication` — Supabase Auth integration with Row Level Security
- `storage` — Supabase Storage bucket configuration and file handling
- `edge-functions` — Supabase Edge Functions (Deno) development
- `realtime` — Supabase Realtime subscription patterns

### Hooks
```json
{
  "event": "pre_push",
  "steps": [
    { "action": "run", "command": "npx supabase db lint" }
  ]
}
```

---

## Stripe

### Marketplace Plugins
- `antigravity/stripe-toolkit` — Stripe integration patterns (Checkout, Subscriptions, Webhooks)

### MCP Servers
```json
{
  "mcpServers": {
    "stripe": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-stripe"],
      "env": {
        "STRIPE_SECRET_KEY": "${STRIPE_SECRET_KEY}"
      }
    }
  }
}
```

### Skills to Generate
- `payment-integration` — Stripe Checkout and payment flow implementation
- `subscription-management` — Subscription plans, billing portal, and lifecycle management
- `webhook-handling` — Stripe webhook verification and event processing
- `testing-payments` — Testing payment flows with Stripe test mode and fixtures

### Hooks
```json
{
  "event": "post_file_create",
  "match": "src/services/stripe/**/*.ts",
  "steps": [
    { "action": "run", "command": "npx eslint --fix {{FILE}}" }
  ]
}
```

---

## Tailwind CSS

### Marketplace Plugins
- `antigravity/tailwind-toolkit` — Tailwind CSS utility patterns and custom configuration

### MCP Servers
No dedicated MCP server needed — Tailwind is a build-time tool.

### Skills to Generate
- `component-creation` — Building components with Tailwind utility classes and design tokens
- `responsive-design` — Mobile-first responsive patterns with Tailwind breakpoints
- `theming` — Custom Tailwind theme configuration and CSS variable integration

### Hooks
```json
{
  "event": "post_file_create",
  "match": "src/components/**/*.tsx",
  "steps": [
    { "action": "run", "command": "npx prettier --write {{FILE}}" }
  ]
}
```

---

## Prisma

### Marketplace Plugins
- `antigravity/prisma-toolkit` — Prisma schema patterns, query optimization, and migration workflows

### MCP Servers
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### Skills to Generate
- `database-changes` — Prisma schema modification → `prisma migrate dev` → client regeneration
- `query-patterns` — Efficient Prisma queries, includes, and transactions
- `seeding` — Database seeding with `prisma db seed`

### Hooks
```json
{
  "event": "post_file_create",
  "match": "prisma/schema.prisma",
  "steps": [
    { "action": "run", "command": "npx prisma format" },
    { "action": "run", "command": "npx prisma validate" }
  ]
}
```

---

## Redis

### Marketplace Plugins
- `antigravity/redis-patterns` — Redis caching, session, and pub/sub patterns

### MCP Servers
```json
{
  "mcpServers": {
    "redis": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-redis"],
      "env": {
        "REDIS_URL": "${REDIS_URL}"
      }
    }
  }
}
```

### Skills to Generate
- `caching` — Redis caching patterns with TTL and invalidation strategies
- `session-management` — Redis-backed session storage
- `rate-limiting` — Redis-based rate limiting implementation

### Hooks
No specific hooks — Redis configuration is typically environment-based.

---

## Elasticsearch

### Marketplace Plugins
- `antigravity/elasticsearch-toolkit` — Elasticsearch indexing, mapping, and query patterns

### MCP Servers
```json
{
  "mcpServers": {
    "elasticsearch": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-elasticsearch"],
      "env": {
        "ELASTICSEARCH_URL": "${ELASTICSEARCH_URL}"
      }
    }
  }
}
```

### Skills to Generate
- `search-setup` — Index creation, mapping definition, and analyzer configuration
- `search-queries` — Full-text search, faceted search, and autocomplete patterns
- `data-sync` — Keeping Elasticsearch in sync with the primary database

### Hooks
No specific hooks — Elasticsearch operations are typically runtime.

---

## GraphQL

### Marketplace Plugins
- `antigravity/graphql-toolkit` — GraphQL schema design, resolver patterns, and client usage

### MCP Servers
```json
{
  "mcpServers": {
    "graphql": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-graphql"],
      "env": {
        "GRAPHQL_ENDPOINT": "${GRAPHQL_ENDPOINT}"
      }
    }
  }
}
```

### Skills to Generate
- `schema-development` — GraphQL schema design with types, queries, mutations, and subscriptions
- `resolver-creation` — Resolver implementation with DataLoader for N+1 prevention
- `client-integration` — Apollo Client / urql setup and hook patterns

### Hooks
```json
{
  "event": "post_file_create",
  "match": "src/graphql/**/*.graphql",
  "steps": [
    { "action": "run", "command": "npx graphql-codegen" }
  ]
}
```

---

## Testing Frameworks

### Jest / Vitest
```json
{
  "mcpServers": {}
}
```
No dedicated MCP server — testing is run via CLI commands.

**Skills to Generate:**
- `unit-testing` — Writing isolated unit tests with mocking patterns
- `integration-testing` — Testing component interactions and API endpoints
- `test-driven-development` — TDD workflow: write test → implement → refactor

**Hooks:**
```json
{
  "event": "pre_push",
  "steps": [
    { "action": "run", "command": "npx vitest run --coverage" }
  ]
}
```

### Playwright / Cypress (E2E)
```json
{
  "mcpServers": {
    "browser-tools": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-browser"],
      "env": {}
    }
  }
}
```

**Skills to Generate:**
- `e2e-testing` — End-to-end test writing with page object patterns
- `visual-regression` — Screenshot comparison testing

**Hooks:**
```json
{
  "event": "pre_push",
  "steps": [
    { "action": "run", "command": "npx playwright test" }
  ]
}
```

---

## Quick Lookup Table

| Technology | Plugin ID | MCP Server | Primary Skill |
|-----------|-----------|-----------|--------------|
| React | `antigravity/react-patterns` | `mcp-browser` | `component-creation` |
| Next.js | `antigravity/nextjs-toolkit` | `mcp-browser`, `mcp-postgres` | `feature-development` |
| Vue | `antigravity/vue-patterns` | `mcp-browser` | `component-creation` |
| Angular | `antigravity/angular-patterns` | `mcp-browser` | `component-creation` |
| Node.js | `antigravity/nodejs-backend` | `mcp-filesystem` | `api-development` |
| Django | `antigravity/django-patterns` | `mcp-postgres` | `feature-development` |
| FastAPI | `antigravity/fastapi-patterns` | `mcp-postgres` | `api-development` |
| Flutter | `antigravity/flutter-patterns` | `mcp-firebase` | `feature-development` |
| Firebase | `antigravity/firebase-toolkit` | `mcp-firebase` | `firebase-setup` |
| PostgreSQL | `antigravity/postgres-toolkit` | `mcp-postgres` | `database-changes` |
| MongoDB | `antigravity/mongodb-toolkit` | `mcp-mongodb` | `database-changes` |
| Docker | `antigravity/docker-toolkit` | `mcp-docker` | `containerization` |
| AWS | `antigravity/aws-toolkit` | `mcp-aws` | `deployment` |
| GCP | `antigravity/gcp-toolkit` | `mcp-gcp` | `deployment` |
| Vercel | `antigravity/vercel-toolkit` | `mcp-vercel` | `deployment` |
| Supabase | `antigravity/supabase-toolkit` | `mcp-supabase` | `database-changes` |
| Stripe | `antigravity/stripe-toolkit` | `mcp-stripe` | `payment-integration` |
| Tailwind | `antigravity/tailwind-toolkit` | — | `component-creation` |
| Prisma | `antigravity/prisma-toolkit` | `mcp-postgres` | `database-changes` |
| Redis | `antigravity/redis-patterns` | `mcp-redis` | `caching` |
| GraphQL | `antigravity/graphql-toolkit` | `mcp-graphql` | `schema-development` |
| Elasticsearch | `antigravity/elasticsearch-toolkit` | `mcp-elasticsearch` | `search-setup` |
