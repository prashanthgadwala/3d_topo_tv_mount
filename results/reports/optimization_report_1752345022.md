# TV Wall Mount Optimization Report

## Project Overview
**Date**: 2025-07-12 20:30:22
**Material**: steel
**Optimization Time**: 9.31 seconds

## Geometry Configuration
- Dimensions: 10.0 x 8.0 x 6.0 m
- TV Weight: 50.0 kg
- Mounting Points: 4
- Wall Thickness: 0.25 m

## Load Case Analysis Results

### static_tv_weight
- **Max Stress**: 49.54 MPa
- **Max Displacement**: 0.548 mm
- **Compliance**: 4.00e-05
- **Safety Factor**: 2.5
- **Converged**: True

### dynamic_vibration
- **Max Stress**: 29.64 MPa
- **Max Displacement**: 0.056 mm
- **Compliance**: 5.21e-05
- **Safety Factor**: 1.8
- **Converged**: True

### seismic_horizontal
- **Max Stress**: 25.67 MPa
- **Max Displacement**: 0.559 mm
- **Compliance**: 5.10e-05
- **Safety Factor**: 3.0
- **Converged**: True

### fatigue_cycling
- **Max Stress**: 46.75 MPa
- **Max Displacement**: 0.834 mm
- **Compliance**: 5.84e-05
- **Safety Factor**: 4.0
- **Converged**: True


## Optimization Parameters
- Volume Fraction: 0.1
- Max Iterations: 10
- Filter Radius: 1.7
- Penalty Parameter: 3.0

## Files Generated
- Mesh: TvMount_Advanced_nx_20_1752345019.mesh
- XML Configurations: Multiple files for each load case

## Recommendations
Based on the analysis results, the optimized TV wall mount design provides adequate safety margins for all considered load cases while minimizing material usage.
