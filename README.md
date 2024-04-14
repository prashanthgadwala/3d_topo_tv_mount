Steps to run this file:
1. run python code TvSupport.py
2. It will generate mesh file with name starting with Tv_WallMount- .... ending with .mesh
3. You would need CFS opensource software to run the code and paraview to visualize.
4. Once the mesh file is created go to terminal in your IDE
5. Type cfs -m Tv_WallMount-(name_generated).mesh -p TvSupport.xml (file_name_of_choice)
6. This will generate .cfs file which can be used to visualize in paraview software and .info.xml with all the data
