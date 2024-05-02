#!/bin/bash
#make NLSA scripts with defined parameters

VAR1=$1 #bragg spots
VAR2=$2 #num of snapshots
VAR3=$3 #nearest neighbours
VAR4=$4 #num of tasks
VAR5=$5 #concatenation parameter
VAR6=$6 #sna parent folder
VAR7=$7 #pyp parent folder

M1="ref_run_PYP_femtosec_concat_x_no_normalize.txt"

echo "working on ${M1} script"

sed -e "s/pvarbrg/${VAR1}/" \
-e "s/pvarss/${VAR2}/" \
-e "s/pvarnn/${VAR3}/" \
-e "s/pvartasks/${VAR4}/" \
-e "s/pvarcc/${VAR5}/" \
-e "s/pathtosna/\~\/${VAR6}/" \
-e "s/pathtodataPYP/\~\/${VAR7}/" \
${M1} > run_PYP_femtosec_concat_x_no_normalize.m


#end
