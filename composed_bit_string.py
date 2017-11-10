import itertools

# Consider the following inductive definition of a composed bit string of 0's and 1's.
#
# Foundation: The empty bit string is a composed bit string.
# Constructor: If s and t are composed bit strings, then so are 0s1t and 1s0t.
#
# Part a: List the composed bit strings that can be created with just one application of the constructor rule.
# Part b: List the composed bit strings that can be created by applying the constructor rule to bit strings that
#  can be created with one or zero applications of the constructor rule. (Hint: there are 16 distinct bit strings.)

def cbs(s, t, itr=1, reuse=False, reusing=None):
    """
    Method to generate possible composed bit strings when given two starting composed bit strings.
    This method can do multiple iterations of the CBS construction, and reuse previously generated strings.
    - s, t are the starting strings.
    - itr is the number of applications of the Composed Bit String constructor.
    - reuse is a boolean indicating whether previously constructed strings will be considered.
    - reusing is a private variable. Do not touch it.
    """
    # generate all possible pairs
    if reuse:
        if reusing:
            use = set([s] + [t] + list(reusing))
            pairs = tuple({x for x in itertools.product(use, use)})  # set ensures uniqueness of pairs
        else:
            reusing = tuple({s, t})
            pairs = tuple({x for x in itertools.product([s, t], [s, t])})
    else:
        pairs = tuple({x for x in itertools.product([s, t], [s, t])})  # set ensures uniqueness of pairs

    # generate the strings possible
    cbs_strings = []
    for pair in (map(_cbs, pairs)):
        for string in pair:
            cbs_strings.append(string)
    cbs_strings = tuple(set(cbs_strings))  # unique

    if itr is 1:
        return cbs_strings

    # generate all possible pairs from our new strings (a lot...)
    my_ret = tuple()
    if reuse:
        cbs_strings = cbs_strings + reusing if reusing else cbs_strings  # union of old and new since reusing
        pairs = tuple({x for x in itertools.product(cbs_strings, cbs_strings)})
        for pair in pairs:
            my_ret += cbs(pair[0], pair[1], itr - 1, reuse=True, reusing=cbs_strings)
    else:
        pairs = tuple({x for x in itertools.product(cbs_strings, cbs_strings)})
        for pair in pairs:
            my_ret += cbs(pair[0], pair[1], itr - 1)

    return tuple(set(my_ret))  # unique


def _cbs(pair):
    return "0{0}1{1}".format(pair[0], pair[1]), "1{0}0{1}".format(pair[0], pair[1])


# Two empty strings are valid Constructed Bit Strings and the base case. itr = number of applications.
# If checking for 0 or 1 applications, use itr=1 and reuse=True. If only looking for 1 application, reuse = False
possible = cbs("", "", itr=2, reuse=True)
print len(possible), possible
