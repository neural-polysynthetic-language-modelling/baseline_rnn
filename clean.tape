#!/usr/bin/env ducttape

global {
        ducttape_output="results" # Put all results in a directory called "results"

        lang=(Lang: eng spa grn ckt ess esu iku esk kal)
        corpus=(Lang: eng=(DataCondition: all=(EnglishCorpus: bible ptb wikitext2 enwiki8) NT) 
                      spa=(DataCondition: all NT)
		      grn=(DataCondition: all NT)
		      ckt=(DataCondition: all NT)
		      ess=(DataCondition: all NT)
		      esu=(DataCondition: all NT)
		      iku=(DataCondition: all NT)
		      esk=(DataCondition: all NT)
		      kal=(DataCondition: all NT)) # is kal the same as iku labrador?
	

}


task JSALT_NPLM_data
  :: url="git@github.com:dowobeha/JSALT_NPLM_data.git"
   > dir="data"
{
	git clone ${url} data
}



task data
     :: lang=$lang
     :: corpus=$corpus
     < jsalt_data=$dir@JSALT_NPLM_data
#      > train="train.txt"
#      > dev="valid.txt"
#      > test="test.txt"
{
	echo -e "Lang: ${lang}\tCorpus: ${corpus}"

	if [[ "${lang}" == "eng" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      # Create train.txt dev.txt test.txt for English NT data
	      # eng bible for esu
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/train.tc.en train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/dev.tc.en valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/test.tc.en test.txt

	      # eng bible for ess
	      # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/train.tc.en train.txt
	      # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/dev.tc.en valid.txt
	      # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/test.tc.en test.txt

	      
	   elif [[ "${corpus}" == "bible" ]]; then
	   	  # eng bible for esu
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/train.tc.en train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/dev.tc.en valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/test.tc.en test.txt

	      # eng bible for ess
	      # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/train.tc.en train.txt
	      # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/dev.tc.en valid.txt
	      # ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/test.tc.en test.txt
	      
	      
	   elif [[ "${corpus}" == "ptb" ]]; then

	      echo

	   elif [[ "${corpus}" == "wikitext2" ]]; then

	      echo

	   elif [[ "${corpus}" == "enwiki8" ]]; then

	      echo
	   
	   fi

	elif [[ "${lang}" == "spa" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/NT/train.tc.spa train.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/NT/valid.tc.spa valid.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/NT/test.tc.spa test.txt

	   elif [[ "${corpus}" == "bible" ]]; then

	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/all/train.tc.spa train.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/all/valid.tc.spa valid.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/all/test.tc.spa test.txt

	   fi

	elif [[ "${lang}" == "grn" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/NT/train.tc.grn train.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/NT/valid.tc.grn valid.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/NT/test.tc.grn test.txt

	   elif [[ "${corpus}" == "bible" ]]; then

	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/all/train.tc.grn train.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/all/valid.tc.grn valid.txt
	      ln -s ${jsalt_data}/Other/grn/grn-spa/preprocess/output/all/test.tc.grn test.txt

	   fi

	elif [[ "${lang}" == "ckt" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo "WARNING: We don't actually have ${lang} NT data"

	   elif [[ "${corpus}" == "bible" ]]; then

	      ln -s ${jsalt_data}/Other/ckt/audio/preprocess/output/train.tok.ckt train.txt
	      ln -s ${jsalt_data}/Other/ckt/audio/preprocess/output/valid.tok.ckt valid.txt
	      ln -s ${jsalt_data}/Other/ckt/audio/preprocess/output/test.tok.ckt test.txt

	   fi

	elif [[ "${lang}" == "ess" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/train.tc.ess train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/dev.tc.ess valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/NT/test.tc.ess test.txt

	   elif [[ "${corpus}" == "bible" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/train.tc.ess train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/dev.tc.ess valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/ess/parallel_corpus/new_testament/preprocess/output/all/test.tc.ess test.txt

	   fi

	elif [[ "${lang}" == "esu" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/train.tc.esu train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/dev.tc.esu valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/NT/test.tc.esu test.txt

	   elif [[ "${corpus}" == "bible" ]]; then

	      
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/train.tc.esu train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/dev.tc.esu valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esu/parallel_corpus/bible/preprocess/output/all/test.tc.esu test.txt

	   fi

	elif [[ "${lang}" == "esk" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/esk/preprocess/output/NT/train.esk train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esk/preprocess/output/NT/dev.esk valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/esk/preprocess/output/NT/test.esk test.txt


	   elif [[ "${corpus}" == "bible" ]]; then

	      echo "WARNING: We don't actually have ${lang} bible data"

	   fi

	elif [[ "${lang}" == "iku" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/NT/train.iku train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/NT/dev.iku valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/NT/test.iku test.txt


	   elif [[ "${corpus}" == "bible" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/all/train.iku train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/all/dev.iku valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/iku/bible_preprocess/output/all/test.iku test.txt

	   fi

	elif [[ "${lang}" == "kal" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      ln -s ${jsalt_data}/Inuit-Yupik/iku_labr/bible_preprocess/output/NT/train.iku_labr train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/iku_labr/bible_preprocess/output/NT/dev.iku_labr valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/iku_labr/bible_preprocess/output/NT/test.iku_labr test.txt

	   elif [[ "${corpus}" == "bible" ]]; then

	   	  ln -s ${jsalt_data}/Inuit-Yupik/iku_labr/bible_preprocess/output/all/train.iku_labr train.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/iku_labr/bible_preprocess/output/all/dev.iku_labr valid.txt
	      ln -s ${jsalt_data}/Inuit-Yupik/iku_labr/bible_preprocess/output/all/test.iku_labr test.txt

	      #echo "WARNING: We don't actually have ${lang} bible data"

	      #touch ${train} ${dev} ${test}

	   fi

	fi

}



task tokenize
    :: lang=$lang
    :: corpus=$corpus
    :: condition=(Tokenize: word morpheme morfessor bpe character)    
    :: bpe_size=(Tokenize: word morpheme morfessor bpe=(BPE: 500 1k 5k 15k 30k 60k) character)    
    :: space_is_token=(SpaceIsToken: False True)
    :: end_of_word_is_token=(EndOfWordIsToken: False True)
#     < train_in=$train@data
#     < dev_in=$dev@data
#     < test_in=$test@data
#     > train="train.txt"
#     > dev="dev.txt"
#     > test="test.txt"
{

}



plan {

      reach data via (Lang: *) * (DataCondition: *) * (EnglishCorpus: *) * (Tokenize: *) * (BPE: *)
}
