#!/bin/bash
for lang in iku_rom iku_rom_eng; do
	for bpe_size in 500 1000 5000 30000 60000 ; do
	#for bpe_size in 500 1000 5000 15000 30000 60000 ; do
		echo "Running experiment for ${lang} with tokenization ${bpe_size}"
		CUDA_VISIBLE_DEVICES=7 python main.py --cuda --data /home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/${lang}_bpe_${bpe_size} --epoch=30 --save=${lang}_bpe_${bpe_size}.pt \
		> ${lang}_${input_level}.log \
	 	2> ${lang}_${input_level}.err
	done
done
