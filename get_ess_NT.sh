#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output"
output_path_ess="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/ess_new_testament"
output_path_eng="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/ess_eng_new_testament"

# Create a folder if necessary
if [[ ! -e ${output_path_ess} ]]; then
    mkdir ${output_path_ess}
elif [[ ! -d ${output_path_ess} ]]; then
    echo "${output_path_ess} already exists but is not a directory" 1>&2
fi

if [[ ! -e ${output_path_eng} ]]; then
    mkdir ${output_path_eng}
elif [[ ! -d ${output_path_eng} ]]; then
    echo "${output_path_eng} already exists but is not a directory" 1>&2
fi

# Copy over the preprocessed data
for prefix in train dev test; do
    if [ -f "${output_path_ess}/${prefix}.txt" ]; then
	echo "${output_path_ess}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.tc.ess ${output_path_ess}/${prefix}.txt
    fi
done


for prefix in train dev test; do
    if [ -f "${output_path_eng}/${prefix}.txt" ]; then
	echo "${output_path_eng}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.tc.en ${output_path_eng}/${prefix}.txt
    fi
done


