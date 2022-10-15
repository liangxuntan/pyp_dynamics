#!/bin/bash
#make NLSA scripts with defined parameters

#VAR1=$1 #bragg spots
#VAR2=$2 #num of snapshots
VAR3=$1 #nearest neighbours
#VAR4=$4 #num of tasks
#VAR5=$5 #concatenation parameter
#VAR6=$6 #sna parent folder
VAR7=$2 #pyp parent folder
VAR8=$3 # numss after cc1

M1="ref_run_ferguson.txt"
M2="ref_ferguson.txt"

echo "working on ${M1} script"

sed -e "s/pvarss2/${VAR8}/" \
-e "s/pvarnn/${VAR3}/" \
-e "s/pathtodataPYP/\~\/${VAR7}/" \
${M1} > run_ferguson.m

echo "working on ${M2} script"

cp ref_ferguson.txt ./ferguson.m

#end
