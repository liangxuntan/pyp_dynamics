#!/bin/bash
#make copies of pypmap*.pml 

STARTC=$1
ENDC=$2
NUMC=$((${2}-${1}+1))
echo "number of pml copies = ${NUMC} "

for (( c=${1}; c<=${2}; c++ ))
do
	echo "Making pypmap${c}.pml "
	sed "s/pypypy/${c}/" pypmap_copy.txt > pmlcopies/pypmap${c}.txt
	mv pmlcopies/pypmap${c}.txt pmlcopies/pypmap${c}.pml

done

