#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Other/grn/bible"
output_path_grn="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/grn_all_FST"

# Create a folder if necessary
if [[ ! -e ${output_path_grn} ]]; then
    mkdir ${output_path_grn}
elif [[ ! -d ${output_path_grn} ]]; then
    echo "${output_path_grn} already exists but is not a directory" 1>&2
fi

# Copy over the preprocessed data
for prefix in train dev test; do
    if [ -f "${output_path_grn}/${prefix}.txt" ]; then
	echo "${output_path_grn}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.txt ${output_path_grn}/${prefix}.txt
    fi
done

mv ${output_path_grn}/dev.txt ${output_path_grn}/valid.txt

