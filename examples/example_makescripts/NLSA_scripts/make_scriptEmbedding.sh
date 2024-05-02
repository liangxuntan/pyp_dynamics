#!/bin/bash
#make NLSA scripts with defined parameters

#VAR1=$1 #bragg spots
#VAR2=$2 #num of snapshots
VAR3=$1 #nearest neighbours
#VAR4=$4 #num of tasks
#VAR5=$5 #concatenation parameter
#VAR6=$6 #sna parent folder
VAR7=$2 #pyp parent folder
VAR8=$3 #numss after cc1
VAR9=$4 #num of eigenfunctions to compute
VAR10=$5 #gaussian width, sig

M1="ref_scriptEmbedding.txt"

echo "working on ${M1} script"

sed -e "s/pvarss2/${VAR8}/" \
-e "s/pvarnn/${VAR3}/" \
-e "s/pvareigs/${VAR9}/" \
-e "s/pvarsig/${VAR10}/" \
-e "s/pathtodataPYP/\~\/${VAR7}/" \
${M1} > scriptEmbedding.m


#end
