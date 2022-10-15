#!/bin/bash

for f in ../outputmtz/*.mtz
do
	f=${f##*/}
	f=${f%.*}
	echo "Processing ${f}.mtz file..."
	inpath="../outputmtz/${f}.mtz"
	outpath="../outputfobs/${f}_fobs.mtz"
	#echo "$inpath $outpath"
	
	phenix.reflection_file_converter "$inpath" --mtz="$outpath" --non_anomalous --write_mtz_amplitudes --mtz_root_label=F > make_amplitudes_phenix_no_massage.log

	echo "done"

done
