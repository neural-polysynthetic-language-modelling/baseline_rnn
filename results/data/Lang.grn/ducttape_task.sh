# This script will try to run a task *outside* any specified submitter
# Note: This script is for archival; it is not actually run by ducttape
export tokenizer="/home/hpark129/projects/baseline_RNN/results/mosesdecoder/Baseline.baseline/tokenizer.perl"
export jsalt_data="/home/hpark129/projects/baseline_RNN/results/JSALT_NPLM_data/Baseline.baseline/data"
export prep_enwik="/home/hpark129/projects/baseline_RNN/results/awd_lstm_lm/Baseline.baseline/./data/enwik8/prep_enwik8.py"
export train="/home/hpark129/projects/baseline_RNN/results/data/Lang.grn/train.txt"
export valid="/home/hpark129/projects/baseline_RNN/results/data/Lang.grn/valid.txt"
export test="/home/hpark129/projects/baseline_RNN/results/data/Lang.grn/test.txt"
export char_cnt="/home/hpark129/projects/baseline_RNN/results/data/Lang.grn/char_cnt"
export corpus="all"
export lang="grn"

  echo -e "Lang: ${lang}\tcorpus: ${corpus}"
  if [[ "${lang}" == "eng" ]]; then
      if [[ "${corpus}" == "NT" ]]; then

        # Create train.txt dev.txt test.txt for English NT data
        # eng bible for esu

        for sub_directory in new_testament ; do
          # Test (John):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> test; done

          # Dev (Luke):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep Luke | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> valid; done

          # Train (remaining data):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep -v Luke | grep -v John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train; done

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
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> test; done

          # Dev (Luke):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep Luke | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> valid; done
        done

        for sub_directory in new_testament old_testament intro ; do
          # Train (remaining data):
          ls ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory} | grep -v Luke | grep -v John | while read line; do cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/engBible/${sub_directory}/$line | sed "s/^[0-9]\+ //g" | sed 's/--/ & /g'| sed 's/\s\s*/ /g' |grep -v '^$'>> train; done

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
                      | ${tokenizer} -l ess -no-escape > ${prefix}.txt
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
                      | ${tokenizer} -l ess -no-escape > ${prefix}.txt
             fi
          done

          echo "$(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -w ) + $(cat ${test} | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc -l )" | bc -l > ${char_cnt}

     fi

      elif [[ "${lang}" == "esu" ]]; then

     if [[ "${corpus}" == "NT" ]]; then

      # Then run normalize-apos-esu.perl (normalizes apostrophes)
          for prefix in train valid test
          do
              if [ -f "$prefix" ]; then
            echo "$prefix exists."
              else
            cat $prefix | ./${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/scripts/normalize-apos-esu.perl > $data/$prefix.apos
              fi
          done

        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/train.tok.esu train.txt
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/valid.tok.esu valid.txt
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/test.tok.esu test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

     elif [[ "${corpus}" == "all" ]]; then

        
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/train.tok.esu train.txt
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/valid.tok.esu valid.txt
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/test.tok.esu test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

     fi


  fi


