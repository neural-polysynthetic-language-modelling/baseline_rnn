import os
import argparse

def preprocess_fst(fst_file, bpe_file, out_file):
	assert os.path.exists(fst_file)
	print("Opening the fst analyzed file in ", fst_file)
	with open(fst_file, "r") as fst_analysis:
		assert os.path.exists(bpe_file)
		print("Opening the bpe file in ", bpe_file)
		with open(bpe_file, "r") as bpe_text:
			with open(out_file, "w") as fst_preprocessed:
				for fst_line, bpe_line in zip(fst_analysis, bpe_text):
					fst_tokens = fst_line.split()
					bpe_tokens = bpe_line.split(" _ ")
					for fst_token, bpe_token in zip(fst_tokens, bpe_tokens):
						if fst_token.startswith("*"):
							new_token = bpe_token + " _ "
							new_token = new_token.replace("\n _ ", "")
							fst_preprocessed.write(new_token)

						else:
							new_token = fst_token.replace(">", " ")
							fst_preprocessed.write(new_token + " _ ")

					fst_preprocessed.write("\n")

	print("Saved the preprocessed file in ", out_file)


if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--fst_path', '-fp', type=str, required=True, 
		help= 'path to the file with fst output e.g. ess_fst/all.train.analyzed.ess')
	parser.add_argument('--bpe_path', '-bp', type=str, required=True, 
		help= 'path to the file with bpe output e.g. BPE.500+DataCondition.all+Lang.ess+Tokenize.bpe/train.txt')
	parser.add_argument('--out_path', '-op', type=str, required=True, 
		help= 'path to the output file e.g. ess_fst/all.train.analyzed.preprocessed.ess')
	args = parser.parse_args()
	preprocess_fst(args.fst_path, args.bpe_path, args.out_path)