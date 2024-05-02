#!/bin/bash
#make pmlscript to loop run all pypmap .pml

STARTC=$1
ENDC=$2
OUTPUTpml="makepng_${1}_${2}.pml"
OUTPUTtxt="makepng_${1}_${2}.txt"

echo "Output=${OUTPUTpml} "
touch ${OUTPUTtxt}

for (( c=${1}; c<=${2}; c++ ))
do
	echo "@~/makemaps/pymscripts/pmlcopies/pypmap${c}.pml" >> ${OUTPUTtxt}
done

mv ${OUTPUTtxt} ${OUTPUTpml}

#@~/makemaps/pymscripts/pypmap201.pml