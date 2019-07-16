#!/bin/bash

echo "Reporting results in char-level ppl for New Testament Only"

# for lang in ckt_all grn_NT grn_spa_NT grn_all grn_spa_all ; do
# # for lang in esu_NT esu_eng_NT esu_all_lm esu_eng_all_lm ; do
# # for lang in esu_NT esu_eng_NT ess_NT ess_eng_NT ess_all ess_eng_all; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_enwik_para.log ${lang} bpe_${bpe_size}
# 	echo "--------"
# done
# done

# for lang in ckt_all grn_NT grn_spa_NT grn_all grn_spa_all ; do
# for lang in esu_NT esu_eng_NT ess_NT ess_eng_NT; do
# for lang in esu_NT esu_eng_NT esu_all_lm esu_eng_all_lm ; do
# for lang in esu_NT esu_eng_NT ess_NT ess_eng_NT ess_all ess_eng_all; do
# for lang in ptb wikitext-2; do
# for lang in esu_all_lm esu_eng_all_lm grn_spa_NT esu_eng_all esu_all; do
# 	bash calculate_char_ppl.sh ${lang}_char_enwik_para.log ${lang} char
# 	echo "--------"
# done

# for lang in esu_all_lm esu_eng_all_lm ckt_all grn_NT grn_spa_NT grn_all grn_spa_all ; do
# 	bash calculate_char_ppl.sh ${lang}_word_wiki_para.log ${lang} word
# 	echo "--------"
# done


for lang in iku_all iku_NT iku_labr_all iku_labr_NT esk_NT ; do
	bash calculate_char_ppl.sh ${lang}_word_wiki_para.log ${lang} ${lang}_char
	echo "--------"
done

# for lang in ess_all ess_eng_all ess_NT ess_eng_NT ; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_enwik_para.log ${lang} bpe_${bpe_size}
# 	echo "--------"
# done
# done

# for lang in esu_NT_intro esu_eng_NT_intro esu_all_intro esu_eng_all_intro; do
# 	bash calculate_char_ppl.sh ${lang}_mor_wiki_para.log ${lang} mor_cleaned
# 	echo "--------"
# done

# for lang in ptb wikitext-2 esk_NT iku_NT iku_labr_NT ckt_all ess_all ess_eng_all esu_all_intro esu_eng_all_intro grn_all grn_spa_all iku_all iku_labr_all; do
# 	bash calculate_char_ppl.sh ${lang}_mor_preprocessed_wiki_para.log ${lang} mor_preprocessed
# 	echo "--------"
# done

# for lang in ckt_all ess_all ess_eng_all esu_all_intro esu_eng_all_intro grn_all grn_spa_all iku_all iku_labr_all; do
# 	bash calculate_char_ppl.sh ${lang}_mor_preprocessed_wiki_para.log ${lang} mor_preprocessed
# 	echo "--------"
# done


# for lang in ess_NT ess_eng_NT esu_NT_intro esu_eng_NT_intro grn_NT grn_spa_NT; do
# 	bash calculate_char_ppl.sh ${lang}_mor_preprocessed_wiki_para.log ${lang} mor_preprocessed
# 	echo "--------"
# done

# for lang in iku_all iku_NT iku_labr_all iku_labr_NT esk_NT ; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.log ${lang} bpe_${bpe_size}_preprocessed
# 	echo "--------"
# done
# done

# for lang in ckt_all ; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.log ${lang} bpe_${bpe_size}_preprocessed
# 	echo "--------"
# done
# done

# for lang in ckt_all ess_all ess_eng_all esu_all_intro esu_eng_all_intro grn_all grn_spa_all ptb wikitext-2; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.log ${lang} bpe_${bpe_size}_preprocessed
# 	echo "--------"
# done
# done

# for lang in ptb wikitext-2 ; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.log ${lang} bpe_${bpe_size}_preprocessed
# 	echo "--------"
# done
# done

# for lang in grn_spa_all grn_spa_NT ess_NT ess_all ess_eng_all esu_all_intro esu_eng_all_intro grn_all grn_spa_all esk_NT iku_NT iku_all iku_labr_NT iku_labr_all ; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.log ${lang} bpe_${bpe_size}_preprocessed
# 	echo "--------"
# done
# done


# for lang in ess_NT ess_eng_NT esu_NT_intro esu_eng_NT_intro grn_NT grn_spa_NT; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.log ${lang} bpe_${bpe_size}_preprocessed
# 	echo "--------"
# done
# done

# for lang in esu_all_intro esu_eng_all_intro esu_NT_intro esu_eng_NT_intro ; do
# 	for bpe_size in 500 1000 5000 15000 30000 60000 ; do
# 	bash calculate_char_ppl.sh ${lang}_bpe_${bpe_size}_preprocessed_enwik_para.log ${lang} bpe_${bpe_size}_preprocessed
# 	echo "--------"
# done
# done


# for lang in esu_all_intro esu_eng_all_intro esu_NT_intro esu_eng_NT_intro ckt_all iku_all iku_NT iku_labr_all iku_labr_NT esk_NT; do
# 	bash calculate_char_ppl.sh ${lang}_word_wiki_para.log ${lang} ${lang}_char
#  	echo "--------"
# done

# for lang in esu_all_intro esu_eng_all_intro esu_NT_intro esu_eng_NT_intro ckt_all iku_all iku_NT iku_labr_all iku_labr_NT esk_NT; do
# 	bash calculate_char_ppl.sh ${lang}_char_enwik_para.log ${lang} char
#  	echo "--------"
# done