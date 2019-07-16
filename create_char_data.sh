#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
texts="train test valid"
#for lang in ckt ckt2 see ipk esu ess iku_rom grn ptb kal ; do
#for lang in SETIMES.en SETIMES.tr ess_eng esu_eng iku_eng grn_spa ; do
# for lang in ess_all ess_eng_all ess_eng_new_testament ess_new_testament esu_new_testament esu_eng_new_testament esu_bible_all esu_eng_bible_all grn_spa_bible_all grn_bible_all grn_bible_new_testament grn_spa_bible_new_testament ckt_all; do
# for lang in grn_all_FST_preprocessed esu_NT_intro esu_eng_NT_intro esu_lm_intro esu_eng_lm_intro; do
# for lang in ckt_all ; do
#for lang in iku_all iku_NT iku_labr_all iku_labr_NT esk_NT ; do
# for lang in  ess_NT ess_eng_NT esu_NT_intro esu_eng_NT_intro grn_NT grn_spa_NT esk_NT iku_NT iku_labr_NT; do
# for lang in ckt_all ess_all ess_eng_all esu_all esu_eng_all grn_all grn_spa_all iku_all iku_labr_all; do

# for lang in iku_all iku_NT iku_labr_all iku_labr_NT esk_NT; do	
for lang in grn_all_tok; do	
	mkdir -p ${path_prefix}/${lang}_char/
	for f in ${texts}; do
		cat ${path_prefix}/${lang}/${f}.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v "^ *$" > ${path_prefix}/${lang}_char/${f}.txt
	done
done
