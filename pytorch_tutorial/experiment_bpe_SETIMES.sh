#!/bin/bash
for lang in SETIMES.en SETIMES.tr; do
	for bpe_size in 10k 1k 4k 7k 20k 30k 40k 50k ; do
	#for bpe_size in 500 1000 5000 15000 30000 60000 ; do
		echo "Running experiment for ${lang} with tokenization ${bpe_size}"
		CUDA_VISIBLE_DEVICES=5 python main.py --cuda --data /home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/${lang}_bpe_${bpe_size} --epoch=30 --save=${lang}_bpe_${bpe_size}.pt \
		> ${lang}_${input_level}.log \
	 	2> ${lang}_${input_level}.err
	done
done
