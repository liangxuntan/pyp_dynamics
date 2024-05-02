#!/bin/bash

INPUT=$1
#echo "Input = ${INPUT}"
fbase=${INPUT##*/}
fname=${fbase%.*}
OUTPUT1="temp_ccp4/${fname}.map"
#echo "Output1 = ${OUTPUT1}"
OUTPUT2="temp_ccp4/${fname}_ex.ccp4"
#echo "Output2 = ${OUTPUT2}"

fft \
HKLIN "${INPUT}"  \
MAPOUT "${OUTPUT1}" > fftout.html  \
<< END-fft
RESO 14.9 1.56 
SCALE F1 1.0 0.0
GRID 160 160 140
BINMAPOUT
LABI F1=DF SIG1=SIGDF  PHI=PHIC_ALL
END-fft

mapmask mapin "${OUTPUT1}" mapout "${OUTPUT2}" xyzin pdb5hd3.pdb > mapmaskout.html << ee
extend xtal
border 0.5
ee

mv temp_ccp4/*.ccp4 ../outputccp4
mv temp_ccp4/*.map ../outputccp4/mapfiles

#echo "done"


