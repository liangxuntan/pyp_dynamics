#!/bin/bash
#make NLSA scripts with defined parameters

VAR1=$1 #bragg spots
VAR2=$2 #num of snapshots
VAR3=$3 #nearest neighbours
VAR4=$4 #concatenation parameter
VAR5=$5 #pyp parent folder
VAR6=$6 #lightdata name append
VAR7=$7 #darkdata name append

M1="ref_mergess_outputhkl.txt"

echo "working on ${M1} script"

sed -e "s/pvarbrg/${VAR1}/" \
-e "s/pvarss/${VAR2}/" \
-e "s/pvarnn/${VAR3}/" \
-e "s/pvarcc/${VAR4}/" \
-e "s/pathtodataPYP/\~\/${VAR5}/" \
-e "s/pvarlm/${VAR6}/" \
-e "s/pvardm/${VAR7}/" \
${M1} > mergess_outputhkl.m


#end
