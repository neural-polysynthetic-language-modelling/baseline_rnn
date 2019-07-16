#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Inuit-Yupik/esk/bible_preprocess/output/NT"
output_path_esk="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/esk_NT"

# Create a folder if necessary
for bpe_size in 500 1000 5000 15000 30000 60000; do
    if [[ ! -e ${output_path_esk}_bpe_${bpe_size} ]]; then
        mkdir ${output_path_esk}_bpe_${bpe_size}
    elif [[ ! -d ${output_path_esk}_bpe_${bpe_size} ]]; then
        echo "${output_path_esk}_bpe_${bpe_size} already exists but is not a directory" 1>&2
    fi
done

# Copy over the preprocessed data
for bpe_size in 500 1000 5000 15000 30000 60000; do
    for prefix in train dev test; do
        if [ -f "${output_path_esk}_bpe_${bpe_size}/${prefix}.txt" ]; then
        echo "${output_path_esk}_bpe_${bpe_size}/${prefix}.txt exists."
        else
        cp ${source_path}/bpe/${bpe_size}/${prefix}.bpe.${bpe_size}.esk ${output_path_esk}_bpe_${bpe_size}/${prefix}.txt
        fi
    done
    mv ${output_path_esk}_bpe_${bpe_size}/dev.txt ${output_path_esk}_bpe_${bpe_size}/valid.txt
done