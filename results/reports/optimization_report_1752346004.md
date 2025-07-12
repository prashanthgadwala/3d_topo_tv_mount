# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:46:44
**Material**: aluminum
**Optimization Time**: 10.09 seconds

## Geometry Configuration
- Dimensions: 12.0 x 8.0 x 6.0 m
- TV Weight: 75.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 49.65 MPa
- **Max Displacement**: 0.127 mm
- **Compliance**: 9.09e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 27.80 MPa
- **Max Displacement**: 0.364 mm
- **Compliance**: 8.66e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 38.49 MPa
- **Max Displacement**: 0.092 mm
- **Compliance**: 2.82e-06
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 29.87 MPa
- **Max Displacement**: 0.988 mm
- **Compliance**: 4.07e-05
- **Safety Factor**: 4.0
- **Converged**: True

### design_basis_earthquake
- **Max Stress**: 29.91 MPa
- **Max Displacement**: 0.413 mm
- **Compliance**: 4.90e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 8
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: /Users/prashanthgadwala/Documents/Study material/Semester1/Structural optimisation/3d_topo_tv_mount/results/meshes/TvMount_Advanced_nx_12_1752346000.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
