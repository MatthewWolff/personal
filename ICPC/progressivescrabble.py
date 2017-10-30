import sys
1
values = list(" abcdefghijklmnopqrstuvwxyz")
for i in xrange(int(sys.stdin.readline())):
    my_input = sys.stdin.readline().replace("\n", "")  # read in line
    encrypt = True if my_input[0] is "e" else False  # check if decrypt or encrypt
    my_input = list(my_input[2:len(my_input)])
    my_output = []
    prev = 0
    index = 0

    if encrypt:
        for letter in my_input:
            curr_index = values.index(letter)
            my_output.append((curr_index + prev) % 27)
            prev = (curr_index + prev) % 27
        my_output = [values[x] for x in my_output]
        print "".join(my_output)
    else:
        for letter in my_input:
            curr_index = values.index(letter)
            my_output.append((curr_index - prev) % 27)
            prev = values.index(my_input[index])
            if index is 0:
                index += 1
                continue
            index += 1
        my_output = [values[x] for x in my_output]
        print "".join(my_output)
