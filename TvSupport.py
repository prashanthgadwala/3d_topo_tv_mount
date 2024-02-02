from mesh_tool import *  

# dimensions of box (m)
width = 10 # X axis
height = 8 # Y axis
depth = 6 # Z axis

# resolution of based on x-resolution
nx = 500 # t needs to match c * width/nx with c = 1,2,3,.. 
ny = int((height/width) * nx)
nz = int((depth/width) * nx)
mesh = create_3d_mesh(nx, ny, nz, width, height, depth) 

# outer region: mech
# inner region: void
# interface region: solid with thickness t (in m)
t = 2*width/nx  # needs to match the discretization 
print('Thickness of Tv Support t: ',t)

# define regions
for e in mesh.elements:
  x, y, z = mesh.calc_barycenter(e)

  if 4 < x < 6 and 0 < y < 8 and 0 < z < 0.25:
    e.region = 'solid'
  if (0 < x < 4 or 6 < x < 10) and 0 < y < 8 and 0 < z < 0.25:
    e.region = 'void'

  if (((1 < x < 3 or 7 < x < 9) and 0 < y < 8) or ((3 < x < 7 and (0 < y < 3 or 5 < y < 8)))) and 5.75 < z < 6 or (3 < x < 7 and 3 < y < 5 and 5.75 < z < 6):
    e.region = 'solid'

  if ((3 < x < 7 and 0 < y < 3) or 
    (3 < x < 7 and 5 < y < 8) or 
    (0 < x < 1 and 0 < y < 8) or 
    (9 < x < 10 and 0 < y < 8)) and 5.75 < z < 6:
    e.region = 'void'
    
# default region is 'mech'
    
# define node set for "surface" load    
back_support = []
force_1 = []
force_2 = []
force_3 = []
force_4 = []

r = 0.2  # radius of the cylinder

centers = [(2, 2), (8, 2), (2, 6), (8, 6)]  # centers of the cylinders

force_sets = [force_1, force_2, force_3, force_4]  # list of force sets

for i, n in enumerate(mesh.nodes):
    x, y, z = n
    for j, (h, k) in enumerate(centers):
        if ((x - h)**2 + (y - k)**2 <= r**2) and 5.75 < z < 6:
            force_sets[j].append(i)

    if 4 < x < 6 and 0 < y < 8 and 0 < z < 0.25:
      back_support.append(i)

mesh.bc.append(('back_support', back_support))
mesh.bc.append(('force_1', force_1))
mesh.bc.append(('force_2', force_2))
mesh.bc.append(('force_3', force_3))
mesh.bc.append(('force_4', force_4))
            
print('size of back_support/force_1/force_2/force_3/force_4', len(back_support), len(force_1), len(force_2), len(force_3), len(force_4))
    
f = 'Tv_WallMount-' + str(t) + '-nx_' + str(nx) + '-ny_' + str(ny) + '-nz_' + str(nz) + '.mesh'   
       
write_ansys_mesh(mesh, f)
print('created ', f) 
# hint: cfs -m <mesh> <problem> -g will just write the mesh without simulation/optimization for check in ParaView
