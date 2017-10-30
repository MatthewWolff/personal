import sys
from fractions import gcd


def greed(remainder, array, my_index):
    my_sum = remainder // array[my_index]
    remainder = remainder % array[my_index]
    if remainder is 0:
        return my_sum
    return my_sum + greed(remainder, array, my_index - 1)


_ = sys.stdin.readline()  # throwaway
coins = [int(x) for x in sys.stdin.readline().replace("\n", "").split(" ")]
orig = coins[:]
rem = coins[1:]  # remove first coin, given as 1

the_gcd = gcd(rem[0], rem[1])  # initial GCD
for i in xrange(len(rem) - 2):
    the_gcd = gcd(the_gcd, rem[i + 2])

if the_gcd is not 1:
    print "canonical"
else:
    offset = 2
    initial_remainder = 2 * (coins[-offset])
    while initial_remainder >= (coins[-1]):
        initial_remainder = 2 * (coins[-offset])
        initial_greedy = greed(initial_remainder, coins, len(coins) - 1)
        for n in xrange(len(coins) - 1):
            coins = coins[:len(coins) - 1]
            new_greedy = greed(initial_remainder, coins, len(coins) - 1)
            if initial_greedy > new_greedy:
                print "non-canonical"
                exit(0)
        coins = orig
        if offset < len(coins) - 1:
            offset += 1
        else:
            break
    print "canonical"
