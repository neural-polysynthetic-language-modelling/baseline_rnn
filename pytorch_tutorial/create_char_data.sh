#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
texts="train test valid"
#for lang in ckt ckt2 see ipk esu ess iku_rom grn ptb kal ; do
#for lang in SETIMES.en SETIMES.tr ess_eng esu_eng iku_eng grn_spa ; do
for lang in esu_bible_all esu_eng_bible_all grn_bible_all grn_spa_bible_all ; do
	mkdir ${path_prefix}/${lang}_char/
	for f in ${texts}; do
		cat ${path_prefix}/${lang}/${f}.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v "^ *$" > ${path_prefix}/${lang}_char/${f}.txt
	done
done
