#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in ess_NT ess_eng_NT ; do
	for bpe_size in 500 1000 5000 15000 30000 60000 ; do

	CUDA_VISIBLE_DEVICES=7 python -u main.py --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 --dropouth 0.1 --dropouti 0.1 \
	 --dropout 0.4 --wdrop 0.2 --wdecay 1.2e-6 --bptt 200 --batch_size 128 --optimizer adam --lr 1e-3 --data ${path_prefix}/${lang}_bpe_${bpe_size}  --save ${lang}_bpe_${bpe_size}_wiki_para.pt  --when 25 35 \
	> ${lang}_bpe_${bpe_size}_enwik_para.log \
	2> ${lang}_bpe_${bpe_size}_enwik_para.err

	done
done