#!/bin/bash

# If you run this, subword should point to the subword-nmt directory.
subword=/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/subword-nmt
# be sure to install subword-nmt with pip install subword-nmt

for lang in ptb wikitext-2; do
	data=./data/${lang}
	for bpe_size in 500 1000 5000 15000 30000 60000; do
		model=${data}_bpe_$bpe_size
		mkdir -p $model
	    echo "Running BPE $bpe_size" > $model/log

	    # train BPE
	    subword-nmt learn-bpe -s $bpe_size --total-symbols -i $data/train.txt > ${model}/${lang}.${bpe_size}.bpe 2>> ${model}/log

	    # apply BPE
	    for prefix in train valid test
	    do
	    	subword-nmt apply-bpe -c $model/${lang}.${bpe_size}.bpe -i ${data}/${prefix}.txt > ${model}/${prefix}.txt 2>> ${model}/log
		done
	done
done