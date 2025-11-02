#!/usr/bin/env python3
"""
TV Wall Mount 3D Mesh Generation
=================================
Generates a structured 3D mesh for topology optimization of a TV wall mount.

The design consists of:
- Wall mounting plate (back, z=0-0.25m)
- TV mounting surface (front, z=5.75-6m)
- Optimizable region (middle) where material can be removed
- 4 force application points for TV weight

Usage:
    python3 TvSupport.py
    
Output:
    Tv_WallMount-<thickness>-nx_<nx>-ny_<ny>-nz_<nz>.mesh
"""

from mesh_tool import *

# =============================================================================
# GEOMETRY CONFIGURATION
# =============================================================================

# Overall dimensions (meters)
WIDTH = 10.0   # X-axis (horizontal)
HEIGHT = 8.0   # Y-axis (horizontal)
DEPTH = 6.0    # Z-axis (wall to TV)

# Mesh resolution (based on X-axis)
NX = 50  # X-direction elements (50=fast, 100=medium, 500=production)
NY = int((HEIGHT / WIDTH) * NX)  # Maintain aspect ratio
NZ = int((DEPTH / WIDTH) * NX)   # Maintain aspect ratio

# Wall thickness (must match discretization: t = c * width/nx where c=1,2,3...)
THICKNESS = 2 * WIDTH / NX

# =============================================================================
# REGION DEFINITIONS (Z-coordinates)
# =============================================================================

# Wall mounting plate (back)
WALL_PLATE_Z_MIN = 0.0
WALL_PLATE_Z_MAX = 0.25

# TV mounting surface (front)
TV_SURFACE_Z_MIN = 5.75
TV_SURFACE_Z_MAX = 6.0

# Force application parameters
FORCE_RADIUS = 0.2  # Radius of circular force regions (m)
FORCE_CENTERS = [(2, 2), (8, 2), (2, 6), (8, 6)]  # TV corner mounting points

# =============================================================================
# MESH GENERATION
# =============================================================================

print(f"Generating TV wall mount mesh...")
print(f"  Dimensions: {WIDTH}m × {HEIGHT}m × {DEPTH}m")
print(f"  Resolution: {NX} × {NY} × {NZ} = {NX*NY*NZ:,} elements")
print(f"  Wall thickness: {THICKNESS}m")

mesh = create_3d_mesh(NX, NY, NZ, WIDTH, HEIGHT, DEPTH)

# =============================================================================
# ASSIGN ELEMENT REGIONS
# =============================================================================

print("Assigning element regions...")

def is_in_wall_plate(x, y, z):
    """Check if point is in the wall mounting plate (back)"""
    return (4 < x < 6 and 
            0 < y < 8 and 
            WALL_PLATE_Z_MIN < z < WALL_PLATE_Z_MAX)

def is_in_wall_void(x, y, z):
    """Check if point is in void region of wall plate"""
    return ((0 < x < 4 or 6 < x < 10) and 
            0 < y < 8 and 
            WALL_PLATE_Z_MIN < z < WALL_PLATE_Z_MAX)

def is_in_tv_mounting_solid(x, y, z):
    """Check if point is in solid TV mounting regions"""
    if not (TV_SURFACE_Z_MIN < z < TV_SURFACE_Z_MAX):
        return False
    
    # Corner supports (4 corners)
    corner_support = ((1 < x < 3 or 7 < x < 9) and 0 < y < 8)
    
    # Side supports (top and bottom)
    side_support = (3 < x < 7 and (0 < y < 3 or 5 < y < 8))
    
    # Center mounting area
    center_mount = (3 < x < 7 and 3 < y < 5)
    
    return corner_support or side_support or center_mount

def is_in_tv_mounting_void(x, y, z):
    """Check if point is in void region of TV mounting surface"""
    if not (TV_SURFACE_Z_MIN < z < TV_SURFACE_Z_MAX):
        return False
    
    # Top/bottom cutouts
    cutout_tb = (3 < x < 7 and (0 < y < 3 or 5 < y < 8))
    
    # Left/right edge voids
    cutout_lr = ((0 < x < 1 or 9 < x < 10) and 0 < y < 8)
    
    return cutout_tb or cutout_lr

# Assign regions to each element
for element in mesh.elements:
    x, y, z = mesh.calc_barycenter(element)
    
    # Solid regions (cannot be removed during optimization)
    if is_in_wall_plate(x, y, z) or is_in_tv_mounting_solid(x, y, z):
        element.region = 'solid'
    
    # Void regions (will remain empty)
    elif is_in_wall_void(x, y, z) or is_in_tv_mounting_void(x, y, z):
        element.region = 'void'
    
    # Default region is 'mech' (optimizable)
    # No need to set explicitly - it's the default

# =============================================================================
# DEFINE BOUNDARY CONDITIONS
# =============================================================================

print("Defining boundary conditions...")

# Initialize node sets
back_support = []  # Fixed wall mounting nodes
force_nodes = [[], [], [], []]  # 4 force application regions

# Classify nodes
for node_idx, (x, y, z) in enumerate(mesh.nodes):
    
    # Wall mounting support (fixed boundary)
    if 4 < x < 6 and 0 < y < 8 and WALL_PLATE_Z_MIN < z < WALL_PLATE_Z_MAX:
        back_support.append(node_idx)
    
    # Force application points (circular regions at TV corners)
    if TV_SURFACE_Z_MIN < z < TV_SURFACE_Z_MAX:
        for force_idx, (cx, cy) in enumerate(FORCE_CENTERS):
            distance_sq = (x - cx)**2 + (y - cy)**2
            if distance_sq <= FORCE_RADIUS**2:
                force_nodes[force_idx].append(node_idx)

# Add boundary conditions to mesh
mesh.bc.append(('back_support', back_support))
for i, nodes in enumerate(force_nodes, 1):
    mesh.bc.append((f'force_{i}', nodes))

# =============================================================================
# OUTPUT MESH FILE
# =============================================================================

# Ensure output directory exists
import os
os.makedirs('results/meshes', exist_ok=True)

# Generate filename
filename = f'results/meshes/Tv_WallMount-{THICKNESS:.2f}-nx_{NX}-ny_{NY}-nz_{NZ}.mesh'

# Write mesh in Ansys format
write_ansys_mesh(mesh, filename)

# Print summary
print(f"\n{'='*70}")
print(f"Mesh generation complete!")
print(f"{'='*70}")
print(f"Output file: {filename}")
print(f"Elements: {len(mesh.elements):,}")
print(f"Nodes: {len(mesh.nodes):,}")
print(f"\nBoundary conditions:")
print(f"  back_support: {len(back_support):,} nodes (fixed wall mount)")
for i, nodes in enumerate(force_nodes, 1):
    print(f"  force_{i}: {len(nodes):,} nodes (TV mounting point {i})")
print(f"\n{'='*70}")
print(f"Next step: Run openCFS optimization")
print(f"  cfs -m {filename} TvSupport")
print(f"{'='*70}")

# Note: Use 'cfs -m <mesh> <problem> -g' to visualize mesh without optimization
