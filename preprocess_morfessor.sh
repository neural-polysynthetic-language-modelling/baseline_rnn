#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"

# for lang in ptb wikitext-2 ; do
# for lang in grn_all_tok ; do	
for lang in esk_NT ; do	
	python preprocess_morfessor_python.py -p=${path_prefix}/${lang}_mor
done

echo "preprocessed NT morfessor data"

# for lang in iku_all iku_NT iku_labr_all iku_labr_NT esk_NT ; do
# 	python preprocess_morfessor_python.py -p=${path_prefix}/${lang}_mor
# done

# echo "preprocessed NT morfessor data"


# for lang in ess_NT ess_eng_NT esu_NT_intro esu_eng_NT_intro grn_NT grn_spa_NT; do
# 	python preprocess_morfessor_python.py -p=${path_prefix}/${lang}_mor
# done

# echo "preprocessed NT morfessor data"


# for lang in ckt_all ess_all ess_eng_all esu_all_intro esu_eng_all_intro grn_all grn_spa_all ptb wikitext-2 ; do
# 	python preprocess_morfessor_python.py -p=${path_prefix}/${lang}_mor
# done

# echo "preprocessed all morfessor data"
