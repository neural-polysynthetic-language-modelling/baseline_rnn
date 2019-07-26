#!/usr/bin/env ducttape

global {
        ducttape_output="results" # Put all results in a directory called "results"
        ducttape_experimental_multiproc=true
        lang=(Lang: eng grn ess esu iku spa)
        corpus=(Lang: eng=(DataCondition: all=(EnglishCorpus: bible ptb wikitext2 enwiki8) NT) 
          grn=(DataCondition: all NT)
          ess=(DataCondition: all NT)
          esu=(DataCondition: all NT)
          iku=(DataCondition: all NT)
          spa=(DataCondition: all NT))
}

task JSALT_NPLM_data
      :: url="https://github.com/dowobeha/JSALT_NPLM_data.git"
      > dir="data"
{
      git clone ${url} data
}

task awd_lstm_lm
      :: url="https://github.com/salesforce/awd-lstm-lm.git"
      > activate="/opt/python/3.7/venv/pytorch0.4_cuda10.0/bin/activate"
      > main="main.py"
      > generate="generate.py"
      > prep_enwik="./data/enwik8/prep_enwik8.py"
{
      git clone ${url} code
      mv code/* .
      sed -i"" "s,store_false,store_true," main.py
      rm -rf code
}

task mosesdecoder
      :: url="https://github.com/moses-smt/mosesdecoder.git"
      > tokenizer="tokenizer.perl"
{
      git clone ${url} code
      mv code/scripts/tokenizer/tokenizer.perl .
      mv code/scripts/share/nonbreaking_prefixes/nonbreaking_prefix.en .
      mv code/scripts/share/nonbreaking_prefixes/nonbreaking_prefix.es .
      rm -rf code
      mkdir nonbreaking_prefixes
      mv nonbreaking_prefix.* nonbreaking_prefixes
      sed -i"" "s,RealBin/../share/nonbreaking_prefixes,RealBin/nonbreaking_prefixes," tokenizer.perl

}

task subword_nmt
      :: url="https://github.com/rsennrich/subword-nmt.git"
      > apply_bpe="apply_bpe.py"
      > learn_bpe="learn_bpe.py"
{
      git clone ${url} code
      mv code/* .
      rm -rf code
}

task data
     :: lang=$lang
     :: corpus=$corpus
     < jsalt_data=$dir@JSALT_NPLM_data
     < prep_enwik=@awd_lstm_lm
     < tokenizer=@mosesdecoder
     > train="train.txt"
     > valid="valid.txt"
     > test="test.txt"
     > char_cnt
{
  echo -e "Lang: ${lang}\tcorpus: ${corpus}"
  if [[ "${lang}" == "eng" ]]; then
      if [[ "${corpus}" == "NT" ]]; then

        # Create train.txt dev.txt test.txt for English NT data
        # eng bible for esu

        for sub_directory in new_testament ; do
          # Test (John):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep 43_John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> test; done

          # Dev (Luke):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep 42_Luke | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> valid; done

          # Train (remaining data):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep -v 42_Luke | grep -v 43_John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train; done

        done

          # tokenize
          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                      | ${tokenizer} -l en -no-escape > ${prefix}.txt
             fi
          done

        
        echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

        elif [[ "${corpus}" == "bible" ]]; then
        for sub_directory in new_testament ; do
          # Test (John):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep 43_John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> test; done

          # Dev (Luke):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep 42_Luke | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> valid; done
        done

        for sub_directory in new_testament old_testament intro ; do
          # Train (remaining data):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep -v 42_Luke | grep -v 43_John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train; done

        done

          # tokenize
          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                      | ${tokenizer} -l en -no-escape > ${prefix}.txt
             fi
          done

        
        echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}


     elif [[ "${corpus}" == "ptb" ]]; then
        wget --quiet --continue "http://www.fit.vutbr.cz/~imikolov/rnnlm/simple-examples.tgz"
        tar -xzf simple-examples.tgz
        mv simple-examples/data/ptb.train.txt train.txt
        mv simple-examples/data/ptb.test.txt test.txt
        mv simple-examples/data/ptb.valid.txt valid.txt
        rm simple-examples.tgz
        #mv simple-examples/data/ptb.char.train.txt .
        #mv simple-examples/data/ptb.char.test.txt .
        #mv simple-examples/data/ptb.char.valid.txt .
        #rm -rf simple-examples
        echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

     elif [[ "${corpus}" == "wikitext2" ]]; then
        wget --quiet --continue "https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-2-v1.zip"
        unzip -q wikitext-2-v1.zip
        mv wikitext-2/wiki.train.tokens train.txt
        mv wikitext-2/wiki.valid.tokens valid.txt
        mv wikitext-2/wiki.test.tokens test.txt
        rm wikitext-2-v1.zip
        rm -r wikitext-2
        echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}


     elif [[ "${corpus}" == "enwiki8" ]]; then

        wget --continue "http://mattmahoney.net/dc/enwik8.zip"
        python ${prep_enwik}
        rm enwik8.zip
        rm *.raw
        echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

     fi

     elif [[ "${lang}" == "grn" ]]; then
     if [[ "${corpus}" == "NT" ]]; then

                
        for sub_directory in new_testament ; do
          # Test (John):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -e "JHN" | xargs cat | cut -f2  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > test

          # Dev (Luke):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -e "LUK" | xargs cat | cut -f2  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > valid

          # Train (remaining data):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -ve "\(JHN\|LUK\)" | xargs cat | cut -f2  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > train

        done

          # tokenize
          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                    | ${jsalt_data}/Other/grn/grn-spa/preprocess/scripts/normalize-apos-grn.perl | ${tokenizer} -l grn -no-escape > ${prefix}.txt
             fi
          done

        
        echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

     elif [[ "${corpus}" == "all" ]]; then

        for sub_directory in new_testament ; do
          # Test (John):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -e "JHN" | xargs cat | cut -f2  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > test

          # Dev (Luke):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -e "LUK" | xargs cat | cut -f2  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > valid
        done

        for sub_directory in new_testament old_testament ; do

          # Train (remaining data):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -ve "\(JHN\|LUK\)" | xargs cat | cut -f2  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > train

        done

          # tokenize
          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                     | ${jsalt_data}/Other/grn/grn-spa/preprocess/scripts/normalize-apos-grn.perl | ${tokenizer} -l grn -no-escape > ${prefix}.txt
             fi
          done

          echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}
     fi

  elif [[ "${lang}" == "ess" ]]; then

     if [[ "${corpus}" == "NT" ]]; then

     grep "_John_" ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/new.testament.parallel.tsv | cut -f2 | sed 's/--/ & /g'| sed 's/\s\s*/ /g' | grep -v '^$' > test
     grep "_Luke_" ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/new.testament.parallel.tsv | cut -f2 | sed 's/--/ & /g'| sed 's/\s\s*/ /g' | grep -v '^$' > valid
     grep -v "_Luke_" ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/new.testament.parallel.tsv | grep -v "_John_" | cut -f2 | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'> train

               # tokenize
          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                     | ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/scripts/normalize-apos-ess.perl | ${tokenizer} -l ess -no-escape > ${prefix}.txt
             fi
          done

          echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}


     elif [[ "${corpus}" == "all" ]]; then

     grep "_John_" ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/new.testament.parallel.tsv | cut -f2 | sed 's/--/ & /g'| sed 's/\s\s*/ /g' | grep -v '^$' > test
     grep "_Luke_" ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/new.testament.parallel.tsv | cut -f2 | sed 's/--/ & /g'| sed 's/\s\s*/ /g' | grep -v '^$' > valid
     grep -v "_Luke_" ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/new.testament.parallel.tsv | grep -v "_John_" | cut -f2 | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'> train

     for dir in elementary_primers/level1.kallagneghet-drumbeats elementary_primers/level2.akiingqwaghneghet-echoes elementary_primers/level3.suluwet-whisperings nagai \
          sivuqam_nangaghnegha/sivuqam_volume1 sivuqam_nangaghnegha/sivuqam_volume2 sivuqam_nangaghnegha/sivuqam_volume3 ungipaghaghlanga; do

        cat ${jsalt_data}/Inuit-Yupik/ess/monolingual_corpus/${dir}/*.gold.ess/*.ess.txt | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train

      done

          # tokenize
          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                     | ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/scripts/normalize-apos-ess.perl | ${tokenizer} -l ess -no-escape > ${prefix}.txt
             fi
          done

          echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

     fi

    elif [[ "${lang}" == "esu" ]]; then

     if [[ "${corpus}" == "NT" ]]; then

       for sub_directory in new_testament ; do
         ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/ | grep John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> test; done

          # Dev (Luke):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/ | grep Luke | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> valid; done

          # Train (remaining data):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/ | grep -v Luke | grep -v John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train; done
         done

          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                     | ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/scripts/normalize-apos-esu.perl | ${tokenizer} -l esu -no-escape > ${prefix}.txt
             fi
          done

        echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

     elif [[ "${corpus}" == "all" ]]; then
      for sub_directory in new_testament ; do
        ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/ | grep John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> test; done

        # Dev (Luke):
        ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/ | grep Luke | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> valid; done
      done

       for sub_directory in intro new_testament old_testament ; do
          # Train (remaining data):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/ | grep -v Luke | grep -v John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/esuBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train; done
      done


          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                     | ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/scripts/normalize-apos-esu.perl | ${tokenizer} -l esu -no-escape > ${prefix}.txt
             fi
          done

          echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}
      fi

           elif [[ "${lang}" == "spa" ]]; then
      if [[ "${corpus}" == "NT" ]]; then
                
        for sub_directory in new_testament ; do
          # Test (John):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -e "JHN" | xargs cat | cut -f3  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > test

          # Dev (Luke):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -e "LUK" | xargs cat | cut -f3  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > valid

          # Train (remaining data):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -ve "\(JHN\|LUK\)" | xargs cat | cut -f3  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > train

        done

          # tokenize
          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                    | ${tokenizer} -l es -no-escape > ${prefix}.txt
             fi
          done
        
        echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

     elif [[ "${corpus}" == "all" ]]; then

        for sub_directory in new_testament ; do
          # Test (John):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -e "JHN" | xargs cat | cut -f3  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > test

          # Dev (Luke):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -e "LUK" | xargs cat | cut -f3  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' > valid
        done

        for sub_directory in new_testament old_testament ; do

          # Train (remaining data):
          find ${jsalt_data}/Other/grn/grn-spa/${sub_directory}/*.tsv | grep -ve "\(JHN\|LUK\)" | xargs cat | cut -f3  | sed 's/¶[A-Z]/ &/g' | sed 's/--/ & /g'| sed "s/'/ʼ/g" | sed 's/\*f\*\*//g' | sed 's/\*..\*/ /g' | sed 's/\*//g' | sed 's/¶//g' |sed 's/\s\s*/ /g' |grep -v '^$' >> train

        done

          # tokenize
          for prefix in train valid test
          do
              if [ -f "${prefix}.txt" ]; then
            echo "${prefix}.txt exists."
              else
            cat ${prefix} \
                     | ${tokenizer} -l es -no-escape > ${prefix}.txt
             fi
          done

          echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

        fi

        elif [[ "${lang}" == "iku" ]]; then

         if [[ "${corpus}" == "NT" ]]; then

        for sub_directory in new_testament ; do
          ls ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/ | grep JHN | while read line; do cat ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> test; done
          
          # Dev (Luke):
          ls ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/ | grep LUK | while read line; do cat ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> valid; done
          
          # Train (remaining data):
          ls ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/ | grep -v LUK | grep -v JHN | while read line; do cat ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train; done
        done


              # tokenize
              for prefix in train valid test
              do
                  if [ -f "${prefix}.roman" ]; then
                echo "${prefix}.roman exists."
                  else
                cat ${prefix} \
                         | uniconv -encode Inuktitut-ICI > ${prefix}.roman 
                 fi
              done

              for prefix in train valid test
              do
                  if [ -f "${prefix}.txt" ]; then
                echo "${prefix}.txt exists."
                  else
                cat ${prefix}.roman \
                         | ${jsalt_data}/Inuit-Yupik/iku/Hansard/NunavutHansard-SentenceAligned-v3-pre-release2/split/romanized_iu/convert_2_utf8.pl \
                         | ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/scripts/normalize-apos_monolingual.perl \
                         | ${tokenizer} -l iku -no-escape > ${prefix}.txt
                 fi
              done

          echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}


          elif [[ "${corpus}" == "all" ]]; then
            for sub_directory in new_testament ; do
              ls ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/ | grep JHN | while read line; do cat ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> test; done
              
              # Dev (Luke):
              ls ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/ | grep LUK | while read line; do cat ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> valid; done
              

            done


            # add old testament texts to train 
            for sub_directory in new_testament old_testament; do
              # Train (remaining data):
              ls ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/ | grep -v LUK | grep -v JHN | while read line; do cat ${jsalt_data}/Inuit-Yupik/iku/bible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train; done
            done


              # tokenize
              for prefix in train valid test
              do
                  if [ -f "${prefix}.roman" ]; then
                echo "${prefix}.roman exists."
                  else
                cat ${prefix} \
                         | uniconv -encode Inuktitut-ICI > ${prefix}.roman 
                 fi
              done


              for prefix in train valid test
              do
                  if [ -f "${prefix}.txt" ]; then
                echo "${prefix}.txt exists."
                  else
                cat ${prefix}.roman \
                         | ${jsalt_data}/Inuit-Yupik/iku/Hansard/NunavutHansard-SentenceAligned-v3-pre-release2/split/romanized_iu/convert_2_utf8.pl \
                         | ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/scripts/normalize-apos_monolingual.perl \
                         | ${tokenizer} -l iku -no-escape > ${prefix}.txt
                 fi
              done

              echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

        fi

    fi

}


task tokenize
    :: lang=$lang
    :: corpus=$corpus
    :: condition=(Tokenize: word morpheme morfessor bpe character)    
    :: bpe_size=(Tokenize: word morpheme morfessor bpe=(BPE: 500 5k) character)   
     < jsalt_data=$dir@JSALT_NPLM_data 
     < train_in=$train@data
     < valid_in=$valid@data
     < test_in=$test@data
     < apply_bpe=@subword_nmt
     < learn_bpe=@subword_nmt
     > train="train.txt"
     > valid="valid.txt"
     > test="test.txt"
     > dir="."
{
  if [[ "${condition}" == "word" ]]; then
     ln -s ${train_in} train.txt
     ln -s ${valid_in} valid.txt
     ln -s ${test_in} test.txt

  elif [[ "${condition}" == "morpheme" ]]; then
     if [[ "${lang}" == "grn" ]]; then
         if [[ "${corpus}" == "NT" ]]; then
             cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/fst/train.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > train.txt
             cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/fst/valid.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > valid.txt
             cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/fst/test.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > test.txt

         elif [[ "${corpus}" == "all" ]]; then
             cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/fst/train.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > train.txt
             cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/fst/valid.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > valid.txt
             cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/fst/test.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > test.txt

         fi
     elif [[ "${lang}" == "ess" ]]; then
        if [[ "${corpus}" == "NT" ]]; then
             cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/fst/train.tok.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > train.txt
             cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/fst/valid.tok.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > valid.txt
             cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/fst/test.tok.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > test.txt

        elif [[ "${corpus}" == "all" ]]; then
             cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/fst/train.tok.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > train.txt
             cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/fst/valid.tok.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > valid.txt
             cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/fst/test.tok.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > test.txt
        fi

     elif [[ "${lang}" == "esu" ]]; then
        echo "WARNING: We don't actually have ${lang} ${condition} data"
        touch ${train} ${valid} ${test}
    elif [[ "${lang}" == "iku" ]]; then
        echo "WARNING: We don't actually have ${lang} ${condition} data"
        touch ${train} ${valid} ${test}
     fi
  elif [[ "${condition}" == "morfessor" ]]; then
      if [ -f "morfessor.model"]; then
          echo "Morfessor-train has already been run."
      else
          morfessor-train --logfile=morfessor.log -s morfessor.model ${train_in}
      fi

      cat ${train_in} | sed 's/^\(.*\)$/\1 ¶/g' > train.pilcrow
      cat ${valid_in} | sed 's/^\(.*\)$/\1 ¶/g' > valid.pilcrow
      cat ${test_in} | sed 's/^\(.*\)$/\1 ¶/g' > test.pilcrow

      for prefix in train valid test
      do
        if [ -f  "${prefix}.morf" ]; then
            echo "Morfessor-segment has already been run."
        else
          morfessor-segment -l morfessor.model ${prefix}.pilcrow >> ${prefix}.morf
        fi
      done

      for prefix in train valid test
      do
      if [ -f  "${prefix}.txt" ]; then
            echo "Morfessor-segment has already been run."
        else
           sed ':a;N;$!ba;s/\n/ _ /g' ${prefix}.morf | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > ${prefix}.txt
        fi
      done

   elif [[ "${condition}" == "bpe" ]]; then

       if [[ "${bpe_size}" == "500" ]]; then

        echo "Running BPE 500" > log

        # train BPE
        if [ -f "bpe.500" ]; then
            echo "bpe.500 exists."
        else
            ${learn_bpe} -s 500 --total-symbols -i ${train_in} > bpe.500 2>> log
        fi

        # apply BPE
        if [ -f "train.bpe" ]; then
            echo "train.bpe exists."
        else
            ${apply_bpe} -c bpe.500 -i ${train_in} > train.bpe 2>> log
        fi

        if [ -f "valid.bpe" ]; then
            echo "valid.bpe exists."
        else
            ${apply_bpe} -c bpe.500 -i ${valid_in} > valid.bpe 2>> log
        fi

        if [ -f "test.bpe" ]; then
            echo "test.txt exists."
        else
            ${apply_bpe} -c bpe.500 -i ${test_in} > test.bpe 2>> log
        fi

        for prefix in train valid test; do
          cat ${prefix}.bpe | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' | grep -v '^$' > ${prefix}.txt
        done

       elif [[ "${bpe_size}" == "5k" ]]; then

        echo "Running BPE 5000" > log

        # train BPE
        if [ -f "bpe.5000" ]; then
            echo "bpe.5000 exists."
        else
            ${learn_bpe} -s 5000 --total-symbols -i ${train_in} > bpe.5000 2>> log
        fi

        # apply BPE
        if [ -f "train.bpe" ]; then
            echo "train.bpe exists."
        else
            ${apply_bpe} -c bpe.5000 -i ${train_in} > train.bpe 2>> log
        fi

        if [ -f "valid.bpe" ]; then
            echo "valid.bpe exists."
        else
            ${apply_bpe} -c bpe.5000 -i ${valid_in} > valid.bpe 2>> log
        fi

        if [ -f "test.bpe" ]; then
            echo "test.bpe exists."
        else
            ${apply_bpe} -c bpe.5000 -i ${test_in} > test.bpe 2>> log
        fi

        for prefix in train valid test; do
          cat ${prefix}.bpe | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' | grep -v '^$' > ${prefix}.txt
        done

       fi

  elif [[ "${condition}" == "character" ]]; then
       cat ${train_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v '^ *$' > ${train} 
       cat ${valid_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v '^ *$' > ${valid}
       cat ${test_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v '^ *$' > ${test}

  fi

}

task train
    :: lang=$lang
    :: corpus=$corpus
    :: condition=@tokenize  
    :: bpe_size=@tokenize
  < train=@tokenize
  < valid=@tokenize
  < test=@tokenize
  < dir=@tokenize
  < activate=@awd_lstm_lm
  < main=@awd_lstm_lm
  > log  
  > err 
  > model="model.pt" 
{

  source ${activate}
  export CUDA_VISIBLE_DEVICES=7
  if [[ "${condition}" == "word" ]]; then

     python ${main} --cuda --epochs 200 --data ${dir} --save ${model} --dropouth 0.2 --seed 1882 \
        > ${log} \
        2> ${err}

    elif [[ "${condition}" == "morpheme" ]]; then
    python ${main} --cuda --epochs 200 --data ${dir} --save ${model} --dropouth 0.2 --seed 1882 \
        > ${log} \
        2> ${err}


    elif [[ "${condition}" == "morfessor" ]]; then
    python ${main} --cuda --epochs 200 --data ${dir} --save ${model} --dropouth 0.2 --seed 1882 \
        > ${log} \
        2> ${err}

    elif [[ "${condition}" == "bpe" ]]; then
    python ${main} --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 \
        --dropouth 0.1 --dropouti 0.1 --dropout 0.4 --wdrop 0.2 --wdecay 1.2e-6 --bptt 200 --batch_size 128 --optimizer adam \
        --lr 1e-3 --data ${dir} --save ${model} --when 25 35 \
        > ${log} \
        2> ${err}

    elif [[ "${condition}" == "character" ]]; then
    python ${main} --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 \
        --dropouth 0.1 --dropouti 0.1 --dropout 0.4 --wdrop 0.2 --wdecay 1.2e-6 --bptt 200 --batch_size 128 --optimizer adam \
        --lr 1e-3 --data ${dir} --save ${model} --when 25 35 \
        > ${log} \
        2> ${err}

  fi

}


task ppl
   :: lang=$lang
   :: corpus=$corpus
   :: condition=@tokenize  
   :: bpe_size=@tokenize
  < log=@train
  < test=@tokenize
  > token_loss
  > ppl_log
  > token_cnt
  
{
    cat ${log} | grep "test loss" | awk -F " " '{print $8}' > ${token_loss}
    echo "<eos> count: $(wc ${test} | awk -F " " '{print $1}')" > ${ppl_log}
    echo "Word count: $(wc ${test} | awk -F " " '{print $2}')" >> ${ppl_log}
    echo "Test token count: $(echo $(wc ${test} | awk -F " " '{print $1}') + $(wc ${test} | awk -F " " '{print $2}') | bc -l)" >> ${ppl_log}
    echo "$(echo $(wc ${test} | awk -F " " '{print $1}') + $(wc ${test} | awk -F " " '{print $2}') | bc -l)" > ${token_cnt}
  
}  

task char_ppl
   :: lang=$lang
   :: corpus=$corpus
   :: condition=@tokenize  
   :: bpe_size=@tokenize
 < token_loss=@ppl
 < token_cnt=@ppl
 < char_cnt=@data
 > character_perplexity
{

    echo -e "${lang}\t${corpus}\t${condition}\t${bpe_size}" > ${character_perplexity}
    echo "Token-level loss: $(cat ${token_loss})" >> ${character_perplexity}
    echo "Token count: $(cat ${token_cnt})" >> ${character_perplexity}
    echo "Char-level loss: $(echo $(cat ${token_loss})*$(cat ${token_cnt})/$(cat ${char_cnt}) | bc -l)" >> ${character_perplexity}
    echo Char-level ppl: $(echo "e($(cat ${token_loss})*$(cat ${token_cnt})/$(cat ${char_cnt}))" | bc -l) >> ${character_perplexity}
}

plan {

      #reach data via (Lang: eng ) * (DataCondition: all NT )
      #reach tokenize via (Lang: * ) * (DataCondition: *) * (Tokenize:  morfessor  ) * (BPE: *)
      #reach train via (Lang: * ) * (DataCondition: *) * (Tokenize: bpe) * (BPE: 5k)
      reach char_ppl via (Lang: *) * (DataCondition: *) * (Tokenize: bpe) * (BPE: 500)
}