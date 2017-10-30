import itertools


def cbs(s, t, itr=1, reuse=False, reusing=None):
    """Method to generate possible composed bit strings when given two starting composed bit strings.
    This method can do multiple iterations of the CBS construction, and reuse previously generated strings"""
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
        cbs_strings_b = cbs_strings + reusing if reusing else cbs_strings  # union of old and new since reusing
        pairs = tuple({x for x in itertools.product(cbs_strings_b, cbs_strings_b)})
        for pair in pairs:
            my_ret += cbs(pair[0], pair[1], itr - 1, reuse=True, reusing=cbs_strings_b)
    else:
        cbs_strings_b = cbs_strings
        pairs = tuple({x for x in itertools.product(cbs_strings_b, cbs_strings_b)})
        for pair in pairs:
            my_ret += cbs(pair[0], pair[1], itr - 1)

    return tuple(set(my_ret))  # unique


def _cbs(pair):
    return "0{0}1{1}".format(pair[0], pair[1]), "1{0}0{1}".format(pair[0], pair[1])


possible = cbs("", "", itr=2, reuse=True)
print len(possible), possible
