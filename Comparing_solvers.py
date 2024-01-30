#!/usr/bin/env python
from cfs_utils import *

# outer loop is the mesh
for t in [2*width/nx for nx in range(40, 101, 20)]:

  # conditionally create the mesh file  
  mesh_file = 'TvSupport' + str(t) + '-nx_' + str(nx) + '-ny_' + str(ny) + '-nz_' + str(nz) + '.mesh'
  if not os.path.exists(mesh_file):  
    # You need to replace this with your own mesh creation code
    # execute("create_mesh.py --res "+ str(mesh) + " --type cantilever2d") # Linux/macOS
    # execute("python %CFS%\create_mesh.py --res "+ str(mesh) + " --type cantilever2d") # for Windows

  # make a real inner loop by adding other solvers in the bracket  
   for solver in ["pardiso", "cholmod", "directLDL", "cg", "lis"]: 
    problem = "Tvsupport3d-solver_" + solver + "-t_" + str(t)

    # the problem file 'mech3d_<solver>' is always the same, store the result files with the mesh size
    # -d gives more detailed output (e.g. solver information)
    # -t <NUM> would set to the number of parallel threads
    cmd = "cfs -d -m " + mesh_file + " -p mech3d_" + solver + ".xml " + problem
    #print(cmd)
    execute(cmd)