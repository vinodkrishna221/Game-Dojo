# Monetization Strategy & CrazyGames Ad Guide
## BroTel: Gym Bro Hotel Tycoon

## 1. Overview & CrazyGames Revenue Model
CrazyGames monetizes web games primarily through **Ad Monetization** (Midgame Interstitials, Rewarded Video Ads, and Banner Ads). Developers receive revenue share based on impressions and eCPM.

Official Documentation: https://docs.crazygames.com/

This document outlines the design, pacing, triggers, and technical rules to maximize developer earnings while strictly complying with CrazyGames publishing policies.

---

## 2. Ad Placement Blueprint

```
┌────────────────────────────────────────────────────────────────────────┐
│                      BroTel Ad Monetization Matrix                     │
├───────────────────┬──────────────┬───────────────────┬────────────────┤
│ Ad Type           │ Frequency    │ Natural Trigger   │ Value Exchange │
├───────────────────┼──────────────┼───────────────────┼────────────────┤
│ Midgame           │ Min 180s cap │ Shift Complete    │ None (Natural  │
│ (Interstitial)    │              │ Floor Expansion   │ Transition)    │
├───────────────────┼──────────────┼───────────────────┼────────────────┤
│ Rewarded Video 1: │ On Demand    │ Shop / HUD Button │ 2x Earnings    │
│ "2x Protein Rush" │ (Cooldown 3m)│                   │ for 3 minutes  │
├───────────────────┼──────────────┼───────────────────┼────────────────┤
│ Rewarded Video 2: │ On Demand    │ When >2 Chaos     │ Instant Full   │
│ "Bouncer Sweep"   │              │ Hazards Active    │ Hotel Clean-up │
├───────────────────┼──────────────┼───────────────────┼────────────────┤
│ Rewarded Video 3: │ On Demand    │ Lobby VIP Desk    │ Spawns Golden  │
│ "Summon VIP"      │ (1 per shift)│                   │ Mr. Olympia Bro│
├───────────────────┼──────────────┼───────────────────┼────────────────┤
│ Responsive Banner │ Continuous   │ Screen margins    │ Non-intrusive  │
│ (300x250/728x90)  │              │ during pause/menu │ brand display  │
└───────────────────┴──────────────┴───────────────────┴────────────────┘
```

---

## 3. Implementation Rules

### 3.1 Midgame Interstitial Ads
- **Never Interrupt Active Movement**: Interstitials must only fire when the player is not controlling the character (e.g. Day Summary modal screen).
- **SDK Automatic Pacing**: The CrazyGames SDK v3 enforces a 3-minute cooldown between midgame ads. Calling `requestAd("midgame")` more frequently is automatically ignored by the SDK, but games should still track time elapsed to avoid redundant calls.
- **Game Freeze**: Always freeze time scale and pause audio:
  ```csharp
  AudioListener.pause = true;
  Time.timeScale = 0f;
  ```
  Restore immediately upon `adFinished` or `adError`:
  ```csharp
  AudioListener.pause = false;
  Time.timeScale = 1f;
  ```

### 3.2 Rewarded Video Ads
- **Explicit Player Choice**: Players must explicitly click a button with a clear ad icon / badge before a rewarded ad opens.
- **Fair Reward Delivery**:
  - Reward is granted **only** if the player watches to completion (`adFinished`).
  - If the player closes early or an error occurs (`adError`), resume gameplay without granting the perk.
- **AdBlock Handling**: If AdBlock is active, the SDK triggers `adError`. The game should display a polite message ("Ad could not be loaded. Please support BroTel by disabling ad blockers!") and keep the player in the game without crashing.

### 3.3 CrazyGames Cloud Save & Account Integration
- Players who log into CrazyGames can persist their BroCoins, VIP unlocks, and high scores across devices.
- Uses `CrazyGames.SDK.data.setItem(key, value)` and `CrazyGames.SDK.data.getItem(key)`.

### 3.4 Happy Time Triggers
- Call `window.CrazyGames.SDK.game.happytime()` during celebratory moments:
  - Unlocking a new hotel floor.
  - Successfully spotting a 500lb bench press.
  - Earning 10,000 BroCoins.
