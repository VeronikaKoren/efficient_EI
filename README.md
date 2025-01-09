# General
This code is associated with the paper "Efficient coding in biophysically realistic excitatory-inhibitory spiking networks." authored by Veronika Koren, Simone Blanco Malerba, Tilo Schwalger and Stefano Panzeri, published in eLife in 2024.

The author of the code is Veronika Koren.  
For any questions, please write to koren.veronika@gmail.com.

# How to open and run a script
Please do not add all the paths but follow point 1) and 2)":

1) in a terminal, cd to the extracted folder "efficient_EI"  
a) open matlab desktop from the terminal by typing "matlab" in the same terminal; this opens a matlab desktop  
b) inside Home of the matlab desktop, open a script by clicking the “open" icon on the top left (between New and Save) and selecting the desired script  
c) before running the script, Matlab may issue a window about the file not being on the current path and asking to either Change the current folder or Add it to Path - choose Add to Path

2) without a terminal
a) open Matlab  
b) navigate to the path .../efficient_EI/code/ 
c) now use the "Open" button on the top left to open the desired script
d) before running the script, Matlab may issue a window about the file not being on the current path and asking to either Change the current folder or Add it to Path - choose Add to Path

# Run an example network simulation in a single trial

To run a simulation of the E-I network with optimal parameters, run the script network_simulation.m located in ...efficient_EI/code/EI_net/. This will plot the activity of the network as on Fig. 1D.

# Dependencies

The folder "code" contains all the code for simulation, analysis and plotting of figures. Inside the folder "code", each subfolder contains code relative to one figure of the paper, as noted in the name of the subfolder. The exception is the subfolder "function" that contains functions run by scripts in all other subfolders. Each subfolder (besides "function") contains a subsubfolder "plot" with scripts that generate figures from saved results. Results are saved in the folder "result", with subfolders following the partition of the result-generating code.

The script fig_settings_default contains default figure settings that were used to produce the figures.
