# Design System: BroTel: Gym Bro Hotel Tycoon

## 1. Visual Identity & Aesthetic

The aesthetic of **BroTel** merges vibrant arcade energy with over-the-top gym bro culture: high-contrast neon lights, industrial iron gym equipment, chrome barbells, neon protein shakers, and comedic exaggerated character anatomy.

---

## 2. Color Palette

| Token Name | Hex Code | Preview | Role / Usage |
|---|---|---|---|
| `--color-neon-cyan` | `#00F0FF` | 🟦 | Primary UI accent, stamina meters, active check-in triggers |
| `--color-energy-orange`| `#FF6B00` | 🟧 | Warning state, spotter alerts, pre-workout station icons |
| `--color-hot-pink` | `#FF007A` | 🟪 | Muscle pump gauges, VIP highlights, high-energy badges |
| `--color-gold-vip` | `#FFD700` | 🟨 | BroCoins currency, Mr. Olympia VIP aura, 2x Protein Rush buff |
| `--color-iron-dark` | `#1A1D20` | ⬛ | Background panels, slate gym floor tiles, primary UI containers |
| `--color-iron-light`| `#2C3238` | ⬛ | Secondary containers, button idle states, unequipped slots |
| `--color-whey-white` | `#F8F9FA` | ⬜ | Primary typography, chalk spill decals, protein powder accents |

---

## 3. Typography Hierarchy

- **Title / Header Font**: *Impact*, *Oswald*, or heavy athletic sans-serif fonts. All-caps for titles, badges, and bro dialogue barks.
- **Body & Numerical Font**: *Inter* or *Roboto* for numerical readouts (currency counters, timers, progress bars).

| Level | Size | Weight | Line Height | Usage |
|---|---|---|---|---|
| **Display** | 36px / 2.25rem | Bold (900) | 1.1 | Shift Complete modals, Level Up banners |
| **H1** | 24px / 1.5rem | Bold (800) | 1.2 | Station Titles, Bro Archetype names |
| **H2** | 18px / 1.125rem| SemiBold (700)| 1.3 | Upgrade buttons, Inventory slot counts |
| **Body** | 14px / 0.875rem| Medium (500) | 1.4 | Descriptions, dialog text, tips |
| **Caption**| 11px / 0.7rem | Regular (400)| 1.3 | Subtext, timestamps, cooldown counters |

---

## 4. UI Components & Layout Guidelines

### 4.1 HUD Layout
- **Top-Left**: Currency cluster (BroCoins with Gold Kettlebell icon, MuscleTips with Flexing Bicep icon).
- **Top-Center**: Shift Timer (180s countdown circular progress ring) and Hotel Reputation Stars (1-5 stars).
- **Top-Right**: Pause/Settings button, AdBlock indicator, Sound toggle.
- **Bottom-Center**: Player Inventory Stack (3 visual slots showing Shakers, Towels, Tools).
- **Bottom-Right**: Active Boost indicator (e.g. "2x PROTEIN RUSH: 02:45").

### 4.2 Interaction Triggers
- Floor interaction circles render in `--color-neon-cyan` when ready to interact.
- Timed spotter alerts pulse in `--color-energy-orange` with an animated countdown dial.
- Completed tasks trigger a starburst particle effect and play an audio chime.
