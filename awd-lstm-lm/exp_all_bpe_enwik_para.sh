#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in ckt_all ess_all ess_eng_all esu_all_intro esu_eng_all_intro grn_all grn_spa_all ptb wikitext-2 ; do
	for bpe_size in 500 1000 5000 15000 30000 60000 ; do

	CUDA_VISIBLE_DEVICES=0 python main.py --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 \
	--dropouth 0.1 --dropouti 0.1 --dropout 0.4 --wdrop 0.2 --wdecay 1.2e-6 --bptt 200 --batch_size 128 --optimizer adam \
	--lr 1e-3 --data ${path_prefix}/${lang}_bpe_${bpe_size}_preprocessed --save ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.pt --when 25 35 \
	> ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.log \
	2> ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.err

	done
done
