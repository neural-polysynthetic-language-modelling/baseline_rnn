#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in grn_NT grn_spa_NT ; do
	CUDA_VISIBLE_DEVICES=0 python main.py --cuda --epochs 200 --data ${path_prefix}/${lang} --save ${lang}_word_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_word_wiki_para.log \
	2> ${lang}_word_wiki_para.err
done
