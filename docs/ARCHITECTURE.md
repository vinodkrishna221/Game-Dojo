# System Architecture: BroTel: Gym Bro Hotel Tycoon

## 1. System Overview

BroTel is built on a modular, contract-first Unity WebGL architecture. The game combines a C# gameplay simulation engine with a JavaScript bridge communicating with the CrazyGames SDK v3 runtime. Stylized low-poly 3D assets are procedurally generated via an automated Blender 5.0 pipeline.

```mermaid
flowchart TD
    subgraph Browser ["Web Browser Runtime (CrazyGames)"]
        CG_SDK["CrazyGames SDK v3 Script"]
        HTML_Template["CrazyGames WebGL Template (index.html)"]
        JSLib_Bridge["CrazyGamesSDK.jslib Bridge"]
    end

    subgraph Unity ["Unity WebGL Engine (C#)"]
        CG_Manager["CrazyGamesSDK.cs (C# Wrapper)"]
        Ad_Placements["AdPlacementManager.cs"]
        Cloud_Save["CloudSaveManager.cs"]
        
        Game_Manager["GameManager.cs (State Machine)"]
        Economy["EconomyManager.cs (BroCoins & Tips)"]
        
        Player_Ctrl["PlayerController.cs (WASD / Touch)"]
        Guest_Mgr["GuestManager.cs & GuestController.cs"]
        Stations["HotelStation.cs & Station Subclasses"]
        Chaos["ChaosEventController.cs"]
        Staff["StaffManager.cs (Automated Bros)"]
    end

    subgraph Assets_Pipeline ["Blender MCP & 3D Asset Pipeline"]
        Blender_Script["tools/blender/generate_brotel_models.py"]
        Blender_MCP["Blender 5.0 Headless / MCP Server"]
        Models["Assets/Models/*.obj"]
        Prefabs["Assets/Prefabs/PrefabsManifest.json"]
    end

    CG_SDK <--> HTML_Template
    HTML_Template <--> JSLib_Bridge
    JSLib_Bridge <--> CG_Manager
    CG_Manager --> Ad_Placements
    CG_Manager --> Cloud_Save

    Ad_Placements --> Economy
    Game_Manager --> Economy
    Game_Manager --> Guest_Mgr
    Game_Manager --> Chaos
    Player_Ctrl --> Stations
    Staff --> Stations
    Staff --> Chaos

    Blender_Script --> Blender_MCP
    Blender_MCP --> Models
    Models --> Prefabs
```

---

## 2. Component Interaction & Sequence Flow

### 2.1 Ad Lifecycle Sequence (Midgame & Rewarded)

```mermaid
sequenceDiagram
    autonumber
    participant Player as Player / Gameplay
    participant AdMgr as AdPlacementManager (C#)
    participant SDK_CS as CrazyGamesSDK (C#)
    participant JSLib as CrazyGamesSDK.jslib
    participant CG_SDK as CrazyGames SDK v3 (JS)

    Player->>AdMgr: Request Ad (Shift End / Rewarded Boost)
    AdMgr->>SDK_CS: RequestRewardedAd("2x_protein_rush")
    SDK_CS->>JSLib: CrazyGames_RequestRewardedAd("CrazyGamesManager", "OnRewardSuccess", "OnRewardError")
    
    Note over SDK_CS: Mute AudioListener & set Time.timeScale = 0
    
    JSLib->>CG_SDK: window.CrazyGames.SDK.ad.requestAd("rewarded", callbacks)
    CG_SDK-->>JSLib: adStarted callback
    CG_SDK-->>JSLib: adFinished callback
    
    JSLib->>SDK_CS: SendMessage("CrazyGamesManager", "OnRewardSuccess")
    Note over SDK_CS: Unmute AudioListener & restore Time.timeScale = 1
    SDK_CS->>AdMgr: Execute Success Callback
    AdMgr->>Player: Grant 2x Protein Tips Multiplier (3 min timer)
```

---

## 3. Directory Structure & Domain Ownership

```
d:/Game_dojo/
├── .agents/                      # Agent skills, hooks, and MCP config
│   ├── skills/
│   │   ├── crazygames-sdk/
│   │   ├── blender-asset-pipeline/
│   │   ├── game-development/
│   │   └── team-orchestrator/
│   ├── hooks.json
│   └── mcp_config.json
├── .ai-team/                     # Multi-Developer Team Governance
│   ├── team.json                 # Team roster, roles, capacities
│   ├── plan.json                 # Milestone roadmap & task DAG
│   └── tasks/                    # Granular task specs with file bounds
├── .github/
│   └── CODEOWNERS                # Domain code review ownership
├── Assets/
│   ├── Scripts/
│   │   ├── Core/                 # [@gameplay-dev] Game state, economy
│   │   ├── Gameplay/             # [@gameplay-dev] Player, guests, stations, chaos, staff
│   │   ├── CrazyGames/           # [@monetization-dev] C# SDK wrapper & callbacks
│   │   └── Monetization/         # [@monetization-dev] Ad placement manager & cloud save
│   ├── Plugins/
│   │   └── WebGL/                # [@monetization-dev] CrazyGamesSDK.jslib
│   ├── WebGLTemplates/
│   │   └── CrazyGames/           # [@monetization-dev] index.html, style.css
│   ├── Models/                   # [@art-dev] 3D .obj/.mtl model files
│   ├── Materials/                # [@art-dev] Palette & material definitions
│   └── Prefabs/                  # [@art-dev] Prefab manifests & configurations
├── tools/
│   └── blender/                  # [@art-dev] Python 3D generation scripts
├── docs/                         # [@lead] PRDs, GDD, specifications
│   ├── PRD.md
│   ├── PROJECT_BRIEF.md
│   ├── REQUIREMENTS.md
│   ├── ARCHITECTURE.md
│   ├── GAME_DESIGN.md
│   ├── MONETIZATION_STRATEGY.md
│   └── contracts/                # [FROZEN] Frozen interface contracts
│       ├── crazygames-bridge-spec.json
│       ├── game-state-schema.json
│       └── hotel-station-interface.json
├── scripts/                      # Setup, build, asset generation, and local server
│   ├── setup.ps1
│   ├── build-webgl.ps1
│   ├── generate-3d-assets.ps1
│   ├── serve-local.ps1
│   └── verify-project.ps1
└── package.json
```
