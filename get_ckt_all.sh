#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Other/ckt/audio/preprocess/output"
output_path_ckt="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/ckt_all"

# Create a folder if necessary
if [[ ! -e ${output_path_ckt} ]]; then
    mkdir ${output_path_ckt}
elif [[ ! -d ${output_path_ckt} ]]; then
    echo "${output_path_ckt} already exists but is not a directory" 1>&2
fi


# Copy over the preprocessed data
for prefix in train valid test; do
    if [ -f "${output_path_ckt}/${prefix}.txt" ]; then
	echo "${output_path_ckt}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.tok.ckt ${output_path_ckt}/${prefix}.txt
    fi
done


