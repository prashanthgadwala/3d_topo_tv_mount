from mesh_tool import *  


# dimensions of box (m)
width = 10
height = 8
depth = 6

# inner box starting on positive z-direction so we don't need to turn in ParaView
wi = 6 # inner width
hi = 5
di = 3 

# resolution of based on x-resolution
nx = 80 # t needs to match c * width/nx with c = 1,2,3,.. 
ny = int((height/width) * nx)
nz = int((depth/width) * nx)
mesh = create_3d_mesh(nx, ny, nz, width, height, depth) 

# outer region: mech
# inner region: void
# interface region: solid with thickness t (in m)
t = 2*width/nx  # needs to match the discretization 
print('t',t,'dx',wi/nx)
# define regions
for e in mesh.elements:
  x, y, z = mesh.calc_barycenter(e)
  # 2d case: x, y = mesh.calc_barycenter(e)
  #print(x,y,z)
  
  # larger inner box of size filled with solid
  if x < (wi+t) and y < (hi+t) and z > (di-t): # have the box in the positive z-diretion
     e.region = 'solid'

  # inside inner overwritten as void
  if x < wi and y < hi and z > di:
    e.region = 'void'
  
  # default region is 'mech'
    
# define node set for "surface" load    
box_width = []    
box_height = []
box_depth = []
    
for i, n in enumerate(mesh.nodes):
  x, y, z = n
  if x == wi and y <= hi and z >= di: # only works if resolution hits the nodes - in case of issues round()
    box_width.append(i)
  if y == hi and x <= wi and z >= di:
    box_height.append(i)       
  if z == di and x <= wi and y <= hi:
    box_depth.append(i)  
    
mesh.bc.append(('box_width',box_width))
mesh.bc.append(('box_height',box_height))
mesh.bc.append(('box_depth',box_depth))    

print('size of box_width/box_height/box_depth',len(box_width),len(box_height),len(box_depth))    
    
f = 'box3d-t_' + str(t) + '-nx_' + str(nx) + '-ny_' + str(ny) + '-nz_' + str(nz) + '.mesh'   
       
write_ansys_mesh(mesh, f)
print('created ', f) 
# hint: cfs -m <mesh> <problem> -g will just write the mesh without simulation/optimization for check in ParaView
