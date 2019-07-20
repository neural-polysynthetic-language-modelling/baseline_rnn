#!/usr/bin/env ducttape

global {
        ducttape_output="results" # Put all results in a directory called "results"

        lang=(Lang: grn ess esu iku)
        corpus=(Lang: grn=(DataCondition: all NT)
		      ess=(DataCondition: all NT)
		      esu=(DataCondition: all NT)
		      iku=(DataCondition: all NT)
		      
}

task JSALT_NPLM_data
     :: url="git@github.com:dowobeha/JSALT_NPLM_data.git"
      > dir="data"
{
      git clone ${url} data
}

task awd_lstm_lm
     :: url="https://github.com/salesforce/awd-lstm-lm.git"
      > activate="/opt/python/3.7/venv/pytorch0.4_cuda10.0/bin/activate"
      > main="main.py"
      > generate="generate.py"
{
      git clone ${url} code
      mv code/* .
}

task data
     :: lang=$lang
     :: corpus=$corpus
     < jsalt_data=$dir@JSALT_NPLM_data
     > train="train.txt"
     > dev="valid.txt"
     > test="test.txt"
{
	echo -e "Lang: ${lang}\tcorpus: ${corpus}"

	if [[ "${lang}" == "grn" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/train.tok.grn train.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/valid.tok.grn valid.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/test.tok.grn test.txt

	   elif [[ "${corpus}" == "all" ]]; then

	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/train.tok.grn train.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/valid.tok.grn valid.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/test.tok.grn test.txt

	   fi

	elif [[ "${lang}" == "ess" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/train.tok.ess train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/valid.tok.ess valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/NT/test.tok.ess test.txt

	   elif [[ "${corpus}" == "all" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/train.tok.ess train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/valid.tok.ess valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/monolingual/all/test.tok.ess test.txt

	   fi

	elif [[ "${lang}" == "esu" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/train.tok.esu train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/valid.tok.esu valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/NT/test.tok.esu test.txt

	   elif [[ "${corpus}" == "all" ]]; then

	      
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/train.tok.esu train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/valid.tok.esu valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/monolingual/all/test.tok.esu test.txt

	   fi

	elif [[ "${lang}" == "iku" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	   	  echo "WARNING: We don't actually have ${lang} bible data"
	      touch ${train} ${dev} ${test}
	      #ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/NT/train.iku train.txt
	      #ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/NT/dev.iku valid.txt
	      #ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/NT/test.iku test.txt


	   elif [[ "${corpus}" == "all" ]]; then
	   	  echo "WARNING: We don't actually have ${lang} bible data"
	      touch ${train} ${dev} ${test}

	      #ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/all/train.iku train.txt
	      #ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/all/dev.iku valid.txt
	      #ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/all/test.iku test.txt

	   fi

	fi

}



task tokenize
    :: lang=$lang
    :: corpus=$corpus
    :: condition=(Tokenize: word morpheme morfessor bpe character)    
    :: bpe_size=(Tokenize: word morpheme morfessor bpe=(BPE: 500 5k) character)    
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
	   if [[ "${corpus}" == "grn" ]]; then
	   	   if [[ "${lang}" == "NT" ]]; then
	           cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/fst/train.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/>/ /g' > train.txt
	           cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/fst/valid.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/>/ /g' > valid.txt
	           cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/NT/fst/test.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/>/ /g' > test.txt

           if [[ "${lang}" == "all" ]]; then
               cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/fst/train.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/>/ /g' > train.txt
	           cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/fst/valid.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/>/ /g' > valid.txt
	           cat ${jsalt_data}/Other/grn/grn-spa/preprocess/monolingual/all/fst/test.tok.grn | sed 's/^ *//g; s/ *$//g; s/ / _ /g; s/>/ /g' > test.txt

           fi
	   else
		   echo "WARNING: We don't actually have ${lang} ${condition} data"
		   touch ${train} ${dev} ${test}
       fi
    elif [[ "${condition}" == "morfessor" ]]; then
       if [[ "${lang}" == "grn" ]]; then
       	   echo "WARNING: We don't actually have ${lang} ${condition} data"
		   touch ${train} ${dev} ${test}

	   elif [[ "${lang}" == "ess" ]]; then
	   	   echo "WARNING: We don't actually have ${lang} ${condition} data"
		   touch ${train} ${dev} ${test}

	   elif [[ "${lang}" == "esu" ]]; then
	   	   echo "WARNING: We don't actually have ${lang} ${condition} data"
		   touch ${train} ${dev} ${test}

	   elif [[ "${lang}" == "iku" ]]; then
	       echo "WARNING: We don't actually have ${lang} ${condition} data"
		   touch ${train} ${dev} ${test}	   
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
       	   elif [[ "${bpe_size}" == "500" ]]; then
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

	   elif [[ "${lang}" == "iku" ]]; then
		   echo "WARNING: We don't actually have ${lang} ${condition} data"
		   touch ${train} ${dev} ${test}
       fi
       

	elif [[ "${condition}" == "character" ]]; then
       cat ${train_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v "^ *$" h> ${train} 
       cat ${dev_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v "^ *$" > ${dev}
       cat ${test_in} | sed 's/ /_/g; s/\(.\)/\1 /g; s/  */ /g' | grep -v "^ *$" > ${test}
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
	> log=${lang}_${condition}.log 
	> err=${lang}_${condition}.err
	> model=${lang}_${condition}.pt	
{
	if [[ "${condition}" == "word" ]]; then
		CUDA_VISIBLE_DEVICES=3 python ${main} --cuda --epochs 200 --data ${dir} --save ${lang}_${condition}.pt --dropouth 0.2 --seed 1882 \
        > ${lang}_${condition}.log \
        2> ${lang}_${condition}.err

    elif [[ "${condition}" == "morpheme" ]]; then
		CUDA_VISIBLE_DEVICES=3 python ${main} --cuda --epochs 200 --data ${dir} --save ${lang}_${condition}.pt --dropouth 0.2 --seed 1882 \
        > ${lang}_${condition}.log \
        2> ${lang}_${condition}.err


    elif [[ "${condition}" == "morfessor" ]]; then
		CUDA_VISIBLE_DEVICES=3 python ${main} --cuda --epochs 200 --data ${dir} --save ${lang}_${condition}.pt --dropouth 0.2 --seed 1882 \
        > ${lang}_${condition}.log \
        2> ${lang}_${condition}.err

    elif [[ "${condition}" == "bpe" ]]; then
		CUDA_VISIBLE_DEVICES=3 python ${main} --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 \
        --dropouth 0.1 --dropouti 0.1 --dropout 0.4 --wdrop 0.2 --wdecay 1.2e-6 --bptt 200 --batch_size 128 --optimizer adam \
        --lr 1e-3 --data ${dir} --save ${lang}_${condition}.pt --when 25 35 \
        > ${lang}_${condition}.log \
        2> ${lang}_${condition}.err

    elif [[ "${condition}" == "character" ]]; then
		CUDA_VISIBLE_DEVICES=3 python ${main} --cuda --epochs 50 --nlayers 3 --emsize 400 --nhid 1840 --alpha 0 --beta 0 --dropoute 0 \
        --dropouth 0.1 --dropouti 0.1 --dropout 0.4 --wdrop 0.2 --wdecay 1.2e-6 --bptt 200 --batch_size 128 --optimizer adam \
        --lr 1e-3 --data ${dir} --save ${lang}_${condition}.pt --when 25 35 \
        > ${lang}_${condition}.log \
        2> ${lang}_${condition}.err

}
	


#task char_ppl


plan {

      reach data via (Lang: grn ess esu iku) * (DataCondition: *)  * (Tokenize: *) * (BPE: *)
      reach tokenize via (Lang: grn ess esu iku) * (DataCondition: *) * (Tokenize: *) * (BPE: *)
      reach train via (Lang: grn ess esu iku) * (DataCondition: *) * (Tokenize: *) * (BPE: *)
}
