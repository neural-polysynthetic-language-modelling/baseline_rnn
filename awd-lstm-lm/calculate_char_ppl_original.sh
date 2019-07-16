#!/bin/bash

log_file=$1
lang=$2
token_level=$3

# token_ppl="$(cat ${lang}_${token_level}.log | grep -o 'test ppl \(.*\)' | sed 's/test ppl //g')"
# token_ppl="$(cat ${lang}_${token_level}.log | grep -o 'test ppl \(.*\) ' | grep -Eo '[0-9]*\.[0-9]*')"
token_ppl="$(cat ${log_file} | grep -o 'test ppl \(.*\) ' | grep -Eo '[0-9]*\.[0-9]*')"



echo ${lang}_${token_level}
echo "Token level ppl: ${token_ppl}"

path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"

if [ "$token_level" == "word" ]; then
    token_cnt="$(wc -w ${path_prefix}/${lang}/test.txt | cut -f1 -d ' ')" 
else
    token_cnt="$(wc -w ${path_prefix}/${lang}_${token_level}/test.txt | cut -f1 -d ' ')" 
fi

# token_cnt="$(wc -w ${path_prefix}/${lang}/test.txt | cut -f1 -d ' ')" 


char_cnt="$(cat ${path_prefix}/${lang}_char/test.txt | tr -d ' '| tr -d '\n' | wc -c | cut -f1 -d ' ')"

echo "Char-level ppl: $(echo "${token_ppl}*${token_cnt}/${char_cnt}" | bc -l)"
