# TV Wall Mount Structural Topology Optimization

## Project Concept
This project demonstrates **structural topology optimization** for designing a TV wall mount. The goal is to find the optimal material distribution that minimizes weight while maintaining structural integrity under various loading conditions.

**What we're doing:**
- Creating a 3D TV wall mount design
- Applying different load cases (static weight, vibrations, seismic forces)
- Using topology optimization to remove unnecessary material
- Achieving 80-90% weight reduction while maintaining safety

## Project Structure
```
src/
├── core/tv_mount_optimizer.py    # Main optimization logic & mesh generation
├── utils/mesh_utilities.py       # Mesh creation and validation
└── visualization/visualization.py # Results plotting and analysis

results/
├── meshes/          # Generated .mesh files for openCFS
├── simulations/     # Generated .xml configuration files
├── plots/           # Visualization outputs
└── reports/         # Analysis reports

examples/demo.py     # Interactive demonstration
basic_usage.py       # Simple usage example
```

## How It Works
1. **Generate mesh and configurations** - Creates the 3D structure and loading conditions
2. **Run topology optimization** - Uses openCFS to find optimal material distribution
3. **Visualize results** - Shows the optimized design and analysis

## Usage

### Step 1: Generate Files
```bash
python basic_usage.py
```
This creates:
- 3D mesh files (`.mesh`) with millions of elements
- openCFS configuration files (`.xml`) with load cases and optimization settings

### Step 2: Run Topology Optimization with openCFS

**Install openCFS first:**
- Download from: https://opencfs.gitlab.io/cfs/
- Or use university cluster if available

**Run optimization:**
```bash
# Basic command format (from course notes):
cfs -m <mesh_file> -p <config_file> <output_name>

# Example with generated files:
cfs -m TvMount_mesh.mesh -p TvSupport_static_tv_weight.xml tv_optimized
```

### Step 3: View Results
```bash
# View optimized topology
paraview tv_optimized.vtk

# Show material density distribution
show_density tv_optimized.density.xml

# Plot convergence
plotviz.py tv_optimized.plot.dat -x mesh -y energy
```

## openCFS Commands Reference
*Based on course materials - these are standard openCFS commands:*

```bash
# Get help
cfs --help

# Run optimization
cfs -m <mesh> -p <problem.xml> <output_name>

# Visualize mesh only (no simulation)
cfs -g -m <mesh> <output_name>

# View results
show_density <output>.density.xml
plotviz.py <output>.plot.dat
```

## Expected Results
- **Material reduction:** 80-90% weight savings
- **Stress analysis:** Real FEA results showing load paths  
- **Safety verification:** All load cases within design limits
- **Manufacturing-ready:** Optimized geometry for production

## Requirements
- Python 3.8+
- openCFS (structural optimization solver)
- ParaView (visualization)

This is a complete structural optimization workflow from concept to optimized design.
