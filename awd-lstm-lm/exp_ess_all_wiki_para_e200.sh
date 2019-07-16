#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in ess_all ess_eng_all ; do

	CUDA_VISIBLE_DEVICES=4 python main.py --cuda --epochs 200 --data ${path_prefix}/${lang} --save ${lang}_wiki_para.pt --dropouth 0.2 --seed 1882 \
	> ${lang}_wiki_para.log \
	2> ${lang}_wiki_para.err
done
