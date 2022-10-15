#!/bin/bash
#make NLSA scripts with defined parameters

VAR1=$1 #bragg spots
VAR2=$2 #num of snapshots
VAR3=$3 #nearest neighbours
VAR4=$4 #num of tasks
VAR5=$5 #concatenation parameter
VAR6=$6 #sna parent folder
VAR7=$7 #pyp parent folder
VAR8=$8 #numss after cc1
VAR9=$9 #num of eigenfunctions to compute
VAR10=${10} #gaussian width, sig
VAR11=${11} #dpN param
VAR12=${12} #num copy(topos) for projecting 

M1="ref_plot_DM.txt"

echo "working on ${M1} script"

sed -e "s/pvarbrg/${VAR1}/" \
-e "s/pvarss/${VAR2}/" \
-e "s/pvarnn/${VAR3}/" \
-e "s/pvartasks/${VAR4}/" \
-e "s/pvarcc/${VAR5}/" \
-e "s/pathtosna/\~\/${VAR6}/" \
-e "s/pathtodataPYP/\~\/${VAR7}/" \
-e "s/pvarscc/${VAR8}/" \
-e "s/pvareigs/${VAR9}/" \
-e "s/pvarsig/${VAR10}/" \
-e "s/pvardpN/${VAR11}/" \
-e "s/pvarcopyt/${VAR12}/" \
${M1} > plot_DM.m


#end
