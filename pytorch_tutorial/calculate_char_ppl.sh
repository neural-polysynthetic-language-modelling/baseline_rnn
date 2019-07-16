#!/bin/bash

log_file=$1

token_ppl="$(cat ${log_file} | grep -o 'test ppl \(.*\)' | sed 's/test ppl //g')"
echo "Token level ppl: ${token_ppl}"

token_folder=$2
char_folder=$3

path_prefix="/home/hpark129/projects/JSALT_NPLM_data/baseline_RNN/data/"

token_cnt="$(wc -w ${path_prefix}${token_folder}/test.txt | cut -f1 -d ' ')" 

char_cnt="$(cat ${path_prefix}${char_folder}/test.txt | tr -d ' '| tr -d '\n' | wc -c | cut -f1 -d ' ')"

echo "${token_ppl}*${token_cnt}/${char_cnt}" | bc -l