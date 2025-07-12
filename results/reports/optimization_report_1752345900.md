# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:45:00
**Material**: steel
**Optimization Time**: 9.23 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 35.69 MPa
- **Max Displacement**: 0.546 mm
- **Compliance**: 2.80e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 25.85 MPa
- **Max Displacement**: 0.031 mm
- **Compliance**: 2.83e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 32.28 MPa
- **Max Displacement**: 0.707 mm
- **Compliance**: 6.35e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 29.03 MPa
- **Max Displacement**: 0.171 mm
- **Compliance**: 8.35e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 10
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: /Users/prashanthgadwala/Documents/Study material/Semester1/Structural optimisation/3d_topo_tv_mount/results/meshes/TvMount_Advanced_nx_20_1752345897.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
