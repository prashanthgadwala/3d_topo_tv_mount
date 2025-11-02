# Technical Notes

## Optimization Method

**SIMP** (Solid Isotropic Material with Penalization)
- Penalization: p = 3
- Objective: Minimize compliance (maximize stiffness)
- Constraint: Volume ≤ 10%
- Filter: Density filter, radius = 1.7 × max edge
- Iterations: Max 50, stops at design change < 0.001

## Mesh

| Parameter | Value |
|-----------|-------|
| Domain | 10m × 8m × 6m |
| Default | 50 × 40 × 30 = 60k elements |
| Type | Hexahedral structured grid |
| Wall thickness | 0.40m |

**Change resolution:** Edit `TvSupport.py` line 32 (`NX = 50`)

## Boundary Conditions

**Fixed:** back_support (z=0, all DOF)  
**Forces:** 4 regions (r=0.2m), -0.78 N each, -Z direction  
**Design:** mech (optimizable) + solid (fixed wall/TV mount)

## Solvers

| Solver | Type | Speed | Memory | Status |
|--------|------|-------|--------|--------|
| **CHOLMOD** | Direct | Fast | 1.5 GB | ✅ Available |
| DirectLDL | Direct | Medium | 1 GB | ⚠️ May work |
| CG | Iterative | Slow | 300 MB | ⚠️ May work |
| PARDISO | Direct | Fastest | 2 GB | ❌ Not compiled |
| LIS | Iterative | Slowest | 250 MB | ❌ Not compiled |

**Note:** All solvers give same result (< 0.1% difference)

**Change solver:** Edit `TvSupport.xml` line 86 or use interactive menu

## Performance

| NX | Elements | Time |
|----|----------|------|
| 50 | 60k | ~37 min |
| 80 | 260k | ~3 hours |
| 100 | 500k | ~8 hours |
| 200 | 3.2M | ~2 days |

## Configuration

**TvSupport.xml:**
```xml
<optimization>
  <costFunction type="compliance" task="minimize"/>
  <constraint type="volume" value=".1" bound="upperBound"/>
  <optimizer type="optimalityCondition" maxIterations="50"/>
</optimization>

<linearSystems>
  <system>
    <solverList>
      <cholmod/>  <!-- Change here: cholmod, directLDL, or cg -->
    </solverList>
  </system>
</linearSystems>
```

## Output Files

```
results/outputs/
├── TvSupport.vtk          # ParaView visualization
├── TvSupport.cfs          # Complete results
├── TvSupport.density.xml  # Material distribution
├── TvSupport.info.xml     # Metadata
└── TvSupport.plot.dat     # Convergence history
```

## Visualization

**ParaView:**
```bash
paraview results/outputs/TvSupport.vtk
```
- Apply Threshold filter (value > 0.3)
- Color by density
- Clip to see internal structure

**Python:**
```bash
python3 src/share/python/process_density.py results/outputs/TvSupport.density.xml
python3 src/share/python/plotviz.py results/outputs/TvSupport.plot.dat
```

## Common Issues

**"mat.xml doesn't exist"**  
→ Use `run_optimization.sh` (handles paths automatically)

**"Compile with USE_PARDISO"**  
→ Choose CHOLMOD (option A) - PARDISO not available in your build

**Out of memory**  
→ Reduce NX in TvSupport.py or use CG solver (low memory)

**"too stalled error" warnings**  
→ Normal behavior, optimization continues and converges

## Material

`mat.xml` - 99lines material database  
Defines Young's modulus, Poisson's ratio, density

## References

- openCFS: `src/` installation
- SIMP: Bendsøe & Sigmund (2003)
- Mesh generation: `src/share/python/mesh_tool.py`
