# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:45:18
**Material**: aluminum
**Optimization Time**: 8.91 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 29.78 MPa
- **Max Displacement**: 0.962 mm
- **Compliance**: 9.49e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 10.66 MPa
- **Max Displacement**: 0.096 mm
- **Compliance**: 1.57e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 18.69 MPa
- **Max Displacement**: 0.087 mm
- **Compliance**: 6.56e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 6.94 MPa
- **Max Displacement**: 0.120 mm
- **Compliance**: 6.64e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 5
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: /Users/prashanthgadwala/Documents/Study material/Semester1/Structural optimisation/3d_topo_tv_mount/results/meshes/TvMount_Advanced_nx_15_1752345915.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
