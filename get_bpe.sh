#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output"
output_path_ess="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/ess_new_testament_bpe"
output_path_eng="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/ess_eng_new_testament_bpe"

# Create a folder if necessary
for bpe_size in 500 1000 5000 15000 30000 60000; do
    if [[ ! -e ${output_path_ess}_bpe_${bpe_size} ]]; then
        mkdir ${output_path_ess}_bpe_${bpe_size}
    elif [[ ! -d ${output_path_ess}_bpe_${bpe_size} ]]; then
        echo "${output_path_ess}_bpe_${bpe_size} already exists but is not a directory" 1>&2
    fi
done

# Copy over the preprocessed data
for prefix in train dev test; do
    if [ -f "${output_path_ess}_bpe_${bpe_size}/${prefix}.txt" ]; then
    echo "${output_path_ess}_bpe_${bpe_size}/${prefix}.txt exists."
    else
    cp ${source_path}/bpe/${bpe_size}/${prefix}.bpe.ess ${output_path_ess}_bpe_${bpe_size}/${prefix}.txt
    fi
done


for bpe_size in 500 1000 5000 15000 30000 60000; do
    if [[ ! -e ${output_path_eng}_bpe_${bpe_size} ]]; then
        mkdir ${output_path_eng}_bpe_${bpe_size}
    elif [[ ! -d ${output_path_eng}_bpe_${bpe_size} ]]; then
        echo "${output_path_eng}_bpe_${bpe_size} already exists but is not a directory" 1>&2
    fi
done

# Copy over the preprocessed data
for prefix in train dev test; do
    if [ -f "${output_path_eng}_bpe_${bpe_size}/${prefix}.txt" ]; then
    echo "${output_path_eng}_bpe_${bpe_size}/${prefix}.txt exists."
    else
    cp ${source_path}/bpe/${bpe_size}/${prefix}.bpe.en ${output_path_eng}_bpe_${bpe_size}/${prefix}.txt
    fi
done