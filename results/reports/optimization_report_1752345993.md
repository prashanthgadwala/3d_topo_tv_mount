# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:46:33
**Material**: carbon_fiber
**Optimization Time**: 8.58 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 11.25 MPa
- **Max Displacement**: 0.456 mm
- **Compliance**: 7.96e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 23.86 MPa
- **Max Displacement**: 0.487 mm
- **Compliance**: 1.86e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 42.35 MPa
- **Max Displacement**: 0.833 mm
- **Compliance**: 4.76e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 3.32 MPa
- **Max Displacement**: 0.214 mm
- **Compliance**: 6.61e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 5
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: /Users/prashanthgadwala/Documents/Study material/Semester1/Structural optimisation/3d_topo_tv_mount/results/meshes/TvMount_Advanced_nx_15_1752345990.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
