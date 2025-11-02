# 3D TV Wall Mount - Topology Optimization

**Structural topology optimization for a 3D TV wall mount using SIMP method and openCFS**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Status](https://img.shields.io/badge/status-active-success.svg)

---

## 📋 Project Overview

This project demonstrates **structural topology optimization** for a TV wall mount bracket using the **SIMP (Solid Isotropic Material with Penalization)** method. The goal is to find an optimal material distribution that minimizes weight while maintaining structural integrity under load.

**Key Features:**
- 3D topology optimization using openCFS finite element solver
- Interactive solver selection menu
- Automated mesh generation and optimization workflow
- Professional visualization with ParaView

---

## 🎯 What Does This Do?

Takes a solid 10m × 8m × 6m design space and optimizes it to:
- ✅ Support TV weight (applied at 4 mounting points)
- ✅ Minimize material usage (~90% reduction to 10% volume)
- ✅ Maximize structural stiffness
- ✅ Generate organic, efficient load-bearing structure

**Input:** Solid rectangular block  
**Output:** Optimized organic structure (like bones or tree branches)

---

## 🚀 Quick Start

### Prerequisites

**Required:**
- Python 3.x with NumPy
- openCFS (included in `src/`)

**Optional:**
- [ParaView](https://www.paraview.org) for visualization

**No installation needed!** Everything is included.

### Run Optimization

```bash
./run_optimization.sh
```

**Interactive menu will appear:**
1. Choose solver (A, B, or C)
2. Wait ~37 minutes (for default mesh)
3. View results in ParaView

That's it! 🎉

---

## 📁 Project Structure

```
3d_topo_tv_mount/
│
├── run_optimization.sh       # Main script (interactive workflow)
├── TvSupport.py              # Mesh generation
├── TvSupport.xml             # openCFS configuration
├── mat.xml                   # Material properties
│
├── src/                      # openCFS installation
│   ├── bin/cfs               # openCFS executable
│   └── share/python/         # Python tools
│
├── results/                  # All outputs go here
│   ├── meshes/               # Generated mesh files
│   └── outputs/              # Optimization results
│       └── TvSupport.vtk     # ← Open this in ParaView!
│
└── docs/                     # Technical documentation
    └── TECHNICAL_NOTES.md    # Detailed specs
```

---

## 💻 Usage

### Option 1: Automated (Recommended)

```bash
./run_optimization.sh
```

Choose solver from menu:
- **[A] CHOLMOD** - Fast, recommended (37 min)
- **[B] DirectLDL** - Alternative (50 min)
- **[C] CG** - Memory efficient (75 min)

### Option 2: Manual

```bash
# 1. Generate mesh
export PYTHONPATH=src/share/python:$PYTHONPATH
python3 TvSupport.py

# 2. Run optimization
export PATH=src/bin:$PATH
cd results/outputs
cfs -m ../meshes/Tv_WallMount-*.mesh -p ../../TvSupport.xml TvSupport
cd ../..

# 3. Visualize
paraview results/outputs/TvSupport.vtk
```

### Adjust Mesh Resolution

Edit `TvSupport.py` line 32:

```python
NX = 50   # Quick test (60k elements, ~37 min)
NX = 80   # Medium quality (260k elements, ~3 hours)
NX = 100  # High quality (500k elements, ~8 hours)
```

Higher resolution = better detail but longer computation time.

---

## 📊 Expected Results

**Optimization Settings:**
- Method: SIMP with p=3 penalization
- Objective: Minimize compliance (maximize stiffness)
- Constraint: Volume ≤ 10% of original
- Iterations: 50 (or until convergence)

**Output:**
- ~90% material removed
- Organic, tree-like support structure
- Optimized for TV weight distribution
- VTK file ready for ParaView

---

## 🛠️ Configuration

### Boundary Conditions
- **Fixed:** Back wall surface (z=0)
- **Forces:** 4 points at TV mounting locations (-0.78 N each)
- **Design Region:** Space between wall and TV mount

### Material
- Material properties in `mat.xml` (99lines material)
- Young's modulus and Poisson's ratio from database

### Solver Options
Change solver in `TvSupport.xml` line 86:
```xml
<cholmod/>     <!-- Default (fast) -->
<directLDL/>   <!-- Alternative -->
<cg/>          <!-- Memory efficient -->
```

Or use interactive menu in `run_optimization.sh`

---

## 📈 Visualization

### ParaView
```bash
paraview results/outputs/TvSupport.vtk
```

**Recommended workflow:**
1. Apply **Threshold** filter (value > 0.3) to show solid material only
2. Color by density to see material distribution
3. Add **Clip** to see internal structure

### Python Tools
```bash
# Process density field
python3 src/share/python/process_density.py results/outputs/TvSupport.density.xml

# Plot convergence
python3 src/share/python/plotviz.py results/outputs/TvSupport.plot.dat
```

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

## 📝 License

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
