#!/bin/bash
for lang in ckt ; do
	for input_level in bpe_1k bpe_2k bpe_3k; do
		echo "Running experiment for ${lang} with tokenization ${input_level}"
		CUDA_VISIBLE_DEVICES=7 python main.py --cuda --data /home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/${lang}_${input_level} --epoch=30 --save=${lang}_${input_level}.pt \
		> ${lang}_${input_level}.log \
	 	2> ${lang}_${input_level}.err
	done
done
