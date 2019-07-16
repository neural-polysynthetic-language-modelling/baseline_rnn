#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
for lang in grn_all_FST_preprocessed grn_all_FST_preprocessed_more_at grn_all_FST_preprocessed_no_at ; do
	for input_size in char ; do

	CUDA_VISIBLE_DEVICES=5 python main.py --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 \
	--dropouth 0.1 --dropouti 0.1 --dropout 0.4 --wdrop 0.2 --wdecay 1.2e-6 --bptt 200 --batch_size 128 --optimizer adam \
	--lr 1e-3 --data ${path_prefix}/${lang}_${input_size} --save ${lang}_${input_size}_enwik_para.pt --when 25 35 \
	> ${lang}_${input_size}_enwik_para.log \
	2> ${lang}_${input_size}_enwik_para.err

	done
done