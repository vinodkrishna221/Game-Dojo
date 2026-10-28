# BroTel: Gym Bro Hotel Tycoon — Project Rules

> **BroTel** is an arcade-style 3D top-down / isometric hotel management game built for **CrazyGames** in Unity 3D (WebGL). Players operate a luxury hotel for gym bros—checking in swole guests, blending high-protein shakes, spotting heavy bench presses, cleaning chalk spills, and handling comedic chaos.

---

## 1. Project Context & Stack

| Layer | Technology | Version / Specification |
|---|---|---|
| **Engine** | Unity 3D (C#) | WebGL 2.0 / Universal or Built-in Render Pipeline |
| **Platform** | CrazyGames | HTML5 WebGL Browser Target |
| **SDK** | CrazyGames SDK v3 | `https://sdk.crazygames.com/crazygames-sdk-v3.js` |
| **Bridge** | Unity WebGL `.jslib` | `Assets/Plugins/WebGL/CrazyGamesSDK.jslib` |
| **3D Asset Pipeline** | Blender 5.0 | Headless Python `bpy` scripting & Blender MCP server |
| **Package / Tooling** | Node.js / PowerShell | Setup, asset generation, and local CORS dev server |
| **Team Mode** | Game Dojo 2.0 | `.ai-team/` task manifests, branch isolation, and CODEOWNERS |

---

## 2. Team Mode & Collaboration Protocol

BroTel is developed by a **4-member squad**:
- **Technical Lead & Merge Authority**: `@lead` (The User)
- **C# Gameplay Engineer**: `@gameplay-dev` (Player, AI, Stations, Chaos, Staff)
- **Monetization & WebGL Engineer**: `@monetization-dev` (CrazyGames SDK v3, JSLib bridge, Ad pacing, Cloud Save)
- **3D Art & Blender Specialist**: `@art-dev` (Low-poly models, materials, prefabs)

### Mandatory Team Rules:
1. **Branch-Task Association**: Every developer and AI agent must work on their assigned git branch matching `feature/<task-id>-<slug>` (e.g. `feature/TASK-001-gameplay-core`).
2. **Strict Scope Bounding (`touchesFiles`)**: Confine all file creations, edits, and deletions strictly to the paths enumerated in `.ai-team/tasks/<task-id>.json`.
3. **Contract-First Conformance**: Shared interfaces in `docs/contracts/` are **FROZEN (v1.0-CONTRACT)**. Do not introduce breaking contract changes unilaterally.
4. **Main Branch Protection**: Direct commits to `main` are strictly forbidden. All changes must be submitted via pull request and merged exclusively by `@lead`.

---

## 3. C# & Unity Coding Standards

1. **Naming Conventions**:
   - Classes, Enums, Structs, and Methods: `PascalCase` (`GameManager`, `PlayerController`, `StartWorkout`).
   - Private Fields: `_camelCase` with leading underscore (`_currentBroCoins`, `_patienceTimer`).
   - Public Properties: `PascalCase` (`public int BroCoins => _currentBroCoins;`).
   - Constants: `ALL_CAPS` (`MAX_INVENTORY_SLOTS`).
2. **Zero Allocation in Update Loops**:
   - Cache `GetComponent` references in `Awake()` or `Start()`.
   - Never use `new List<>()` or LINQ queries inside `Update()` or per-frame callbacks.
3. **WebGL Compatibility**:
   - Wrap WebGL-specific calls in `#if UNITY_WEBGL && !UNITY_EDITOR` with editor mock fallbacks.
   - Use `DontDestroyOnLoad` for core singletons (`GameManager`, `EconomyManager`, `CrazyGamesSDK`).
4. **Ad Audio & Time Handling**:
   - Always mute `AudioListener.pause = true` and set `Time.timeScale = 0f` on ad start; restore upon ad finish or error.

---

## 4. Key Documentation & Contract Links

- **Product Requirements**: [docs/PRD.md](file:///d:/Game_dojo/docs/PRD.md)
- **System Architecture**: [docs/ARCHITECTURE.md](file:///d:/Game_dojo/docs/ARCHITECTURE.md)
- **Game Design Document**: [docs/GAME_DESIGN.md](file:///d:/Game_dojo/docs/GAME_DESIGN.md)
- **Monetization Strategy**: [docs/MONETIZATION_STRATEGY.md](file:///d:/Game_dojo/docs/MONETIZATION_STRATEGY.md)
- **Frozen Contracts**:
  - [CrazyGames Bridge Contract](file:///d:/Game_dojo/docs/contracts/crazygames-bridge-spec.json)
  - [Game State Schema](file:///d:/Game_dojo/docs/contracts/game-state-schema.json)
  - [Station Interface Contract](file:///d:/Game_dojo/docs/contracts/hotel-station-interface.json)
- **Team Governance**: [.ai-team/team.json](file:///d:/Game_dojo/.ai-team/team.json) | [.ai-team/plan.json](file:///d:/Game_dojo/.ai-team/plan.json)
