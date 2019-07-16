#!/bin/bash

for lang in iku_rom iku_rom_eng ; do
	for bpe_size in 500 1000 5000 15000 30000 60000; do
		echo "Character level ppl for ${lang}_${bpe_size}"
		./calculate_char_ppl.sh ${lang}_bpe_${bpe_size}.log ${lang}_bpe_${bpe_size} ${lang}_char
	done
done