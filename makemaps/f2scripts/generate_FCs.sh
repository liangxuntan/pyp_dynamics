#!/bin/bash

if [  "X$#" == "X2" ] ; then
	pdb=$1
	SYMM=$2
	mtz=`echo $pdb | sed -e 's/\.pdb$/_SFALL.mtz/'`
else
    echo
    echo "Usage: <pdbfile> <symmetry eg 19> (outfile) will then calculate structure factors using SFALL"
    echo
    exit 1
fi


if [ ! -f $pdb ]; then
    echo "$pdb not found!"
    exit 1
fi

echo "Running generate_FC.."
base=$(echo $pdb | sed -e 's/\.pdb$//')
mtz=$(echo $pdb | sed -e 's/\.pdb$/_SFALL.mtz/')

sfall XYZIN ${pdb} HKLOUT ${mtz} > ${base}_sfall_out.html << EOF
labout  FC=FC_ALL PHIC=PHIC_ALL
MODE SFCALC XYZIN
symmetry ${SYMM}
badd 0.0
vdwr 2.5
end
EOF
echo "Completed generate_FC.."
