#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in ess_new_testament ess_eng_new_testament ; do
	for bpe_size in 500 1000 5000 15000 30000 60000 ; do

	CUDA_VISIBLE_DEVICES=1 python main.py --epochs 750 --data ${path_prefix}/${lang}_bpe_${bpe_size} --save ${lang}_bpe_${bpe_size}_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_bpe_${bpe_size}_wiki_para.log \
	2> ${lang}_bpe_${bpe_size}_wiki_para.err

	done
done