#!/bin/bash

for lang in ckt ckt2 see ipk esu ess iku_rom grn ptb kal SETIMES.en SETIMES.tr grn_spa ess_eng esu_eng iku_rom_eng wikitext-2 iku_rom_10 ; do
	for input_level in word; do
		echo "Character level ppl for ${lang}_${input_level}"
		./calculate_char_ppl.sh ${lang}_${input_level}.log ${lang} ${lang}_char
	done
done
