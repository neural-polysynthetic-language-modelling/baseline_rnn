#!/bin/bash

for lang in ckt ckt2 see ipk esu ess iku_rom grn ptb kal SETIMES.en SETIMES.tr grn_spa ess_eng esu_eng iku_rom_eng wikitext-2; do
	for input_level in char; do
		token_ppl="$(cat ${lang}_${input_level}.log | grep -o 'test ppl \(.*\)' | sed 's/test ppl //g')"
		echo "${lang}_${input_level} Token level ppl: ${token_ppl}"
	done
done
