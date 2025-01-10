# General
This code is associated with the paper "Efficient coding in biophysically realistic excitatory-inhibitory spiking networks." authored by Veronika Koren, Simone Blanco Malerba, Tilo Schwalger and Stefano Panzeri, published in eLife in 2025 (version of record).

The author of this computer code is Veronika Koren. For any questions, please write to koren.veronika@gmail.com.

This repository is licensed under : CC BY-NC-SA 4.0 (see LICENSE.txt)
The repository has a DOI: 10.5281/zenodo.14623182. Any reuse should cite the repository as specified at https://zenodo.org/records/14628492

# How to open and run a script
Please do not add all the paths but follow point 1) or 2)":

1) with a terminal

a) cd to the extracted folder "efficient_EI" and open matlab desktop from the terminal by typing "matlab" in the same terminal  
b) inside Home of the matlab desktop, open a script by clicking the “open" icon on the top left (between New and Save) and selecting the desired script  
c) before running the script, Matlab may issue a window about the file not being on the current path and asking to either Change the current folder or Add it to Path - choose Add to Path

2) without a terminal

a) open Matlab  
b) navigate to the path .../efficient_EI/ 
c) use the "Open" icon on the top left to open the desired script
d) before running the script, Matlab may issue a window about the file not being on the current path and asking to either Change the current folder or Add it to Path - choose Add to Path

# Run an example network simulation in a single trial

To run a simulation of the E-I network with optimal parameters, run the script network_simulation.m located in "...efficient_EI/code/EI_net/". This will run a network simulation in a single trial and plot the targets, estimates and neural activity as on Fig. 1D.

# Dependencies

The folder "code" contains all the code for simulation, analysis and plotting of figures. Inside the folder "code", each subfolder contains code relative to one figure of the paper, as noted in the name of the subfolder. The exception is the subfolder "function" that contains functions run by scripts in all other subfolders. Each subfolder (besides "function") contains a subsubfolder "plot" with scripts that generate figures from saved results. 

Results are saved in the folder "result", with subfolders following the partition of the result-generating code.

The script fig_settings_default contains default figure settings that were used to produce the figures.
