# Tech Stack Reference

Common technology stack configurations with trade-offs, folder structures, key packages, MCP servers, and typical skills to generate.

---

## 1. Modern Web App — Next.js

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 14+ (App Router) |
| Language | TypeScript |
| ORM | Prisma |
| Database | PostgreSQL |
| Styling | Tailwind CSS + shadcn/ui |
| Auth | NextAuth.js (Auth.js) |
| Testing | Vitest + Playwright |
| Deployment | Vercel |

**Pros:** Unified full-stack, SSR/SSG/ISR flexibility, huge ecosystem, excellent DX, native Vercel deployment.
**Cons:** Vercel lock-in risk, App Router learning curve, server component complexity.
**Best for:** SaaS products, e-commerce, marketing sites, dashboards, content platforms.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── feature-development/SKILL.md
│   │   ├── api-development/SKILL.md
│   │   ├── testing/SKILL.md
│   │   └── database-changes/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   ├── login/page.tsx
│   │   │   └── register/page.tsx
│   │   ├── (dashboard)/
│   │   │   └── dashboard/page.tsx
│   │   ├── api/
│   │   │   └── [...route]/route.ts
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── globals.css
│   ├── components/
│   │   ├── ui/           # shadcn/ui components
│   │   ├── forms/        # Form components
│   │   ├── layout/       # Header, Footer, Sidebar
│   │   └── shared/       # Shared/reusable components
│   ├── lib/
│   │   ├── db.ts         # Prisma client
│   │   ├── auth.ts       # Auth configuration
│   │   ├── utils.ts      # Utility functions
│   │   └── validations.ts # Zod schemas
│   ├── services/         # Business logic
│   ├── hooks/            # Custom React hooks
│   └── types/            # TypeScript types
├── prisma/
│   ├── schema.prisma
│   ├── migrations/
│   └── seed.ts
├── public/
├── docs/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── GEMINI.md
├── AGENTS.md
├── DESIGN_SYSTEM.md
├── README.md
├── next.config.ts
├── tailwind.config.ts
├── tsconfig.json
└── package.json
```

### Key Packages
```json
{
  "dependencies": {
    "next": "^14.2.0",
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "@prisma/client": "^5.15.0",
    "next-auth": "^4.24.0",
    "zod": "^3.23.0",
    "tailwindcss": "^3.4.0",
    "@radix-ui/react-slot": "^1.0.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.1.0",
    "tailwind-merge": "^2.3.0",
    "lucide-react": "^0.380.0"
  },
  "devDependencies": {
    "typescript": "^5.5.0",
    "prisma": "^5.15.0",
    "@types/node": "^20.14.0",
    "@types/react": "^18.3.0",
    "vitest": "^1.6.0",
    "@playwright/test": "^1.44.0",
    "eslint": "^8.57.0",
    "eslint-config-next": "^14.2.0",
    "prettier": "^3.3.0",
    "prettier-plugin-tailwindcss": "^0.6.0"
  }
}
```

### MCP Servers
- `@anthropic/mcp-postgres` — Database introspection and query assistance
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `feature-development` — End-to-end Next.js feature implementation
- `api-development` — Creating API routes with validation
- `testing` — Writing unit, integration, and E2E tests
- `database-changes` — Prisma schema changes and migrations
- `deployment` — Vercel deployment and environment management
- `component-creation` — Building shadcn/ui-based components

---

## 2. API Backend — Node.js / Express

| Layer | Technology |
|-------|-----------|
| Runtime | Node.js 20+ |
| Framework | Express.js |
| Language | TypeScript |
| Database | MongoDB |
| ODM | Mongoose |
| Validation | Zod |
| Testing | Jest + Supertest |
| Deployment | Railway / AWS ECS |

**Pros:** Mature ecosystem, flexible, massive community, easy to hire for, extensive middleware library.
**Cons:** Callback patterns (mitigated by async/await), no built-in structure (requires discipline), single-threaded.
**Best for:** REST APIs, microservices, real-time backends, BFF (backend-for-frontend) layers.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── api-development/SKILL.md
│   │   ├── testing/SKILL.md
│   │   └── database-changes/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── src/
│   ├── controllers/      # Route handlers
│   ├── services/         # Business logic
│   ├── models/           # Mongoose models
│   ├── middleware/        # Auth, error handling, logging
│   ├── routes/           # Route definitions
│   ├── validators/       # Zod schemas
│   ├── utils/            # Helpers
│   ├── config/           # Environment config
│   ├── types/            # TypeScript types
│   └── app.ts            # Express app setup
├── tests/
│   ├── unit/
│   └── integration/
├── docs/
├── scripts/              # DB seeds, migrations
├── GEMINI.md
├── AGENTS.md
├── README.md
├── Dockerfile
├── docker-compose.yml
├── tsconfig.json
├── jest.config.ts
└── package.json
```

### Key Packages
```json
{
  "dependencies": {
    "express": "^4.19.0",
    "mongoose": "^8.4.0",
    "zod": "^3.23.0",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0",
    "dotenv": "^16.4.0",
    "jsonwebtoken": "^9.0.0",
    "bcryptjs": "^2.4.3",
    "express-rate-limit": "^7.3.0",
    "winston": "^3.13.0"
  },
  "devDependencies": {
    "typescript": "^5.5.0",
    "@types/express": "^4.17.0",
    "@types/node": "^20.14.0",
    "jest": "^29.7.0",
    "ts-jest": "^29.1.0",
    "supertest": "^7.0.0",
    "@types/supertest": "^6.0.0",
    "eslint": "^8.57.0",
    "prettier": "^3.3.0",
    "tsx": "^4.15.0",
    "nodemon": "^3.1.0"
  }
}
```

### MCP Servers
- `@anthropic/mcp-mongodb` — MongoDB introspection
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `api-development` — Creating new endpoints with validation and tests
- `testing` — Unit tests with Jest, integration tests with Supertest
- `database-changes` — Mongoose model changes and data migrations
- `deployment` — Docker build and deployment pipeline
- `error-handling` — Consistent error handling patterns

---

## 3. Full-Stack Python — FastAPI

| Layer | Technology |
|-------|-----------|
| Backend | FastAPI |
| Language | Python 3.11+ |
| ORM | SQLAlchemy 2.0 |
| Database | PostgreSQL |
| Migrations | Alembic |
| Frontend | React (Vite) |
| Testing | pytest + httpx |
| Deployment | Docker + Railway / AWS |

**Pros:** Automatic OpenAPI docs, async-native, type hints, excellent performance for Python, built-in validation (Pydantic).
**Cons:** Smaller ecosystem than Django, requires manual setup of features Django provides out-of-box (admin, ORM migrations).
**Best for:** High-performance APIs, ML model serving, real-time apps, data-intensive backends.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── api-development/SKILL.md
│   │   ├── testing/SKILL.md
│   │   └── database-changes/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── backend/
│   ├── app/
│   │   ├── api/
│   │   │   ├── v1/
│   │   │   │   ├── endpoints/
│   │   │   │   └── router.py
│   │   │   └── deps.py
│   │   ├── core/
│   │   │   ├── config.py
│   │   │   ├── security.py
│   │   │   └── database.py
│   │   ├── models/         # SQLAlchemy models
│   │   ├── schemas/        # Pydantic schemas
│   │   ├── services/       # Business logic
│   │   └── main.py
│   ├── alembic/
│   │   ├── versions/
│   │   └── env.py
│   ├── tests/
│   │   ├── conftest.py
│   │   ├── test_api/
│   │   └── test_services/
│   ├── alembic.ini
│   ├── pyproject.toml
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── services/      # API client
│   │   └── App.tsx
│   ├── package.json
│   └── vite.config.ts
├── docs/
├── docker-compose.yml
├── GEMINI.md
├── AGENTS.md
├── DESIGN_SYSTEM.md
└── README.md
```

### Key Packages
```toml
[project]
dependencies = [
    "fastapi>=0.111.0",
    "uvicorn[standard]>=0.30.0",
    "sqlalchemy>=2.0.30",
    "alembic>=1.13.0",
    "asyncpg>=0.29.0",
    "pydantic>=2.7.0",
    "pydantic-settings>=2.3.0",
    "python-jose[cryptography]>=3.3.0",
    "passlib[bcrypt]>=1.7.0",
    "python-multipart>=0.0.9",
    "httpx>=0.27.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.2.0",
    "pytest-asyncio>=0.23.0",
    "pytest-cov>=5.0.0",
    "httpx>=0.27.0",
    "ruff>=0.4.0",
    "mypy>=1.10.0",
]
```

### MCP Servers
- `@anthropic/mcp-postgres` — PostgreSQL introspection
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `api-development` — FastAPI endpoint creation with Pydantic schemas
- `testing` — pytest-based testing with async support
- `database-changes` — SQLAlchemy model + Alembic migration workflow
- `deployment` — Docker and cloud deployment
- `frontend-integration` — Connecting React frontend to FastAPI backend

---

## 4. Mobile App — React Native

| Layer | Technology |
|-------|-----------|
| Framework | React Native (Expo) |
| Language | TypeScript |
| Navigation | React Navigation |
| State | Zustand |
| Backend | Firebase / Supabase |
| Testing | Jest + React Native Testing Library |
| Deployment | EAS Build + App Stores |

**Pros:** Share code between iOS and Android, JavaScript ecosystem, hot reloading, Expo simplifies native modules.
**Cons:** Performance below native for heavy graphics, large app size, native module bridging complexity.
**Best for:** Consumer mobile apps, cross-platform MVPs, apps that don't need intense graphics/animations.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── feature-development/SKILL.md
│   │   ├── screen-creation/SKILL.md
│   │   └── testing/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── src/
│   ├── screens/           # Screen components
│   ├── components/        # Reusable components
│   ├── navigation/        # Navigation configuration
│   ├── services/          # API and Firebase services
│   ├── stores/            # Zustand stores
│   ├── hooks/             # Custom hooks
│   ├── utils/             # Helpers
│   ├── types/             # TypeScript types
│   ├── constants/         # Theme, config
│   └── assets/            # Images, fonts
├── tests/
├── docs/
├── app.json
├── eas.json
├── GEMINI.md
├── AGENTS.md
├── DESIGN_SYSTEM.md
├── README.md
├── tsconfig.json
└── package.json
```

### Key Packages
```json
{
  "dependencies": {
    "expo": "~51.0.0",
    "react-native": "0.74.0",
    "react": "^18.3.0",
    "@react-navigation/native": "^6.1.0",
    "@react-navigation/native-stack": "^6.9.0",
    "zustand": "^4.5.0",
    "expo-secure-store": "~13.0.0",
    "expo-image-picker": "~15.0.0",
    "react-native-safe-area-context": "^4.10.0",
    "react-native-screens": "~3.31.0",
    "nativewind": "^4.0.0",
    "firebase": "^10.12.0"
  },
  "devDependencies": {
    "typescript": "~5.5.0",
    "@types/react": "~18.3.0",
    "jest": "^29.7.0",
    "@testing-library/react-native": "^12.5.0",
    "eslint": "^8.57.0"
  }
}
```

### MCP Servers
- `@anthropic/mcp-firebase` — Firebase project management
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `feature-development` — End-to-end mobile feature implementation
- `screen-creation` — Creating new screens with navigation
- `testing` — Component and integration testing
- `deployment` — EAS Build and app store submission
- `state-management` — Zustand store patterns

---

## 5. Mobile App — Flutter

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| Language | Dart |
| State | Riverpod |
| Backend | Firebase / Supabase |
| Testing | flutter_test + integration_test |
| Deployment | App Stores / Firebase Distribution |

**Pros:** True native rendering, single codebase for iOS/Android/Web/Desktop, excellent performance, rich widget library, strong typing.
**Cons:** Dart learning curve, smaller job market, larger app size, platform-specific code still needed sometimes.
**Best for:** High-performance mobile apps, apps needing custom UI, multi-platform (mobile + web + desktop).

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── feature-development/SKILL.md
│   │   ├── screen-creation/SKILL.md
│   │   └── testing/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── lib/
│   ├── src/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   │   ├── data/
│   │   │   │   ├── domain/
│   │   │   │   └── presentation/
│   │   │   └── home/
│   │   ├── common/
│   │   │   ├── widgets/
│   │   │   ├── utils/
│   │   │   └── constants/
│   │   ├── routing/
│   │   └── services/
│   └── main.dart
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── assets/
├── docs/
├── GEMINI.md
├── AGENTS.md
├── DESIGN_SYSTEM.md
├── README.md
├── pubspec.yaml
└── analysis_options.yaml
```

### Key Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.0
  go_router: ^14.2.0
  dio: ^5.5.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.9.0
  firebase_core: ^3.2.0
  firebase_auth: ^5.1.0
  cloud_firestore: ^5.1.0
  shared_preferences: ^2.2.0
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  mockito: ^5.4.0
  integration_test:
    sdk: flutter
```

### MCP Servers
- `@anthropic/mcp-firebase` — Firebase project management
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `feature-development` — Flutter feature development with Riverpod
- `screen-creation` — Creating new screens with go_router
- `testing` — Unit, widget, and integration testing
- `deployment` — App store builds and distribution
- `state-management` — Riverpod provider patterns

---

## 6. Desktop App — Electron

| Layer | Technology |
|-------|-----------|
| Framework | Electron |
| Language | TypeScript |
| UI | React |
| Database | SQLite (better-sqlite3) |
| Build | electron-builder |
| Testing | Vitest + Playwright |
| Distribution | Auto-updater + GitHub Releases |

**Pros:** Cross-platform desktop (Windows, macOS, Linux), web tech skills transfer, access to native APIs, rich UI capabilities.
**Cons:** Large memory footprint, bundled Chromium, not suitable for resource-constrained environments.
**Best for:** Developer tools, productivity apps, internal enterprise tools, media applications.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── feature-development/SKILL.md
│   │   └── testing/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── src/
│   ├── main/              # Electron main process
│   │   ├── index.ts
│   │   ├── ipc/           # IPC handlers
│   │   ├── services/      # Native services
│   │   └── database/      # SQLite operations
│   ├── renderer/          # React frontend
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── stores/
│   │   └── App.tsx
│   ├── shared/            # Shared types and utils
│   └── preload/           # Preload scripts
├── resources/             # Icons, native assets
├── tests/
├── docs/
├── GEMINI.md
├── AGENTS.md
├── DESIGN_SYSTEM.md
├── README.md
├── electron-builder.yml
├── tsconfig.json
└── package.json
```

### Key Packages
```json
{
  "dependencies": {
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "better-sqlite3": "^11.0.0",
    "electron-updater": "^6.2.0",
    "zustand": "^4.5.0"
  },
  "devDependencies": {
    "electron": "^31.0.0",
    "electron-builder": "^24.13.0",
    "typescript": "^5.5.0",
    "vite": "^5.3.0",
    "@vitejs/plugin-react": "^4.3.0",
    "vitest": "^1.6.0"
  }
}
```

### MCP Servers
- `@anthropic/mcp-sqlite` — SQLite introspection
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `feature-development` — Electron feature development with IPC patterns
- `testing` — Main process and renderer testing
- `deployment` — Building and distributing desktop apps
- `ipc-communication` — Main ↔ Renderer process communication

---

## 7. Static Site / Blog — Astro

| Layer | Technology |
|-------|-----------|
| Framework | Astro |
| Language | TypeScript |
| Content | Markdown / MDX |
| Styling | Tailwind CSS |
| CMS | Content Collections / Headless CMS |
| Deployment | Netlify / Vercel / Cloudflare Pages |

**Pros:** Zero JavaScript by default (fast), island architecture for interactivity, supports React/Vue/Svelte components, excellent for content.
**Cons:** Not for full web apps, smaller ecosystem than Next.js, SSR support still maturing.
**Best for:** Blogs, documentation sites, marketing sites, portfolios, landing pages.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── content-creation/SKILL.md
│   │   └── deployment/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── src/
│   ├── pages/
│   ├── layouts/
│   ├── components/
│   ├── content/
│   │   ├── blog/
│   │   └── config.ts
│   ├── styles/
│   └── utils/
├── public/
├── docs/
├── GEMINI.md
├── AGENTS.md
├── DESIGN_SYSTEM.md
├── README.md
├── astro.config.mjs
├── tailwind.config.mjs
├── tsconfig.json
└── package.json
```

### Key Packages
```json
{
  "dependencies": {
    "astro": "^4.10.0",
    "@astrojs/tailwind": "^5.1.0",
    "@astrojs/mdx": "^3.1.0",
    "@astrojs/sitemap": "^3.1.0",
    "tailwindcss": "^3.4.0",
    "sharp": "^0.33.0"
  },
  "devDependencies": {
    "typescript": "^5.5.0",
    "prettier": "^3.3.0",
    "prettier-plugin-astro": "^0.14.0"
  }
}
```

### MCP Servers
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `content-creation` — Writing and publishing content
- `deployment` — Static site deployment and CDN configuration
- `component-creation` — Building Astro and framework components

---

## 8. AI/ML Project — Python

| Layer | Technology |
|-------|-----------|
| API | FastAPI |
| Language | Python 3.11+ |
| ML | PyTorch / TensorFlow |
| Notebooks | Jupyter |
| Experiment Tracking | MLflow / Weights & Biases |
| Data | Pandas + NumPy |
| Deployment | Docker + cloud GPU instances |

**Pros:** Python is the ML lingua franca, massive library ecosystem, Jupyter for exploration, FastAPI for serving.
**Cons:** Python performance limitations (mitigated by C extensions), dependency management complexity, GPU infrastructure costs.
**Best for:** ML model development, data pipelines, AI-powered APIs, research projects, data science.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── model-training/SKILL.md
│   │   ├── api-development/SKILL.md
│   │   └── data-pipeline/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── src/
│   ├── api/               # FastAPI serving layer
│   │   ├── main.py
│   │   ├── routes/
│   │   └── schemas/
│   ├── models/            # ML model definitions
│   ├── training/          # Training scripts
│   ├── data/              # Data processing
│   │   ├── loaders/
│   │   ├── transforms/
│   │   └── datasets/
│   ├── evaluation/        # Evaluation metrics
│   └── utils/
├── notebooks/             # Jupyter notebooks
├── data/
│   ├── raw/
│   ├── processed/
│   └── external/
├── models/                # Saved model artifacts
├── configs/               # Experiment configurations
├── tests/
├── docs/
├── GEMINI.md
├── AGENTS.md
├── README.md
├── pyproject.toml
├── Dockerfile
└── docker-compose.yml
```

### Key Packages
```toml
[project]
dependencies = [
    "fastapi>=0.111.0",
    "uvicorn[standard]>=0.30.0",
    "torch>=2.3.0",
    "numpy>=1.26.0",
    "pandas>=2.2.0",
    "scikit-learn>=1.5.0",
    "matplotlib>=3.9.0",
    "pydantic>=2.7.0",
    "python-dotenv>=1.0.0",
    "mlflow>=2.14.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.2.0",
    "ruff>=0.4.0",
    "mypy>=1.10.0",
    "jupyter>=1.0.0",
    "ipykernel>=6.29.0",
]
```

### MCP Servers
- `@anthropic/mcp-filesystem` — File system operations
- `@anthropic/mcp-postgres` — If using PostgreSQL for metadata

### Skills to Generate
- `model-training` — Training workflow with experiment tracking
- `api-development` — FastAPI model serving endpoints
- `data-pipeline` — Data loading, cleaning, and transformation
- `evaluation` — Model evaluation and reporting
- `deployment` — Docker-based model deployment

---

## 9. Game — Unity

| Layer | Technology |
|-------|-----------|
| Engine | Unity 2022 LTS+ |
| Language | C# |
| IDE | Visual Studio / Rider |
| Version Control | Git LFS |
| Testing | Unity Test Framework |
| Build | Unity Build Pipeline |

**Pros:** Massive asset store, cross-platform (mobile, desktop, console, web), visual editor, huge community, mature tooling.
**Cons:** Licensing costs at scale, performance vs Unreal for AAA, runtime size for mobile.
**Best for:** 2D and 3D games, mobile games, indie games, serious games, VR/AR applications.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── feature-development/SKILL.md
│   │   ├── level-design/SKILL.md
│   │   └── testing/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── Assets/
│   ├── Scripts/
│   │   ├── Core/          # Game managers, singletons
│   │   ├── Player/        # Player controller, input
│   │   ├── UI/            # UI controllers
│   │   ├── Systems/       # Game systems (inventory, combat)
│   │   └── Utils/         # Helpers
│   ├── Prefabs/
│   ├── Scenes/
│   ├── Materials/
│   ├── Textures/
│   ├── Audio/
│   ├── Animations/
│   └── Resources/
├── Packages/
├── ProjectSettings/
├── Tests/
│   ├── EditMode/
│   └── PlayMode/
├── docs/
├── GEMINI.md
├── AGENTS.md
├── README.md
├── .gitattributes        # LFS configuration
└── .gitignore
```

### MCP Servers
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `feature-development` — Implementing game features with Unity patterns
- `level-design` — Scene setup and level configuration
- `testing` — Edit-mode and play-mode testing
- `build-pipeline` — Multi-platform build configuration
- `performance` — Profiling and optimization

---

## 10. Game — Godot

| Layer | Technology |
|-------|-----------|
| Engine | Godot 4.x |
| Language | GDScript / C# |
| Testing | GUT (Godot Unit Testing) |
| Build | Godot Export Templates |

**Pros:** Free and open source (MIT), lightweight, GDScript is easy to learn, excellent 2D support, growing 3D capabilities.
**Cons:** Smaller ecosystem than Unity, fewer assets/plugins, less documentation for advanced features.
**Best for:** 2D games, indie games, game jams, learning game development, open-source game projects.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── feature-development/SKILL.md
│   │   └── level-design/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── scenes/
│   ├── main/
│   ├── player/
│   ├── enemies/
│   ├── ui/
│   └── levels/
├── scripts/
│   ├── autoload/          # Singletons
│   ├── player/
│   ├── enemies/
│   ├── systems/
│   └── utils/
├── assets/
│   ├── sprites/
│   ├── audio/
│   ├── fonts/
│   └── shaders/
├── addons/
├── tests/
├── export_presets.cfg
├── docs/
├── GEMINI.md
├── AGENTS.md
├── README.md
└── project.godot
```

### MCP Servers
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `feature-development` — GDScript/C# feature implementation
- `level-design` — Scene composition and level building
- `asset-management` — Importing and organizing game assets
- `export` — Multi-platform export configuration

---

## 11. CLI Tool — Node.js

| Layer | Technology |
|-------|-----------|
| Runtime | Node.js 20+ |
| Language | TypeScript |
| CLI Framework | Commander.js |
| Styling | chalk + ora |
| Testing | Vitest |
| Distribution | npm |

**Pros:** JavaScript ecosystem familiarity, npm distribution, rich CLI libraries, cross-platform.
**Cons:** Node.js runtime required, startup time, large dependency trees possible.
**Best for:** Developer tools, project generators, automation scripts, npm-distributed CLIs.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── command-development/SKILL.md
│   │   └── testing/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── src/
│   ├── commands/          # Individual commands
│   ├── utils/             # Shared utilities
│   ├── types/             # TypeScript types
│   ├── config/            # Configuration handling
│   └── index.ts           # Entry point
├── tests/
├── docs/
├── GEMINI.md
├── AGENTS.md
├── README.md
├── tsconfig.json
└── package.json
```

### Key Packages
```json
{
  "dependencies": {
    "commander": "^12.1.0",
    "chalk": "^5.3.0",
    "ora": "^8.0.0",
    "inquirer": "^9.3.0",
    "conf": "^13.0.0",
    "zod": "^3.23.0"
  },
  "devDependencies": {
    "typescript": "^5.5.0",
    "vitest": "^1.6.0",
    "tsx": "^4.15.0",
    "eslint": "^8.57.0",
    "prettier": "^3.3.0"
  }
}
```

### MCP Servers
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `command-development` — Adding new CLI commands
- `testing` — Testing CLI commands and output
- `distribution` — Publishing to npm

---

## 12. CLI Tool — Go

| Layer | Technology |
|-------|-----------|
| Language | Go 1.22+ |
| CLI Framework | Cobra |
| Config | Viper |
| Testing | Go testing + testify |
| Distribution | goreleaser |

**Pros:** Single binary distribution, fast startup, excellent concurrency, strong standard library, cross-compilation.
**Cons:** Verbose error handling, no generics until recently (now available), smaller web framework ecosystem.
**Best for:** High-performance CLIs, infrastructure tools, system utilities, cross-platform tools.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── command-development/SKILL.md
│   │   └── testing/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── cmd/
│   └── root.go            # Root command
├── internal/
│   ├── commands/          # Command implementations
│   ├── config/            # Configuration
│   └── utils/             # Utilities
├── pkg/                   # Public packages
├── tests/
├── docs/
├── GEMINI.md
├── AGENTS.md
├── README.md
├── go.mod
├── go.sum
├── main.go
├── Makefile
└── .goreleaser.yml
```

### MCP Servers
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `command-development` — Adding new Cobra commands
- `testing` — Go test patterns with testify
- `distribution` — goreleaser-based cross-platform distribution

---

## 13. CLI Tool — Rust

| Layer | Technology |
|-------|-----------|
| Language | Rust |
| CLI Framework | Clap |
| Serialization | Serde |
| Testing | Built-in + assert_cmd |
| Distribution | cargo install / crates.io |

**Pros:** Maximum performance, memory safety, single binary, excellent error handling (Result type), fearless concurrency.
**Cons:** Steep learning curve, longer compilation times, borrow checker can slow development.
**Best for:** Performance-critical CLIs, system tools, security tools, tools that handle large data.

### Folder Structure
```
project-root/
├── .agents/
│   ├── skills/
│   │   ├── command-development/SKILL.md
│   │   └── testing/SKILL.md
│   ├── hooks.json
│   └── mcp_config.json
├── src/
│   ├── commands/
│   ├── config/
│   ├── utils/
│   ├── cli.rs             # Clap argument definitions
│   ├── lib.rs
│   └── main.rs
├── tests/
│   ├── integration/
│   └── fixtures/
├── docs/
├── GEMINI.md
├── AGENTS.md
├── README.md
├── Cargo.toml
└── Cargo.lock
```

### Key Packages
```toml
[dependencies]
clap = { version = "4.5", features = ["derive"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
tokio = { version = "1", features = ["full"] }
anyhow = "1.0"
thiserror = "1.0"
colored = "2.1"
indicatif = "0.17"
dialoguer = "0.11"
dirs = "5.0"

[dev-dependencies]
assert_cmd = "2.0"
predicates = "3.1"
tempfile = "3.10"
```

### MCP Servers
- `@anthropic/mcp-filesystem` — File system operations

### Skills to Generate
- `command-development` — Adding new Clap commands with proper error handling
- `testing` — Integration testing with assert_cmd
- `distribution` — Publishing to crates.io and cross-compilation
