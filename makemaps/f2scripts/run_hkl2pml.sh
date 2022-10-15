#!/bin/bash
#make .pml from hkl

firstcopy=$1
lastcopy=$2

cd ~/makemaps/f2scripts/

echo "running run_hkl2inputmaps.sh"
./run_hkl2inputmaps.sh > h2plog.txt

echo "running runallqw.py"
python runallqw.py ${firstcopy} ${lastcopy} >> h2plog.txt

echo "running m2ccp4all.sh"
./m2ccp4all.sh >> h2plog.txt



cd ../pymscripts

echo "running makepmlcopies.sh"
./makepmlcopies.sh ${firstcopy} ${lastcopy} >> ../f2scripts/h2plog.txt

echo "running makepml_runall.sh"
./makepml_runall.sh ${firstcopy} ${lastcopy} >> ../f2scripts/h2plog.txt

echo "Done. Next, run makepng.pml"
