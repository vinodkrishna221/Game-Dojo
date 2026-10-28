# 🏨 BroTel: Gym Bro Hotel Tycoon

> *Sleep. Lift. Chug. Repeat.* An arcade-style 3D top-down hotel management game for **CrazyGames** built with **Unity 3D WebGL**, **CrazyGames SDK v3**, and an automated **Blender 5.0** 3D asset pipeline.

---

## 👥 Multi-Developer Team Architecture

BroTel is organized as a contract-first multi-member project managed under **Game Dojo 2.0 Team Mode**:

| Member | Git Handle | Role | Primary Task Domains |
|---|---|---|---|
| **Lead / Merge Authority** | `@lead` | Technical Lead | Project Architecture, Frozen Contracts, PR Review, Main Merging |
| **Teammate 1** | `@gameplay-dev` | Gameplay Engineer | Core C# Scripts, Player Controller, Guest AI, 5 Hotel Stations, Chaos, Staff |
| **Teammate 2** | `@monetization-dev` | Monetization & WebGL | CrazyGames SDK v3 JSLib Bridge, Ad Pacing, Cloud Save, WebGL Template |
| **Teammate 3** | `@art-dev` | 3D Art & Blender | Blender Procedural Asset Scripts, Low-Poly 3D Models, Materials, Prefabs |

---

## 🚀 Quick Start Guide

### 1. Prerequisites Check
Run the setup script to verify Git, Unity CLI, Blender 5.0, and Node.js:
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/setup.ps1
```

### 2. Generate 3D Assets (Blender 5.0 Headless)
Execute the procedural modeling script to generate all 7 low-poly 3D models into `Assets/Models/`:
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/generate-3d-assets.ps1
# or via npm
npm run generate:assets
```

### 3. Run Quality & Contract Verification
Validate that all JSON configurations, task bounds, and contracts are 100% compliant:
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/verify-project.ps1
# or via npm
npm run test:verify
```

### 4. Local CrazyGames WebGL Testing
Launch a local HTTP server with correct MIME types for `.wasm` and `.data`:
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/serve-local.ps1
# or via npm
npm run dev
```

---

## 🛠️ Team Workflow & Task Branches

1. **Check Out Assigned Branch**:
   Every teammate checks out their designated task branch:
   ```bash
   git checkout feature/TASK-001-gameplay-core    # Teammate 1
   git checkout feature/TASK-002-crazygames-sdk   # Teammate 2
   git checkout feature/TASK-003-blender-assets   # Teammate 3
   ```
2. **Work Within Task Boundaries**:
   Inspect your task manifest at `.ai-team/tasks/<task-id>.json`. You may only modify files listed in `touchesFiles` and `allowedPaths`.
3. **Commit & Open Pull Request**:
   Commit with conventional prefix: `git commit -m "feat(TASK-001): implement player controller and guest ai"`. Push your branch and open a PR.
4. **Lead Review & Merge**:
   The lead (`@lead`) reviews the PR against frozen contracts and merges into `main`.

---

## 📑 Specifications & Frozen Contracts

- **Product Requirements**: [docs/PRD.md](docs/PRD.md)
- **Game Design Document**: [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md)
- **CrazyGames Monetization Guide**: [docs/MONETIZATION_STRATEGY.md](docs/MONETIZATION_STRATEGY.md)
- **System Architecture**: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- **[FROZEN] CrazyGames SDK Bridge**: [docs/contracts/crazygames-bridge-spec.json](docs/contracts/crazygames-bridge-spec.json)
- **[FROZEN] Game State Schema**: [docs/contracts/game-state-schema.json](docs/contracts/game-state-schema.json)
- **[FROZEN] Hotel Station Interface**: [docs/contracts/hotel-station-interface.json](docs/contracts/hotel-station-interface.json)
