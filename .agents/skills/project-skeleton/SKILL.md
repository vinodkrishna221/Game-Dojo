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

---

## Prerequisites

Before generating skeleton files, the following must already exist:
- `docs/ARCHITECTURE.md` — Defines the tech stack, folder structure, and architectural patterns
- `docs/REQUIREMENTS.md` — Lists features and capabilities the skeleton should support
- `docs/DESIGN_SYSTEM.md` — Defines styling choices (needed for Tailwind config, theme files, etc.)
- `GEMINI.md` — Defines coding standards the skeleton must follow

Read all four documents before generating any files.

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
$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Host "❌ Node.js is not installed. Please install Node.js 18+ from https://nodejs.org" -ForegroundColor Red
    exit 1
}
$major = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
if ($major -lt 18) {
    Write-Host "❌ Node.js $nodeVersion is too old. Please upgrade to Node.js 18+." -ForegroundColor Red
    exit 1
}
Write-Host "  ✅ Node.js $nodeVersion" -ForegroundColor Green

# Check npm
$npmVersion = npm --version 2>$null
if (-not $npmVersion) {
    Write-Host "❌ npm is not available." -ForegroundColor Red
    exit 1
}
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

# 5. Done
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
Generate the equivalent Bash script with:
- `#!/usr/bin/env bash` shebang
- `set -euo pipefail` for safety
- Same prerequisite checks using `command -v`
- Same installation and setup steps
- `chmod +x` reminder in the README

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

---

## Integration with Other Skills

- **doc-generator**: Must run first to produce the documentation this skill reads
- **self-healing**: Should run after skeleton generation to catch any issues
- **project-validator**: Validates the skeleton output for completeness
- **adaptive-memory**: Records which skeleton patterns worked well for future bootstraps
