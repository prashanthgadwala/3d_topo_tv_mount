# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 19:36:51
**Material**: carbon_fiber
**Optimization Time**: 8.73 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 44.69 MPa
- **Max Displacement**: 0.130 mm
- **Compliance**: 3.78e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 8.88 MPa
- **Max Displacement**: 0.960 mm
- **Compliance**: 4.05e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 38.69 MPa
- **Max Displacement**: 0.905 mm
- **Compliance**: 1.86e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 6.51 MPa
- **Max Displacement**: 0.557 mm
- **Compliance**: 2.99e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 5
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: TvMount_Advanced_nx_15_1752341808.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
