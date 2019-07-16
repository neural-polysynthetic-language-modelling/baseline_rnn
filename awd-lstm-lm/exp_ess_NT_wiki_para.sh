#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in ess_new_testament ess_eng_new_testament ; do
	for input_level in word; do

	python main.py --epochs 750 --data ${path_prefix}/${lang} --save ${lang}_${input_level}_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_${input_level}_wiki_para.log \
	2> ${lang}_${input_level}_wiki_para.err

	done
done