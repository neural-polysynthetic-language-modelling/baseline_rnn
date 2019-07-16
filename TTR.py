import glob
import argparse
import re

def TTR_path(txt_path):
    paths = glob.glob(txt_path)
    print(paths)
    all_tokens = []
    pattern = re.compile(r".+\t") # ignore line numbers, etc.
    for path in paths:
        print(path)
        with open(path, 'r') as txt:
            tokens = txt.read()
            tokens = re.sub(pattern, "", tokens).split()
            tokens = [token for token in tokens if token != "."]
            print(tokens[:10])
            all_tokens.extend(tokens)
    n_tokens = len(all_tokens)
    types = set(all_tokens)
    n_types= len(types)
    print('Type: {}, Token: {}, TTR: {}'.format(n_types, n_tokens,
        round(n_types/n_tokens, 4)))

if __name__ == "__main__":
    argparser = argparse.ArgumentParser(description='Calcaulate TTR for text files')
    argparser.add_argument('file_path', type=str, help='path to the txt file e.g. ./data/ptb/*.txt')
    args = argparser.parse_args()
    TTR_path(args.file_path)
