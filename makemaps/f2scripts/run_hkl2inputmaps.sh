#!/bin/bash

./h2mall.sh

./m2fall.sh

./generate_FCs.sh pdb5hd3.pdb 173

echo "moving files to inputmaps folder"
mv ../outputfobs/*.mtz ../inputmaps
mv ./pdb5hd3_SFALL.mtz ../inputmaps
