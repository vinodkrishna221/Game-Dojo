---
name: project-skeleton
description: "Generates executable project skeleton code including package manifests, configuration files, folder structures, database schemas, CI/CD workflows, and starter code. Goes beyond documentation to create a project that actually runs with npm install && npm run dev. Use this skill when the agent needs to create runnable project infrastructure, not just documentation."
---

# Project Skeleton Generator

This skill generates a fully runnable project skeleton — not just documentation, but actual code, configs, and scripts that let a developer clone the repo and start developing immediately.

The goal: after running the setup script, `npm install && npm run dev` (or the equivalent for the chosen stack) should produce a working application.

---

## When to Use

Activate this skill when:
- The doc-generator skill has finished creating project documentation
- The user explicitly asks for runnable code scaffolding
- The bootstrap workflow reaches the "Generate project skeleton" phase
- A project needs executable infrastructure beyond markdown files
- Team Mode is active and requires `.ai-team/` orchestration scaffolding, task branch initialization, and CODEOWNERS generation

---

## Prerequisites

Before generating skeleton files, the following must already exist:
- `docs/ARCHITECTURE.md` — Defines the tech stack, folder structure, and architectural patterns
- `docs/REQUIREMENTS.md` — Lists features and capabilities the skeleton should support
- `docs/DESIGN_SYSTEM.md` — Defines styling choices (needed for Tailwind config, theme files, etc.)
- `GEMINI.md` — Defines coding standards the skeleton must follow
- For Team Mode: Roster definition, role assignments, and initial milestone/task breakdown

Read all prerequisites before generating any files.

---

## File Generation by Tech Stack

### Node.js / TypeScript Projects

Generate the following files:

#### `package.json`
```json
{
  "name": "<project-name-kebab-case>",
  "version": "0.1.0",
  "private": true,
  "description": "<from PROJECT_BRIEF.md>",
  "scripts": {
    "dev": "<framework-specific dev command>",
    "build": "<framework-specific build command>",
    "start": "<framework-specific start command>",
    "test": "jest --passWithNoTests",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint . --ext .ts,.tsx",
    "lint:fix": "eslint . --ext .ts,.tsx --fix",
    "format": "prettier --write \"**/*.{ts,tsx,json,md}\"",
    "format:check": "prettier --check \"**/*.{ts,tsx,json,md}\"",
    "type-check": "tsc --noEmit",
    "db:migrate": "<orm-specific migrate command>",
    "db:seed": "<orm-specific seed command>",
    "db:studio": "<orm-specific studio command>"
  },
  "dependencies": { },
  "devDependencies": { }
}
```

Rules for `package.json`:
- Use the latest stable major version for every dependency (e.g., `"next": "^14.0.0"`, not `"next": "13.4.12"`)
- Include only dependencies the project actually uses — no kitchen-sink installs
- Group scripts logically: dev → build → test → lint → format → db
- Include `engines` field specifying the minimum Node.js version (18+)

#### `tsconfig.json`
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "skipLibCheck": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src/**/*.ts", "src/**/*.tsx"],
  "exclude": ["node_modules", "dist", "coverage"]
}
```

Rules for `tsconfig.json`:
- `strict: true` is mandatory — never disable it
- Always enable `noUncheckedIndexedAccess` for safer object access
- Configure path aliases matching the architecture document
- Adjust `lib`, `module`, and framework-specific settings (e.g., Next.js uses `"jsx": "preserve"`)

#### `.eslintrc.json`
```json
{
  "root": true,
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "plugins": ["@typescript-eslint"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "prettier"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/prefer-nullish-coalescing": "error",
    "@typescript-eslint/prefer-optional-chain": "error",
    "no-console": ["warn", { "allow": ["warn", "error"] }],
    "prefer-const": "error",
    "no-var": "error"
  },
  "ignorePatterns": ["dist/", "node_modules/", "coverage/"]
}
```

Rules for `.eslintrc.json`:
- Must extend `prettier` to avoid conflicts
- Must match coding standards defined in `GEMINI.md`
- Add framework-specific plugins as needed (e.g., `eslint-plugin-react-hooks` for React projects)

#### `.prettierrc`
```json
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

#### `.env.example`
Generate with every environment variable the project needs, each with a description comment:
```env
# Application
NODE_ENV=development
PORT=3000

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Authentication (if applicable)
NEXTAUTH_SECRET=generate-a-secret-here
NEXTAUTH_URL=http://localhost:3000

# External APIs (if applicable)
# API_KEY=your-api-key-here
```

Rules for `.env.example`:
- Every variable must have a comment explaining its purpose
- Provide sensible development defaults where safe
- Never include real secrets, API keys, or credentials
- Group variables by category with blank line separators

#### `.gitignore`
Generate a comprehensive gitignore covering:
- `node_modules/`, `dist/`, `build/`, `.next/`
- `.env`, `.env.local`, `.env.*.local` (but NOT `.env.example`)
- Coverage reports: `coverage/`
- IDE files: `.vscode/settings.json` (but keep `.vscode/extensions.json`)
- OS files: `.DS_Store`, `Thumbs.db`
- Lock files as appropriate (keep `package-lock.json` or `pnpm-lock.yaml`)

---

### Next.js Specific

In addition to the base Node.js files, generate:

#### `next.config.js`
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    remotePatterns: [],
  },
  experimental: {},
};

module.exports = nextConfig;
```

Configure based on architecture choices:
- Add `images.remotePatterns` if the project uses external images
- Add relevant experimental features if needed
- Add webpack customizations if the architecture requires them

#### `tailwind.config.js` (if using Tailwind)
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/lib/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // Pull from DESIGN_SYSTEM.md
      },
      fontFamily: {
        // Pull from DESIGN_SYSTEM.md
      },
    },
  },
  plugins: [],
};
```

Rules for `tailwind.config.js`:
- Colors and fonts must match `DESIGN_SYSTEM.md` exactly
- Content paths must cover all directories that use Tailwind classes
- Add plugins like `@tailwindcss/forms`, `@tailwindcss/typography` only if the project needs them

#### `postcss.config.js`
```javascript
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
```

#### `src/app/layout.tsx` — Root Layout
```tsx
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: '<Project Name>',
  description: '<Project description from brief>',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        {/* Add providers here (theme, auth, query client, etc.) */}
        {children}
      </body>
    </html>
  );
}
```

Wrap with providers as needed:
- `SessionProvider` if using NextAuth
- `QueryClientProvider` if using React Query
- `ThemeProvider` if using theme switching
- Generate the provider wrapper component at `src/components/providers.tsx`

#### `src/app/page.tsx` — Landing Page
Generate a minimal but functional landing page that:
- Renders without errors
- Shows the project name and a brief description
- Includes at least one interactive element (link, button)
- Uses the project's styling system (Tailwind classes or CSS modules)

#### `src/lib/db.ts` — Database Client
Generate based on the chosen ORM:

**Prisma:**
```typescript
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const prisma = globalForPrisma.prisma ?? new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
});

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}

export default prisma;
```

**Drizzle:**
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const db = drizzle(pool, { schema });
```

#### `src/lib/auth.ts` — Auth Configuration
Generate based on the chosen auth solution:

**NextAuth.js:**
```typescript
import { NextAuthOptions } from 'next-auth';
// Import providers based on architecture choices

export const authOptions: NextAuthOptions = {
  providers: [
    // Configure providers from architecture doc
  ],
  callbacks: {
    async session({ session, token }) {
      // Attach user ID to session
      return session;
    },
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
      }
      return token;
    },
  },
  pages: {
    signIn: '/auth/signin',
    error: '/auth/error',
  },
};
```

---

### Python Projects

#### `pyproject.toml`
```toml
[project]
name = "<project-name>"
version = "0.1.0"
description = "<from PROJECT_BRIEF.md>"
readme = "README.md"
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov>=4.0",
    "ruff>=0.1.0",
    "mypy>=1.0",
]

[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]

[tool.mypy]
strict = true
python_version = "3.11"

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --cov=src"
```

#### Package Structure
```
src/
├── <package_name>/
│   ├── __init__.py
│   ├── main.py
│   ├── config.py
│   ├── models/
│   │   └── __init__.py
│   ├── services/
│   │   └── __init__.py
│   └── utils/
│       └── __init__.py
tests/
├── __init__.py
├── conftest.py
└── test_main.py
```

Every `__init__.py` must contain appropriate exports, not be empty.

---

### Flutter Projects

#### `pubspec.yaml`
```yaml
name: <project_name_snake_case>
description: <from PROJECT_BRIEF.md>
version: 0.1.0

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  # Add dependencies from architecture doc

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

#### `analysis_options.yaml`
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
    prefer_single_quotes: true
```

#### Folder Structure
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   └── home/
│       ├── presentation/
│       ├── domain/
│       └── data/
└── shared/
    ├── widgets/
    └── models/
```

---

## Universal Files (All Projects)

### Docker Configuration (if containerization was chosen)

#### `Dockerfile`
Generate a multi-stage Dockerfile appropriate for the tech stack:

**Node.js Example:**
```dockerfile
# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

# Stage 2: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Stage 3: Production
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

RUN addgroup --system --gid 1001 appgroup
RUN adduser --system --uid 1001 appuser

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

USER appuser
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

Rules for Dockerfile:
- Always use multi-stage builds to minimize image size
- Pin to specific major Node/Python version with `-alpine` for small images
- Create a non-root user for security
- Copy only necessary files to the production stage
- Set `NODE_ENV=production` in the runner stage

#### `docker-compose.yml`
```yaml
version: '3.9'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${PORT:-3000}:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/${DB_NAME:-appdb}
    depends_on:
      db:
        condition: service_healthy
    volumes:
      - .:/app
      - /app/node_modules
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: ${DB_NAME:-appdb}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

Adjust services based on the architecture:
- Add Redis if caching is required
- Add a mail service if email functionality is needed
- Use MySQL/MongoDB image if that database was chosen
- Add pgAdmin or Adminer for development database management

### CI/CD Pipeline

#### `.github/workflows/ci.yml`
```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  quality:
    name: Code Quality
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Type check
        run: npm run type-check

      - name: Lint
        run: npm run lint

      - name: Format check
        run: npm run format:check

  test:
    name: Tests
    runs-on: ubuntu-latest
    needs: quality

    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: testdb
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm run test:coverage
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/testdb

      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/

  build:
    name: Build
    runs-on: ubuntu-latest
    needs: test

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build
```

Adjust the CI pipeline based on:
- The project's test framework (Jest, Vitest, Playwright, pytest)
- The database service needed (PostgreSQL, MySQL, MongoDB, none)
- The build tool (Next.js, Vite, esbuild, tsc)
- Whether E2E tests need a running server
- Python projects should use `actions/setup-python` and `pip install`

### Database Schema Files

#### Prisma Schema (`prisma/schema.prisma`)
Generate based on `DATA_MODEL.md`:
```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Generate models from DATA_MODEL.md
// Include proper relations, indexes, and constraints
```

Rules for database schemas:
- Every model must have an `id` field (UUID or auto-increment based on architecture)
- Include `createdAt` and `updatedAt` timestamps on all models
- Define proper relations with explicit foreign keys
- Add indexes on commonly queried fields
- Include a seed file (`prisma/seed.ts`) with realistic sample data

### Setup Scripts

#### `scripts/setup.ps1` (Windows)
```powershell
#!/usr/bin/env pwsh
# Project Setup Script for Windows
# Usage: .\scripts\setup.ps1

$ErrorActionPreference = "Stop"

Write-Host "🥋 Setting up <Project Name>..." -ForegroundColor Cyan
Write-Host ""

# 1. Check prerequisites
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

# Check Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js is not installed. Please install Node.js 18+ from https://nodejs.org" -ForegroundColor Red
    exit 1
}
$nodeVersion = node --version
$major = [int]($nodeVersion -replace '^v(\d+)\..*', '$1')
if ($major -lt 18) {
    Write-Host "❌ Node.js $nodeVersion is too old. Please upgrade to Node.js 18+." -ForegroundColor Red
    exit 1
}
Write-Host "  ✅ Node.js $nodeVersion" -ForegroundColor Green

# Check npm
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ npm is not available." -ForegroundColor Red
    exit 1
}
$npmVersion = npm --version
Write-Host "  ✅ npm v$npmVersion" -ForegroundColor Green

# 2. Install dependencies
Write-Host ""
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies." -ForegroundColor Red
    exit 1
}
Write-Host "  ✅ Dependencies installed" -ForegroundColor Green

# 3. Set up environment
Write-Host ""
Write-Host "🔐 Setting up environment..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "  ✅ Created .env from .env.example" -ForegroundColor Green
    Write-Host "  ⚠️  Please update .env with your actual values" -ForegroundColor Yellow
} else {
    Write-Host "  ℹ️  .env already exists, skipping" -ForegroundColor Cyan
}

# 4. Database setup (if applicable)
Write-Host ""
Write-Host "🗃️ Setting up database..." -ForegroundColor Yellow
npm run db:migrate 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✅ Database migrations applied" -ForegroundColor Green
    npm run db:seed 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ Database seeded with sample data" -ForegroundColor Green
    }
} else {
    Write-Host "  ⚠️  Database setup skipped (check DATABASE_URL in .env)" -ForegroundColor Yellow
}

# 5. Team Mode task branch initialization (if applicable)
if (Test-Path ".ai-team") {
    Write-Host ""
    Write-Host "👥 Initializing Team Mode task branches..." -ForegroundColor Yellow
    try {
        $taskBranches = @()
        if (Test-Path ".ai-team/plan.json") {
            $plan = Get-Content ".ai-team/plan.json" -Raw | ConvertFrom-Json
            if ($plan.taskIndex) {
                $taskBranches = $plan.taskIndex | ForEach-Object { $_.branch }
            }
        }
        if ($taskBranches.Count -eq 0 -and (Test-Path ".ai-team/tasks")) {
            $taskBranches = Get-ChildItem -Path ".ai-team/tasks" -Filter "*.json" | ForEach-Object {
                $t = Get-Content $_.FullName -Raw | ConvertFrom-Json
                $t.branch
            }
        }
        foreach ($branchName in $taskBranches) {
            if ($branchName) {
                $existing = git branch --list $branchName
                if (-not $existing) {
                    git branch $branchName 2>$null
                    Write-Host "  ✅ Created branch $branchName" -ForegroundColor Green
                } else {
                    Write-Host "  ℹ️  Branch $branchName exists" -ForegroundColor Cyan
                }
            }
        }
    } catch {
        Write-Host "  ⚠️  Could not initialize all task branches: $_" -ForegroundColor Yellow
    }
}

# 6. Done
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "  Start developing:  npm run dev" -ForegroundColor White
Write-Host "  Run tests:         npm test" -ForegroundColor White
Write-Host "  Check code:        npm run lint" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
```

#### `scripts/setup.sh` (Unix)
```bash
#!/usr/bin/env bash
# Project Setup Script for Unix/macOS/Linux
# Usage: chmod +x ./scripts/setup.sh && ./scripts/setup.sh

set -euo pipefail

echo "🥋 Setting up project..."
echo ""

# 1. Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v node >/dev/null 2>&1; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ from https://nodejs.org"
    exit 1
fi

NODE_VERSION=$(node --version)
NODE_MAJOR=$(echo "$NODE_VERSION" | sed -E 's/^v([0-9]+)\..*/\1/')
if [ "$NODE_MAJOR" -lt 18 ]; then
    echo "❌ Node.js $NODE_VERSION is too old. Please upgrade to Node.js 18+."
    exit 1
fi
echo "  ✅ Node.js $NODE_VERSION"

if ! command -v npm >/dev/null 2>&1; then
    echo "❌ npm is not available."
    exit 1
fi
NPM_VERSION=$(npm --version)
echo "  ✅ npm v$NPM_VERSION"

# 2. Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install
echo "  ✅ Dependencies installed"

# 3. Set up environment
echo ""
echo "🔐 Setting up environment..."
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "  ✅ Created .env from .env.example"
        echo "  ⚠️  Please update .env with your actual values"
    fi
else
    echo "  ℹ️  .env already exists, skipping"
fi

# 4. Database setup (if applicable)
echo ""
echo "🗃️ Setting up database..."
if npm run 2>/dev/null | grep -q "db:migrate"; then
    if npm run db:migrate 2>/dev/null; then
        echo "  ✅ Database migrations applied"
        if npm run 2>/dev/null | grep -q "db:seed"; then
            npm run db:seed 2>/dev/null && echo "  ✅ Database seeded with sample data" || true
        fi
    else
        echo "  ⚠️  Database setup skipped (check DATABASE_URL in .env)"
    fi
fi

# 5. Team Mode task branch initialization (if applicable)
if [ -d ".ai-team" ]; then
    echo ""
    echo "👥 Initializing Team Mode task branches..."
    if command -v jq >/dev/null 2>&1; then
        branches=()
        if [ -f ".ai-team/plan.json" ]; then
            for b in $(jq -r '.taskIndex[]?.branch // empty' .ai-team/plan.json 2>/dev/null); do
                [ -n "$b" ] && branches+=("$b")
            done
        fi
        if [ ${#branches[@]} -eq 0 ] && [ -d ".ai-team/tasks" ]; then
            for tf in .ai-team/tasks/*.json; do
                if [ -f "$tf" ]; then
                    b=$(jq -r '.branch // empty' "$tf" 2>/dev/null)
                    [ -n "$b" ] && branches+=("$b")
                fi
            done
        fi
        for branch in "${branches[@]}"; do
            if [ -n "$branch" ] && ! git show-ref --verify --quiet "refs/heads/$branch"; then
                git branch "$branch" 2>/dev/null && echo "  ✅ Created branch $branch" || true
            fi
        done
    else
        echo "  ℹ️  jq not installed; skipping automatic task branch creation"
    fi
fi

# 6. Done
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Setup complete!"
echo ""
echo "  Start developing:  npm run dev"
echo "  Run tests:         npm test"
echo "  Check code:        npm run lint"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

---

## Team Mode Infrastructure (.ai-team/)

When **Team Mode** is active (e.g. collaborative team projects, multi-agent development swarms, or team-ready prompt bootstrapping), `project-skeleton` scaffolds a dedicated `.ai-team/` folder structure and root `CODEOWNERS` file.

This establishes explicit boundaries, transparent task ownership, non-conflicting branch spaces, and real-time availability tracking across human and AI team members.

### Directory Layout

```
<project-root>/
├── .ai-team/
│   ├── team.json               # Roster, roles, capabilities, and availability
│   ├── plan.json               # Milestones, delivery phases, and task index
│   └── tasks/                  # Granular task specifications (one file per task)
│       ├── task-001.json
│       ├── task-002.json
│       ├── task-003.json
│       ├── task-004.json
│       └── task-005.json
└── CODEOWNERS                  # Git code ownership mapping file paths to git handles (or .github/CODEOWNERS)
```

---

### 1. `.ai-team/team.json` — Team Roster & Availability

Defines all team members (human engineers and autonomous AI specialist agents), their functional roles, Git usernames, skill capabilities, current workload limits, and real-time availability status.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "teamId": "team-game-dojo-core",
  "teamName": "Core Engineering Team",
  "updatedAt": "2026-10-28T12:00:00Z",
  "lead": "architect-lead",
  "members": [
    {
      "id": "architect-lead",
      "name": "Alex Mercer",
      "role": "Architect & System Lead",
      "gitUser": "@amercer-lead",
      "email": "alex.mercer@example.com",
      "type": "human",
      "availability": "active",
      "maxConcurrentTasks": 2,
      "assignedTaskIds": [
        "task-001"
      ],
      "capabilities": [
        "architecture",
        "code-review",
        "security",
        "schema-design"
      ]
    },
    {
      "id": "backend-specialist",
      "name": "Devon Vance",
      "role": "Backend Engineer",
      "gitUser": "@dvance-backend",
      "email": "devon.vance@example.com",
      "type": "ai-agent",
      "availability": "active",
      "maxConcurrentTasks": 3,
      "assignedTaskIds": [
        "task-002",
        "task-003"
      ],
      "capabilities": [
        "typescript",
        "nodejs",
        "prisma",
        "rest-api",
        "postgresql"
      ]
    },
    {
      "id": "frontend-specialist",
      "name": "Elena Rostova",
      "role": "Frontend Engineer",
      "gitUser": "@erostova-frontend",
      "email": "elena.rostova@example.com",
      "type": "ai-agent",
      "availability": "idle",
      "maxConcurrentTasks": 3,
      "assignedTaskIds": [
        "task-004"
      ],
      "capabilities": [
        "react",
        "nextjs",
        "tailwind",
        "accessibility",
        "state-management"
      ]
    },
    {
      "id": "qa-validator",
      "name": "Kiran Patel",
      "role": "QA & Test Automation Specialist",
      "gitUser": "@kpatel-qa",
      "email": "kiran.patel@example.com",
      "type": "ai-agent",
      "availability": "idle",
      "maxConcurrentTasks": 2,
      "assignedTaskIds": [
        "task-005"
      ],
      "capabilities": [
        "vitest",
        "jest",
        "playwright",
        "integration-testing"
      ]
    }
  ]
}
```

**Rules for `team.json`:**
- Every member `id` must be unique and in `lowercase-kebab-case`.
- `gitUser` (or `githubUsername`) must include the leading `@` and represent a valid git handle.
- `type` must be either `"human"` or `"ai-agent"`.
- `availability` must be one of `"active"`, `"idle"`, `"busy"`, `"offline"`.
- `maxConcurrentTasks` must be an integer ≥ 1.
- `assignedTaskIds` (or `activeTasks`) must strictly reference task IDs defined in `.ai-team/tasks/`.
- No placeholders, fake wildcards, or empty strings.

---

### 2. `.ai-team/plan.json` — Milestones & Task Index

Defines high-level delivery milestones, target dates, sequencing dependencies, and a consolidated index of all tasks with their current execution status and assigned branches.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "planId": "plan-v1",
  "version": "1.0.0",
  "createdAt": "2026-10-28T12:00:00Z",
  "updatedAt": "2026-10-28T12:00:00Z",
  "currentMilestone": "m1-foundation",
  "milestones": [
    {
      "id": "m1-foundation",
      "title": "Foundation & Core Infrastructure",
      "description": "Establish environment, database schema, authentication, and core API routing.",
      "targetDate": "2026-11-05",
      "status": "in_progress",
      "tasks": [
        "task-001",
        "task-002",
        "task-003"
      ]
    },
    {
      "id": "m2-ui-features",
      "title": "Core UI & Client Experience",
      "description": "Deliver primary client views, forms, and responsive components integrated with the API.",
      "targetDate": "2026-11-12",
      "status": "todo",
      "tasks": [
        "task-004"
      ]
    },
    {
      "id": "m3-testing-hardening",
      "title": "Test Coverage & Production Hardening",
      "description": "Comprehensive E2E suite, load verification, and CI/CD deployment checks.",
      "targetDate": "2026-11-19",
      "status": "todo",
      "tasks": [
        "task-005"
      ]
    }
  ],
  "taskIndex": [
    {
      "id": "task-001",
      "title": "Project Base Configuration & Core Schemas",
      "slug": "base-config",
      "milestoneId": "m1-foundation",
      "assignedTo": "architect-lead",
      "status": "completed",
      "branch": "feature/task-001-base-config"
    },
    {
      "id": "task-002",
      "title": "Prisma Database Models & Migration Pipeline",
      "slug": "database-models",
      "milestoneId": "m1-foundation",
      "assignedTo": "backend-specialist",
      "status": "in_progress",
      "branch": "feature/task-002-database-models"
    },
    {
      "id": "task-003",
      "title": "User Authentication & Session Middleware",
      "slug": "auth-middleware",
      "milestoneId": "m1-foundation",
      "assignedTo": "backend-specialist",
      "status": "todo",
      "branch": "feature/task-003-auth-middleware"
    },
    {
      "id": "task-004",
      "title": "Interactive Dashboard & Navigation Shell",
      "slug": "dashboard-shell",
      "milestoneId": "m2-ui-features",
      "assignedTo": "frontend-specialist",
      "status": "todo",
      "branch": "feature/task-004-dashboard-shell"
    },
    {
      "id": "task-005",
      "title": "End-to-End Test Suite & Verification Matrix",
      "slug": "e2e-suite",
      "milestoneId": "m3-testing-hardening",
      "assignedTo": "qa-validator",
      "status": "todo",
      "branch": "feature/task-005-e2e-suite"
    }
  ]
}
```

---

### 3. Individual Task Files (`.ai-team/tasks/<task-id>.json`)

Every task is created as an independent JSON file named `<task-id>.json` inside `.ai-team/tasks/`. This prevents merge conflicts when parallel agents simultaneously update their assigned tasks.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "id": "task-003",
  "title": "User Authentication & Session Middleware",
  "slug": "auth-middleware",
  "milestoneId": "m1-foundation",
  "assignedTo": "backend-specialist",
  "ownerGit": "@dvance-backend",
  "status": "todo",
  "priority": "high",
  "branch": "feature/task-003-auth-middleware",
  "dependencies": [
    "task-001",
    "task-002"
  ],
  "touchesFiles": [
    "src/lib/auth.ts",
    "src/middleware.ts",
    "src/app/api/auth/[...nextauth]/route.ts",
    "tests/auth.test.ts"
  ],
  "description": "Implement authentication handlers, JWT validation, and route protection middleware using NextAuth with the Prisma database adapter.",
  "acceptanceCriteria": [
    "JWT session tokens are signed and verified against NEXTAUTH_SECRET",
    "Protected API routes return 401 Unauthorized for unauthenticated requests",
    "Middleware redirects unauthenticated requests for /dashboard to /auth/signin",
    "All unit and integration tests in tests/auth.test.ts pass with 100% assertion success"
  ],
  "verificationCommand": "npm test tests/auth.test.ts"
}
```

**Key Fields in Task Files:**
- `id`: Unique identifier formatted as `task-<number>` (3-digit zero-padded, e.g. `task-003`).
- `slug`: Short lowercase kebab-case description (e.g. `auth-middleware`).
- `milestoneId`: Associated milestone defined in `.ai-team/plan.json`.
- `assignedTo`: Member ID corresponding to an entry in `.ai-team/team.json` (or `assignee` object `{ id, name }`).
- `ownerGit`: Git username matching the member's `gitUser` (e.g. `@dvance-backend`).
- `status`: One of `"todo"`, `"in_progress"`, `"in_review"`, `"done"` (canonical; `"completed"` and `"blocked"` are also accepted).
- `branch`: Strictly formatted as `feature/<task-id>-<slug>` (primary; `feat/<task-id>-<slug>` accepted as alias).
- `dependencies`: Array of prerequisite task IDs that must reach `"done"` (or `"completed"`) status before this task can start (also aliased as `blockedBy`).
- `touchesFiles`: Exact list of repository paths this task creates or edits (also aliased as `allowedPaths`). Critical for conflict avoidance and parallel agent isolation.
- `acceptanceCriteria`: Testable, concrete functional statements.
- `verificationCommand`: Specific test or script that must exit with code 0 to satisfy verification (or `verificationCommands` array).

---

### 4. Root `CODEOWNERS` (or `.github/CODEOWNERS`)

Generates a `CODEOWNERS` file conforming to GitHub and GitLab syntax. It can be placed at the repository root (`CODEOWNERS`) or in `.github/CODEOWNERS`. Maps project file paths and directories to the assigned team member's Git username (`gitUser`).

```text
# ==============================================================================
# Game Dojo CODEOWNERS
# ==============================================================================
# Syntax: <path-pattern> <@username> [<@additional_username>]
# Rules are evaluated from top to bottom; the last matching pattern takes precedence.

# Global default owner
* @amercer-lead

# Configuration & Infrastructure
/.github/ @amercer-lead
/docker-compose*.yml @amercer-lead
/Dockerfile* @amercer-lead
/scripts/ @amercer-lead
/package.json @amercer-lead
/tsconfig.json @amercer-lead

# Database Models & Migrations
/prisma/ @dvance-backend
/src/lib/db.ts @dvance-backend

# Backend API & Server Services
/src/app/api/ @dvance-backend
/src/services/ @dvance-backend
/src/middleware.ts @dvance-backend

# Frontend Components, Pages & Styles
/src/app/(dashboard)/ @erostova-frontend
/src/components/ @erostova-frontend
/src/styles/ @erostova-frontend
/tailwind.config.js @erostova-frontend

# Test Automation & QA Suites
/tests/ @kpatel-qa
/vitest.config.ts @kpatel-qa

# AI Team Coordination Directory
/.ai-team/ @amercer-lead
```

**Rules for `CODEOWNERS`:**
- Every git username must start with `@` and map to an existing member in `.ai-team/team.json`.
- Directories must end with `/` or match specific glob patterns.
- Paths must correspond to real project directories created in the skeleton or planned in `touchesFiles`.
- Note: When validating path patterns relative to project root on Windows, always strip the leading `/` (e.g. `/src/lib/` becomes `src/lib/`) to prevent path resolution to the drive root.

---

### 5. Task Branch Initialization Commands

When Team Mode is bootstrapped, Game Dojo generates the git branch creation commands so each specialist agent or human developer can work in isolated feature branches without merge collisions.

#### Individual Branch Command Convention
For any task, the feature branch command is:
```bash
git branch feature/<task-id>-<slug>
# Or checkout immediately:
git checkout -b feature/<task-id>-<slug>
```

#### Batch Initialization Commands

**PowerShell (Windows):**
```powershell
# Parse plan.json (or fallback to .ai-team/tasks/*.json) and create all task branches from main
$branches = @()
if (Test-Path ".ai-team/plan.json") {
    $plan = Get-Content ".ai-team/plan.json" -Raw | ConvertFrom-Json
    if ($plan.taskIndex) {
        $branches = $plan.taskIndex | ForEach-Object { [PSCustomObject]@{ id = $_.id; branch = $_.branch } }
    }
}
if ($branches.Count -eq 0 -and (Test-Path ".ai-team/tasks")) {
    $branches = Get-ChildItem -Path ".ai-team/tasks" -Filter "*.json" | ForEach-Object {
        $t = Get-Content $_.FullName -Raw | ConvertFrom-Json
        [PSCustomObject]@{ id = $t.id; branch = $t.branch }
    }
}

foreach ($item in $branches) {
    $branch = $item.branch
    if ($branch) {
        $exists = git branch --list $branch
        if (-not $exists) {
            git branch $branch
            Write-Host "🌿 Created branch $branch for $($item.id)" -ForegroundColor Green
        } else {
            Write-Host "ℹ️  Branch $branch already exists" -ForegroundColor Cyan
        }
    }
}
```

**Bash (Unix):**
```bash
# Parse plan.json (or fallback to .ai-team/tasks/*.json) and create all task branches from main
branches=()
if [ -f ".ai-team/plan.json" ] && command -v jq >/dev/null 2>&1; then
    for b in $(jq -r '.taskIndex[]?.branch // empty' .ai-team/plan.json 2>/dev/null); do
        [ -n "$b" ] && branches+=("$b")
    done
fi
if [ ${#branches[@]} -eq 0 ] && [ -d ".ai-team/tasks" ] && command -v jq >/dev/null 2>&1; then
    for tf in .ai-team/tasks/*.json; do
        if [ -f "$tf" ]; then
            b=$(jq -r '.branch // empty' "$tf" 2>/dev/null)
            [ -n "$b" ] && branches+=("$b")
        fi
    done
fi

for branch in "${branches[@]}"; do
    if [ -n "$branch" ]; then
        if git show-ref --verify --quiet "refs/heads/$branch"; then
            echo "ℹ️  Branch $branch already exists"
        else
            git branch "$branch"
            echo "🌿 Created branch $branch"
        fi
    fi
done
```

---

## Skeleton Code Generation

For each core feature identified in `REQUIREMENTS.md`, generate minimal but functional starter code.

### Code Quality Rules

Every generated code file must:

1. **Follow architectural patterns** — If the architecture says "repository pattern," generate repository interfaces and implementations. If it says "feature-based modules," organize code by feature.

2. **Include proper TypeScript types** — No `any` types. Define interfaces for all data shapes. Use union types, generics, and utility types appropriately.

3. **Have basic error handling** — Wrap async operations in try/catch. Define custom error classes. Return proper error responses from API routes.

4. **Be testable** — Use dependency injection where it improves testability. Prefer pure functions. Avoid hard-coded dependencies.

5. **Include at least one test file** — Generate `__tests__/` or `*.test.ts` files with:
   - At least one unit test per exported function
   - Proper test descriptions using `describe`/`it` blocks
   - Mock setup for external dependencies
   - Both success and error case coverage

### Example Test File
```typescript
import { describe, it, expect, vi } from 'vitest';
// or: import { describe, it, expect, jest } from '@jest/globals';

describe('ExampleService', () => {
  describe('create', () => {
    it('should create a new record with valid input', async () => {
      // Arrange
      const input = { name: 'Test', email: 'test@example.com' };

      // Act
      const result = await service.create(input);

      // Assert
      expect(result).toBeDefined();
      expect(result.name).toBe('Test');
    });

    it('should throw an error for invalid input', async () => {
      // Arrange
      const input = { name: '', email: 'invalid' };

      // Act & Assert
      await expect(service.create(input)).rejects.toThrow('Validation failed');
    });
  });
});
```

---

## Execution Checklist

Before marking skeleton generation as complete, verify:

- [ ] `npm install` (or equivalent) completes without errors
- [ ] `npm run build` succeeds
- [ ] `npm run lint` passes with no errors
- [ ] `npm run type-check` passes
- [ ] `npm test` runs and at least one test passes
- [ ] `.env.example` documents every required variable
- [ ] `.gitignore` excludes all appropriate files
- [ ] Setup script runs without errors (given correct prerequisites)
- [ ] CI pipeline YAML is valid
- [ ] Docker builds successfully (if applicable)
- [ ] Database schema is valid and migratable (if applicable)
- [ ] Every generated file is syntactically valid
- [ ] `.ai-team/team.json` contains valid member roster, git handles, and availability (when Team Mode is active)
- [ ] `.ai-team/plan.json` has complete milestone definitions and indexed tasks (when Team Mode is active)
- [ ] Individual task files `.ai-team/tasks/<task-id>.json` contain `touchesFiles`, `dependencies`, and `branch` (when Team Mode is active)
- [ ] Root `CODEOWNERS` maps directory areas to valid team member git handles (when Team Mode is active)
- [ ] Feature branches initialized via `git branch feature/<task-id>-<slug>` (when Team Mode is active)

---

## Integration with Other Skills

- **doc-generator**: Must run first to produce the documentation this skill reads
- **self-healing**: Runs after skeleton generation to validate `.ai-team/*.json` schemas, detect circular dependencies, enforce branch slug conventions, resolve concurrent file collisions, and reconcile CODEOWNERS
- **project-validator**: Validates both the skeleton code output and `.ai-team/` configuration for completeness
- **agent-swarm**: Coordinates parallel specialist agents bound by `.ai-team/` tasks, branches, and CODEOWNERS boundaries
- **adaptive-memory**: Records which skeleton patterns worked well for future bootstraps
