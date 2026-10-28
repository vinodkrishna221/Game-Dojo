---
name: blender-asset-pipeline
description: "Instructions for automated and interactive 3D model generation using Blender 5.0 and Blender MCP server for Unity games. Covers headless Python scripting (bpy), low-poly stylized character modeling, props, materials, vertex colors, and .obj/.fbx/.gltf export to Assets/Models."
---

# Blender 3D Asset Pipeline Skill

## Overview
This skill guides agents and developers in generating stylized low-poly 3D assets for the game using Blender 5.0 and the Blender MCP server.

---

## Executing Headless Blender Scripts
Blender 5.0 is installed locally at `C:\Program Files\Blender Foundation\Blender 5.0\blender.exe`.
To run procedural generation scripts:
```powershell
& "C:\Program Files\Blender Foundation\Blender 5.0\blender.exe" --background --python tools/blender/generate_brotel_models.py
```

## Modeling Standards for Unity WebGL
1. **Low-Poly Budget**:
   - Characters: 1,500 - 3,500 triangles.
   - Props / Stations: 300 - 1,200 triangles.
   - Items (dumbbells, shakers): 100 - 400 triangles.
2. **Materials & Shading**:
   - Flat/faceted shading with vibrant stylized colors.
   - Standard material slots mapped to palette entries (e.g. `BroSkin`, `TankTop`, `NeonBlue`, `DarkIron`).
3. **Pivots & Origin Points**:
   - Characters and furniture models must have their pivot centered at the bottom (Z=0) for clean grid and NavMesh placement.
4. **Export Targets**:
   - Export `.obj` with `.mtl` or `.gltf` into `Assets/Models/`.

## Blender MCP Server Commands
When Blender is running with the MCP addon enabled:
- `execute_blender_code`: Run Python snippets interactively.
- `get_scene_info`: Inspect active meshes, materials, and hierarchy.
- `generate_3d`: Prompt-based 3D generation.
