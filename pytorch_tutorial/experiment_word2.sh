#!/bin/bash
for lang in SETIMES.en SETIMES.tr ess_eng esu_eng iku_rom_eng grn_spa ; do
	for input_level in word; do
		echo "Running experiment for ${lang} with tokenization ${input_level}"
		CUDA_VISIBLE_DEVICES=6 python main.py --cuda --data /home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/${lang} --epoch=30 --save=${lang}_${input_level}.pt \
		> ${lang}_${input_level}.log \
	 	2> ${lang}_${input_level}.err
	done
done