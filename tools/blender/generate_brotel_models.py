"""
Procedural 3D Low-Poly Model Generator for BroTel: Gym Bro Hotel Tycoon
Using Blender 5.0 headless bpy scripting.
Generates:
1. gym_bro_character.obj
2. dumbbell.obj
3. barbell_squat_rack.obj
4. protein_shaker.obj
5. reception_desk.obj
6. hotel_bed_suite.obj
7. sauna_bench.obj
"""

import bpy
import os
import math

def clean_scene():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    for obj in bpy.data.objects:
        bpy.data.objects.remove(obj, do_unlink=True)
    for mesh in bpy.data.meshes:
        bpy.data.meshes.remove(mesh, do_unlink=True)
    for mat in bpy.data.materials:
        bpy.data.materials.remove(mat, do_unlink=True)

def create_material(name, color_rgba, roughness=0.5):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs['Base Color'].default_value = color_rgba
        bsdf.inputs['Roughness'].default_value = roughness
    return mat

def export_active_as_obj(filepath):
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    # Blender 5.0 export obj syntax
    try:
        bpy.ops.wm.obj_export(filepath=filepath, export_selected_objects=False)
    except Exception:
        bpy.ops.export_scene.obj(filepath=filepath, use_selection=False)

def build_dumbbell(output_path):
    clean_scene()
    iron_mat = create_material("DarkIron", (0.1, 0.1, 0.12, 1.0), 0.3)
    chrome_mat = create_material("ChromeKnurl", (0.8, 0.8, 0.85, 1.0), 0.2)

    # Handle
    bpy.ops.mesh.primitive_cylinder_add(radius=0.04, depth=0.4, location=(0, 0, 0))
    handle = bpy.context.active_object
    handle.name = "Dumbbell_Handle"
    handle.rotation_euler = (0, math.radians(90), 0)
    handle.data.materials.append(chrome_mat)

    # Left Weight Plates (Hexagonal cylinder)
    bpy.ops.mesh.primitive_cylinder_add(vertices=6, radius=0.2, depth=0.15, location=(-0.25, 0, 0))
    plate_l = bpy.context.active_object
    plate_l.rotation_euler = (0, math.radians(90), 0)
    plate_l.data.materials.append(iron_mat)

    # Right Weight Plates
    bpy.ops.mesh.primitive_cylinder_add(vertices=6, radius=0.2, depth=0.15, location=(0.25, 0, 0))
    plate_r = bpy.context.active_object
    plate_r.rotation_euler = (0, math.radians(90), 0)
    plate_r.data.materials.append(iron_mat)

    export_active_as_obj(output_path)
    print(f"Generated: {output_path}")

def build_protein_shaker(output_path):
    clean_scene()
    shaker_mat = create_material("NeonShakerCyan", (0.0, 0.94, 1.0, 0.9), 0.2)
    cap_mat = create_material("EnergyOrangeCap", (1.0, 0.42, 0.0, 1.0), 0.4)

    # Bottle body (tapered cone/cylinder)
    bpy.ops.mesh.primitive_cone_add(vertices=12, radius1=0.12, radius2=0.09, depth=0.35, location=(0, 0, 0.175))
    bottle = bpy.context.active_object
    bottle.data.materials.append(shaker_mat)

    # Cap
    bpy.ops.mesh.primitive_cylinder_add(vertices=12, radius=0.13, depth=0.08, location=(0, 0, 0.37))
    cap = bpy.context.active_object
    cap.data.materials.append(cap_mat)

    # Flip lid spout
    bpy.ops.mesh.primitive_cube_add(size=0.06, location=(0.06, 0, 0.42))
    spout = bpy.context.active_object
    spout.data.materials.append(cap_mat)

    export_active_as_obj(output_path)
    print(f"Generated: {output_path}")

def build_gym_bro_character(output_path):
    clean_scene()
    skin_mat = create_material("BroSkin", (0.9, 0.68, 0.55, 1.0), 0.6)
    tank_mat = create_material("TankTopRed", (0.95, 0.15, 0.2, 1.0), 0.5)
    shorts_mat = create_material("GymShortsBlack", (0.1, 0.1, 0.1, 1.0), 0.7)
    cap_mat = create_material("BackwardCapCyan", (0.0, 0.9, 1.0, 1.0), 0.4)

    # Torso (Massive broad chest tapering to waist)
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.4))
    torso = bpy.context.active_object
    torso.scale = (0.7, 0.4, 0.8)
    torso.data.materials.append(tank_mat)

    # Head
    bpy.ops.mesh.primitive_uv_sphere_add(segments=8, ring_count=6, radius=0.25, location=(0, 0, 2.0))
    head = bpy.context.active_object
    head.data.materials.append(skin_mat)

    # Backward Baseball Cap
    bpy.ops.mesh.primitive_uv_sphere_add(segments=8, ring_count=6, radius=0.27, location=(0, 0, 2.05))
    cap = bpy.context.active_object
    cap.scale = (1.0, 1.0, 0.6)
    cap.data.materials.append(cap_mat)

    # Cap brim (pointing backwards)
    bpy.ops.mesh.primitive_cube_add(size=0.2, location=(0, -0.25, 2.0))
    brim = bpy.context.active_object
    brim.scale = (1.0, 0.6, 0.1)
    brim.data.materials.append(cap_mat)

    # Massive Left Bicep & Arm
    bpy.ops.mesh.primitive_uv_sphere_add(segments=8, ring_count=6, radius=0.28, location=(-0.65, 0, 1.4))
    bicep_l = bpy.context.active_object
    bicep_l.scale = (0.9, 0.9, 1.2)
    bicep_l.data.materials.append(skin_mat)

    # Massive Right Bicep & Arm
    bpy.ops.mesh.primitive_uv_sphere_add(segments=8, ring_count=6, radius=0.28, location=(0.65, 0, 1.4))
    bicep_r = bpy.context.active_object
    bicep_r.scale = (0.9, 0.9, 1.2)
    bicep_r.data.materials.append(skin_mat)

    # Legs / Shorts
    bpy.ops.mesh.primitive_cylinder_add(vertices=8, radius=0.18, depth=0.7, location=(-0.25, 0, 0.65))
    leg_l = bpy.context.active_object
    leg_l.data.materials.append(shorts_mat)

    bpy.ops.mesh.primitive_cylinder_add(vertices=8, radius=0.18, depth=0.7, location=(0.25, 0, 0.65))
    leg_r = bpy.context.active_object
    leg_r.data.materials.append(shorts_mat)

    export_active_as_obj(output_path)
    print(f"Generated: {output_path}")

def build_reception_desk(output_path):
    clean_scene()
    wood_mat = create_material("DarkCedar", (0.35, 0.22, 0.14, 1.0), 0.6)
    counter_mat = create_material("MarbleWhite", (0.95, 0.95, 0.95, 1.0), 0.2)
    gold_mat = create_material("GoldBell", (1.0, 0.84, 0.0, 1.0), 0.2)

    # Base Desk Counter
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.55))
    counter = bpy.context.active_object
    counter.scale = (2.2, 0.8, 1.1)
    counter.data.materials.append(wood_mat)

    # Top Marble Slab
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 1.12))
    top = bpy.context.active_object
    top.scale = (2.3, 0.9, 0.08)
    top.data.materials.append(counter_mat)

    # Reception Bell
    bpy.ops.mesh.primitive_uv_sphere_add(segments=8, ring_count=6, radius=0.1, location=(0.4, 0, 1.2))
    bell = bpy.context.active_object
    bell.scale = (1.0, 1.0, 0.5)
    bell.data.materials.append(gold_mat)

    export_active_as_obj(output_path)
    print(f"Generated: {output_path}")

def build_squat_rack(output_path):
    clean_scene()
    steel_mat = create_material("HeavySteel", (0.15, 0.16, 0.18, 1.0), 0.4)
    barbell_mat = create_material("ChromeBar", (0.8, 0.8, 0.85, 1.0), 0.2)
    plate_mat = create_material("IronPlate45", (0.85, 0.15, 0.15, 1.0), 0.5)

    # Left & Right Cage Uprights
    for x in [-0.9, 0.9]:
        bpy.ops.mesh.primitive_cube_add(size=1.0, location=(x, 0, 1.25))
        post = bpy.context.active_object
        post.scale = (0.1, 0.1, 2.5)
        post.data.materials.append(steel_mat)

    # Barbell Bar
    bpy.ops.mesh.primitive_cylinder_add(radius=0.035, depth=2.4, location=(0, 0, 1.5))
    bar = bpy.context.active_object
    bar.rotation_euler = (0, math.radians(90), 0)
    bar.data.materials.append(barbell_mat)

    # Left Weight Plates (45 lbs)
    for x_offset in [-1.0, -1.08]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.35, depth=0.06, location=(x_offset, 0, 1.5))
        p = bpy.context.active_object
        p.rotation_euler = (0, math.radians(90), 0)
        p.data.materials.append(plate_mat)

    # Right Weight Plates
    for x_offset in [1.0, 1.08]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.35, depth=0.06, location=(x_offset, 0, 1.5))
        p = bpy.context.active_object
        p.rotation_euler = (0, math.radians(90), 0)
        p.data.materials.append(plate_mat)

    export_active_as_obj(output_path)
    print(f"Generated: {output_path}")

def build_bed_suite(output_path):
    clean_scene()
    wood_mat = create_material("HeavyOak", (0.3, 0.18, 0.1, 1.0), 0.6)
    mattress_mat = create_material("MattressFoam", (0.9, 0.92, 0.95, 1.0), 0.8)
    pillow_mat = create_material("PillowWhite", (0.98, 0.98, 0.98, 1.0), 0.9)

    # Bed Frame
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.25))
    frame = bpy.context.active_object
    frame.scale = (1.8, 2.2, 0.5)
    frame.data.materials.append(wood_mat)

    # Mattress
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, 0.55))
    mattress = bpy.context.active_object
    mattress.scale = (1.7, 2.1, 0.3)
    mattress.data.materials.append(mattress_mat)

    # Pillows
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(-0.4, 0.8, 0.75))
    pil1 = bpy.context.active_object
    pil1.scale = (0.5, 0.35, 0.15)
    pil1.data.materials.append(pillow_mat)

    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0.4, 0.8, 0.75))
    pil2 = bpy.context.active_object
    pil2.scale = (0.5, 0.35, 0.15)
    pil2.data.materials.append(pillow_mat)

    export_active_as_obj(output_path)
    print(f"Generated: {output_path}")

def build_sauna_bench(output_path):
    clean_scene()
    cedar_mat = create_material("SaunaCedar", (0.65, 0.42, 0.22, 1.0), 0.7)
    stone_mat = create_material("LavaStone", (0.1, 0.1, 0.1, 1.0), 0.9)

    # Lower Tier Bench
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, -0.3, 0.3))
    bench1 = bpy.context.active_object
    bench1.scale = (2.2, 0.6, 0.6)
    bench1.data.materials.append(cedar_mat)

    # Upper Tier Bench
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0.3, 0.75))
    bench2 = bpy.context.active_object
    bench2.scale = (2.2, 0.6, 0.9)
    bench2.data.materials.append(cedar_mat)

    # Hot Stone Bucket
    bpy.ops.mesh.primitive_cylinder_add(radius=0.2, depth=0.35, location=(0.8, -0.7, 0.2))
    bucket = bpy.context.active_object
    bucket.data.materials.append(stone_mat)

    export_active_as_obj(output_path)
    print(f"Generated: {output_path}")

if __name__ == "__main__":
    models_dir = os.path.abspath("Assets/Models")
    print(f"Starting BroTel 3D Model Generation -> {models_dir}")
    
    build_gym_bro_character(os.path.join(models_dir, "gym_bro_character.obj"))
    build_dumbbell(os.path.join(models_dir, "dumbbell.obj"))
    build_protein_shaker(os.path.join(models_dir, "protein_shaker.obj"))
    build_reception_desk(os.path.join(models_dir, "reception_desk.obj"))
    build_squat_rack(os.path.join(models_dir, "barbell_squat_rack.obj"))
    build_bed_suite(os.path.join(models_dir, "hotel_bed_suite.obj"))
    build_sauna_bench(os.path.join(models_dir, "sauna_bench.obj"))
    
    print("All 7 BroTel 3D models exported successfully!")
