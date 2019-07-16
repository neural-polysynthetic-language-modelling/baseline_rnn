#!/bin/bash
#for lang in ckt ckt2 see ipk esu ess iku_rom grn ptb kal ; do
for lang in iku_rom_unk ; do
	for input_level in word; do
		echo "Running experiment for ${lang} with tokenization ${input_level}"
		python main.py --cuda --data /home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/${lang} --epoch=30 --save=${lang}_${input_level}.pt \
		> ${lang}_${input_level}.log \
	 	2> ${lang}_${input_level}.err
	done
done
