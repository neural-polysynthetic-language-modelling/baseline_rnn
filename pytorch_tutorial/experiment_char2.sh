#!/bin/bash
for lang in SETIMES.en SETIMES.tr ess_eng esu_eng iku_eng grn_spa ; do
	for input_level in char; do
		echo "Running experiment for ${lang} with tokenization ${input_level}"
		CUDA_VISIBLE_DEVICES=2 python main.py --cuda --data /home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/${lang}_${input_level} --epoch=30 --save=${lang}_${input_level}.pt \
		> ${lang}_${input_level}.log \
	 	2> ${lang}_${input_level}.err
	done
done
