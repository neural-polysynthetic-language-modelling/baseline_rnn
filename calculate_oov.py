import os
import argparse
from collections import Counter

def calculate_oov_rate(in_file):
	assert os.path.exists(in_file + "/train.txt")
	with open(in_file + "/train.txt", "r") as train_set:
		train_dic = Counter()
		for line in train_set:
			words = line.split() + ['<eos>']
			for word in words:
				train_dic[word] += 1

	oov_list = []
	tokens = 0
	assert os.path.exists(in_file + "/test.txt")
	with open(in_file + "/test.txt", "r") as test_set:
		for line in test_set:
			words = line.split() + ['<eos>']
			for word in words:
				if word not in train_dic:
					oov_list.append(word)
				tokens += 1
	print(oov_list)
	print("Number of OoV: {}".format(len(oov_list)))
	print("Number of tokens in the test set: {}".format(tokens))
	print("Oov Ratio: {}%".format(len(oov_list)/tokens*100))

if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--path', '-p', type=str, required=True, 
		help= 'path to the directory with the train and test datasets e.g. ptb')
	args = parser.parse_args()
	calculate_oov_rate(args.path)