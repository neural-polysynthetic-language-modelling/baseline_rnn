#!/bin/bash

for lang in ckt ; do
	for input_level in bpe_1k bpe_2k bpe_3k; do
		echo "Character level ppl for ${lang}_${input_level}"
		./calculate_char_ppl.sh ${lang}_${input_level}.log ${lang}_${input_level} ${lang}_char
	done
done