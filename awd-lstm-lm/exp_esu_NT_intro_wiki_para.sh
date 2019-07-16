#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in esu_NT_intro esu_eng_NT_intro ; do
	for input_level in word; do

	CUDA_VISIBLE_DEVICES=2 python main.py --epochs 200 --cuda --data ${path_prefix}/${lang} --save ${lang}_${input_level}_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_${input_level}_wiki_para.log \
	2> ${lang}_${input_level}_wiki_para.err

	done
done
