---
name: crazygames-sdk
description: "Instructions and best practices for integrating the CrazyGames SDK v3 in Unity WebGL and HTML5 web games. Covers SDK initialization, midgame ads pacing (3-min frequency caps), rewarded ads with value exchanges, gameplay lifecycle tracking (gameplayStart/Stop), happytime triggers, AdBlock resilience, and submission requirements."
---

# CrazyGames SDK v3 Integration Skill

## Overview
CrazyGames is a leading browser gaming platform. To successfully publish and monetize a game, developers must integrate the **CrazyGames SDK v3**.

Official Documentation: https://docs.crazygames.com/

---

## Core Rules & Requirements

### 1. SDK Script Installation
In the custom WebGL template `index.html`, load the v3 SDK script in `<head>`:
```html
<script src="https://sdk.crazygames.com/crazygames-sdk-v3.js"></script>
```

### 2. SDK Initialization
Initialize before calling any other methods:
```javascript
await window.CrazyGames.SDK.init();
```

### 3. Gameplay Lifecycle Tracking (Mandatory)
- Call `window.CrazyGames.SDK.game.gameplayStart()` whenever active play begins or resumes (e.g. game start, unpausing, closing menus/shops).
- Call `window.CrazyGames.SDK.game.gameplayStop()` whenever gameplay pauses or stops (menus, level transitions, game over).

### 4. Midgame Ads (Interstitials)
- **Natural Breaks Only**: Never trigger midgame ads during active gameplay or movement.
- **3-Minute Cooldown**: The CrazyGames SDK caps midgame ads to once every 3 minutes. Request ads at natural shift/day completions or milestone screens.
- **Audio & Time Control**: Always mute game audio (`AudioListener.pause = true`) and pause game time (`Time.timeScale = 0f`) in `adStarted`, and restore them in `adFinished` or `adError`.

### 5. Rewarded Ads
- **Value Exchange**: Provide clear rewards (e.g., 2x Protein Tips for 3 minutes, instant full-hotel clean, summon VIP Mr. Olympia).
- Only award the prize when `adFinished` callback fires. If `adError` fires, restore game state without awarding the prize.

### 6. AdBlock Compatibility
- Games must function completely even when players have AdBlock active. The SDK will call `adError` or bypass ads gracefully; the game must never lock up or get stuck on a black screen.

### 7. File Size Guidelines
- Initial download size must be $\le$ 50MB (and $\le$ 20MB for mobile featured consideration).
- Total file count $\le$ 1500 files, total bundle $\le$ 250MB.
