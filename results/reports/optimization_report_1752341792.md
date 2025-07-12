# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 19:36:32
**Material**: steel
**Optimization Time**: 8.60 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 38.22 MPa
- **Max Displacement**: 0.666 mm
- **Compliance**: 5.97e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 4.36 MPa
- **Max Displacement**: 0.640 mm
- **Compliance**: 5.25e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 25.53 MPa
- **Max Displacement**: 0.406 mm
- **Compliance**: 7.66e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 15.71 MPa
- **Max Displacement**: 0.421 mm
- **Compliance**: 3.29e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 5
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: TvMount_Advanced_nx_15_1752341789.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
