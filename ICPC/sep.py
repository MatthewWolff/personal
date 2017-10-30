the_input = "these are the words that you need to separate"
words = the_input.split(" ")
for ind, word in enumerate(words):
    temp = ""
    for w in word:
        temp = w + temp
    words[ind] = temp
print " ".join(words)
