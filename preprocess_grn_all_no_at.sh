#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
texts="train test valid"

for lang in grn_all_bpe_500_preprocessed grn_all_mor_preprocessed; do
	mkdir -p ${path_prefix}/${lang}_no_at
	for f in ${texts}; do
		# tokenize ’” to ’ ”
		# remove preceeding/trailling spaces
		# replace spaces with _
		# replace one or more of the morpheme boundary symbol (>) with @
		cat ${path_prefix}/${lang}/${f}.txt | sed 's/ @ / /g'  > ${path_prefix}/${lang}_no_at/${f}.txt
	done
done