# Requirements Specification: BroTel: Gym Bro Hotel Tycoon

## 1. Functional Requirements (FR)

### FR-01: Player Movement & Interactions
- **FR-01.1**: The player character must support 8-directional movement via WASD and Arrow Keys on desktop.
- **FR-01.2**: The player character must support point-and-click / touch-to-move via ground plane raycasting for mobile web and mouse players.
- **FR-01.3**: The player character must carry up to 3 items simultaneously in a visible vertical stack (Protein Shakes, Clean Towels, Wrench, Mop).
- **FR-01.4**: Approaching any interactive station or hazard within a 2.0m radius must automatically trigger context-sensitive interactions.

### FR-02: Hotel Stations & Operations
- **FR-02.1: Reception Desk**: Guests queue at the counter. Player interaction checks in the next guest, assigns an available room, and awards initial BroCoins.
- **FR-02.2: Protein Bar**: Blends shakes over 3 seconds. Player collects completed shake to deliver to guests or stations.
- **FR-02.3: Squat Rack & Bench Arena**: Guests occupy racks. When spot request timer appears (red danger gauge), player must interact within 5 seconds to spot and earn bonus tips.
- **FR-02.4: Bed Suites**: Guests sleep to recover energy. Upon checkout, rooms enter `Dirty` state requiring towel replacement and bed tidying.
- **FR-02.5: Sauna Recovery Zone**: Guests cool down in the sauna. Requires periodically restocking cold water buckets and dry towels.

### FR-03: Guest AI & Archetypes
- **FR-03.1**: Five distinct bro archetypes (Pre-Workout Fiend, Heavy Powerlifter, Calisthenics Bro, Fitness Influencer, Mr. Olympia VIP) with differentiated walk speeds, patience timers, and tip multipliers.
- **FR-03.2**: Guests exhibit humorous speech bubble barks based on state (e.g., "LIGHT WEIGHT BABY!", "WHERE IS MY PROTEIN?", "10/10 RECOVERY").
- **FR-03.3**: If patience drops to 0%, the guest enters `RageQuit` state, drops hotel cleanliness by 20%, and leaves without paying.

### FR-04: Chaos Events & Hazards
- **FR-04.1**: Random chaos events spawn at intervals between 45 and 90 seconds.
- **FR-04.2: Protein Powder Explosion**: Spawns white puddle hazard slowing movement by 50% until mopped.
- **FR-04.3: Dumbbell Drop Crack**: Causes screen shake, cracks floor tile, and requires wrench repair.
- **FR-04.4: Mirror Flex Stand-Off**: Spawns two posing bros blocking hallway navigation until player whistles or Bouncer Bro intervenes.

### FR-05: AI Staff Automation
- **FR-05.1**: Players can purchase and upgrade automated staff members using BroCoins.
- **FR-05.2: Bouncer Bro**: Patrols the hotel and automatically resolves flex stand-offs and removes enraged guests.
- **FR-05.3: Barista Bro**: Automatically brews and serves shakes at the Protein Bar.
- **FR-05.4: Sweeper Bro**: Automatically paths to chalk/sweat spills and cleans them with a mop.

### FR-06: CrazyGames SDK v3 Integration
- **FR-06.1**: Must initialize CrazyGames SDK v3 asynchronously before gameplay begins.
- **FR-06.2**: Must trigger `gameplayStart()` and `gameplayStop()` in adherence to game state changes.
- **FR-06.3**: Must trigger Midgame Interstitial Ads at shift ends, respecting the 180-second frequency cooldown.
- **FR-06.4**: Must provide Rewarded Video Ads with guaranteed value exchanges (2x Protein Tips for 3 mins, Instant Full Clean, Summon VIP Mr. Olympia).
- **FR-06.5**: Must integrate CrazyGames User Account info and Cloud Save API (`setItem` / `getItem`).
- **FR-06.6**: Must maintain seamless gameplay operation if AdBlock is detected or ad requests fail.

---

## 2. Non-Functional Requirements (NFR)

### NFR-01: Performance & Frame Rate
- Maintain consistent 60 FPS in WebGL on standard browser hardware (WebGL 2.0).
- Garbage collection allocations in C# update loops must be minimized (zero heap allocations per frame in `Update()`).

### NFR-02: Download Size & Bundle Budgets
- Initial download bundle $\le$ 25MB compressed.
- Total asset count $\le$ 500 files.

### NFR-03: Responsive Layout & Mobile Friendliness
- Responsive WebGL canvas automatically scaling to fit 100% viewport width and height.
- Dynamic aspect ratio adjustment supporting 16:9, 16:10, and mobile portrait/landscape orientations.

### NFR-04: Audio & Pause Management
- During ad displays (`adStarted`), audio must mute (`AudioListener.pause = true`) and physics/time must freeze (`Time.timeScale = 0f`).
- Upon ad completion or error (`adFinished` / `adError`), audio and time scale must cleanly restore.
