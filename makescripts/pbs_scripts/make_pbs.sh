#!/bin/bash
#make copies of pbs job script

VAR1=$1 #matlab script name
VAR2=$2 #logfile name
VAR3=$3 #pbsname append

PBSNAME="${3}_${1}"

echo "making job file for ${1}"

sed -e "s/mscriptname/${VAR1}/" \
-e "s/logname/${VAR2}/" \
ref_pbs.txt > ${PBSNAME}.pbs

#end
