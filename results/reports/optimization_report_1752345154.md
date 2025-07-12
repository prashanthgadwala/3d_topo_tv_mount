# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:32:34
**Material**: steel
**Optimization Time**: 8.22 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 20.79 MPa
- **Max Displacement**: 0.366 mm
- **Compliance**: 5.84e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 46.56 MPa
- **Max Displacement**: 0.851 mm
- **Compliance**: 7.18e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 44.65 MPa
- **Max Displacement**: 0.164 mm
- **Compliance**: 8.66e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 40.88 MPa
- **Max Displacement**: 0.213 mm
- **Compliance**: 5.67e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 100
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: TvMount_Advanced_nx_3_1752345151.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
