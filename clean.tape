#!/usr/bin/env ducttape

global {
        ducttape_output="results" # Put all results in a directory called "results"
        ducttape_experimental_multiproc=true
        lang=(Lang: eng grn ess esu iku)
        corpus=(Lang: eng=(DataCondition: all=(EnglishCorpus: bible ptb wikitext2 enwiki8) NT) 
          grn=(DataCondition: all NT)
          ess=(DataCondition: all NT)
          esu=(DataCondition: all NT)
          iku=(DataCondition: all NT))
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
}

task data
     :: lang=$lang
     :: corpus=$corpus
     < jsalt_data=$dir@JSALT_NPLM_data
     < prep_enwik=@awd_lstm_lm
     > train="train.txt"
     > dev="valid.txt"
     > test="test.txt"
     > char_cnt
{
  echo -e "Lang: ${lang}\tcorpus: ${corpus}"
  if [[ "${lang}" == "eng" ]]; then
      if [[ "${corpus}" == "NT" ]]; then

        # Create train.txt dev.txt test.txt for English NT data
        # eng bible for esu
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/train.tc.en train.txt
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/dev.tc.en valid.txt
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/test.tc.en test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

        # eng bible for ess
        # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/train.tc.en train.txt
        # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/dev.tc.en valid.txt
        # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/test.tc.en test.txt
        # echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

     elif [[ "${corpus}" == "bible" ]]; then
        # eng bible for esu
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/train.tc.en train.txt
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/dev.tc.en valid.txt
        ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/test.tc.en test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

        # eng bible for ess
        # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/train.tc.en train.txt
        # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/dev.tc.en valid.txt
        # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/test.tc.en test.txt
        # echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt


     elif [[ "${corpus}" == "ptb" ]]; then
        wget --quiet --continue "http://www.fit.vutbr.cz/~imikolov/rnnlm/simple-examples.tgz"
        tar -xzf simple-examples.tgz
        mv simple-examples/data/ptb.train.txt train.txt
        mv simple-examples/data/ptb.test.txt test.txt
        mv simple-examples/data/ptb.valid.txt valid.txt
        rm simple-examples.tgz
        mv simple-examples/data/ptb.char.train.txt .
        mv simple-examples/data/ptb.char.test.txt .
        mv simple-examples/data/ptb.char.valid.txt .
        rm -rf simple-examples
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

     elif [[ "${corpus}" == "wikitext2" ]]; then
        wget --quiet --continue "https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-2-v1.zip"
        unzip -q wikitext-2-v1.zip
        mv wikitext-2/wiki.train.tokens train.txt
        mv wikitext-2/wiki.valid.tokens valid.txt
        mv wikitext-2/wiki.test.tokens test.txt
        rm wikitext-2-v1.zip
        rm -r wikitext-2
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt


     elif [[ "${corpus}" == "enwiki8" ]]; then

        wget --continue "http://mattmahoney.net/dc/enwik8.zip"
        python ${prep_enwik}
        rm enwik8.zip
        rm *.raw
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt


     fi



  elif [[ "${lang}" == "grn" ]]; then
     if [[ "${corpus}" == "NT" ]]; then
        ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/train.tok.grn train.txt
        ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/valid.tok.grn valid.txt
        ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/test.tok.grn test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

     elif [[ "${corpus}" == "all" ]]; then

        ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/train.tok.grn train.txt
        ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/valid.tok.grn valid.txt
        ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/test.tok.grn test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

     fi

  elif [[ "${lang}" == "ess" ]]; then

     if [[ "${corpus}" == "NT" ]]; then

        ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/train.tok.ess train.txt
        ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/valid.tok.ess valid.txt
        ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/test.tok.ess test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

     elif [[ "${corpus}" == "all" ]]; then

        ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/train.tok.ess train.txt
        ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/valid.tok.ess valid.txt
        ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/test.tok.ess test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

     fi

  elif [[ "${lang}" == "esu" ]]; then

     if [[ "${corpus}" == "NT" ]]; then

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

  elif [[ "${lang}" == "iku" ]]; then

     if [[ "${corpus}" == "NT" ]]; then
        ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/train.tok.iku train.txt
        ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/valid.tok.iku valid.txt
        ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/test.tok.iku test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt


     elif [[ "${corpus}" == "all" ]]; then
        ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/train.tok.iku train.txt
        ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/valid.tok.iku valid.txt
        ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/test.tok.iku test.txt
        echo "$(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $1}') + $(cat test.txt | sed 's/ /_/g; s/\(.\)/\1 /g; s/\s\s*/ /g' | grep -v '^ *$' | wc  | awk -F " " '{print $2}')" | bc -l > char_cnt

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
     < dev_in=$dev@data
     < test_in=$test@data
     > train="train.txt"
     > dev="valid.txt"
     > test="test.txt"
     > dir="."
{
  if [[ "${condition}" == "word" ]]; then
     ln -s ${train_in} train.txt
     ln -s ${dev_in} valid.txt
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
        touch ${train} ${dev} ${test}
    elif [[ "${lang}" == "iku" ]]; then
        echo "WARNING: We don't actually have ${lang} ${condition} data"
        touch ${train} ${dev} ${test}
     fi
  elif [[ "${condition}" == "morfessor" ]]; then
     if [[ "${lang}" == "grn" ]]; then
       if [[ "${corpus}" == "NT" ]]; then
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/mor/train.grn | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > train.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/mor/valid.grn | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > valid.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/mor/test.grn | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > test.txt

       elif [[ "${corpus}" == "all" ]]; then
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/mor/train.grn | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > train.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/mor/valid.grn | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > valid.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/mor/test.grn | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > test.txt

      fi

     elif [[ "${lang}" == "ess" ]]; then
       if [[ "${corpus}" == "NT" ]]; then
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/mor/train.ess | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > train.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/mor/valid.ess | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > valid.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/mor/test.ess | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > test.txt

       elif [[ "${corpus}" == "all" ]]; then
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/mor/train.ess | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > train.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/mor/valid.ess | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > valid.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/mor/test.ess | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > test.txt
       fi

     elif [[ "${lang}" == "esu" ]]; then
       if [[ "${corpus}" == "NT" ]]; then
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/mor/train.esu | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > train.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/mor/valid.esu | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > valid.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/mor/test.esu | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > test.txt

       elif [[ "${corpus}" == "all" ]]; then
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/mor/train.esu | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > train.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/mor/valid.esu | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > valid.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/mor/test.esu | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > test.txt
       fi

     elif [[ "${lang}" == "iku" ]]; then
       if [[ "${corpus}" == "NT" ]]; then
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/mor/train.iku | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > train.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/mor/valid.iku | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > valid.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/mor/test.iku | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > test.txt

       elif [[ "${corpus}" == "all" ]]; then
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/mor/train.iku | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > train.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/mor/valid.iku | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > valid.txt
          sed ':a;N;$!ba;s/\n/ _ /g' ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/mor/test.iku | sed 's/¶/\n/g' | sed 's/^ _ //g' |grep -v '^$' > test.txt
       fi  
       
     fi

   elif [[ "${condition}" == "bpe" ]]; then
       if [[ "${lang}" == "grn" ]]; then

           if [[ "${bpe_size}" == "500" ]]; then

              if [[ "${corpus}" == "NT" ]]; then 
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/bpe/500/train.bpe.500.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/bpe/500/valid.bpe.500.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/bpe/500/test.bpe.500.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt


              elif [[ "${corpus}" == "all" ]]; then 
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/bpe/500/train.bpe.500.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/bpe/500/valid.bpe.500.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/bpe/500/test.bpe.500.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt

              fi

           elif [[ "${bpe_size}" == "5k" ]]; then
              if [[ "${corpus}" == "NT" ]]; then 
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/bpe/5000/train.bpe.5000.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/bpe/5000/valid.bpe.5000.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/bpe/5000/test.bpe.5000.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt


              elif [[ "${corpus}" == "all" ]]; then 
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/bpe/5000/train.bpe.5000.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/bpe/5000/valid.bpe.5000.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/bpe/5000/test.bpe.5000.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt
              fi

           fi

       elif [[ "${lang}" == "ess" ]]; then
           if [[ "${bpe_size}" == "500" ]]; then

              if [[ "${corpus}" == "NT" ]]; then 
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/bpe/500/train.bpe.500.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/bpe/500/valid.bpe.500.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/bpe/500/test.bpe.500.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt


              elif [[ "${corpus}" == "all" ]]; then 
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/bpe/500/train.bpe.500.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/bpe/500/valid.bpe.500.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/bpe/500/test.bpe.500.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt


              fi

           elif [[ "${bpe_size}" == "5k" ]]; then
              if [[ "${corpus}" == "NT" ]]; then 
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/bpe/5000/train.bpe.5000.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/bpe/5000/valid.bpe.5000.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/bpe/5000/test.bpe.5000.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt


              elif [[ "${corpus}" == "all" ]]; then 
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/bpe/5000/train.bpe.5000.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/bpe/5000/valid.bpe.5000.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/bpe/5000/test.bpe.5000.ess | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt
              fi
            fi

       elif [[ "${lang}" == "esu" ]]; then
           if [[ "${bpe_size}" == "500" ]]; then
              if [[ "${corpus}" == "NT" ]]; then 
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/bpe/500/train.bpe.500.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/bpe/500/valid.bpe.500.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/bpe/500/test.bpe.500.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt


              elif [[ "${corpus}" == "all" ]]; then 
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/bpe/500/train.bpe.500.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/bpe/500/valid.bpe.500.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/bpe/500/test.bpe.500.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt


              fi

           elif [[ "${bpe_size}" == "5k" ]]; then
              if [[ "${corpus}" == "NT" ]]; then 
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/bpe/5000/train.bpe.5000.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/bpe/5000/valid.bpe.5000.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/bpe/5000/test.bpe.5000.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt

              elif [[ "${corpus}" == "all" ]]; then 
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/bpe/5000/train.bpe.5000.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/bpe/5000/valid.bpe.5000.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                cat ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/bpe/5000/test.bpe.5000.esu | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt
              fi
            fi

       elif [[ "${lang}" == "iku" ]]; then
            if [[ "${bpe_size}" == "500" ]]; then
                if [[ "${corpus}" == "NT" ]]; then 
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/bpe/500/train.bpe.500.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/bpe/500/valid.bpe.500.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/bpe/500/test.bpe.500.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt

                elif [[ "${corpus}" == "all" ]]; then 
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/bpe/500/train.bpe.500.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/bpe/500/valid.bpe.500.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/bpe/500/test.bpe.500.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt
                fi


              elif [[ "${bpe_size}" == "5k" ]]; then 
                  if [[ "${corpus}" == "NT" ]]; then 
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/bpe/5000/train.bpe.5000.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/bpe/5000/valid.bpe.5000.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/NT/bpe/5000/test.bpe.5000.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt

                  elif [[ "${corpus}" == "all" ]]; then 
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/bpe/5000/train.bpe.5000.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > train.txt
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/bpe/5000/valid.bpe.5000.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > valid.txt
                    cat ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/monolingual/all/bpe/5000/test.bpe.5000.iku | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/@@ _ / /g' > test.txt
                  fi
                fi

          fi

  elif [[ "${condition}" == "character" ]]; then
       cat ${train_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v '^ *$' > ${train} 
       cat ${dev_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v '^ *$' > ${dev}
       cat ${test_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v '^ *$' > ${test}

  fi

}

task train
    :: lang=$lang
    :: corpus=$corpus
    :: condition=@tokenize  
    :: bpe_size=@tokenize
  < train=@tokenize
  < dev=@tokenize
  < test=@tokenize
  < dir=@tokenize
  < activate=@awd_lstm_lm
  < main=@awd_lstm_lm
  > log  
  > err 
  > model="model.pt" 
{

  source ${activate}

  if [[ "${condition}" == "word" ]]; then

    CUDA_VISIBLE_DEVICES=6 python ${main} --cuda --epochs 200 --data ${dir} --save ${model} --dropouth 0.2 --seed 1882 \
        > ${log} \
        2> ${err}

    elif [[ "${condition}" == "morpheme" ]]; then
    CUDA_VISIBLE_DEVICES=6 python ${main} --cuda --epochs 200 --data ${dir} --save ${model} --dropouth 0.2 --seed 1882 \
        > ${log} \
        2> ${err}


    elif [[ "${condition}" == "morfessor" ]]; then
    CUDA_VISIBLE_DEVICES=6 python ${main} --cuda --epochs 200 --data ${dir} --save ${model} --dropouth 0.2 --seed 1882 \
        > ${log} \
        2> ${err}

    elif [[ "${condition}" == "bpe" ]]; then
    CUDA_VISIBLE_DEVICES=6 python ${main} --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 \
        --dropouth 0.1 --dropouti 0.1 --dropout 0.4 --wdrop 0.2 --wdecay 1.2e-6 --bptt 200 --batch_size 128 --optimizer adam \
        --lr 1e-3 --data ${dir} --save ${model} --when 25 35 \
        > ${log} \
        2> ${err}

    elif [[ "${condition}" == "character" ]]; then
    CUDA_VISIBLE_DEVICES=6 python ${main} --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 \
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

      #reach data via (Lang: eng ) * (DataCondition: ptb wikitext2 enwiki8)  * (Tokenize: * ) * (BPE: *)
      #reach tokenize via (Lang: eng ) * (DataCondition: *) * (Tokenize: word morfessor bpe character ) * (BPE: *)
      #reach train via (Lang: iku ) * (DataCondition: *) * (Tokenize: bpe) * (BPE: *)
      reach char_ppl via (Lang: grn) * (DataCondition: *) * (Tokenize: word) * (BPE: *)
}
