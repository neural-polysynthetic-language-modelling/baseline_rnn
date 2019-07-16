#!/bin/bash

for lang in iku_rom iku_rom_eng ; do
	for bpe_size in 500 1000 5000 30000 60000; do
		echo "Character level ppl for ${lang}_bpe_${bpe_size}"
		./calculate_char_ppl.sh ${lang}_bpe_${bpe_size}.log ${lang}_bpe_${bpe_size} ${lang}_char
	done
done