# Results Directory

This directory contains all generated outputs from the TV wall mount topology optimization.

## Structure

### `meshes/`
Generated mesh files from `TvSupport.py`:
- `Tv_WallMount-<thickness>-nx_<nx>-ny_<ny>-nz_<nz>.mesh`

These are Ansys-format meshes compatible with openCFS.

### `outputs/`
openCFS optimization results:
- `TvSupport.cfs` - Complete result file
- `TvSupport.vtk` - ParaView visualization file
- `TvSupport.density.xml` - Optimized material density distribution
- `TvSupport.info.xml` - Simulation information and settings
- `TvSupport.plot.dat` - Convergence data for plotting

### `simulations/`
(Reserved for future use - multiple simulation configurations)

## Viewing Results

```bash
# View optimized topology
paraview results/outputs/TvSupport.vtk

# Process density distribution
python3 src/share/python/process_density.py results/outputs/TvSupport.density.xml

# Plot convergence
python3 src/share/python/plotviz.py results/outputs/TvSupport.plot.dat
```

## Note
All files in this directory are generated and can be recreated by running:
```bash
./run_optimization.sh
```
