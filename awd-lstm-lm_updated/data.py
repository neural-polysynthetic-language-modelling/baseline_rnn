import os
import torch

from collections import Counter

class Dictionary(object):
    def __init__(self):
        self.word2idx = {}
        self.idx2word = []
        self.counter = Counter()
        self.total = 0

    def add_word(self, word):
        if word not in self.word2idx:
            self.idx2word.append(word)
            self.word2idx[word] = len(self.idx2word) - 1
        token_id = self.word2idx[word]
        self.counter[token_id] += 1
        self.total += 1
        return self.word2idx[word]

    def __len__(self):
        return len(self.idx2word)


class Corpus(object):
    def __init__(self, path):
        self.dictionary = Dictionary()
        self.train = self.tokenize(os.path.join(path, 'train.txt'))
        self.valid = self.tokenize(os.path.join(path, 'valid.txt'))
        self.test = self.tokenize(os.path.join(path, 'test.txt'))

    def tokenize(self, path):
        """Tokenizes a text file."""
        assert os.path.exists(path)
        if path.endswith("train.txt"):
            # Add words to the dictionary
            with open(path, 'r') as f:
                tokens = 0
                for line in f:
                    words = line.split() + ['<eos>']
                    tokens += len(words)
                    for word in words:
                        self.dictionary.add_word(word)
        else:
            # Do not add words to the dictionary if it's the valid or test set.
            with open(path, 'r') as f:
                tokens = 0
                for line in f:
                    words = line.split() + ['<eos>']
                    tokens += len(words)
                    for word in words:
                        if word not in self.dictionary.word2idx: 
                            self.dictionary.add_word("<unk>")
                        else:
                            self.dictionary.add_word(word)

        # Tokenize file content
        with open(path, 'r') as f:
            ids = torch.LongTensor(tokens)
            token = 0
            for line in f:
                words = line.split() + ['<eos>']
                for word in words:
                    if word not in self.dictionary.word2idx: 
                        ids[token] = self.dictionary.word2idx["<unk>"]
                        token += 1
                    else:
                        ids[token] = self.dictionary.word2idx[word]
                        token += 1

        return ids

if __name__ == '__main__':
    corpus = Corpus("/home/hpark129/projects/baseline_RNN/results/data/DataCondition.NT+Lang.grn")
    print(corpus.train)
    print(corpus.train.unique(sorted=True))
    print(len(corpus.train.unique(sorted=True)))
    print(corpus.valid)
    print(corpus.valid.unique(sorted=True))
    print(len(corpus.valid.unique(sorted=True)))
    print(corpus.test)
    print(corpus.test.unique(sorted=True))
    print(len(corpus.test.unique(sorted=True)))
    print(corpus.dictionary.word2idx["<unk>"])