# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:30:31
**Material**: steel
**Optimization Time**: 8.51 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 19.71 MPa
- **Max Displacement**: 0.683 mm
- **Compliance**: 6.96e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 48.82 MPa
- **Max Displacement**: 0.267 mm
- **Compliance**: 5.58e-06
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 43.57 MPa
- **Max Displacement**: 0.957 mm
- **Compliance**: 5.74e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 22.43 MPa
- **Max Displacement**: 0.293 mm
- **Compliance**: 8.48e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 5
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: TvMount_Advanced_nx_15_1752345028.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
