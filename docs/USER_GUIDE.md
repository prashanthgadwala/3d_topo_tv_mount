# Topology Optimization User Guide

Complete reference for customization and advanced workflows in 3D topology optimization.

---

## Quick Start

```bash
# Standard workflow (quick, default settings)
./run_optimization.sh

# Advanced workflow (full customization)
./run_optimization_advanced.sh
```

---

## Parameter Reference

### Key Configuration Files

**TvSupport.xml** - Main optimization settings:
- Line 18: `material="99lines"` (Material selection)
- Line 55: `<volfrac>0.25</volfrac>` (Volume: 5-70%)
- Line 56: `<penalty>3.0</penalty>` (SIMP: 1.5-5.0)
- Line 57: `<filterRadius>0.05</filterRadius>` (Filter: 0.02-0.15)
- Line 86: `<cholmod/>` (Solver choice)

**TvSupport.py** - Mesh generation:
```python
nx, ny, nz = 80, 64, 48  # Mesh resolution
lx, ly, lz = 1.6, 1.28, 0.96  # Domain size (m)
```

**mat.xml** - Material database (10+ materials available)

### Parameter Ranges

| Parameter | Range | Default | Effect |
|-----------|-------|---------|--------|
| Volume fraction | 0.05-0.70 | 0.25 | Material budget |
| SIMP penalty | 1.5-5.0 | 3.0 | Solid/void sharpness |
| Filter radius | 0.02-0.15 | 0.05 | Minimum feature size |
| Mesh (nx) | 20-200 | 80 | Resolution/detail |

### Material Database

| Material | E (GPa) | ρ (kg/m³) | Application |
|----------|---------|-----------|-------------|
| 99lines | 1 | 1e-8 | Benchmark |
| Steel | 200 | 7872 | Metal fabrication |
| aluminium | 107.8 | 2700 | Lightweight |
| TitaniumWikipedia | 110 | 4506 | High strength |
| soft/weak | 0.01/0.0001 | 1e-9 | Compliant mechanisms |

---

## Advanced Workflow Modes

### Mode 1: Quick Run
- Default parameters (50×40×30 mesh, 25% volume)
- CHOLMOD solver, 99lines material
- Runtime: ~3 minutes

### Mode 2: Custom Parameters
Interactive configuration of:
- **Mesh**: Coarse (40×32×24) to Ultra (120×96×72)
- **Material**: Full database access
- **Volume**: 10-70% material fraction
- **Solver**: CHOLMOD/DirectLDL/CG
- **Filter**: Feature size control

### Mode 3: Parameter Studies
Automated comparative analysis:
- **Volume study**: Test 10%, 15%, 20%, 25%, 30%, 35%
- **Material study**: Compare 99lines, Steel, Aluminium, Titanium
- **Mesh convergence**: Verify solution independence
- **Filter study**: Optimize manufacturability

---

## Mesh Resolution Guidelines

| Configuration | Elements | Time | Application |
|---------------|----------|------|-------------|
| Coarse (40×32×24) | 30,720 | 30s | Quick tests |
| Medium (80×64×48) | 245,760 | 3min | Standard runs |
| Fine (120×96×72) | 829,440 | 15min | Detailed results |
| Ultra (160×128×96) | 1,966,080 | 1hr | Publication quality |

**Rule:** Higher resolution = better detail but longer computation

---

## Solver Comparison

| Solver | Type | Speed | Memory | Best For |
|--------|------|-------|--------|----------|
| CHOLMOD | Direct | Fast | 1.5 GB | General use (default) |
| DirectLDL | Direct | Medium | 1.0 GB | Alternative |
| CG | Iterative | Slow | 300 MB | Large meshes, limited RAM |

---

## Common Configurations

### Fast Prototyping
```
Mesh: 40×32×24
Material: 99lines
Volume: 25%
Time: ~30 seconds
```

### Production Design
```
Mesh: 120×96×72
Material: Steel/Aluminium
Volume: 15-25%
Time: ~10 minutes
```

### Lightweighting Study
```
Study: Volume fraction sweep
Cases: 10%, 15%, 20%, 25%, 30%, 35%
Total time: ~3 hours
```

---

## Boundary Conditions & Loads

**Fixed:** Rear surface (z=0) fully constrained

**Loads:** Four point loads (TV mounting)
```xml
<force name="tv_load_1">
  <comp dof="y" value="-0.78"/>  <!-- Vertical (downward) -->
</force>
```

**Load Calculation for Real Design:**
1. TV mass M (kg) → Force F = M × 9.81 N
2. Per point: F_point = F / 4
3. With safety factor: F_design = F_point × 2-3

**Alternative Loading:**
- Lateral: `<comp dof="x" value="0.5"/>`
- Torsional: Off-center point loads

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Out of memory | Use CG solver or reduce mesh |
| Checkerboard pattern | Increase filter radius |
| Too much gray material | Increase SIMP penalty or iterations |
| Non-convergence | Reduce volume constraint or adjust filter |
| Solver not found | Use CHOLMOD (always available) |

---

## Recommended Workflow

### Phase 1: Exploration (Fast)
- Coarse mesh: 40×32×24
- Test different materials
- Volume: 25%
- Time: 1-2 min/run

### Phase 2: Refinement
- Medium mesh: 100×80×60
- Fine-tune volume fraction
- Add alternative loads
- Time: 5-10 min/run

### Phase 3: Validation (Final)
- Fine mesh: 140×112×84
- Real material properties
- Tight convergence (tol=0.0001)
- Time: 30-60 min/run

### Phase 4: Manufacturing
- Export to STL
- CAD post-processing
- Add mounting features
- FEA verification

---

## Parametric Studies

### Experiment 1: Volume Sensitivity
Test: volfrac = [0.10, 0.15, 0.20, 0.25, 0.30, 0.35]
Output: Compliance vs. volume curve
Goal: Find optimal material budget

### Experiment 2: Material Comparison
Test: 99lines vs Steel vs Aluminium vs Titanium
Fixed: Geometry, volume
Compare: Final topology, mass, cost

### Experiment 3: Load Robustness
Cases: Vertical, lateral, torsion, combined
Goal: Multi-load optimization

### Experiment 4: Mesh Independence
Test: nx = [60, 80, 100, 120]
Verify: Compliance change < 1%
Validates: Solution accuracy

---

## Post-Processing

```bash
# Visualize in ParaView
paraview results/outputs/TvSupport.vtk

# Recommended workflow:
# 1. Apply Threshold filter (density > 0.5)
# 2. Color by density or stress
# 3. Add Clip to view internal structure
```

---

## Advanced Topics

### Anisotropic Materials
Directional fiber reinforcement available in mat.xml:
- `orient_0_degrees` (X-axis)
- `orient_90_degrees` (Y-axis)
- `orient_45_degrees`, `orient_135_degrees`

**Applications:** Composite layup, continuous fiber 3D printing

### Multi-Load Optimization
Combine multiple load cases for robust design
**Requires:** Advanced openCFS configuration

### Enhanced Solvers
Recompile openCFS with PARDISO/LIS support:
```bash
cmake -DUSE_PARDISO=ON -DUSE_LIS=ON ..
```

---

## References

- Bendsøe & Sigmund (2003). *Topology Optimization: Theory, Methods, and Applications*
- Sigmund (2001). A 99 line topology optimization code. *Struct. Multidisc. Optim.*
- Andreassen et al. (2011). Efficient topology optimization in MATLAB. *Struct. Multidisc. Optim.*

---

**Note:** The advanced script (`run_optimization_advanced.sh`) handles all parameter updates via interactive menus - no manual file editing needed.
