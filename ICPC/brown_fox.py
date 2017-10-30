import re

f = open("input.txt", "rb")
line_num = int(f.readline())
sentences = []
for x in range(0, line_num):
    sentence = f.readline().replace("\n", "")
    sentence = re.sub("[\W\d\s]", "", sentence)  # remove all but letters
    sentence = sorted(set(sentence.lower()))  # unique
    remaining = "abcdefghijklmnopqrstuvwxyz"
    for letter in sentence:  # check
        remaining = re.sub(letter, "", remaining)
    sentences.append("".join(remaining))

for string in sentences:
    if string == "":
        print "pangram"
    else:
        print "missing " + string

f.close()
