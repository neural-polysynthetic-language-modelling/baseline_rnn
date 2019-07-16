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
		      kal=(DataCondition: all NT))
	

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
#      > dev="dev.txt"
#      > test="test.txt"
{
	echo -e "Lang: ${lang}\tCorpus: ${corpus}"

	if [[ "${lang}" == "eng" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      # Create train.txt dev.txt test.txt for English NT data
	      # ln -s ${jsalt_data}/
	      
	   elif [[ "${corpus}" == "bible" ]]; then

	      echo
	      
	   elif [[ "${corpus}" == "ptb" ]]; then

	      echo

	   elif [[ "${corpus}" == "wikitext2" ]]; then

	      echo

	   elif [[ "${corpus}" == "enwiki8" ]]; then

	      echo
	   
	   fi

	elif [[ "${lang}" == "spa" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo

	   elif [[ "${corpus}" == "bible" ]]; then

	      echo

	   fi

	elif [[ "${lang}" == "grn" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo

	   elif [[ "${corpus}" == "bible" ]]; then

	      echo

	   fi

	elif [[ "${lang}" == "ckt" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo

	   elif [[ "${corpus}" == "bible" ]]; then

	      echo

	   fi

	elif [[ "${lang}" == "ess" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo

	   elif [[ "${corpus}" == "bible" ]]; then

	      echo

	   fi

	elif [[ "${lang}" == "esu" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo

	   elif [[ "${corpus}" == "bible" ]]; then

	      echo

	   fi

	elif [[ "${lang}" == "esk" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo

	   elif [[ "${corpus}" == "bible" ]]; then

	      echo

	   fi

	elif [[ "${lang}" == "iku" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo

	   elif [[ "${corpus}" == "bible" ]]; then

	      echo

	   fi

	elif [[ "${lang}" == "kal" ]]; then

	   if [[ "${corpus}" == "NT" ]]; then

	      echo

	   elif [[ "${corpus}" == "bible" ]]; then

	      echo "WARNING: We don't actually have ${lang} bible data"

	      touch ${train} ${dev} ${test}

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
