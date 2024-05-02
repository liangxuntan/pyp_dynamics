#!/bin/bash

dwMTZS="../outputmaps/*.mtz"

for f in ${dwMTZS}
do
	echo "Processing ${f} file..."
	./makeccp4.sh ${f}
done
