#!/bin/bash

for i in *lm_intro*.*
do
    mv "$i" "${i/lm_intro/all_intro}"
done

