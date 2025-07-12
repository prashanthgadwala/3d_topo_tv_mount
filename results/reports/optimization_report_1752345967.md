# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:46:07
**Material**: steel
**Optimization Time**: 8.61 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 45.88 MPa
- **Max Displacement**: 0.214 mm
- **Compliance**: 2.69e-06
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 18.81 MPa
- **Max Displacement**: 0.230 mm
- **Compliance**: 1.99e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 40.99 MPa
- **Max Displacement**: 0.941 mm
- **Compliance**: 1.69e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 24.26 MPa
- **Max Displacement**: 0.758 mm
- **Compliance**: 8.33e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 10
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: /Users/prashanthgadwala/Documents/Study material/Semester1/Structural optimisation/3d_topo_tv_mount/results/meshes/TvMount_Advanced_nx_20_1752345964.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
