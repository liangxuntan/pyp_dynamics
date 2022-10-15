README file for running NLSA codes on Imperial's HPC server
Matlab version - R2021a
Edited Oct 2022
##################################################
changes
1)scripts parallel workers directory now uses HPC ephemeral space (unlimited) to prevent scripts from
crashing when user's space (1TB) is used up (note-output files final destination is user's NLSA dir)

2)use makescripts to generate all .pbs job files and .m matlab scripts
//scripts default directory : ~/pyp_run10

3)run mergess_outputhkl after scriptReconstruction
input: reconstructed modes .mat 
output: .hkl

4)use makemaps to create DED videos from .hkl

Edited Jul 2022
##################################################

1)move pyphpcmain folder into User's home directory (~/pyphpcmain)
/// 2 pyphpcmain folders found in pyphpcmain_dark/ and pyphpcmain_light/

2)change directory into ~/pyphpcmain/NLSA

3).pbs files are job scripts with parameters to define #cores,ram,runtime with associated matlab 							script to run

Default script parameters specified as 20core, 256gb ram, 72h runtime
/// #core >= #workers(in parallel scripts)

4)submit jobscript using qsub 
Example --- qsub run3_concat_x_no_norm.pbs

To check status of script : qstat

To check logfiles : cat <scriptname>.pbs.o<jobid>

5)Order of jobscripts to submit on HPC
a. run_concat_x_no_norm.pbs 
/// parameters for light data: c=32768 nN=15000  /// dark data: c=32768 nN=1000
/// numTasks=6 /// to satisfy n>nN
/// In (~/pyphpcmain/sna/release/2.0/variations/parallel_SnA_with_masks_no_norm.m)
/// specify #worker>=numTasks (example--parpool(jm, 6);)

b. run_ferguson.pbs 
/// obtain sigma value from logfile (example from lightdata --"sigma_opt = 142.7")

c. run_sembedding.pbs
/// parameters for lightdata: sigma=1420 /// darkdata: sigma=3380
/// set nEigs=4 
///copy "dataPsi_nS*_nN*_nA0_sigma*_nEigs*.mat" from HPC to local machine, then run plot_DM locally

d. run_dp_no_norm.pbs
/// In (~/pyphpcmain/sna/release/2.0/variations/parallel_SnA_dp.m)
/// specify #worker>=numTasks (example--parpool(jm, 6);)

e. run_concat_x_USV.pbs 
///copy "SVD_results_sigma*.mat" to local machine, then run plot_USV locally

f. run_parallel_reconstruct.pbs

g. run_scriptrecon.pbs
/// specify modes for reconstruction
/// for mode2-mode3, (example--kOfInterest_new=2,3;)

###########################################################################
Changes 
###########################################################################

---(~/pyphpcmain/NLSA)---
run_PYP_femtosec_concat_x_no_normalize.m
run_ferguson.m
scriptEmbedding.m
run_PYP_femtosec_concat_x_dp_no_normalize.m
run_PYP_femtosec_concat_x_USV.m
parallel_reconstruct.m
scriptReconstruction.m
plot_DM.m 
plot_USV.m 
---(~/pyphpcmain/sna/release/2.0/variations)----
parallel_SnA_dp.m
parallel_SnA_with_masks_no_norm.m
---(~/pyphpcmain/sna/release/2.0/core)---
check_job_ticket_progress.m

###########################################################################
README file for running the NLSA codes
Ourmazd Lab, 2022
###########################################################################

(1) run "run_PYP_femtosec_concat_x_no_normalize.m"
    Input:  
         - data file including snapshots matrix and the correspoinding mask 
    Output: 
         - a set of *.dat files in "test_results" directory
         - symmetrized distance matrix as "./dataY/dataY_nS*_nN*_sym.mat"

(2) run "ferguson.m"
    Input: 
         - symmetrized distances matrix
    Output:
         - Ferguson plot
         - Gaussian Kernel width (sigma value)

(3) run "scriptEmbedding.m"
    Input: 
         - symmetrized distance matrix (within "./dataY")
         - sigma value from step (2)
         - other embedding parameters (do NOT change nA, nNA, and alpha)
    Output:
         - eigenfuncs of diffusion map as "dataPsi_nS*_nN*_nA0_sigma*_nEigs*.mat"
    *** notice: optimum sigma parameter in "scriptEmbedding.m" is usually 
        larger than that from "run_Ferguson.m", e.g., 10 times larger. In 
        general, we take a sigma that the embedding process converges to 
        meaningful eigenfunctions.       

(4) run "plot_DM.m" 
    Input:
         - eigenfunctions and eigenvalues (psi & lambda) in dataPsi*.mat
    Output:
         - plot of eigenfunctions and a plot of eigenvalues 

(5) run "run_PYP_femtosec_concat_x_dp_no_normalize.mat"
    Input:
         - data file including snapshots matrix 
    Output:
         - matrix of squared distances as "X^T X" 
           *** stored as chunks in a folder named as "dp_N*_n*_c*"

(6) run "run_PYP_femtosec_concat_x_USV.m"
    Input: 
         - data file including snapshots matrix
         - "dataPsi_nS*_nN*_nA0_sigma*_nEigs*.mat" from step (3)
         - output of step (5)
         - some other NLSA parameters (see the code)
    Output:
         - singular value decomposition (SVD) components:
           * S: singular values
           * U: topograms
           * V: chronograms (projected back onto data space)

(7) run "plot_USV.m"
    Input:
         - S, U, V from step (6)
         - some other embedding and NLSA parameters (see the code)
    Output:
         - plots of singular values, topos, and chronos

(8) run "parallel_reconstruct.m"
    Input:
         - SVD results from step (6)
         - some other embedding and NLSA parameters (see the code)
    Output:
         - reconstructed diffraction volumes from every mode as split files
           (saved as "reconstructedData*_of_*.mat" on the cluster)

(9) run "scriptReconstruction.m"
    Input:
         - reconstruced data from step (8)
    Output:
         - full reconstructed diffraction volumes as a single matrix (each
           column corresponds to a full volume at a single time point)

******************************* Notice ************************************
If you would like to use very large nN values, right after step (1) run 
"make_large_dSq.m" and "do_dataY_symmetrization_with_large_dSq.m" and then 
go to step (2).

"make_large_dSq.m":
    Input:
         - the set of *.dat files in "test_results" directory from step (1)
    Output:
         - a set of new *.dat files in "test_results_n*" directory

"do_dataY_symmetrization_with_large_dSq.m":
    Input: 
         - the set of new *.dat files in "test_results_n*" directory
    Output:
         - symmetrized distances saved as dataY*sym.* in dataY folder

