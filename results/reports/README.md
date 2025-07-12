# TV Wall Mount Structural Optimization Framework

[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> An advanced computational framework for designing TV wall mounts using topology optimization, multi-load case analysis, and finite element methods.

## 📋 Table of Contents

- [What This Project Does](#what-this-project-does)
- [Project Evolution](#project-evolution)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Understanding the Code](#understanding-the-code)
- [Configuration Guide](#configuration-guide)
- [Running the Project](#running-the-project)
- [Understanding Results](#understanding-results)
- [Development Guide](#development-guide)
- [Troubleshooting](#troubleshooting)

## 🎯 What This Project Does

This project solves a real engineering problem: **designing an optimal TV wall mount structure** that:

1. **Minimizes material usage** (saves cost and weight)
2. **Maximizes structural strength** (ensures safety)
3. **Handles multiple loading scenarios** (static weight, vibrations, seismic forces)
4. **Provides visual feedback** (3D plots, analysis reports)

### The Engineering Challenge

Traditional TV wall mounts are designed with fixed geometry and often use more material than necessary. This project uses **topology optimization** - a mathematical method that automatically finds the best material distribution to create the strongest structure with the least material.

### What Makes This Special

- **Multi-Physics Analysis**: Tests your design against 5 different loading scenarios
- **Material Comparison**: Compares steel, aluminum, and carbon fiber options
- **Automated Optimization**: Uses SIMP (Solid Isotropic Material with Penalization) method
- **Professional Visualization**: Generates interactive plots and engineering reports
- **Safety Engineering**: Calculates safety factors for each load case

## 🔄 Project Evolution

This project evolved from a simple mesh generator to a comprehensive optimization framework:

**Original (TvSupport.py)**: 
- Simple 3D mesh generation
- Single static load case
- Basic geometry definition
- ~70 lines of code

**Enhanced Framework**:
- Advanced topology optimization
- 5 different load cases (static, dynamic, seismic, fatigue, earthquake)
- Material property optimization
- Interactive visualization
- Comprehensive testing
- ~2000+ lines of professional code

## 🚀 Getting Started

### Prerequisites

Before running this project, make sure you have:

```bash
# Check Python version (need 3.8+)
python --version

# Check if pip is installed
pip --version
```

### Quick Installation

```bash
# 1. Clone/download the project
cd path/to/your/project

# 2. Install dependencies
pip install -r config/requirements.txt

# 3. Test installation
python examples/demo.py
```

### What You'll See

When you run the demo, you'll see:
1. Optimization progress messages
2. Generated mesh files in `results/meshes/`
3. Visualization plots in `results/plots/`
4. Analysis reports in `results/reports/`

## 📁 Project Structure Explained

```
tv-wall-mount-optimizer/
├── 📄 README.md                 # This file - project documentation
├── 📄 LICENSE                   # MIT license terms
├── 📄 setup.py                  # Python package installation script
├── 📄 Makefile                  # Development commands (make help)
├── 📄 .gitignore               # Files to ignore in version control
│
├── 📂 src/                      # Main source code
│   ├── 📄 __init__.py          # Makes src a Python package
│   │
│   ├── 📂 core/                # Core optimization algorithms
│   │   ├── 📄 __init__.py
│   │   └── 📄 tv_mount_optimizer.py  # Main optimization engine
│   │
│   ├── 📂 utils/               # Utility functions
│   │   ├── 📄 __init__.py
│   │   ├── 📄 mesh_utilities.py     # Mesh generation and analysis
│   │   └── 📄 mesh_tool.py          # Compatibility layer
│   │
│   ├── 📂 visualization/       # Plotting and visualization
│   │   ├── 📄 __init__.py
│   │   └── 📄 visualization.py      # Creates plots and dashboards
│   │
│   └── 📂 analysis/            # Analysis modules (extensible)
│       └── 📄 __init__.py
│
├── 📂 config/                   # Configuration files
│   ├── 📄 config.yaml          # Main configuration (EDIT THIS!)
│   ├── 📄 requirements.txt     # Python dependencies
│   └── 📄 mat.xml              # Material properties for FEA
│
├── 📂 tests/                    # Test suite
│   └── 📄 test_suite.py        # Comprehensive tests
│
├── 📂 examples/                 # Example scripts
│   └── 📄 demo.py              # Interactive demonstration
│
├── 📂 legacy/                   # Original implementation
│   ├── 📄 TvSupport.py         # Original mesh generator
│   └── 📄 TvSupport.xml        # Original configuration
│
└── 📂 results/                  # Generated outputs
    ├── 📂 meshes/              # .mesh files (3D geometry)
    ├── 📂 plots/               # .png, .html visualization files
    ├── 📂 reports/             # .md analysis reports
    └── 📂 simulations/         # .xml simulation configurations
```

## 🔍 Understanding the Code

### Main Components

#### 1. TVMountOptimizer (`src/core/tv_mount_optimizer.py`)
**What it does**: The brain of the system
```python
# Creates an optimizer instance
optimizer = TVMountOptimizer()

# Runs the complete optimization
results = optimizer.run_optimization()
```

**Key classes**:
- `TVMountOptimizer`: Main optimization engine
- `LoadCase`: Defines different loading scenarios
- `MaterialType`: Steel, aluminum, carbon fiber options
- `GeometryConfig`: TV mount dimensions and parameters

#### 2. Mesh Utilities (`src/utils/mesh_utilities.py`)
**What it does**: Creates and analyzes 3D meshes
```python
# Generate a 3D mesh
mesh = create_3d_mesh(nx=80, ny=64, nz=48, width=10, height=8, depth=6)

# Analyze mesh quality
analyzer = MeshQualityAnalyzer()
stats = analyzer.analyze_mesh_quality(mesh)
```

#### 3. Visualization (`src/visualization/visualization.py`)
**What it does**: Creates plots and interactive dashboards
```python
# Create visualization
visualizer = ResultsVisualizer()
visualizer.create_stress_distribution_plot()
visualizer.create_optimization_convergence_plot()
```

### Load Cases Explained

The system tests your TV mount design against 5 scenarios:

1. **Static TV Weight** (`static_tv_weight`)
   - Normal TV hanging on the wall
   - Safety factor: 2.5x

2. **Dynamic Vibration** (`dynamic_vibration`)
   - TV vibration from sound, movement
   - Safety factor: 1.8x

3. **Seismic Horizontal** (`seismic_horizontal`)
   - Earthquake forces (horizontal shaking)
   - Safety factor: 3.0x

4. **Fatigue Cycling** (`fatigue_cycling`)
   - Repeated TV on/off cycles over years
   - Safety factor: 4.0x

5. **Design Basis Earthquake** (`design_basis_earthquake`)
   - Maximum expected earthquake
   - Safety factor: 4.0x

### Material Properties

The system compares three materials:

| Material | Density (kg/m³) | Yield Strength (MPa) | Cost Factor |
|----------|-----------------|---------------------|-------------|
| Steel | 7850 | 250 | Low |
| Aluminum | 2700 | 240 | Medium |
| Carbon Fiber | 1600 | 600 | High |

## ⚙️ Configuration Guide

### Main Configuration (`config/config.yaml`)

This is the most important file to understand! It controls everything:

```yaml
geometry:
  width: 10.0           # TV mount width (meters)
  height: 8.0           # TV mount height (meters)  
  depth: 6.0            # TV mount depth (meters)
  tv_weight: 50.0       # TV weight (kg)
  
mesh:
  base_resolution: 100  # Mesh density (higher = more detailed)
  
optimization:
  volume_fraction: 0.1  # Material usage (0.1 = use 10% of space)
  max_iterations: 100   # Optimization steps
  
materials:
  steel:
    density: 7850
    yield_strength: 250
```

### How to Customize

**For a heavier TV**:
```yaml
geometry:
  tv_weight: 75.0  # Change from 50.0 to 75.0 kg
```

**For higher quality results**:
```yaml
mesh:
  base_resolution: 200  # Change from 100 to 200
optimization:
  max_iterations: 200   # Change from 100 to 200
```

**For more material usage**:
```yaml
optimization:
  volume_fraction: 0.15  # Change from 0.1 to 0.15 (use 15% of space)
```

## 🏃‍♂️ Running the Project

### Option 1: Quick Demo
```bash
# Runs a complete demonstration
python examples/demo.py
```
**What happens**: Runs optimization with default settings, shows progress, generates all outputs.

### Option 2: Custom Optimization
```bash
# Run with specific material
python -m src.core.tv_mount_optimizer --material aluminum

# Run with custom resolution
python -m src.core.tv_mount_optimizer --resolution 150
```

### Option 3: Interactive Python
```python
# Start Python interpreter
python

# Import and run
from src.core.tv_mount_optimizer import TVMountOptimizer
optimizer = TVMountOptimizer()
results = optimizer.run_optimization()

# Check results
print(f"Optimization time: {results.optimization_time:.2f} seconds")
print(f"Max stress: {results.max_stress:.2f} MPa")
```

### Option 4: Using Make Commands
```bash
make help      # Show all available commands
make install   # Install dependencies
make demo      # Run demonstration
make test      # Run tests
make clean     # Clean up generated files
```

## 📊 Understanding Results

### Generated Files

After running optimization, you'll find:

#### 1. Mesh Files (`results/meshes/*.mesh`)
- 3D geometry of your optimized TV mount
- Can be opened in ParaView or similar software
- Filename format: `TvMount_Advanced_nx_[resolution]_[timestamp].mesh`

#### 2. Reports (`results/reports/*.md`)
Example report content:
```markdown
## Load Case Analysis Results

### static_tv_weight
- Max Stress: 11.76 MPa
- Max Displacement: 0.382 mm
- Safety Factor: 2.5
- Status: ✅ SAFE
```

#### 3. Visualizations (`results/plots/*.html`)
- Interactive 3D stress plots
- Material comparison charts
- Optimization convergence graphs

### Interpreting Results

**Safety Factor > 1.0**: ✅ Design is safe
**Safety Factor < 1.0**: ❌ Design may fail (increase material or change geometry)

**Low Max Stress**: Good (structure not overloaded)
**High Max Stress**: May need design changes

**Small Displacement**: Good (structure doesn't deform much)
**Large Displacement**: May affect TV positioning

## 🛠️ Development Guide

### Adding New Features

#### 1. Adding a New Load Case
Edit `src/core/tv_mount_optimizer.py`:
```python
# Add to LoadType enum
class LoadType(Enum):
    STATIC = "static"
    DYNAMIC = "dynamic"
    # Add your new load case
    THERMAL = "thermal"
```

#### 2. Adding New Material
Edit `config/config.yaml`:
```yaml
materials:
  titanium:
    density: 4500
    yield_strength: 880
    cost_per_kg: 30.0
```

#### 3. Custom Visualization
Edit `src/visualization/visualization.py`:
```python
def create_custom_plot(self):
    # Your plotting code here
    pass
```

### Running Tests
```bash
# Run all tests
python tests/test_suite.py

# Or use pytest for more details
python -m pytest tests/ -v
```

### Code Style
```bash
# Format code
python -m black src/ tests/ examples/

# Check code quality  
python -m flake8 src/
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Import Errors
```
ImportError: No module named 'numpy'
```
**Solution**: Install dependencies
```bash
pip install -r config/requirements.txt
```

#### 2. Mesh Generation Fails
```
Error: Cannot create mesh with resolution 500
```
**Solution**: Reduce resolution in `config/config.yaml`
```yaml
mesh:
  base_resolution: 100  # Reduce from 500 to 100
```

#### 3. Optimization Doesn't Converge
```
Warning: Optimization did not converge
```
**Solution**: Increase iterations
```yaml
optimization:
  max_iterations: 200  # Increase from 100
```

#### 4. Memory Issues
```
MemoryError: Unable to allocate array
```
**Solution**: Reduce mesh resolution or close other programs

#### 5. Visualization Doesn't Show
```
Warning: Plotly not available
```
**Solution**: Install visualization dependencies
```bash
pip install plotly matplotlib
```

### Getting Help

1. **Check the error message** - most errors have helpful descriptions
2. **Verify config file** - ensure `config/config.yaml` has valid values
3. **Run tests** - `python tests/test_suite.py` to check system health
4. **Check dependencies** - `pip list` to see installed packages
5. **Try smaller resolution** - reduce mesh size for testing

### Performance Tips

- **Start small**: Use `base_resolution: 50` for quick tests
- **Increase gradually**: 50 → 100 → 200 for final results  
- **Monitor memory**: Watch system memory usage during optimization
- **Use make commands**: `make clean` to free up disk space

## 📚 Further Learning

### Understanding Topology Optimization
- SIMP method (Solid Isotropic Material with Penalization)
- Density-based optimization
- Volume fraction constraints

### Finite Element Analysis
- Mesh generation and quality
- Boundary conditions
- Load case definitions

### Computational Engineering
- Multi-physics simulation
- Safety factor calculations
- Material property optimization

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **OpenCFS**: Open source finite element software
- **Python Scientific Stack**: NumPy, SciPy, Matplotlib
- **Plotly**: Interactive visualization
- **SIMP Method**: Foundational topology optimization approach

---

**Developed by Prashanth Gadwala** | **Advanced Structural Optimization** | **2025**

*This project demonstrates the application of computational engineering methods to solve real-world design optimization problems.*
