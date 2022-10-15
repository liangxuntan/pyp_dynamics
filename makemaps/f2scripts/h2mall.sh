#!/bin/bash

hklFILES="../inputhkl/*.hkl"

for f in $hklFILES
do
  echo "Processing $f file..."
  ./create-mtz $f

done

mv ../inputhkl/*.mtz ../outputmtz
