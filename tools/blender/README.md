# Blender 3D Asset Pipeline for BroTel

This directory contains automated Python scripts for generating stylized low-poly 3D models for **BroTel: Gym Bro Hotel Tycoon** using Blender 5.0.

---

## 🚀 Running Procedural Asset Generation

Execute the script in headless/background mode via Blender:

```powershell
& "C:\Program Files\Blender Foundation\Blender 5.0\blender.exe" --background --python tools/blender/generate_brotel_models.py
```

Or run the convenient helper script:
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/generate-3d-assets.ps1
```

---

## 📦 Generated Models in `Assets/Models/`

1. **`gym_bro_character.obj`**: Stylized low-poly buff humanoid with broad shoulders, oversized biceps, tank top, shorts, and backward gym cap.
2. **`dumbbell.obj`**: Hexagonal black iron dumbbell with knurled chrome handle.
3. **`protein_shaker.obj`**: Sports shaker bottle with flip-spout cap.
4. **`reception_desk.obj`**: Hotel counter with reception bell and marble top slab.
5. **`barbell_squat_rack.obj`**: Steel squat rack with Olympic barbell and loaded 45lb plates.
6. **`hotel_bed_suite.obj`**: Reinforced king-sized hotel bed with mattress and pillows.
7. **`sauna_bench.obj`**: Tiered cedar sauna bench with hot stone bucket.

---

## 🎨 Interactive Modeling via Blender MCP Server

When developing new custom models:
1. Open Blender 5.0 with the Antigravity Blender MCP Addon enabled.
2. In Antigravity IDE, call `blender` MCP tools (`execute_blender_code`, `get_scene_info`, `look`).
3. Export newly approved assets directly into `Assets/Models/` and update `Assets/Prefabs/PrefabsManifest.json`.
