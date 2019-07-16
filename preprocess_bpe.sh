#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"
texts="train test valid"

# for lang in iku_all iku_NT iku_labr_all iku_labr_NT esk_NT ; do
for lang in grn_all_tok ; do
	for bpe_size in 500 1000 5000 15000 30000 60000; do
	mkdir -p ${path_prefix}/${lang}_bpe_${bpe_size}_preprocessed
	for f in ${texts}; do
		cat ${path_prefix}/${lang}_bpe_${bpe_size}/${f}.txt | sed 's/^ *//g; s/ *$//g; s/@@ /@/g; s/ @-@ /@-@/g; s/ / _ /g; s/@/ @ /g' > ${path_prefix}/${lang}_bpe_${bpe_size}_preprocessed/${f}.txt
	done
done
done

echo "preprocessed NT bpe data"


# for lang in ess_NT ess_eng_NT esu_NT_intro esu_eng_NT_intro grn_NT grn_spa_NT; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000; do
# 	mkdir -p ${path_prefix}/${lang}_bpe_${bpe_size}_preprocessed
# 	for f in ${texts}; do
# 		cat ${path_prefix}/${lang}_bpe_${bpe_size}/${f}.txt | sed 's/^ *//g; s/ *$//g; s/@@ /@/g; s/ @-@ /@-@/g; s/ / _ /g; s/@/ @ /g' > ${path_prefix}/${lang}_bpe_${bpe_size}_preprocessed/${f}.txt
# 	done
# done
# done

# echo "preprocessed NT bpe data"


# for lang in ckt_all ess_all ess_eng_all esu_all_intro esu_eng_all_intro grn_all grn_spa_all ptb wikitext-2 ; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000; do
# 	mkdir -p ${path_prefix}/${lang}_bpe_${bpe_size}_preprocessed
# 	for f in ${texts}; do
# 		cat ${path_prefix}/${lang}_bpe_${bpe_size}/${f}.txt | sed 's/^ *//g; s/ *$//g; s/@@ /@/g; s/ @-@ /@-@/g; s/ / _ /g; s/@/ @ /g' > ${path_prefix}/${lang}_bpe_${bpe_size}_preprocessed/${f}.txt
# 	done
# done
# done

# echo "preprocessed all bpe data"