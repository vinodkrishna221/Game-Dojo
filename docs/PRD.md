# Product Requirements Document (PRD)
## BroTel: Gym Bro Hotel Tycoon

- **Document Version**: 1.0.0
- **Status**: APPROVED / ACTIVE
- **Target Platform**: CrazyGames (HTML5 WebGL)
- **Monetization**: CrazyGames SDK v3 (Midgame Interstitials, Rewarded Video, Banner Ads, Cloud Save)
- **Target Audience**: Casual browser players, gym enthusiasts, tycoon & arcade management fans

---

## 1. Executive Summary & Vision

**BroTel: Gym Bro Hotel Tycoon** is an arcade-style 3D top-down / isometric hotel management game. Players operate a specialized luxury resort catering exclusively to hilarious gym bro stereotypes—bodybuilders, powerlifters, calisthenics fiends, and fitness influencers. 

The gameplay balances fast-paced resource management (mixing protein shakes, spotting heavy bench presses, delivering clean gym towels) with chaotic emergent events (protein powder explosions, dropped dumbbell earthquakes, mirror flexing stand-offs).

The game is engineered specifically to maximize eCPM and retention on **CrazyGames**, utilizing natural break midgame interstitials, high-converting rewarded video ads, and CrazyGames Cloud Save to drive player return rates.

---

## 2. Core Pillars

1. **Gym Bro Comedic Chaos**: Over-the-top character designs, hilarious sound bites ("LIGHT WEIGHT BABY!", "DO YOU EVEN LIFT?"), and slapstick chaos.
2. **Instant "Just One More Shift" Flow**: 180-second hotel shifts with clear revenue targets, upgrade unlocks, and satisfying cleanup interactions.
3. **Seamless CrazyGames Integration**: CrazyGames SDK v3 lifecycle events, responsive desktop/mobile controls, AdBlock resilience, and fast loading (< 25MB initial bundle).
4. **Contract-First Modular Development**: Strict boundaries allowing independent teammates to build gameplay, SDK bridges, and 3D assets in parallel without merge conflicts.

---

## 3. User Personas & Target Demographics

- **CrazyGames Player (Desktop & Mobile)**: 13-35 years old, looking for immediate fun without downloads, loves idle/tycoon games like *My Perfect Hotel*, *Gym Simulator*, and *Idle Restaurant*.
- **Session Length**: 5 to 15 minutes per session; 3 to 6 shifts per session.
- **Hardware Profile**: Low to mid-spec laptops, Chromebooks, and mobile browser touchscreens. Target: Stable 60 FPS in WebGL.

---

## 4. Feature Specifications

### 4.1 Hotel Check-In & Reception
- Gym bros arrive at the hotel entrance and queue at the **Reception Desk**.
- Player interacts with the reception bell to check in guests, collecting initial room deposits (BroCoins).
- Guest patience meter drains if waiting too long; enraged guests leave a 1-star review and walk out.

### 4.2 The 5 Core Hotel Stations
1. **Reception Desk**:
   - Check-in queue (up to 4 guests).
   - Upgrades: Faster check-in speed, increased queue capacity, bell sound effect.
2. **Protein Shake Bar**:
   - Blends protein smoothies (Whey, Banana, Raw Eggs, Creatine).
   - Player loads ingredients and takes shakers to waiting guests.
   - Upgrades: Automatic multi-blender, exotic shake recipes (+50% tips).
3. **Squat Rack & Bench Arena**:
   - Guests work out and trigger spotter requests when barbell meters turn red.
   - Player must spot lifter within 5 seconds to prevent barbell drops.
   - Upgrades: Olympic gold barbells, heavier weight plates, multiple racks.
4. **Reinforced Bed Suites**:
   - Heavy-duty king-sized beds with barbell headboards.
   - Guests sleep and restore muscle energy.
   - Requires bed-making and towel change after guest checkout.
   - Upgrades: Memory foam gym mattresses, luxury locker storage.
5. **Sauna Recovery Zone**:
   - Cedar sauna bench where pumped guests cool down.
   - Requires cold water buckets and dry towels.
   - Upgrades: Eucalyptus steam infusion, infrared heaters.

### 4.3 The 5 Gym Bro Archetypes
| Archetype | Trait / Behavior | Special Demand | Tip Multiplier |
|---|---|---|---|
| **The Pre-Workout Fiend** | Fast walker (1.5x speed), short patience | Demands double-scoop protein shakes instantly | 1.2x |
| **The Heavy Powerlifter** | Heavy footsteps, loud grunts | Requires spotting on 500lb bench presses | 1.5x |
| **The Calisthenics Bro** | Does muscle-ups on door frames | Demands chalk bowls and pull-up stations | 1.1x |
| **The Fitness Influencer** | Poses for selfies, blocks walkways | Needs aesthetic lighting and mirror access | 1.3x |
| **Mr. Olympia VIP** | Golden aura, rare appearance | Demands VIP Penthouse suite and all amenities | 5.0x |

### 4.4 Chaos Events
- **Protein Powder Spill**: Shaker drops, creating a white powder puddle that slows player/guest speed by 50% until mopped.
- **Dumbbell Drop Crack**: Dumbbell slams into floor, cracking tile and reducing hotel cleanliness by 15%. Requires wrench repair.
- **Mirror Flex Stand-Off**: Two gym bros flex in front of a mirror, blocking hallway traffic until player whistles or Bouncer Bro separates them.
- **Influencer Live-Stream**: Ring light tripod creates a crowd obstruction.

### 4.5 AI Bro Staff (Automation)
- **Bouncer Bro**: Patrols hallways, automatically resolves flex stand-offs and kicks out enraged guests.
- **Barista Bro**: Automatically blends and serves protein shakes at the bar.
- **Sweeper Bro**: Automatically paths to chalk/sweat spills and mops them.

---

## 5. CrazyGames Monetization Requirements

1. **Midgame Interstitial Ads**:
   - Triggered strictly between Day/Shift transitions or after major room expansions.
   - Enforce CrazyGames 180-second frequency cooldown via SDK pacing.
   - Audio muted (`AudioListener.pause = true`) and game paused (`Time.timeScale = 0f`).
2. **Rewarded Video Ads**:
   - **Offer 1: 2x Protein Rush**: Doubles all BroCoin and MuscleTip earnings for 3 minutes.
   - **Offer 2: Instant Bouncer Sweep**: Instantly cleans all messes, repairs cracks, and restores hotel cleanliness to 100%.
   - **Offer 3: Summon VIP Mr. Olympia**: Instantly spawns a golden VIP guest who drops high-value tips.
3. **CrazyGames User Accounts & Cloud Save**:
   - Silent login via `window.CrazyGames.SDK.user.getUser()`.
   - Save progress, unlocked floors, and BroCoins via `window.CrazyGames.SDK.data.setItem()`.
4. **Banner Ads**:
   - Responsive banner placement in UI footer/margin during pause and shift summary screens.
5. **AdBlock Resilience**:
   - Game must never block or crash if an ad fails or AdBlock is enabled.

---

## 6. Non-Functional & Technical Requirements

- **Engine**: Unity 3D (C#) targeting WebGL 2.0.
- **Asset Pipeline**: Stylized low-poly 3D models generated via Blender 5.0 and Blender MCP.
- **Performance Budget**: Stable 60 FPS on integrated Intel Iris Xe / Apple M1 / Android WebGL.
- **Bundle Budget**: Initial load size $\le$ 25MB (compressed) to qualify for CrazyGames mobile homepage features.
- **Control Schemes**: WASD / Arrow keys for desktop, ground-click / touch-to-move for mobile.
