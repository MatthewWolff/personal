def euclid(x, y):  # euclidean GCD
    while x is not 0:
        x, y = y, x
        x = x % y
    return y


print euclid(60, 54)
