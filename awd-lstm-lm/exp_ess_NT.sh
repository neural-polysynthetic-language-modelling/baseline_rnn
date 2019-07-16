#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in ess_new_testament ess_eng_new_testament ; do
	for input_level in word; do
	CUDA_VISIBLE_DEVICES=3 python main.py --batch_size 20 --data ${path_prefix}/${lang} --dropouti 0.4 --dropouth 0.25 --seed 141 --epoch 500 --save ${lang}_${input_level}.pt \
	> ${lang}_${input_level}.log \
	2> ${lang}_${input_level}.err

	done
done
