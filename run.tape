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
{
	git clone ${url} code
	mv code/* .
}

task en_wiki
  :: url=""
  > train
  > test
  > dev
{

}
