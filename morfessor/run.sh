#!/bin/bash
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/"
texts="train test valid"

#for lang_fol in ess_eng_new_testament ess_new_testament esu_bible_all esu_eng_bible_all wikitext-2; do
#for lang_fol in esu_lm_intro esu_eng_lm_intro esu_NT_intro esu_eng_NT_intro ; do
for lang_fol in iku_all iku_NT iku_labr_all iku_labr_NT esk_NT ; do
	mkdir ${path_prefix}${lang_fol}_mor
	morfessor-train --logfile=${lang_fol}.log -s ${lang_fol}.model ${path_prefix}${lang_fol}/train.txt

	for txt_name in ${texts}; do
		morfessor-segment -l ${lang_fol}.model "${path_prefix}${lang_fol}/${txt_name}".txt >> "${path_prefix}${lang_fol}_mor/${txt_name}".txt
	done
done

# for f_name in ess_eng_new_testament ess_new_testament esu_bible_all esu_eng_bible_all wikitext-2; do
# 	texts="train test valid"
# 	out_path=`echo ${path_prefix}${f_name}_mor`
# 	mkdir ${out_path}
# 	morfessor-train --logfile=${f_name}.log -s ${f_name}.model ${path_prefix}${f_name}/train.txt

# 	for f in $texts; do
# 		f+=".txt"
# 		morfessor-segment -l ${f_name}.model ${path_prefix}${f_name}/${f} >> ${out_path}/${f}
# 	done

# done
