#!/bin/bash -v

# USAGE: bash preprocess.sh

SRC=en
TRG=ess

data=../output/all_test
model=$data
# If you run this, mosesdecoder should point to the scripts directory for Moses.
mosesdecoder=/home/hpark129/projects/mosesdecoder/scripts  

# This sample script preprocesses a sample corpus, including tokenization,
# and truecasing.

# First split the data into train/dev/test:
# Test (John):
grep "_John_" ../../new.testament.parallel.tsv | cut -f2 > $data/test.$TRG
grep "_John_" ../../new.testament.parallel.tsv | cut -f3 > $data/test.$SRC

# Dev (Luke):
grep "_Luke_" ../../new.testament.parallel.tsv | cut -f2 > $data/dev.$TRG
grep "_Luke_" ../../new.testament.parallel.tsv | cut -f3 > $data/dev.$SRC

# Train (remaining data):
grep -v "_Luke_" ../../new.testament.parallel.tsv | grep -v "_John_" | cut -f2 > $data/train.$TRG
grep -v "_Luke_" ../../new.testament.parallel.tsv | grep -v "_John_" | cut -f3 > $data/train.$SRC

for dir in elementary_primers/level1.kallagneghet-drumbeats elementary_primers/level2.akiingqwaghneghet-echoes elementary_primers/level3.suluwet-whisperings nagai \
sivuqam_nangaghnegha/sivuqam_volume1 sivuqam_nangaghnegha/sivuqam_volume2 sivuqam_nangaghnegha/sivuqam_volume3 ungipaghaghlanga; do

    cat /home/hpark129/projects/JSALT_NPLM_data/Inuit-Yupik/ess/monolingual_corpus/${dir}/*.gold.eng/*.eng.txt >> ${data}/train.${SRC}
    cat /home/hpark129/projects/JSALT_NPLM_data/Inuit-Yupik/ess/monolingual_corpus/${dir}/*.gold.ess/*.${TRG}.txt >> ${data}/train.${TRG}

done

# Remove square brackets from English data (remove-brackets.perl)
for prefix in train dev test
do
    if [ -f "$data/$prefix.prep.$SRC" ]; then
	echo "$data/$prefix.prep.$SRC exists."
    else
	cat $data/$prefix.$SRC | ./remove-brackets.perl > $data/$prefix.prep.$SRC
    fi
done

# Then run normalize-apos-ess.perl (normalizes apostrophes)
for prefix in train dev test
do
    if [ -f "$data/$prefix.apos.$TRG" ]; then
	echo "$data/$prefix.apos.$TRG exists."
    else
	cat $data/$prefix.$TRG | ./normalize-apos-ess.perl > $data/$prefix.apos.$TRG
    fi
done
	

# tokenize
for prefix in train dev test
do
    if [ -f "$data/$prefix.tok.$SRC" ]; then
	echo "$data/$prefix.tok.$SRC exists."
    else
	cat $data/$prefix.prep.$SRC \
            | $mosesdecoder/tokenizer/normalize-punctuation.perl -l $SRC \
            | $mosesdecoder/tokenizer/tokenizer.perl -a -l $SRC > $data/$prefix.tok.$SRC
    fi
    if [ -f "$data/$prefix.tok.$TRG" ]; then
	echo "$data/$prefix.tok.$TRG exists."
    else
	cat $data/$prefix.apos.$TRG \
            | $mosesdecoder/tokenizer/normalize-punctuation.perl -l $TRG \
            | $mosesdecoder/tokenizer/tokenizer.perl -a -l $TRG > $data/$prefix.tok.$TRG
    fi
done

if [ -f "$data/train.tok.clean.$SRC" -a -f "$data/train.tok.clean.$TRG" ]; then
    echo "Data cleaning has already been run."
else
    # clean empty and long sentences, and sentences with high source-target ratio (training corpus only)
    $mosesdecoder/training/clean-corpus-n.perl -ratio 10 $data/train.tok $SRC $TRG $data/train.tok.clean 1 80
fi

for prefix in dev test
do
    if [ -f "$data/$prefix.tok.clean.$SRC" -a -f "$data/$prefix.tok.clean.$TRG" ]; then
	echo "Data cleaning ($prefix) has already been run."
    else
	# clean empty and long sentences, and sentences with high source-target ratio (training corpus only)
	$mosesdecoder/training/clean-corpus-n.perl -ignore-ratio $data/$prefix.tok $SRC $TRG $data/$prefix.tok.clean 1 1000
    fi
done

if [ -f "$model/tc.$SRC" -a -f "$model/tc.$TRG" ]; then
    echo "Truecaser exists."
else
    # train truecaser
    $mosesdecoder/recaser/train-truecaser.perl -corpus $data/train.tok.clean.$SRC -model $model/tc.$SRC
    $mosesdecoder/recaser/train-truecaser.perl -corpus $data/train.tok.clean.$TRG -model $model/tc.$TRG
fi

# apply truecaser to all data
for prefix in train dev test
do
    if [ -f "$data/$prefix.tc.$SRC" -a -f "$data/$prefix.tc.$TRG" ]; then
	echo "Truecaser has been applied (train)."
    else
	$mosesdecoder/recaser/truecase.perl -model $model/tc.$SRC < $data/$prefix.tok.clean.$SRC > $data/$prefix.tc.$SRC
	$mosesdecoder/recaser/truecase.perl -model $model/tc.$TRG < $data/$prefix.tok.clean.$TRG > $data/$prefix.tc.$TRG
    fi
done

