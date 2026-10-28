# Game Dojo Workflow Guide

This guide walks through the complete Game Dojo bootstrapping workflow using a real example. Follow along to understand exactly what happens at each phase.

---

## Example Project: "Build me a recipe sharing app"

A user opens a new session and types:

> "Build me a recipe sharing app where people can post recipes, rate them, and save favorites. I want it to be a web app."

Here's exactly what Game Dojo does with that input.

---

## Phase 1: Discovery (Structured Interview)

Game Dojo launches the Interview Engine, which asks categorized questions to fill in details the user didn't specify.

### Questions Asked

**Category: Project Identity**

| # | Question | Sample Answer |
|---|----------|---------------|
| 1 | What would you like to call this project? | "RecipeHub" |
| 2 | In one sentence, what is the core purpose? | "A community platform for sharing, discovering, and saving recipes" |
| 3 | Who is the primary audience? | "Home cooks and food enthusiasts" |

**Category: Features & Scope**

| # | Question | Sample Answer |
|---|----------|---------------|
| 4 | Let me confirm the features I heard. You mentioned: recipe posting, ratings, and favorites. Anything else? | "Yes, also add search by ingredient and a meal planner" |
| 5 | Which features are must-haves for launch vs nice-to-haves? | "Recipe posting, ratings, favorites, and search are must-haves. Meal planner is nice-to-have." |
| 6 | Do users need accounts? What kind of authentication? | "Yes, email/password and Google login" |

**Category: Technical Preferences**

| # | Question | Sample Answer |
|---|----------|---------------|
| 7 | Do you have a preferred frontend framework? (React, Vue, Svelte, Angular, or no preference) | "React" |
| 8 | Do you have a backend preference? (Node.js, Python, Go, or no preference) | "Node.js" |
| 9 | Database preference? (PostgreSQL, MongoDB, MySQL, or no preference) | "No preference — you pick" |
| 10 | Where do you plan to host this? (Vercel, AWS, Railway, self-hosted, or no preference) | "Vercel" |

**Category: Constraints**

| # | Question | Sample Answer |
|---|----------|---------------|
| 11 | What's your timeline? | "MVP in 2 months" |
| 12 | Team size? | "Just me" |
| 13 | Any budget constraints for services? | "Free tier only to start" |

### Discovery Output

The Interview Engine produces a structured requirements object:

```json
{
  "projectName": "RecipeHub",
  "projectType": "web-app",
  "description": "A community platform for sharing, discovering, and saving recipes",
  "audience": {
    "primary": "Home cooks and food enthusiasts",
    "secondary": "Food bloggers, nutritionists"
  },
  "features": [
    { "name": "Recipe CRUD", "priority": "must-have", "description": "Create, read, update, delete recipes with images" },
    { "name": "Ratings & Reviews", "priority": "must-have", "description": "5-star rating system with text reviews" },
    { "name": "Favorites", "priority": "must-have", "description": "Save recipes to personal favorites list" },
    { "name": "Ingredient Search", "priority": "must-have", "description": "Search recipes by ingredient" },
    { "name": "Meal Planner", "priority": "nice-to-have", "description": "Weekly meal planning with shopping list" }
  ],
  "techPreferences": {
    "frontend": "React",
    "backend": "Node.js",
    "database": "no-preference",
    "hosting": "Vercel"
  },
  "auth": {
    "methods": ["email-password", "google-oauth"]
  },
  "constraints": {
    "timeline": "2 months MVP",
    "teamSize": 1,
    "budget": "free-tier"
  }
}
```

---

## Phase 2: Analysis (Architecture Decisions)

The Analysis Engine evaluates the requirements and makes architectural decisions, using sequential-thinking for complex trade-offs.

### Key Decisions Made

| Decision | Choice | Reasoning |
|----------|--------|-----------|
| Frontend | Next.js (React) | User wants React + Vercel hosting → Next.js is optimal for SSR/SSG on Vercel |
| Backend | Next.js API Routes | Solo developer + Vercel hosting → co-located API reduces complexity |
| Database | PostgreSQL via Supabase | Relational data (recipes, users, ratings) + free tier + built-in auth |
| Auth | Supabase Auth | Supports email/password + Google OAuth, free tier, no separate service needed |
| Image Storage | Supabase Storage | Co-located with database, free tier includes 1GB |
| Search | PostgreSQL full-text search | Simpler than Elasticsearch for MVP scale, no extra service |
| Styling | Tailwind CSS | Fast iteration for solo developer, great Next.js integration |

### Architecture Pattern

```
Monolithic Next.js Application
├── Frontend: React (Next.js App Router)
├── API: Next.js Route Handlers
├── Database: Supabase (PostgreSQL)
├── Auth: Supabase Auth
├── Storage: Supabase Storage
└── Hosting: Vercel (free tier)
```

---

## Phase 3: Generation (File Creation)

The Template Engine renders all project files in dependency order.

### Files Generated (in order)

```
RecipeHub/
├── docs/
│   ├── PROJECT_BRIEF.md          ← 1st: Foundation document
│   ├── REQUIREMENTS.md           ← 2nd: Detailed requirements
│   ├── ARCHITECTURE.md           ← 3rd: Technical architecture
│   ├── DESIGN_SYSTEM.md          ← 4th: UI/UX design tokens
│   ├── DATA_MODEL.md             ← 5th: Database schema
│   ├── API_SPEC.md               ← 6th: API endpoint docs
│   └── IMPLEMENTATION_PLAN.md    ← 7th: Sprint-by-sprint plan
├── .agents/
│   ├── hooks.json                ← Lifecycle hooks
│   ├── mcp_config.json           ← MCP server config
│   └── scripts/
│       ├── welcome.ps1
│       ├── lint-markdown.ps1
│       └── validation-reminder.ps1
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── recipes/
│   │   │   ├── page.tsx
│   │   │   └── [id]/
│   │   │       └── page.tsx
│   │   └── api/
│   │       └── recipes/
│   │           └── route.ts
│   ├── components/
│   │   └── ui/
│   │       └── .gitkeep
│   └── lib/
│       ├── supabase.ts
│       └── types.ts
├── supabase/
│   └── migrations/
│       └── .gitkeep
├── public/
│   └── .gitkeep
├── package.json
├── tsconfig.json
├── tailwind.config.ts
├── next.config.js
├── .env.example
├── .gitignore
└── README.md
```

### Sample Generated Content

Here's what the generated `docs/PROJECT_BRIEF.md` looks like:

```markdown
---
project: RecipeHub
type: web-app
status: scaffolded
created: 2024-01-15
---

# RecipeHub — Project Brief

## Vision
A community platform for sharing, discovering, and saving recipes,
built for home cooks and food enthusiasts.

## Target Audience
- **Primary:** Home cooks looking for recipe inspiration
- **Secondary:** Food bloggers wanting to share their creations

## Core Features (MVP)
1. Recipe CRUD — Full recipe management with image uploads
2. Ratings & Reviews — 5-star system with text reviews
3. Favorites — Personal saved recipes collection
4. Ingredient Search — Find recipes by what you have

## Future Features
- Meal Planner with shopping list generation

## Technical Summary
| Component | Technology |
|-----------|-----------|
| Frontend  | Next.js 14 (App Router) |
| Styling   | Tailwind CSS |
| Backend   | Next.js Route Handlers |
| Database  | Supabase (PostgreSQL) |
| Auth      | Supabase Auth |
| Hosting   | Vercel |

## Constraints
- Solo developer
- 2-month MVP timeline
- Free-tier services only
```

---

## Phase 4: Validation

The Validation Engine checks all generated files:

```
✅ Validation Report for RecipeHub
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files checked: 24
Passed: 23
Warnings: 1

Checks performed:
  ✅ All required docs exist (7/7)
  ✅ All docs have valid frontmatter
  ✅ All cross-references resolve
  ✅ All required sections present
  ✅ package.json has correct dependencies
  ✅ .env.example lists all required variables
  ⚠️  DATA_MODEL.md references 'meal_plans' table but
     Meal Planner is marked as nice-to-have (not in MVP scope)

Recommendation: Consider adding a note in DATA_MODEL.md that
the meal_plans table is for post-MVP implementation.
```

---

## Phase 5: Presentation

Game Dojo presents a summary to the user:

```
🥋 RecipeHub has been bootstrapped!

📁 24 files created across 4 directories
📝 7 documentation files with full project specs
⚙️  Agent configuration with lifecycle hooks
🏗️  Project skeleton ready for development

Quick start:
  1. Run `npm install` to install dependencies
  2. Copy `.env.example` to `.env.local` and fill in your Supabase keys
  3. Run `npm run dev` to start the development server

📦 Marketplace suggestions:
  • supabase-plugin — Supabase integration helpers and migration tools
  • nextjs-auth-plugin — Pre-built auth components for Next.js + Supabase
  • tailwind-ui-kit — Ready-made Tailwind components for common UI patterns

Would you like me to install any of these plugins?
```

---

## Before & After Comparison

### Before: Empty Workspace

```
d:\RecipeHub\
└── (empty)
```

The user has nothing — just an idea and an empty folder.

### After: Bootstrapped Workspace

```
d:\RecipeHub\
├── .agents/
│   ├── hooks.json                    # Automated quality checks
│   ├── mcp_config.json               # AI reasoning tools
│   ├── MCP_GUIDE.md                  # Server documentation
│   ├── scripts/
│   │   ├── welcome.ps1               # Session greeting
│   │   ├── lint-markdown.ps1         # Auto-lint on file write
│   │   └── validation-reminder.ps1   # Post-invocation reminder
│   └── plugins/
│       └── game-dojo/
│           ├── plugin.json           # Plugin manifest
│           └── rules/
│               └── AGENTS.md         # Behavioral rules
├── docs/
│   ├── PROJECT_BRIEF.md              # What are we building?
│   ├── REQUIREMENTS.md               # Detailed feature specs
│   ├── ARCHITECTURE.md               # How is it structured?
│   ├── DESIGN_SYSTEM.md              # How does it look?
│   ├── DATA_MODEL.md                 # What's the schema?
│   ├── API_SPEC.md                   # What are the endpoints?
│   └── IMPLEMENTATION_PLAN.md        # What do we build when?
├── src/
│   ├── app/                          # Next.js App Router pages
│   ├── components/                   # Reusable UI components
│   └── lib/                          # Utilities and types
├── supabase/
│   └── migrations/                   # Database migrations
├── public/                           # Static assets
├── package.json                      # Dependencies configured
├── tsconfig.json                     # TypeScript configured
├── tailwind.config.ts                # Tailwind configured
├── next.config.js                    # Next.js configured
├── .env.example                      # Environment variables documented
├── .gitignore                        # Git ignore rules
└── README.md                         # Project README with setup instructions
```

The user now has a complete, documented, and configured project ready for development. Every file is immediately usable — no placeholders, no TODOs, no guesswork.

---

## Key Principles

1. **Structure before code** — Documentation and architecture decisions come before any implementation files
2. **Dependency-ordered generation** — Files are created in an order that ensures references always resolve
3. **Template-driven consistency** — All docs follow the same patterns and conventions
4. **Validation as a safety net** — Automated checks catch inconsistencies before the user sees them
5. **Extensibility by design** — New templates, questions, and tech stacks can be added without changing core logic
