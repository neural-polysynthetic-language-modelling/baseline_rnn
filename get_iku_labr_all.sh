#!/bin/bash
source_path="/home/hpark129/projects/JSALT_NPLM_data/Inuit-Yupik/iku_labr/bible_preprocess/output/all"
output_path_iku="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/iku_labr_all"

# Create a folder if necessary
if [[ ! -e ${output_path_iku} ]]; then
    mkdir ${output_path_iku}
elif [[ ! -d ${output_path_iku} ]]; then
    echo "${output_path_iku} already exists but is not a directory" 1>&2
fi

# Copy over the preprocessed data
for prefix in train dev test; do
    if [ -f "${output_path_iku}/${prefix}.txt" ]; then
	echo "${output_path_iku}/${prefix}.txt exists."
    else
	cp ${source_path}/${prefix}.iku_labr ${output_path_iku}/${prefix}.txt
    fi
done

mv ${output_path_iku}/dev.txt ${output_path_iku}/valid.txt 



