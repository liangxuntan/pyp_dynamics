#!/bin/bash

echo "clearing inputhkl"
rm ../inputhkl/*.hkl
echo "clearing outputmtz"
rm ../outputmtz/*.mtz
echo "clearing inputmaps"
rm ../inputmaps/*.mtz
echo "clearing outputmaps"
rm ../outputmaps/*.mtz

echo "clearing outputccp4"
rm ../outputccp4/*.ccp4
rm ../outputccp4/mapfiles/*.map

echo "clearing pmlcopies"
rm ../pymscripts/pmlcopies/*.pml

echo "clearing pngs"
rm ../pymscripts/pngfiles/*.png

echo "done"
