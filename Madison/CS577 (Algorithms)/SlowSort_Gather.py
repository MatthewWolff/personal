def SlowSort(array):
    n = len(array)
    if n > 1:
        array = SlowSort(array[:n / 2]) + array[n / 2:]
        array = array[:n / 2] + SlowSort(array[n / 2:])
        array = Gather(array[:])
    return array


def Gather(array):
    n = len(array)
    if n == 2:
        global count
        count += 1
        if array[0] > array[1]:
            array[0], array[1] = array[1], array[0]

    else:
        for i in xrange(n / 4):
            array[i + n / 4], array[i + n / 2] = array[i + n / 2], array[i + n / 4]
        array = Gather(array[:n / 2]) + array[n / 2:]
        array = array[:n / 2] + Gather(array[n / 2:])
        array = array[:n / 4] + Gather(array[n / 4:3 * n / 4]) + array[3 * n / 4:]
    return array


global count
count = 0

k = 5
n = 2 ** k
before = list(reversed(range(n)))
print "before:", before
print "after:", SlowSort(before)
print k, n, count, 3**k - 2**k

# k, n, comparisons
# 1, 2, 1
# 2, 4, 5
# 3, 8, 19
# 4, 16, 65
# 5, 32, 211
# 6, 64, 665
