#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/"
texts="train test valid"
for lang in ckt ckt2 see ipk esu ess iku_rom grn ptb kal SETIMES.en SETIMES.tr ess_eng esu_eng iku_eng grn_spa ; do
	mkdir ${path_prefix}${lang}_cleaned/
	for f in ${texts}; do
		cat ${path_prefix}${lang}/${f}.txt | grep -v "^ *$" > ${path_prefix}${lang}_cleaned/${f}.txt
	done
done