# Project Brief: BroTel: Gym Bro Hotel Tycoon

## 1. Project Overview
- **Project Name**: BroTel: Gym Bro Hotel Tycoon
- **Repository Slug**: `brotel-tycoon`
- **Lead / Merge Authority**: `@lead`
- **Platform**: CrazyGames (HTML5 WebGL)
- **Primary Tech Stack**: Unity 3D (C#), WebGL, CrazyGames SDK v3, Blender 5.0 MCP Asset Pipeline
- **Target Launch Window**: Q4 2026

## 2. High Concept
*Sleep. Lift. Chug. Repeat.* You are the proprietor of the world's first luxury hotel dedicated exclusively to gym bros. Check in swole guests, brew massive protein shakes, spot 500lb bench presses, mop up chalk spills, break up mirror flexing stand-offs, and expand your empire across multi-story fitness resorts.

## 3. Core Objectives & Business Goals
1. **CrazyGames Full Launch Compliance**: Integrate all mandatory CrazyGames SDK v3 modules (Lifecycle tracking, midgame interstitial ads, rewarded video ads, cloud save, and user accounts).
2. **High-Yield Ad Monetization**: Target top-quartile eCPMs through compelling rewarded video offers (2x Protein Rush, Instant Clean, VIP Summon) and non-intrusive midgame interstitials paced at natural 3-minute shift boundaries.
3. **Low Latency & High Accessibility**: Fast initial download under 25MB, responsive touch/mouse controls, 60 FPS performance on standard browser hardware.
4. **Clean Multi-Developer Team Workflow**: Contract-first architecture and `.ai-team` boundaries ensuring four parallel developers/agents can build gameplay, SDK integration, and 3D assets without merge conflicts.

## 4. Work Stream Assignments
| Member | Role | Domain | Primary Deliverables |
|---|---|---|---|
| **@lead** | Technical Lead | Project Governance, Contracts, Merging | PRDs, Contract Schemas, PR Reviews, Main Branch Merging |
| **@gameplay-dev** | Gameplay Engineer | `Assets/Scripts/Core/**`, `Assets/Scripts/Gameplay/**` | Player Controller, Guest AI, 5 Hotel Stations, Chaos Events, Staff Automation |
| **@monetization-dev** | SDK & WebGL Engineer | `Assets/Plugins/WebGL/**`, `Assets/Scripts/CrazyGames/**`, `Assets/WebGLTemplates/**` | CrazyGames SDK v3 JSLib Bridge, Ad Placement Manager, Cloud Save, WebGL Template |
| **@art-dev** | 3D Art & Asset Specialist | `tools/blender/**`, `Assets/Models/**`, `Assets/Prefabs/**` | Blender Procedural Asset Scripts, Low-Poly 3D Models, Prefab Manifest, Materials |
