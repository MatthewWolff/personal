import math


def T(iteration):  # temperature function
    return 2 * 0.9 ** iteration


def f(x):  # score function
    return max([4 - abs(x), 2 - abs(x - 6), 2 - abs(x + 6)])


def z_prob():
    for x in 0.102, 0.223, 0.504, 0.493, 0.312, 0.508, 0.982, 0.887:
        yield x


def y_succ():
    for x in 3, 1, 1, 4, 2, 3, 4, 3:
        yield x


def prob(x, y, iteration):
    return math.e ** (-abs(f(x) - f(y)) / T(iteration))


def simulated_annealing():
    # generators to supply values
    z = z_prob()  # our given random probability
    y_val = y_succ()  # our given random y successors

    x = 2  # initial x
    for i in [1, 2, 3, 4, 5, 6, 7, 8]:  # range(1,8) == 0 thru 7 :(
        y = next(y_val)
        _z = next(z)
        print "iter: {0}, current: {1}, temp: {3}," \
              " \tprobability of moving on: {4}".format(i, x, y, round(T(i), 3), round(prob(x, y, i), 4))
        if f(y) > f(x):
            x = y
        else:
            _p = prob(x, y, i)
            if _z <= _p:
                x = y


simulated_annealing()
