# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:30:49
**Material**: carbon_fiber
**Optimization Time**: 8.56 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 35.29 MPa
- **Max Displacement**: 0.226 mm
- **Compliance**: 1.67e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 47.87 MPa
- **Max Displacement**: 0.801 mm
- **Compliance**: 1.72e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 7.84 MPa
- **Max Displacement**: 0.389 mm
- **Compliance**: 1.34e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 31.65 MPa
- **Max Displacement**: 0.346 mm
- **Compliance**: 8.45e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 5
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: TvMount_Advanced_nx_15_1752345046.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
