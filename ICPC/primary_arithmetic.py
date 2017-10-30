import sys

while 1:

    nums = sys.stdin.readline().replace("\n", "")
    line = nums.split(" ")
    int1 = line[0]
    int2 = line[1]
    carry_count = 0

    if int1 == "0" and int2 == "0":
        break  # end of output

    int1_list = list(int1)
    int2_list = list(int2)

    if len(int1_list) >= len(int2_list):
        large = [int(i) for i in int1_list]
        small = [int(i) for i in int2_list]
    else:
        large = [int(i) for i in int2_list]
        small = [int(i) for i in int1_list]

    small.reverse()
    large.reverse()
    while len(small) < len(large):
        small.append(0)
    summation = [0] * (len(large) + 1)  # one bigger than the largest

    for digit in range(0, len(large)):
        summation[digit] = small[digit] + large[digit]
    for digit in range(0, len(summation)):
        if summation[digit] > 9:
            carry_count += 1
            summation[digit] = summation[digit] % 10
            summation[digit + 1] += 1

    summation.reverse()
    # print "summation: %d" % int("".join([str(i) for i in summation]))
    # print "actual: %d" % (int(int1) + int(int2))

    if carry_count is 0:
        print "No carry operation."
    elif carry_count is 1:
        print "1 carry operation."
    else:
        print "%s carry operations." % carry_count
