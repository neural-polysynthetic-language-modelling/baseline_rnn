#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Other/grn/grn-spa/preprocess/output/new_testament"
output_path_grn="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/grn_bible_new_testatment"
output_path_spa="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/grn_spa_bible_new_testatment"

# Create a folder if necessary
if [[ ! -e ${output_path_grn} ]]; then
    mkdir ${output_path_grn}
elif [[ ! -d ${output_path_grn} ]]; then
    echo "${output_path_grn} already exists but is not a directory" 1>&2
fi

if [[ ! -e ${output_path_spa} ]]; then
    mkdir ${output_path_spa}
elif [[ ! -d ${output_path_spa} ]]; then
    echo "${output_path_spa} already exists but is not a directory" 1>&2
fi

# Copy over the preprocessed data
for prefix in train valid test; do
    if [ -f "${output_path_grn}/${prefix}.txt" ]; then
	echo "${output_path_grn}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.tc.grn ${output_path_grn}/${prefix}.txt
    fi
done


for prefix in train valid test; do
    if [ -f "${output_path_spa}/${prefix}.txt" ]; then
	echo "${output_path_spa}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.tc.spa ${output_path_spa}/${prefix}.txt
    fi
done


