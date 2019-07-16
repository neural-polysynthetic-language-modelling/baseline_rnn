#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
texts="train test valid"

for lang in grn_all_mor_preprocessed grn_all_bpe_500_preprocessed; do
	mkdir -p ${path_prefix}/${lang}_more_at
	for f in ${texts}; do
		# replace space to @ and _
		cat ${path_prefix}/${lang}/${f}.txt | sed 's/_/@ _/g'  > ${path_prefix}/${lang}_more_at/${f}.txt
	done
done