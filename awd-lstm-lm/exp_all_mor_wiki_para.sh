#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in ckt_all ess_all ess_eng_all esu_all_intro esu_eng_all_intro grn_all grn_spa_all ; do
	CUDA_VISIBLE_DEVICES=4 python main.py --cuda --epochs 200 --data ${path_prefix}/${lang}_mor_preprocessed --save ${lang}_mor_preprocessed_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_mor_preprocessed_wiki_para.log \
	2> ${lang}_mor_preprocessed_wiki_para.err
done
