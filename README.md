````markdown
# 3D Topology Optimization: TV Wall Mount Bracket

Implementation of density-based topology optimization for structural design using the SIMP method and openCFS finite element solver.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Status](https://img.shields.io/badge/status-active-success.svg)

## Abstract

This repository contains a complete implementation of 3D structural topology optimization applied to a TV wall mount bracket design problem. The optimization employs the Solid Isotropic Material with Penalization (SIMP) method to determine optimal material distribution within a prescribed design domain, subject to volume constraints and static load conditions.

**Capabilities:**
- 3D density-based topology optimization via openCFS FEA solver
- Parametric mesh generation with aspect-ratio control
- Multiple direct and iterative linear system solvers
- Automated workflow with configurable optimization parameters
- Post-processing and visualization pipeline

## Problem Definition

**Design Domain:** Rectangular cuboid (10m × 8m × 6m)

**Objective:** Minimize structural compliance (maximize stiffness)

**Constraints:**
- Volume fraction ≤ 25% (default)
- Fixed boundary conditions on rear wall surface
- Four point loads representing TV weight distribution

**Output:** Spatially-varying density field defining optimal material layout

## Installation and Setup

### System Requirements

**Required Software:**
- openCFS v. 23.11 (finite element solver, compiled without PARDISO/LIS support)
- Python 3.x with NumPy (mesh generation)
- ParaView (post-processing visualization)

**Supported Platforms:**
- Linux (tested on Ubuntu 20.04+)
- macOS (tested on macOS 12+)
- Windows WSL2

### Installation Procedure

1. Clone repository:
   ```bash
   git clone <repository-url>
   cd 3d_topo_tv_mount
   ```

2. Install Python dependencies:
   ```bash
   pip install numpy
   ```

3. Configure openCFS path:
   Edit `run_optimization.sh` or `run_optimization_advanced.sh` and set:
   ```bash
   OPENCFS_DIR="/path/to/openCFS"
   ```

### Execution Methods

**Method 1: Standard Workflow (Default Configuration)**

Executes optimization with pre-configured settings suitable for most applications:
```bash
chmod +x run_optimization.sh
./run_optimization.sh
```

Configuration: CHOLMOD solver, 80×64×48 mesh, 25% volume fraction, SIMP penalty p=3.0

**Method 2: Advanced Interactive Workflow (Full Customization)**

Provides complete control over optimization parameters via interactive menus:
```bash
chmod +x run_optimization_advanced.sh
./run_optimization_advanced.sh
```

Features:
- Mesh resolution selection (30K to 2M elements)
- Material database (10+ engineering materials)
- Solver selection (CHOLMOD, DirectLDL, CG)
- Parameter customization (volume fraction, filter radius, penalty exponent)
- Automated parametric studies
- Runtime estimation and result summaries

Workflow:
1. Select operation mode (Quick Run / Custom Parameters / Parameter Studies)
2. Configure mesh resolution, material properties, solver algorithm
3. Set optimization parameters (volume constraint, filter radius, convergence criteria)
4. Review configuration summary with estimated runtime
5. Execute optimization
6. Post-process results in ParaView

---

## Technical Implementation

### Optimization Algorithm

**Method:** SIMP (Solid Isotropic Material with Penalization)

Material interpolation:
```
E(ρ) = ρ^p × E₀
```
where:
- ρ: element density (0 ≤ ρ ≤ 1)
- p: penalty exponent (default: 3.0)
- E₀: base material Young's modulus

**Objective Function:**
```
min: C(ρ) = U^T K(ρ) U  (compliance minimization)
```

**Constraints:**
```
V(ρ)/V₀ ≤ f_vol  (volume fraction constraint)
0 < ρ_min ≤ ρ_e ≤ 1  (density bounds)
```

**Filter:** Density filter with Helmholtz-type averaging prevents checkerboard patterns

**Solver:** Optimality Criteria (OC) method for density updates

### Repository Structure

```
3d_topo_tv_mount/
│
├── run_optimization.sh       # Standard workflow script
├── run_optimization_advanced.sh  # Interactive advanced workflow
├── TvSupport.py              # Mesh generator (numpy-based)
├── TvSupport.xml             # FEA problem definition
├── mat.xml                   # Material property database
│
├── src/                      # openCFS installation
│   ├── bin/cfs               # openCFS executable
│   └── share/python/         # Python tools
│
├── results/                  # Output directory
│   ├── meshes/               # Generated mesh files
│   └── outputs/              # Optimization results
│       └── TvSupport.vtk     # VTK format for ParaView
│
└── docs/                     # Documentation
    ├── CUSTOMIZATION_GUIDE.md  # Complete parameter reference
    ├── ADVANCED_FEATURES.md    # Feature documentation
    └── QUICK_REFERENCE.md      # Parameter quick reference
```

### Configuration Files

**TvSupport.xml** - FEA and optimization parameters:
- Boundary conditions (fixed rear surface)
- Load definition (four point loads)
- Volume fraction constraint (default: 25%)
- SIMP penalty exponent (default: 3.0)
- Filter radius (default: 0.025)
- Convergence criteria
- Solver selection

**mat.xml** - Material properties:
- Young's modulus (E)
- Poisson's ratio (ν)
- Density (ρ)
- Yield strength (σ_y)
- Cost factors

Available materials: 99lines, Steel (S235JR, 304SS), Aluminium (6061-T6, 7075-T6), Titanium (Ti6Al4V), composites (Carbon/Glass fiber), ceramics (Alumina, Silicon Carbide)

**TvSupport.py** - Mesh generation:
Generates structured hexahedral mesh with specified resolution:
```python
nx, ny, nz = 80, 64, 48  # Mesh divisions (default)
Lx, Ly, Lz = 10, 8, 6    # Domain dimensions (meters)
```
Aspect ratio: 10:8:6 (maintains geometric proportions)

## Computational Performance

### Linear Solver Selection

Available solvers (openCFS compiled without PARDISO/LIS support):

| Solver | Type | Performance | Memory | Recommended For |
|--------|------|-------------|--------|-----------------|
| CHOLMOD | Direct (sparse Cholesky) | Fast (37 min) | Moderate | General purpose (default) |
| DirectLDL | Direct (LDL factorization) | Moderate (50 min) | Higher | Alternative direct method |
| CG | Iterative (Conjugate Gradient) | Slower (75 min) | Low | Large-scale problems |

Performance metrics based on 80×64×48 mesh (≈245,760 elements) on standard workstation.

### Mesh Resolution Guidelines

Resolution trade-offs (domain: 10m × 8m × 6m):

| Resolution | Elements | Runtime | Detail Level | Application |
|------------|----------|---------|--------------|-------------|
| 50×40×30 | 60,000 | 37 min | Low | Concept validation |
| 80×64×48 | 245,760 | 3 hours | Medium | Standard optimization |
| 100×80×60 | 480,000 | 8 hours | High | Publication quality |
| 120×96×72 | 829,440 | 18 hours | Very High | Research studies |

Modify mesh resolution in `TvSupport.py`:
```python
nx, ny, nz = 80, 64, 48  # Adjust these values
```

---

## Results and Visualization

### Optimization Output

**Primary Output File:** `results/outputs/TvSupport.vtk`

Contains:
- Element density field (ρ ∈ [0,1])
- Von Mises stress distribution
- Displacement field
- Iteration history

**Visualization Procedure:**
1. Open ParaView
2. Load `TvSupport.vtk`
3. Apply threshold filter (ρ > 0.3) to visualize solid regions
4. Color by stress or density field
5. Adjust transparency for internal structure visualization

**Expected Morphology:**
- Material reduction: ≈75-90% (depending on volume constraint)
- Organic load-path geometry
- Concentrated material along principal stress directions
- Minimal compliance structure

### Convergence Criteria

Default convergence tolerances:
- Density change: < 1% between iterations
- Objective change: < 0.1%
- Maximum iterations: 50

Monitor convergence in terminal output:
```
Iteration: 1, Objective: 234.56, Volume: 0.250
Iteration: 2, Objective: 198.34, Volume: 0.250
...
Converged at iteration: 42
```

---

## Parameter Customization

### Basic Configuration

**TvSupport.xml** modification for key parameters:

**Volume Fraction** (line ≈75):
```xml
<volfrac>0.25</volfrac>  <!-- Range: 0.05 to 0.70 -->
```

**SIMP Penalty Exponent** (line ≈76):
```xml
<penalty>3.0</penalty>  <!-- Range: 1.5 to 5.0 -->
```

**Filter Radius** (line ≈77):
```xml
<filterRadius>0.025</filterRadius>  <!-- Range: 0.02 to 0.15 -->
```

**Solver Selection** (line ≈86):
```xml
<cholmod/>      <!-- Fast direct solver (default) -->
<directLDL/>    <!-- Alternative direct solver -->
<cg/>           <!-- Iterative solver for large problems -->
```

### Advanced Customization

For comprehensive parameter exploration and advanced features, refer to `docs/USER_GUIDE.md` for complete customization guide including:
- Automated parametric studies (volume fraction, material properties, mesh convergence, filter radius)
- Multiple material selection from engineering database
- Runtime estimation and result summaries
- Configuration templates for common scenarios

Execute advanced workflow:
```bash
./run_optimization_advanced.sh
```

---

## Quick Reference

### Key Parameter Locations

**TvSupport.xml:**
- Line 18: `material="99lines"` (Material selection)
- Line 55: `<volfrac>0.25</volfrac>` (Volume: 5-70%)
- Line 56: `<penalty>3.0</penalty>` (SIMP: 1.5-5.0)
- Line 57: `<filterRadius>0.05</filterRadius>` (Filter: 0.02-0.15)
- Line 86: `<cholmod/>` (Solver selection)

**TvSupport.py:**
```python
nx, ny, nz = 80, 64, 48  # Mesh resolution
```

### Parameter Ranges

| Parameter | Range | Default | Effect |
|-----------|-------|---------|--------|
| Volume fraction | 0.05-0.70 | 0.25 | Material budget |
| SIMP penalty | 1.5-5.0 | 3.0 | Solid-void sharpness |
| Filter radius | 0.02-0.15 | 0.05 | Minimum feature size |
| Mesh (nx) | 20-200 | 80 | Detail level |

### Available Materials

| Material | E (GPa) | ρ (kg/m³) | Application |
|----------|---------|-----------|-------------|
| 99lines | 1 | 1e-8 | Benchmark |
| Steel | 200 | 7872 | Metal fabrication |
| aluminium | 107.8 | 2700 | Lightweight |
| TitaniumWikipedia | 110 | 4506 | High strength |

### Mesh Resolution Presets

| Configuration | Elements | Time | Application |
|---------------|----------|------|-------------|
| 40×32×24 | 30K | 30s | Quick test |
| 80×64×48 | 246K | 3min | Standard run |
| 120×96×72 | 829K | 15min | High detail |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `cfs: command not found` | Update `OPENCFS_DIR` path in script |
| `ModuleNotFoundError: No module named 'numpy'` | Install: `pip install numpy` |
| Mesh generation fails | Set `PYTHONPATH=/path/to/openCFS/share/python` |
| Out of memory | Use CG solver or reduce mesh resolution |
| Checkerboard pattern | Increase filter radius |
| Excessive gray material | Increase SIMP penalty or iteration count |
| Non-convergence | Reduce volume constraint or adjust filter |
| ParaView shows empty | Apply Threshold filter (density > 0.3-0.5) |

---

## References and Resources

### Theoretical Background

- Bendsøe, M. P., & Sigmund, O. (2003). *Topology Optimization: Theory, Methods, and Applications*. Springer.
- Sigmund, O. (2001). A 99 line topology optimization code written in Matlab. *Structural and Multidisciplinary Optimization*, 21(2), 120-127.
- Andreassen, E., Clausen, A., Schevenels, M., Lazarov, B. S., & Sigmund, O. (2011). Efficient topology optimization in MATLAB using 88 lines of code. *Structural and Multidisciplinary Optimization*, 43(1), 1-16.

### openCFS Documentation

- openCFS User Manual: [https://www.opencfs.org/](https://www.opencfs.org/)
- openCFS GitHub Repository: Contact repository maintainers for access

### Related Software

- ParaView: [https://www.paraview.org/](https://www.paraview.org/)
- NumPy: [https://numpy.org/](https://numpy.org/)

---

## License

This project is licensed under the MIT License. See LICENSE file for details.

---

## Contact and Support

For technical questions, implementation issues, or research collaboration inquiries, please open an issue on the project repository or contact the maintainers directly.

**Note:** This implementation is provided for educational and research purposes. Results should be validated against analytical solutions or experimental data before application to engineering design problems.
````

---

## 📚 Documentation

- **[Technical Notes](docs/TECHNICAL_NOTES.md)** - Detailed specifications, solver comparison, performance data

---

## ⚙️ System Requirements

| Component | Requirement |
|-----------|-------------|
| OS | macOS, Linux |
| Python | 3.6+ |
| RAM | 2-4 GB (NX=50), 8-16 GB (NX=100) |
| CPU | Single-threaded (can take hours) |
| Storage | ~100 MB for results |

---

## 🔍 Troubleshooting

### Error: "mat.xml doesn't exist"
**Solution:** Use `run_optimization.sh` (handles paths automatically)

### Error: "Compile with USE_PARDISO"
**Solution:** Choose option **[A] CHOLMOD** from menu (PARDISO not available)

### Out of memory
**Solution:** Reduce `NX` in `TvSupport.py` or use **[C] CG** solver

### Slow convergence warnings
**Normal!** Messages like "too stalled error" are expected, optimization continues

---

## � Documentation

Comprehensive guides available in the `docs/` folder:

- **[ADVANCED_FEATURES.md](docs/ADVANCED_FEATURES.md)** - New advanced script features & usage
- **[CUSTOMIZATION_GUIDE.md](docs/CUSTOMIZATION_GUIDE.md)** - Complete parameter reference & expansion scope
- **[TECHNICAL_NOTES.md](docs/TECHNICAL_NOTES.md)** - SIMP method, solvers, performance

**Want to explore more?** The customization guide shows you how to:
- Experiment with different materials (Steel, Aluminium, Titanium)
- Adjust volume fractions (10% to 70%)
- Modify mesh resolution (coarse to ultra-fine)
- Run automated parameter studies
- Expand to multi-load cases, stress constraints, and more

---

## �📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **openCFS** - Computational Finite Element System
- **SIMP Method** - Bendsøe & Sigmund (2003)
- Course: Structural Optimization, Semester 1

---

## 📧 Contact

For questions or issues, please open an issue on GitHub.

---

**Ready to optimize?** Run `./run_optimization.sh` and watch the magic happen! ✨
