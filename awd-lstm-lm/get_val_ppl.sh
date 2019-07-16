#!/bin/bash
log_file=$1

cat ${log_file}.log | grep "valid ppl" | cut -f5 -d '|' | grep -Eo '[0-9]*\.[0-9]*' > ${log_file}.val_ppl