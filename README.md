We're using https://github.com/pytorch/examples/tree/master/word_language_model as the very basic model.
We're training https://github.com/salesforce/awd-lstm-lm as a more state-of-the-art baseline model.



# Baseline RNN language_model

RNN adapted from https://github.com/pytorch/examples/tree/master/word_language_model

Model parameters similar to Zaremba et al., 2015, Kim et al., 2016, & Gerz et al., 2018

```
> python train.py --data=./data/ckt_mor_cleaned/ --test_path=./data/ckt/ --input=word \
--cuda --save=ckt_mor.pt

Usage: python train.py [options]
                    
Options:
--data             location of the data corpus                                  ./data/
--test_path        location of the test corpus to calculate word or             if not specified, the same as data
                        character-level perplexity 
--model            type of recurrent net (RNN_TANH, RNN_RELU, LSTM, GRU)        LSTM
--input            input level (word, grapheme, bpe, syllable, morfessor, char) word
--emsize           size of word embeddings                                      650
--nhid             number of hidden units per layer                             200
--nlayers          number of layers                                             2
--lr               initial learning rate                                        1
--clip             gradient clipping                                            10
--epochs           upper epoch limit                                            40
--batch_size       batch size                                                   20
--bptt             sequence length                                              35
--dropout          dropout applied to layers (0 = no dropout)                   0.5
--seed             random seed                                                  234
--cuda             use CUDA
--log-interval     report interval                                              200
--save             path to save the final model                                 model.pt
```
## BPE 
subword-nmt: https://github.com/rsennrich/subword-nmt

Segment text into subword units (BPE), by default it builds shared vocabulary of
32,000 tokens.

Preprocessing removes all pairs of sentences that can't be decoded by latin-1
encoder.

## Morfessor
https://github.com/aalto-speech/morfessor

