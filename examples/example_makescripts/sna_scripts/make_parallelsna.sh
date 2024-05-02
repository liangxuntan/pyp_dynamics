#!/bin/bash
#make copies of parallel_SnA_with_masks_no_norm
#make copies of parallel_SnA_dp

VAR1=$1
M1="ref_parallel_SnA_with_masks_no_norm.txt"
M2="ref_parallel_SnA_dp.txt"

echo "making parallel_SnA_with_masks_no_norm.m"

sed -e "s/pathtosna/\~\/${VAR1}/" \
${M1} > parallel_SnA_with_masks_no_norm.m

echo "making parallel_SnA_dp.m"

sed -e "s/pathtosna/\~\/${VAR1}/" \
${M2} > parallel_SnA_dp.m

#end
