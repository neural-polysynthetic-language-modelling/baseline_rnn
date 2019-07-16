#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in esu_bible_all_mor esu_eng_bible_all_mor ; do

	CUDA_VISIBLE_DEVICES=3 python main.py --cuda --epochs 750 --data ${path_prefix}/${lang}_cleaned --save ${lang}_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_wiki_para.log \
	2> ${lang}_wiki_para.err
done
