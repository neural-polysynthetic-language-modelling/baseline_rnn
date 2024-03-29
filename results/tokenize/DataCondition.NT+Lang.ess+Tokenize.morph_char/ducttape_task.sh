# This script will try to run a task *outside* any specified submitter
# Note: This script is for archival; it is not actually run by ducttape
export learn_bpe="/home/hpark129/projects/baseline_RNN/results/subword_nmt/Baseline.baseline/learn_bpe.py"
export ess_fst_bpe_preprocess="/home/hpark129/projects/baseline_RNN/results/fst_data/Baseline.baseline/fst_data/ess_fst_bpe_preprocess.py"
export valid_in="/home/hpark129/projects/baseline_RNN/results/data/DataCondition.NT+Lang.ess/valid.txt"
export fst_dir="/home/hpark129/projects/baseline_RNN/results/fst_data/Baseline.baseline/./fst_data"
export ess_fst_char_preprocess="/home/hpark129/projects/baseline_RNN/results/fst_data/Baseline.baseline/fst_data/ess_fst_char_preprocess.py"
export apply_bpe="/home/hpark129/projects/baseline_RNN/results/subword_nmt/Baseline.baseline/apply_bpe.py"
export train_in="/home/hpark129/projects/baseline_RNN/results/data/DataCondition.NT+Lang.ess/train.txt"
export jsalt_data="/home/hpark129/projects/baseline_RNN/results/JSALT_NPLM_data/Baseline.baseline/data"
export test_in="/home/hpark129/projects/baseline_RNN/results/data/DataCondition.NT+Lang.ess/test.txt"
export train="/home/hpark129/projects/baseline_RNN/results/tokenize/DataCondition.NT+Lang.ess+Tokenize.morph_char/train.txt"
export valid="/home/hpark129/projects/baseline_RNN/results/tokenize/DataCondition.NT+Lang.ess+Tokenize.morph_char/valid.txt"
export test="/home/hpark129/projects/baseline_RNN/results/tokenize/DataCondition.NT+Lang.ess+Tokenize.morph_char/test.txt"
export dir="/home/hpark129/projects/baseline_RNN/results/tokenize/DataCondition.NT+Lang.ess+Tokenize.morph_char/."
export corpus="NT"
export condition="morph_char"
export lang="ess"
export bpe_size="morph_char"

  if [[ "${condition}" == "word" ]]; then
     ln -s ${train_in} train.txt
     ln -s ${valid_in} valid.txt
     ln -s ${test_in} test.txt

  elif [[ "${condition}" == "morpheme" ]]; then
     if [[ "${lang}" == "grn" ]]; then
         if [[ "${corpus}" == "NT" ]]; then
            for prefix in train valid test; do
              cat ${fst_dir}/DataCondition.NT+Lang.grn/${prefix}.txt | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > ${prefix}.txt
            done

         elif [[ "${corpus}" == "all" ]]; then
            for prefix in train valid test; do
              cat ${fst_dir}/DataCondition.all+Lang.grn/${prefix}.txt | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/\*/ /g; s/>/ /g' > ${prefix}.txt
            done

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


  elif [[ "${condition}" == "morph_char" ]]; then
     if [[ "${lang}" == "ess" ]]; then
        if [[ "${corpus}" == "NT" ]]; then
          python ${ess_fst_char_preprocess} -ip=${fst_dir}/DataCondition.NT+Lang.ess/nt.train.analyzed.ess -op=train.txt
          python ${ess_fst_char_preprocess} -ip=${fst_dir}/DataCondition.all+Lang.ess/all.valid.analyzed.ess -op=valid.txt
          python ${ess_fst_char_preprocess} -ip=${fst_dir}/DataCondition.all+Lang.ess/all.test.analyzed.ess  -op=test.txt

        elif [[ "${corpus}" == "all" ]]; then
          for prefix in train valid test; do
            python ${ess_fst_char_preprocess} -ip=${fst_dir}/DataCondition.all+Lang.ess/all.${prefix}.analyzed.ess -op=${prefix}.txt
           done

        fi
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


