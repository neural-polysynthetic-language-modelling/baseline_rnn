#!/bin/bash
for lang in ipk ; do
	for input_level in bpe_4k bpe_1k bpe_7k bpe_10k ; do
		echo "Running experiment for ${lang} with tokenization ${input_level}"
		CUDA_VISIBLE_DEVICES=5 python main.py --cuda --data /home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/${lang}_${input_level} --epoch=30 --save=${lang}_${input_level}.pt \
		> ${lang}_${input_level}.log \
	 	2> ${lang}_${input_level}.err
	done
done
