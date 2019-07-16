#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all"
output_path_ess="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/ess_all_test"
output_path_eng="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/ess_eng_all_test"

# Create a folder if necessary
for bpe_size in 500 1000 5000 15000 30000 60000; do
    if [[ ! -e ${output_path_ess}_bpe_${bpe_size} ]]; then
        mkdir ${output_path_ess}_bpe_${bpe_size}
    elif [[ ! -d ${output_path_ess}_bpe_${bpe_size} ]]; then
        echo "${output_path_ess}_bpe_${bpe_size} already exists but is not a directory" 1>&2
    fi
done

# Copy over the preprocessed data
for bpe_size in 500 1000 5000 15000 30000 60000; do
    for prefix in train dev test; do
        if [ -f "${output_path_ess}_bpe_${bpe_size}/${prefix}.txt" ]; then
        echo "${output_path_ess}_bpe_${bpe_size}/${prefix}.txt exists."
        else
        cp ${source_path}/bpe/${prefix}.bpe.${bpe_size}.ess ${output_path_ess}_bpe_${bpe_size}/${prefix}.txt
        fi
    done
    mv ${output_path_ess}_bpe_${bpe_size}/dev.txt ${output_path_ess}_bpe_${bpe_size}/valid.txt
done



for bpe_size in 500 1000 5000 15000 30000 60000; do
    if [[ ! -e ${output_path_eng}_bpe_${bpe_size} ]]; then
        mkdir ${output_path_eng}_bpe_${bpe_size}
    elif [[ ! -d ${output_path_eng}_bpe_${bpe_size} ]]; then
        echo "${output_path_eng}_bpe_${bpe_size} already exists but is not a directory" 1>&2
    fi
done

# Copy over the preprocessed data
for bpe_size in 500 1000 5000 15000 30000 60000; do
    for prefix in train dev test; do
        if [ -f "${output_path_eng}_bpe_${bpe_size}/${prefix}.txt" ]; then
        echo "${output_path_eng}_bpe_${bpe_size}/${prefix}.txt exists."
        else
        cp ${source_path}/bpe/${prefix}.bpe.${bpe_size}.en ${output_path_eng}_bpe_${bpe_size}/${prefix}.txt
        fi
    done
    mv ${output_path_eng}_bpe_${bpe_size}/dev.txt ${output_path_eng}_bpe_${bpe_size}/valid.txt    
done
