#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in iku_all iku_NT iku_labr_all iku_labr_NT esk_NT ; do
	CUDA_VISIBLE_DEVICES=4 python main.py --cuda --epochs 200 --data ${path_prefix}/${lang}_mor_preprocessed --save ${lang}_mor_preprocessed_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_mor_preprocessed_wiki_para.log \
	2> ${lang}_mor_preprocessed_wiki_para.err
done
