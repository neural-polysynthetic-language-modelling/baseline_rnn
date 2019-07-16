#!/bin/bash

for lang in see ; do
	for input_level in bpe_1k bpe_4k bpe_7k; do
		echo "Character level ppl for ${lang}_${input_level}"
		./calculate_char_ppl.sh ${lang}_${input_level}.log ${lang}_${input_level} ${lang}_char
	done
done