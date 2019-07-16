import re
import pickle

def isAlpha(character):
    if character.lower() != character.upper(): 
        return True
    else:
        return False

def grapheme_tokenizer(word):
    graphemes = ['ngngw', 'ghhw', 'ngng', 'ghh', 'ghw',
                 'ngw', 'gg', 'gh', 'kw', 'll', 'mm',
                 'ng', 'nn', 'qw', 'rr', 'wh', 'a', 'e',
                 'f', 'g', 'h', 'i', 'k', 'l', 'm', 'n',
                 'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
                 'y', 'z']
    result = []
    word = word.lower() # use lowercase
    end = len(word)
    while end > 0:
        found_grapheme = False
        for grapheme in graphemes:
            if word[0:end].endswith(grapheme):
                result.insert(0, grapheme)
                end -= len(grapheme)
                found_grapheme = True
                break
                
        if not found_grapheme:
            character = word[end-1: end]
            if isAlpha(character):
                result.insert(0, character)
            elif character != '':
                result.insert(0, character)
            end -= 1
            
    return result

# Yupik syllables must be of the form:
#
# * CV
# * CVC
# * CVV
# * CVVC
#
# Additionally, the first syllable of a word may be of the form:
#
# * V
# * VC
# * VV
# * VVC
#
# Where C represents a Yupik consonant and V represents a Yupik vowel.
# 
#
# In all cases, the only instances of VV that are allowed are:
#
# * ii
# * aa
# * uu
#
#
# Yupik words may contain apostrophe (to separate otherwise ambiguous grapheme sequences).
#
def convert_to_CV(graphemes):
    V = ['i', 'a', 'u', 'e']
    VV = ['i', 'a', 'u']
    new_graphemes = []
    result = []
    # Convert graphemes to consonant "C" or vowel "V"
    i = 0
    while i < len(graphemes):
        if graphemes[i] in VV:
            if i+1 < len(graphemes):
                if graphemes[i] == graphemes[i+1]:
                    result.append('VV')
                    new_graphemes.append(graphemes[i] + graphemes[i+1])
                    i += 2
                else:
                    result.append('V')
                    new_graphemes.append(graphemes[i])
                    i += 1
            else:
                result.append('V')
                new_graphemes.append(graphemes[i])
                i += 1
        elif graphemes[i] in V:
            result.append('V')
            new_graphemes.append(graphemes[i])
            i += 1
        else:
            result.append('C')
            new_graphemes.append(graphemes[i])
            i += 1
    return result, new_graphemes 

def syllable_tokenizer(graphemes):
    result = []
    syllable = []
    c_v, new_graphemes = convert_to_CV(graphemes)
    for i in range(0, len(c_v)):
        if c_v[i] == "C":
            if i == 0:
                syllable.append(new_graphemes[i])
            elif i == len(c_v)-1:
                syllable.append(new_graphemes[i])
                result.append(syllable)
                syllable = []
            else:
                if c_v[i+1] == "C":
                    syllable.append(new_graphemes[i])
                    result.append(syllable)
                    syllable = []
                elif c_v[i-1] == "V":
                    result.append(syllable)
                    syllable = []
                    syllable.append(new_graphemes[i])
                elif c_v[i-1] == "C":
                    syllable.append(new_graphemes[i])
                    
        else:
            if i == len(c_v)-1:
                syllable.append(new_graphemes[i])
                result.append(syllable)
                syllable = []
            else:
                syllable.append(new_graphemes[i])
    
    final = []
    for grapheme in result:
        final.append(''.join(grapheme))
            
    return final

if __name__ == "__main__":
	for f_name in "train valid test".split():
	    with open("../data/ess_grapheme/" + f_name + ".txt", "wb") as out_text:  
	        with open("../data/ess/" + f_name + ".txt", "r") as in_text:
	            result = []
	            for line in in_text:
	                l = []
	                words = line.split()
	                for word in words:
	                    l.extend(grapheme_tokenizer(word) + [' '])
	                if len(l) > 0:
	                    if l[-1] == " ":
	                        l[-1] = "\n"
	                    result.append(l)
	            pickle.dump(result, out_text)  
	for f_name in "train valid test".split():
	    with open("../data/ess_syllable/" + f_name + ".txt", "wb") as out_text:  
	        with open("../data/ess/" + f_name + ".txt", "r") as in_text:
	                result = []
	                for line in in_text:
	                    l = []
	                    words = line.split()
	                    for word in words:
	                        gs = grapheme_tokenizer(word)
	                        ss = syllable_tokenizer(gs)
	                        l.extend(ss + [' '])
	                    if len(l) > 0:
	                        if l[-1] == " ":
	                            l[-1] = "\n"
	                        result.append(l)
               		pickle.dump(result, out_text) 