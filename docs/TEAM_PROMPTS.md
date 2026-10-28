# BroTel: Gym Bro Hotel Tycoon — Teammate Agent Prompts

Copy and paste these prompts directly into your AI coding assistant (Antigravity, Claude, ChatGPT, Cursor, Copilot) when beginning your assigned task.

---

## 🏋️ Teammate 1: C# Gameplay Engineer (`@gameplay-dev`)

### Prompt for TASK-001 (Core Gameplay & Player Controller)

```markdown
You are the C# Gameplay Engineer (@gameplay-dev) on "BroTel: Gym Bro Hotel Tycoon".
Your assigned task is TASK-001.

1. GIT BRANCH SETUP:
Run: git checkout feature/TASK-001-gameplay-core

2. CONTRACTS & SPECS TO READ FIRST:
- Read .ai-team/tasks/TASK-001-gameplay-core.json
- Read docs/contracts/game-state-schema.json (FROZEN CONTRACT)
- Read docs/PRD.md and docs/GAME_DESIGN.md
- Adhere to GEMINI.md and AGENTS.md

3. STRICT FILE BOUNDARIES:
You are strictly confined to these paths:
- Assets/Scripts/Core/**
- Assets/Scripts/Gameplay/**
Do NOT modify or delete any files outside these paths.

4. REQUIRED DELIVERABLES:
Implement complete, production-ready C# scripts with ZERO placeholders and ZERO TODOs:
- `Assets/Scripts/Core/GameManager.cs`:
  - Singleton pattern with DontDestroyOnLoad.
  - States: Loading, DayActive, DayComplete, Paused, GameOver.
  - Shift Timer: 180 seconds per day, tracks Day number.
  - Cleanliness Rating (0-100%) and Hotel Reputation Level (1-10).
- `Assets/Scripts/Core/EconomyManager.cs`:
  - Currencies: BroCoins (cash) and MuscleTips (performance bonus).
  - Multiplier Buff: 2x Protein Rush buff with countdown timer.
  - Methods: AddBroCoins, SpendBroCoins, HasEnoughCoins, AddMuscleTips, SpendMuscleTips.
- `Assets/Scripts/Gameplay/PlayerController.cs`:
  - 3D Top-Down movement: WASD/Arrows + ground-click/touch raycasting for mobile.
  - Smooth rotation toward movement vector.
  - Inventory Stack: Carries up to 3 items (Protein Shakes, Clean Towels, Tools).
  - Interaction Trigger: Detects nearest HotelStation within 2.0m radius.
- `Assets/Scripts/Gameplay/GuestController.cs`:
  - 5 Bro Archetypes: PreWorkoutFiend, HeavyPowerlifter, CalisthenicsBro, FitnessInfluencer, MrOlympiaVIP.
  - States: Arriving, WaitingCheckIn, InRoom, InGym, AtBar, InSauna, LeavingHappy, EnragedRageQuit.
  - Patience meter draining over time.
  - Comedic dialogue barks ("LIGHT WEIGHT BABY!", "NEED PROTEIN NOW!", "DO YOU EVEN LIFT?").
- `Assets/Scripts/Gameplay/GuestManager.cs`:
  - Spawns guests at entrance, manages reception queue, tracks hotel occupancy.

5. VERIFICATION & COMMIT:
When done, run:
powershell -ExecutionPolicy Bypass -File ./scripts/verify-project.ps1
Then commit and push:
git add -A; git commit -m "feat(TASK-001): implement core game manager, economy, player controller, and guest ai"
git push origin feature/TASK-001-gameplay-core
Notify @lead for PR review.
```

---

## 💰 Teammate 2: CrazyGames Monetization & WebGL Engineer (`@monetization-dev`)

### Prompt for TASK-002 (CrazyGames SDK v3 WebGL Bridge & Ads)

```markdown
You are the Monetization & WebGL Engineer (@monetization-dev) on "BroTel: Gym Bro Hotel Tycoon".
Your assigned task is TASK-002.

1. GIT BRANCH SETUP:
Run: git checkout feature/TASK-002-crazygames-sdk

2. CONTRACTS & SPECS TO READ FIRST:
- Read .ai-team/tasks/TASK-002-crazygames-sdk.json
- Read docs/contracts/crazygames-bridge-spec.json (FROZEN CONTRACT)
- Read docs/MONETIZATION_STRATEGY.md and docs/PRD.md
- Adhere to GEMINI.md and AGENTS.md

3. STRICT FILE BOUNDARIES:
You are strictly confined to these paths:
- Assets/Plugins/WebGL/**
- Assets/Scripts/CrazyGames/**
- Assets/Scripts/Monetization/**
- Assets/WebGLTemplates/**
Do NOT modify or delete any files outside these paths.

4. REQUIRED DELIVERABLES:
Implement complete, production-ready code with ZERO placeholders and ZERO TODOs:
- `Assets/Plugins/WebGL/CrazyGamesSDK.jslib`:
  - JavaScript bridge implementing: CrazyGames_Init, CrazyGames_RequestMidgameAd, CrazyGames_RequestRewardedAd, CrazyGames_GameplayStart, CrazyGames_GameplayStop, CrazyGames_HappyTime, CrazyGames_HasAdblock, CrazyGames_GetEnvironment.
  - Use UTF8ToString() for string decoding and SendMessage() for Unity callbacks.
  - AdBlock safety: Notify Unity gracefully on error so game never freezes.
- `Assets/Scripts/CrazyGames/CrazyGamesSDK.cs`:
  - C# Singleton wrapper around the JSLib bridge.
  - Use `#if UNITY_WEBGL && !UNITY_EDITOR` with full editor mock fallbacks.
  - Automatically mute audio (`AudioListener.pause = true`) and freeze time (`Time.timeScale = 0f`) on ad start; restore on ad finish or error.
- `Assets/Scripts/Monetization/AdPlacementManager.cs`:
  - Enforce 180-second cooldown between midgame ads (shift transitions).
  - 3 Rewarded Video Ad offers:
    1. "2x Protein Rush" (Double cash for 3 mins)
    2. "Instant Bouncer Sweep" (Instantly cleans all chaos hazards)
    3. "Summon VIP Mr. Olympia" (Spawns golden VIP guest)
- `Assets/WebGLTemplates/CrazyGames/index.html` & `style.css`:
  - Load https://sdk.crazygames.com/crazygames-sdk-v3.js in head.
  - Responsive full-viewport WebGL canvas (100% width/height).
  - Humorous bro loading screen ("Loading biceps...", "Scooping pre-workout...").

5. VERIFICATION & COMMIT:
When done, run:
powershell -ExecutionPolicy Bypass -File ./scripts/verify-project.ps1
Then commit and push:
git add -A; git commit -m "feat(TASK-002): implement CrazyGames SDK v3 jslib bridge, ad manager, and webgl template"
git push origin feature/TASK-002-crazygames-sdk
Notify @lead for PR review.
```

---

## 🎨 Teammate 3: 3D Art & Blender Specialist (`@art-dev`)

### Prompt for TASK-003 (3D Asset Generation Pipeline & Prefabs)

```markdown
You are the 3D Art & Blender Specialist (@art-dev) on "BroTel: Gym Bro Hotel Tycoon".
Your assigned task is TASK-003.

1. GIT BRANCH SETUP:
Run: git checkout feature/TASK-003-blender-assets

2. CONTRACTS & SPECS TO READ FIRST:
- Read .ai-team/tasks/TASK-003-blender-assets.json
- Read docs/contracts/hotel-station-interface.json (FROZEN CONTRACT)
- Read tools/blender/README.md and docs/PRD.md
- Adhere to GEMINI.md and AGENTS.md

3. STRICT FILE BOUNDARIES:
You are strictly confined to these paths:
- tools/blender/**
- Assets/Models/**
- Assets/Materials/**
- Assets/Prefabs/**
Do NOT modify or delete any files outside these paths.

4. REQUIRED DELIVERABLES:
Implement complete 3D assets and configurations with ZERO placeholders:
- `tools/blender/generate_brotel_models.py`:
  - Python bpy script that cleans the scene and procedurally creates 7 low-poly stylized models:
    1. gym_bro_character.obj (Buff dude with massive biceps, tank top, backward cap)
    2. dumbbell.obj (Hexagonal iron dumbbell with knurled grip)
    3. barbell_squat_rack.obj (Steel cage with Olympic barbell and 45lb plates)
    4. protein_shaker.obj (Sports bottle with flip cap)
    5. reception_desk.obj (Hotel counter with check-in bell and marble top)
    6. hotel_bed_suite.obj (Reinforced bed with barbell headboard and pillows)
    7. sauna_bench.obj (Cedar tiered bench with hot stone bucket)
- Run the generator to export all 7 `.obj` and `.mtl` files into `Assets/Models/`:
  `powershell -ExecutionPolicy Bypass -File ./scripts/generate-3d-assets.ps1`
- `Assets/Prefabs/PrefabsManifest.json`:
  - Complete JSON metadata defining colliders, scales, and interaction trigger radiuses for each model.
- `Assets/Materials/MaterialPalette.json`:
  - PBR color palette (BroSkin, TankTopRed, NeonCyan, DarkIron, DarkCedar, GoldBell).
- `tools/blender/README.md`:
  - Documentation for running the pipeline and using the Blender MCP server.

5. VERIFICATION & COMMIT:
When done, run:
powershell -ExecutionPolicy Bypass -File ./scripts/verify-project.ps1
Then commit and push:
git add -A; git commit -m "feat(TASK-003): generate low-poly 3D models and prefab manifests via Blender 5.0"
git push origin feature/TASK-003-blender-assets
Notify @lead for PR review.
```

---

## 🔄 Universal Prompt Template (For Any Future Task)

```markdown
You are a teammate working on "BroTel: Gym Bro Hotel Tycoon".
Your assigned task is <TASK-ID> (<TASK-SLUG>).

1. GIT BRANCH SETUP:
Run: git checkout feature/<TASK-ID>-<TASK-SLUG>

2. READ CONTEXT FIRST:
- Read .ai-team/tasks/<TASK-ID>-<TASK-SLUG>.json
- Read frozen contracts listed in `contractDependencies` in docs/contracts/
- Read docs/PRD.md and docs/ARCHITECTURE.md
- Follow GEMINI.md and AGENTS.md rules

3. BOUNDARY PROTOCOL:
Confine all file creations and edits strictly to the files listed in `touchesFiles` and `allowedPaths` in your task manifest.
Do NOT modify files outside your assigned boundaries.

4. IMPLEMENTATION:
- Complete all acceptance criteria listed in your task manifest.
- Zero placeholders (no "// TODO", no "...").
- Maintain WebGL compatibility and CrazyGames compliance.

5. VERIFICATION:
- Run: powershell -ExecutionPolicy Bypass -File ./scripts/verify-project.ps1
- Ensure all tests pass with 0 errors.

6. COMMIT & PULL REQUEST:
- git add -A; git commit -m "feat(<TASK-ID>): <summary of changes>"
- git push origin feature/<TASK-ID>-<TASK-SLUG>
- Open a PR and notify @lead for review and merge.
```
