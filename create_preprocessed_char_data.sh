#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
texts="train test valid"

# for lang in grn_all_FST_preprocessed_no_at grn_all_FST_preprocessed grn_all_FST_preprocessed_more_at ; do
for lang in grn_all_tok_mor_preprocessed grn_all_tok_mor_preprocessed_no_at grn_all_tok_mor_preprocessed_more_at grn_all_tok_bpe_500_preprocessed grn_all_tok_bpe_500_preprocessed_no_at grn_all_tok_bpe_500_preprocessed_more_at ; do
	mkdir -p ${path_prefix}/${lang}_char/
	for f in ${texts}; do
		cat ${path_prefix}/${lang}/${f}.txt | sed 's/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v "^ *$" > ${path_prefix}/${lang}_char/${f}.txt
	done
done
