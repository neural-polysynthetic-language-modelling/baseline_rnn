for prefix in "train valid test".split():
	with open("all." + prefix + ".analyzed.ess", "r") as fst_analysis:
		with open("all." + prefix + ".analyzed.prerpocessed.ess", "w") as fst_preprocessed:
			for line in fst_analysis:
				tokens = line.split()
				for token in tokens:
					if token.startswith("*"):
						new_token = token[1:] # remove *
						new_character_token = ' '.join(list(new_token)) # tokenize it by character 
						new_character_token = new_character_token.replace("*", "") # remove extra asterisks
						fst_preprocessed.write(new_character_token + " _ ")
					else:
						new_token = token.split(":")[1] # get the fst segmentation 
						new_token = new_token.replace("^", " ")
						new_token = new_token.replace("*", "") # remove extra asterisks
						fst_preprocessed.write(new_token + " _ ")

				fst_preprocessed.write("\n")
			
