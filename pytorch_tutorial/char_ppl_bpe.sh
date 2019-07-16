#!/bin/bash

# for lang in ckt ckt2 see ipk esu ess iku_rom grn ptb kal SETIMES.en SETIMES.tr grn_spa ess_eng esu_eng iku_rom_eng wikitext-2 iku_rom_10 ; do
for lang in ckt ckt2  ; do
	for bpe_size in 1k 4k 7k 10k 20k 30k 40k 50k; do
		echo "Character level ppl for ${lang}_bpe_${bpe_size}"
		./calculate_char_ppl.sh ${lang}_bpe_${bpe_size}.log ${lang}_bpe_${bpe_size} ${lang}_char
	done
done
