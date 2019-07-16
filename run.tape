#!/usr/bin/env ducttape

task pytorch_tutorial
  :: url="https://github.com/pytorch/examples.git"
   > main="main.py"
   > generate="generate.py"
   > activate="/opt/python/3.7/venv/pytorch0.4_cuda10.0/bin/activate"
{

	git clone ${url} code
	mv code/word_language_model/*.py .
	rm -rf code
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
}

task en_wiki
  :: url="https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-2-v1.zip"
  > train="train.txt"
  > test="test.txt"
  > dev="valid.txt"
{
  wget --quiet --continue ${url}
  unzip -q wikitext-2-v1.zip
  mv wikitext-2/wiki.train.tokens train.txt
  mv wikitext-2/wiki.valid.tokens valid.txt
  mv wikitext-2/wiki.test.tokens test.txt
  rm wikitext-2-v1.zip
  rm -r wikitext-2
}

task enwik8
  :: url="http://mattmahoney.net/dc/enwik8.zip"
  > train="train.txt"
  > test="test.txt"
  > dev="valid.txt"
  < prep_enwik=@awd_lstm_lm
{
  wget --continue ${url}
  python ${prep_enwik}
  rm enwik8.zip
  rm *.raw
}

task ptb
  :: url="http://www.fit.vutbr.cz/~imikolov/rnnlm/simple-examples.tgz"
  > train="train.txt"
  > test="test.txt"
  > dev="valid.txt"
  > train_char="ptb.char.train.txt"
  > test_char="ptb.char.test.txt"
  > dev_char="ptb.char.valid.txt"
{
  wget --quiet --continue ${url}
  tar -xzf simple-examples.tgz
  mv simple-examples/data/ptb.train.txt train.txt
  mv simple-examples/data/ptb.test.txt test.txt
  mv simple-examples/data/ptb.valid.txt valid.txt
  rm simple-examples.tgz
  mv simple-examples/data/ptb.char.train.txt .
  mv simple-examples/data/ptb.char.test.txt .
  mv simple-examples/data/ptb.char.valid.txt .
  rm -rf simple-examples

}

task ptb_char
  :: url="http://www.fit.vutbr.cz/~imikolov/rnnlm/simple-examples.tgz"
  < train_char=@ptb
  < test_char=@ptb
  < dev_char=@ptb
  > train="train.txt"
  > test="test.txt"
  > dev="valid.txt"
{
  mv ${train_char} train.txt
  mv ${test_char} test.txt
  mv ${dev_char} valid.txt
}
