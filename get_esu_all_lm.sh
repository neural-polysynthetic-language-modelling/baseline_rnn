#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/lm"
output_path_esu="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/esu_bible_all_lm"
output_path_eng="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/esu_eng_bible_all_lm"

# Create a folder if necessary
if [[ ! -e ${output_path_esu} ]]; then
    mkdir ${output_path_esu}
elif [[ ! -d ${output_path_esu} ]]; then
    echo "${output_path_esu} already exists but is not a directory" 1>&2
fi

if [[ ! -e ${output_path_eng} ]]; then
    mkdir ${output_path_eng}
elif [[ ! -d ${output_path_eng} ]]; then
    echo "${output_path_eng} already exists but is not a directory" 1>&2
fi

# Copy over the preprocessed data
for prefix in train dev test; do
    if [ -f "${output_path_esu}/${prefix}.txt" ]; then
	echo "${output_path_esu}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.tc.esu ${output_path_esu}/${prefix}.txt
    fi
done


for prefix in train dev test; do
    if [ -f "${output_path_eng}/${prefix}.txt" ]; then
	echo "${output_path_eng}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.tc.en ${output_path_eng}/${prefix}.txt
    fi
done


