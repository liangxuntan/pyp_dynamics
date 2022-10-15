#!/bin/bash
#make copies of NLSA PBS sna

#NLSA scripts

cd ./NLSA_scripts

./make_run_PYP_femtosec_concat_x_no_normalize.sh 15498 147799 15000 6 32768 pyp_run10 pyp_run10
./make_ferguson.sh 15000 pyp_run10 115031
./make_scriptEmbedding.sh 15000 pyp_run10 115031 4 1420
./make_run_PYP_femtosec_concat_x_dp_no_normalize.sh 15498 147799 15000 6 32768 pyp_run10 pyp_run10
./make_run_PYP_femtosec_concat_x_USV.sh 15498 147799 15000 6 32768 pyp_run10 pyp_run10 115031 4 1420 19172 1000
./make_parallel_reconstruct.sh 15498 147799 15000 6 32768 pyp_run10 pyp_run10 115031 4 1420 19172 1000
./make_scriptReconstruction.sh 15498 147799 15000 6 32768 0 pyp_run10 0 0 0 0 0 2
./make_plot_USV.sh 15498 147799 15000 6 32768 pyp_run10 pyp_run10 115031 4 1420 19172 1000
./make_plot_DM.sh 15498 147799 15000 6 32768 pyp_run10 pyp_run10 115031 4 1420 19172 1000
./make_mergess_outputhkl.sh 15498 147799 15000 32768 pyp_run10 2 1

mv *.m ../outputscripts

#PBS scripts

cd ../pbs_scripts

./make_pbs.sh run_PYP_femtosec_concat_x_no_normalize 1a 1a
./make_pbs.sh run_ferguson 1b 1b
./make_pbs.sh scriptEmbedding 1c 1c
./make_pbs.sh run_PYP_femtosec_concat_x_dp_no_normalize 1d 1d
./make_pbs.sh run_PYP_femtosec_concat_x_USV 1e 1e
./make_pbs.sh parallel_reconstruct 1f 1f
./make_pbs.sh scriptReconstruction 1g 1g
./make_pbs.sh mergess_outputhkl 1h 1h

mv *.pbs ../outputscripts

#sna scripts

cd ../sna_scripts

./make_parallelsna.sh pyp_run10
mv *.m ../outputscripts

cd ../

#end
