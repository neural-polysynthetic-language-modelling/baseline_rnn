#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in esu_NT_intro_mor esu_eng_NT_intro_mor esu_lm_intro_mor esu_eng_lm_intro_mor ; do
	CUDA_VISIBLE_DEVICES=7 python main.py --cuda --epochs 200 --data ${path_prefix}/${lang}_cleaned --save ${lang}_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_wiki_para.log \
	2> ${lang}_wiki_para.err
done
