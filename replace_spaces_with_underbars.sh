#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
texts="train test valid"

for lang in grn_all_FST; do
	mkdir -p ${path_prefix}/${lang}/preprocess
	for f in ${texts}; do
		cat ${path_prefix}/${lang}/${f}.txt | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/>/ @ /g'  > ${path_prefix}/${lang}/preprocess/${f}.txt
	done
done