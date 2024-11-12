# General
This code is associated with the paper "Efficient coding in biophysically realistic excitatory-inhibitory spiking networks." published in eLife in 2024.

The author of the code is Veronika Koren.  
For any questions, please write to koren.veronika@gmail.com.

# How to open and run a script
Please do not add all the paths but follow one of the two points described below. 1) with a terminal

1) in a terminal, cd to the extracted folder "efficient_EI"  
open matlab desktop from the terminal by typing "matlab" in the same terminal; this opens a matlab desktop  
inside a matlab desktop, open a script by clicking the “open" icon on the top left (see image on the LEFT below) and selecting the desired script  
before running the script, Matlab may issue a window about the file not being on the current path and asking to either Change the current folder or Add it to Path - choose Add to Path

2) without a terminal

open Matlab  
by navigating with the button inside the red circle on the image on the LEFT, open the folder "efficient_EI" to have the current folder as displayed as on the RIGHT image below  
now use the "Open" button on the top left (red circle on the image on the LEFT) to open the desired script
before running the script, Matlab may issue a window about the file not being on the current path and asking to either Change the current folder or Add it to Path - choose Add to Path

# Run an example network simulation in a single trial

To run a simulation of the E-I network with optimal parameters, go to code/EI_net and run the script network_simulation.m. This will plot the activity of the network as on Fig. 1D.

# Dependencies

The folder "code" contains all the code for simulation, analysis and plotting of figures. Inside the folder "code", each subfolder contains simulations and analysis of a topic addressed in the paper. The exception is the folder "function" that contains functions run by scripts in all other subfolders. Each folder besides the folder "function" also contains a subfolder "plt" that gathers scripts that generate figures from saved results.

Due to space constraints, results of simulations are not saved in the present repository, but they can be recreated by running the scripts and saving the results.

The script fig_settings_default contains default figure settings that were used to produce the figures.
