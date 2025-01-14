# TV Support Mesh Generation

## Steps to Run the Code

1. Run the Python script `TvSupport.py`:
    ```sh
    python TvSupport.py
    ```
2. The script will generate a mesh file with a name starting with `Tv_WallMount-` and ending with `.mesh`.
3. You will need the CFS open-source software to run the code and ParaView to visualize the results.
4. Once the mesh file is created, open a terminal in your IDE.
5. Type the following command to process the mesh file:
    ```sh
    cfs -m Tv_WallMount-(mesh_dimensions).mesh -p TvSupport.xml (file_name_of_choice)
    ```
6. This will generate a `.cfs` file, which can be used to visualize in ParaView, and a `.info.xml` file with all the data.

## Installing openCFS

openCFS runs on Linux, macOS, and Windows. Below are the instructions for installing openCFS on Linux.

### Linux

We provide openCFS including all dependencies in a single archive. The software should run on any recent Linux system.

1. Download the most recent archive, e.g., the latest release package Linux binary (tar.gz):
    ```sh
    wget https://gitlab.com/openCFS/cfs/-/releases/permalink/latest/downloads/CFS-Linux.tar.gz
    ```
2. Extract the archive to the desired location:
    ```sh
    tar -xzvf CFS-Linux.tar.gz
    ```
    This will extract to `CFS-<release>-Linux` where `<release>` denotes the version.

3. Add the `bin` directory of the installation to your `PATH`:
    ```sh
    export PATH=<absolute-cfs-installation-path>/bin:$PATH
    ```
    To make this change persistent, add it to the configuration file of your shell, e.g., `~/.bashrc` for bash:
    ```sh
    echo 'export PATH=<absolute-cfs-installation-path>/bin:$PATH' >> ~/.bashrc
    ```

4. You can now run `cfs` by typing:
    ```sh
    cfs -h
    ```

## Installing ParaView and Activating the CFSReader Plugin

In order to read openCFS native HDF5 data format (*.cfs or *.h5ref files) with ParaView, you need the CFSReader plugin. The plugin has been included in ParaView (from version 5.12) and needs to be activated before it can be used.

### Install ParaView

You can build ParaView from source or install an official ParaView release for your operating system.

Note: The plugin is included in ParaView from version 5.12, see the release notes.

### Activate CFSReader Plugin

To read openCFS result files (*.cfs files) with ParaView, follow these steps:

1. Open ParaView and in the menu bar click `Tools > Manage Plugins`.
2. Select `CFSReader` and click the `Load Selected` button (you can also activate the `Auto Load` check box to load the plugin on every subsequent program start).
3. Now `.cfs` files can be opened and visualized using ParaView.

## Simulation with CFS

Use an XML-editor (e.g., oXygen or Eclipse) to define the simulation input for CFS.

The input file `simulation-input.xml` is the simulation input. In the file [mat.xml](http://_vscodecontentref_/1), the material properties are defined. Both files are complete and can be used for the example problem.

To start the computation, run the following command in the terminal:
```sh
cfs -p simulation-input.xml <name_desired>
```

where <name_desired> can be any name you choose for the simulation.

CFS will write some output on the terminal and produce two files:
- `<name_desired>.info.xml`, which contains some details about the run.
- `<name_desired>.cfs` in the `results_hdf5` directory, which you can view with ParaView.

## Postprocessing with ParaView

Open ParaView (by typing `paraview` in a terminal) and load the result file using `File > Open...`, then click `Apply`.
