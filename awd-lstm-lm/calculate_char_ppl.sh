#!/bin/bash

log_file=$1
token_level=$2
char_level=$3
path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data"

# token_ppl="$(cat ${lang}_${token_level}.log | grep -o 'test ppl \(.*\)' | sed 's/test ppl //g')"
# token_ppl="$(cat ${lang}_${token_level}.log | grep -o 'test ppl \(.*\) ' | grep -Eo '[0-9]*\.[0-9]*')"
token_ppl="$(cat ${log_file} | grep -o 'test ppl \(.*\) ' | grep -Eo '[0-9]*\.[0-9]*')"

echo ${token_level}

token_cnt="$(wc -w ${path_prefix}/${token_level}/test.txt | cut -f1 -d ' ')" 

# token_cnt="$(wc -w ${path_prefix}/${lang}/test.txt | cut -f1 -d ' ')" 


char_cnt="$(cat ${path_prefix}/${char_level}/test.txt | tr -d ' '| tr -d '\n' | wc -c | cut -f1 -d ' ')"

echo "Char-level ppl: $(echo "${token_ppl}*${token_cnt}/${char_cnt}" | bc -l)"
