import sys

for __ in xrange(int(sys.stdin.readline())):
    line = [int(x) for x in sys.stdin.readline().replace("\n", "").split(" ")]
    for num in xrange(len(line)):
        if num is 0:
            continue
        elif num is 1:
            comp = num
        else:
            if line[num] - line[comp] is not 1:
                print num
                break
            else:
                comp = num
