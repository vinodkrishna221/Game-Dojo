# Question Bank

A comprehensive interview question bank for gathering project requirements across 9 categories (Category 0 for Project Mode & Team Intake, followed by Categories 1–8 for functional, technical, and operational requirements). Each question includes context on why it matters, a smart default, and conditional follow-ups.

---

## 0. Project Mode & Team Intake

### Q0.1 — Is this a Solo project or a Team project?
- **Why it matters:** Determines whether Game Dojo bootstraps in Solo Mode or activates Team Mode (`.ai-team/` configuration, contract-first planning, role-based task allocation, CODEOWNERS, and parallel task branching).
- **Smart default:** Solo (standard bootstrap).
- **Follow-ups:**
  - If Solo → proceed directly to Category 1 (Project Identity).
  - If Team → triggers Q0.2 through Q0.4 to gather roster details, role assignments, and review preferences, activating the `team-orchestrator` workflow.

### Q0.2 — How many members are on the team?
- **Why it matters:** Dictates milestone slicing, task dependency graph granularity, and workload capacity balancing across parallel work streams.
- **Smart default:** 3 members.
- **Follow-ups:**
  - Are all members developers, or are cross-functional roles included (e.g., designer, QA, tech lead)? (Shapes role taxonomy in `team.json`)
  - Expected team growth during current milestone? (If yes → design modular domain boundaries)

### Q0.3 — What are the team member details (name, git username/email, primary & secondary roles, experience level, weekly availability)?
- **Why it matters:** Populates `.ai-team/team.json` with identity, git handles, skill sets, and weekly bandwidth to enable automated, balanced task assignment with zero overload.
- **Smart default:** 3 developers:
  - **Lead / Full-Stack** (`lead`): Name: "Lead Developer", Git: `@lead` (`lead@example.com`), Primary: `lead`, Secondary: `fullstack`, Senior, 40h/week
  - **Frontend Specialist** (`frontend`): Name: "Frontend Developer", Git: `@frontend` (`frontend@example.com`), Primary: `frontend`, Secondary: `ui-ux`, Mid, 40h/week
  - **Backend Specialist** (`backend`): Name: "Backend Developer", Git: `@backend` (`backend@example.com`), Primary: `backend`, Secondary: `devops`, Mid, 40h/week
- **Follow-ups:**
  - For each member, collect:
    - **Name & Git username/email** (e.g., Jane Doe, `@janedoe` / `jane@example.com`)
    - **Primary & Secondary roles** (e.g., `frontend` / `ui-ux`, `backend` / `devops`, `fullstack` / `qa`)
    - **Experience level** (`junior`, `mid`, `senior`, `lead`)
    - **Weekly availability** (Hours per week: 10h, 20h, 40h)
  - Any domain specialties or ownership preferences? (e.g., auth, payment gateway, database migrations)

### Q0.4 — What are your team branching and review preferences?
- **Why it matters:** Configures git branching rules, GitHub Actions PR workflows, and automated `CODEOWNERS` reviewer routing.
- **Smart default:** Protected `main` branch, PR required with at least 1 peer approval, feature branches named `feature/<task-id>-<slug>`.
- **Follow-ups:**
  - Require automated CI/CD checks to pass before merging? (Default: yes)
  - Enforce `.github/CODEOWNERS` approvals by directory or subsystem? (Default: yes)
  - Squash and merge vs merge commits? (Default: squash and merge for clean history)

---

## 1. Project Identity

### Q1.1 — What is the project name?
- **Why it matters:** Sets the repository name, package name, branding, and all configuration filenames.
- **Smart default:** Derived from the project description (e.g., "recipe app" → `recipe-app`)
- **Follow-ups:**
  - Is there an existing brand or logo? (If yes → affects DESIGN_SYSTEM.md color palette)
  - Is the name finalized, or a working title? (If working title → use it but note it's changeable)

### Q1.2 — Describe your project in one sentence (tagline).
- **Why it matters:** Goes into README, meta tags, app store descriptions. Forces clarity of purpose.
- **Smart default:** Auto-generated from the project description.
- **Follow-ups:** None.

### Q1.3 — Who are your target users?
- **Why it matters:** Drives UX decisions, accessibility requirements, language/i18n needs, and performance targets (e.g., low-bandwidth users need lighter bundles).
- **Smart default:** "General consumers" for B2C, "Internal team" for tools, "Developers" for dev-tools.
- **Follow-ups:**
  - What's their technical proficiency? (Beginner / Intermediate / Advanced)
  - Any specific age group or accessibility needs? (If yes → bump WCAG level to AAA)

### Q1.4 — What is the #1 core problem this project solves?
- **Why it matters:** Anchors the MVP feature set. Every feature must trace back to solving this problem.
- **Smart default:** Inferred from the description.
- **Follow-ups:**
  - How are users currently solving this problem? (Helps identify competitive advantages)
  - What would make someone switch to your solution? (Identifies the unique value proposition)

### Q1.5 — How will you measure success?
- **Why it matters:** Determines which analytics, metrics, and monitoring to integrate. Shapes the docs/DEPLOYMENT.md monitoring section.
- **Smart default:** "User signups and weekly active users" for consumer apps, "Task completion rate" for tools, "API request volume" for backends.
- **Follow-ups:**
  - Do you need an analytics dashboard? (If yes → add analytics integration)
  - Any specific KPIs or OKRs? (If yes → embed in ARCHITECTURE.md)

---

## 2. Technical Stack

### Q2.1 — What is your primary programming language?
- **Why it matters:** Determines linting, type checking, package manager, and all downstream tooling choices.
- **Smart default:** TypeScript (most versatile for web), Python (for data/ML/backend), Dart (for mobile with Flutter).
- **Follow-ups:**
  - Any version constraints? (e.g., must use Python 3.11+, Node 20+)
  - Are you open to TypeScript if starting with JavaScript? (Usually yes → recommend TS)

### Q2.2 — Do you have a preferred framework?
- **Why it matters:** The framework choice cascades into folder structure, routing, state management, and deployment options.
- **Smart default:** Next.js (web), FastAPI (Python API), Flutter (mobile), Electron (desktop).
- **Follow-ups:**
  - Any specific version? (e.g., Next.js 14 with App Router vs Pages Router)
  - Is this a hard requirement or are you open to alternatives? (Flexibility affects recommendations)

### Q2.3 — What type of database do you need?
- **Why it matters:** Relational vs document vs key-value fundamentally changes data modeling, query patterns, and ORM choice.
- **Smart default:** PostgreSQL (structured data), MongoDB (flexible/document data), SQLite (embedded/local), None (static sites).
- **Follow-ups:**
  - How complex are your data relationships? (Complex → relational, Simple → document)
  - Do you need full-text search? (If yes → consider Elasticsearch or PostgreSQL FTS)
  - Expected data volume? (Large → influences indexing and caching strategy)

### Q2.4 — What API style do you prefer?
- **Why it matters:** Affects how frontend and backend communicate, documentation format, and client generation.
- **Smart default:** REST (most common), GraphQL (complex nested data), gRPC (microservices), tRPC (full-stack TypeScript).
- **Follow-ups:**
  - Do you need real-time capabilities? (If yes → add WebSocket/SSE layer)
  - Will third parties consume this API? (If yes → prioritize OpenAPI spec and versioning)

### Q2.5 — Do you need server-side rendering (SSR) or static generation (SSG)?
- **Why it matters:** Impacts SEO, initial load performance, hosting requirements, and framework choice.
- **Smart default:** SSR (dynamic content apps), SSG (content sites/blogs), CSR (internal tools/dashboards).
- **Follow-ups:**
  - Is SEO critical for your project? (If yes → SSR or SSG is essential)
  - Do you need incremental static regeneration (ISR)? (Next.js specific)

---

## 3. Architecture

### Q3.1 — Monolith or microservices?
- **Why it matters:** Dramatically changes project structure, deployment complexity, and team coordination needs.
- **Smart default:** Monolith (solo dev or small team, MVP), Modular monolith (medium team), Microservices (large team, proven domain).
- **Follow-ups:**
  - How many developers will work on this? (1–3 → monolith, 4+ → consider modular)
  - Do different parts of the system need to scale independently? (If yes → microservices)

### Q3.2 — How do you want to split frontend and backend?
- **Why it matters:** Affects repository structure, deployment pipeline, CORS configuration, and developer experience.
- **Smart default:** Unified (Next.js/Nuxt), Separate repos (SPA + API), Monorepo (Turborepo/Nx).
- **Follow-ups:**
  - Will the frontend and backend be deployed to different services? (If yes → separate or monorepo)
  - Do you need a shared type system between frontend and backend? (If yes → monorepo with shared packages)

### Q3.3 — Do you need real-time features?
- **Why it matters:** Real-time adds significant architectural complexity — WebSocket servers, connection management, state synchronization.
- **Smart default:** No (most apps), Yes with WebSockets (chat, live updates), Yes with SSE (notifications, feeds).
- **Follow-ups:**
  - What needs to be real-time? (Chat, notifications, live dashboards, collaborative editing)
  - How many concurrent connections do you expect? (Affects infrastructure sizing)

### Q3.4 — What's your caching strategy?
- **Why it matters:** Caching is the #1 performance optimization. The wrong strategy causes stale data bugs.
- **Smart default:** Browser caching + CDN (static sites), Redis (session/API caching), In-memory (small apps), None (simple MVPs).
- **Follow-ups:**
  - Do you have data that changes infrequently but is read often? (If yes → aggressive caching)
  - Do you need cache invalidation across multiple instances? (If yes → Redis or similar)

### Q3.5 — Do you need background job processing?
- **Why it matters:** Email sending, image processing, report generation — anything that takes >1 second should be async.
- **Smart default:** No (simple apps), Yes with a queue (BullMQ, Celery), Yes with serverless functions (simple tasks).
- **Follow-ups:**
  - What tasks need to run in the background? (Helps size the worker infrastructure)
  - Do any tasks need to be scheduled/recurring? (If yes → add cron-like scheduler)

---

## 4. Core Features

### Q4.1 — List your MVP features (the absolute minimum to launch).
- **Why it matters:** Defines the scope of generated skills, API endpoints, database tables, and components.
- **Smart default:** Inferred from the project type (e.g., e-commerce → product listing, cart, checkout; social → profiles, posts, feed).
- **Follow-ups:**
  - Can you prioritize these? (P0 = must have, P1 = should have, P2 = nice to have)
  - Are any features complex enough to be their own module? (If yes → separate skill per module)

### Q4.2 — What type of authentication do you need?
- **Why it matters:** Auth touches every layer — database schema, API middleware, frontend routing, session management.
- **Smart default:** Email/password + OAuth (consumer apps), OAuth only (dev tools), API keys (machine-to-machine), None (public tools).
- **Follow-ups:**
  - Which OAuth providers? (Google, GitHub, Apple, Facebook, etc.)
  - Do you need role-based access control (RBAC)? (If yes → adds roles table and middleware)
  - Do you need multi-factor authentication (MFA)? (If yes → adds TOTP/SMS integration)

### Q4.3 — Do you need file uploads?
- **Why it matters:** File handling requires storage integration (S3, GCS, Cloudflare R2), upload size limits, file type validation, and often image processing.
- **Smart default:** No (most apps), Yes — images only (profiles, posts), Yes — documents (PDF, DOCX), Yes — mixed media.
- **Follow-ups:**
  - What's the max file size? (Affects upload strategy — direct vs presigned URL vs chunked)
  - Do you need image transformation? (Resize, crop, thumbnails → add image processing pipeline)

### Q4.4 — Do you need search functionality?
- **Why it matters:** Simple search uses database LIKE/ILIKE queries; complex search needs Elasticsearch, Algolia, or Meilisearch.
- **Smart default:** No (simple apps), Basic database search (small datasets), Full-text search engine (large datasets or complex queries).
- **Follow-ups:**
  - How many searchable records? (<10K → database, 10K–1M → PostgreSQL FTS, >1M → dedicated search engine)
  - Do you need autocomplete/suggestions? (If yes → add search index with prefix matching)
  - Do you need faceted search/filters? (If yes → Elasticsearch or Meilisearch)

### Q4.5 — Do you need notifications?
- **Why it matters:** Notifications span multiple channels (in-app, email, push, SMS) and require queuing, preferences, and templates.
- **Smart default:** Email only (most apps), In-app + email (social/collaborative apps), Push + email (mobile apps), None (simple tools).
- **Follow-ups:**
  - Which channels? (In-app, email, push, SMS, Slack)
  - Do users need notification preferences/settings? (Usually yes → add preferences table)

---

## 5. Integrations

### Q5.1 — Do you need payment processing?
- **Why it matters:** Payments require PCI compliance awareness, webhook handling, subscription management, and careful error handling.
- **Smart default:** No (non-commercial apps), Stripe (most cases), PayPal (international focus), Both (maximum reach).
- **Follow-ups:**
  - One-time payments, subscriptions, or both? (Affects Stripe configuration significantly)
  - Do you need invoicing? (If yes → Stripe Invoicing or custom)
  - Multiple currencies? (If yes → configure Stripe for multi-currency)

### Q5.2 — Do you need email sending?
- **Why it matters:** Transactional emails (verification, reset password, receipts) vs marketing emails have different provider needs.
- **Smart default:** Resend (modern, developer-friendly), SendGrid (established), AWS SES (cost-effective at scale), None.
- **Follow-ups:**
  - Transactional only or marketing too? (Marketing → add email list management)
  - Do you need email templates? (Usually yes → set up template system)

### Q5.3 — Do you need cloud storage (beyond database)?
- **Why it matters:** User uploads, generated reports, media files — all need object storage with CDN.
- **Smart default:** AWS S3 (most common), Cloudflare R2 (no egress fees), GCS (if on GCP), Supabase Storage (if using Supabase), None.
- **Follow-ups:**
  - Do you need CDN for stored files? (Usually yes → CloudFront, Cloudflare, or Vercel)
  - Public or private files? (Private → add presigned URL generation)

### Q5.4 — Do you need analytics or tracking?
- **Why it matters:** Product analytics inform feature decisions, marketing analytics drive growth.
- **Smart default:** Vercel Analytics (Next.js), PostHog (self-hostable, privacy-focused), Google Analytics (established), None (internal tools).
- **Follow-ups:**
  - Privacy-sensitive market (EU/GDPR)? (If yes → avoid GA, use privacy-focused alternative)
  - Do you need custom event tracking? (If yes → add event tracking utility layer)

### Q5.5 — Do you need AI/ML integration?
- **Why it matters:** AI features require API keys, token management, prompt engineering patterns, and often streaming responses.
- **Smart default:** No (most apps), OpenAI API (general AI features), Hugging Face (custom models), Local models (privacy-critical).
- **Follow-ups:**
  - What AI features? (Chat, summarization, image generation, search, classification)
  - Do you need streaming responses? (If yes → add SSE/streaming infrastructure)
  - Budget constraints for API usage? (Affects model choice and caching strategy)

---

## 6. Development Workflow

### Q6.1 — What's your team size?
- **Why it matters:** Solo devs need simplicity; teams need conventions, code review processes, and CI/CD.
- **Smart default:** Solo developer.
- **Follow-ups:**
  - Will the team grow? (If yes → set up for scale from the start)
  - Any junior developers? (If yes → stricter linting, more documentation)

### Q6.2 — What git branching strategy do you prefer?
- **Why it matters:** Affects CI/CD configuration, release process, and hooks.json setup.
- **Smart default:** GitHub Flow (simple: main + feature branches), GitFlow (complex: main + develop + feature + release), Trunk-based (continuous deployment).
- **Follow-ups:**
  - Do you need release branches? (If yes → GitFlow)
  - How often do you deploy? (Daily → trunk-based, Weekly+ → GitHub Flow)

### Q6.3 — What CI/CD tool do you use?
- **Why it matters:** Determines the CI configuration file format and deployment automation.
- **Smart default:** GitHub Actions (GitHub repos), GitLab CI (GitLab repos), Vercel (Next.js auto-deploy), None yet.
- **Follow-ups:**
  - Do you need staging environments? (If yes → add staging deployment config)
  - Do you need deployment approvals? (If yes → add manual approval step)

### Q6.4 — What's your testing philosophy?
- **Why it matters:** Shapes the testing skill, CI pipeline, and code coverage requirements.
- **Smart default:** Pragmatic testing (test critical paths, not everything), TDD (test-first development), Minimal testing (prototype/MVP speed).
- **Follow-ups:**
  - Do you want code coverage thresholds? (If yes → set in CI config, typically 70–80%)
  - E2E testing needed? (If yes → add Playwright/Cypress)
  - Do you want visual regression testing? (If yes → add Chromatic or Percy)

### Q6.5 — What code quality tools do you want?
- **Why it matters:** Linting and formatting ensure consistency, especially with AI-generated code.
- **Smart default:** ESLint + Prettier (JS/TS), Ruff (Python), `dart analyze` + `dart format` (Dart).
- **Follow-ups:**
  - Strict or relaxed linting rules? (Strict → catches more issues, relaxed → fewer interruptions)
  - Do you want pre-commit hooks? (Usually yes → configure in hooks.json)

---

## 7. Design & UX

### Q7.1 — What UI framework or component library do you prefer?
- **Why it matters:** Drives the entire DESIGN_SYSTEM.md structure and component generation patterns.
- **Smart default:** Tailwind CSS + shadcn/ui (modern, customizable), Material UI (Google design), Chakra UI (accessible), Ant Design (enterprise), None/custom.
- **Follow-ups:**
  - Do you want pre-built components or fully custom? (Pre-built → faster, custom → more control)
  - Any existing design system or Figma files? (If yes → extract tokens into DESIGN_SYSTEM.md)

### Q7.2 — Do you need dark mode?
- **Why it matters:** Requires CSS variable architecture, theme context, and toggle component.
- **Smart default:** Yes with system preference detection (modern standard), Light only (simple apps), Dark only (dev tools, gaming).
- **Follow-ups:**
  - System preference auto-detection? (Usually yes → add `prefers-color-scheme` support)
  - User toggle to override? (Usually yes → add theme switcher component)

### Q7.3 — What responsive breakpoints do you need?
- **Why it matters:** Determines the grid system, component variants, and testing requirements.
- **Smart default:** Mobile-first with sm/md/lg/xl (Tailwind defaults), Desktop-only (internal tools), Mobile-only (mobile app webviews).
- **Follow-ups:**
  - Is mobile the primary platform? (If yes → mobile-first approach)
  - Do you need to support tablets specifically? (If yes → add tablet breakpoint)

### Q7.4 — What accessibility (a11y) level do you need?
- **Why it matters:** Legal compliance (ADA, EEA), broader user base, and better SEO.
- **Smart default:** WCAG 2.1 AA (standard for most projects), WCAG 2.1 AAA (government, healthcare, education), Basic (prototypes).
- **Follow-ups:**
  - Any specific accessibility requirements? (Screen reader support, keyboard navigation, color contrast)
  - Do you need accessibility testing in CI? (If yes → add axe-core or similar)

### Q7.5 — Do you have brand colors or a design direction?
- **Why it matters:** Seeds the entire color palette in DESIGN_SYSTEM.md.
- **Smart default:** Generate a professional palette based on the project domain (blue for finance, green for health, purple for creative).
- **Follow-ups:**
  - Any specific brand colors (hex codes)? (If yes → build palette around them)
  - Preferred visual style? (Minimal, playful, corporate, bold)

---

## 8. Deployment & Ops

### Q8.1 — Where do you want to deploy?
- **Why it matters:** Determines infrastructure configuration, CI/CD targets, and cost structure.
- **Smart default:** Vercel (Next.js/frontend), Railway (full-stack), AWS (enterprise/custom), Fly.io (Docker), Self-hosted (internal).
- **Follow-ups:**
  - Do you have an existing cloud account? (If yes → use that provider)
  - Any budget constraints? (If tight → prioritize serverless/free tiers)

### Q8.2 — Do you need containerization?
- **Why it matters:** Docker adds consistency but also complexity. Kubernetes adds orchestration but significant overhead.
- **Smart default:** Docker (team projects, microservices), Docker Compose (local dev with multiple services), No (serverless deployments, simple apps).
- **Follow-ups:**
  - Do you need Kubernetes? (Only for large-scale, multi-service deployments)
  - Do you need a local dev environment that mirrors production? (If yes → Docker Compose)

### Q8.3 — Do you have a domain name?
- **Why it matters:** Affects DNS configuration, SSL setup, and deployment documentation.
- **Smart default:** Not yet (use platform subdomain initially), Yes (configure DNS in deployment docs).
- **Follow-ups:**
  - Where is it registered? (Helps with DNS configuration instructions)
  - Do you need subdomains? (e.g., api.example.com, docs.example.com)

### Q8.4 — What monitoring and logging do you need?
- **Why it matters:** Production issues without monitoring are invisible. Logging without structure is useless.
- **Smart default:** Platform built-in (Vercel/Railway analytics), Sentry (error tracking), DataDog (full observability), Basic console logging (MVP).
- **Follow-ups:**
  - Do you need error alerting? (If yes → Sentry or PagerDuty)
  - Do you need structured logging? (If yes → add Winston/Pino for Node, structlog for Python)
  - Do you need uptime monitoring? (If yes → add Better Uptime, Checkly, or similar)

### Q8.5 — What environments do you need?
- **Why it matters:** Determines the number of deployment targets, environment variable sets, and CI/CD stages.
- **Smart default:** Development + Production (minimum), Development + Staging + Production (recommended for teams).
- **Follow-ups:**
  - Do you need preview deployments for PRs? (If yes → Vercel/Netlify preview deploys)
  - Do you need environment-specific feature flags? (If yes → add feature flag system)
