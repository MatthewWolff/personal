_RESET = "\033[0m"
_YELLOW = "\033[33m"
_PURPLE = "\033[35m"
_RED = "\033[31m"


def red(s):
    return _RED + s + _RESET


def yellow(s):
    return _YELLOW + str(s) + _RESET


def purple(s):
    return _PURPLE + str(s) + _RESET


def pop_genetics(pp, pq, qq):
    p = 2 * pp + pq
    q = 2 * qq + pq
    tot = pp + pq + qq
    tot_alleles = 2 * tot

    p_freq = p / float(tot_alleles)
    q_freq = q / float(tot_alleles)

    hw_e = [p_freq ** 2 * tot, 2 * p_freq * q_freq * tot, q_freq ** 2 * tot]
    hw_e = map(int, map(round, hw_e))

    PQ = pq / float(tot)  # = 2pq - 2pq*F     homozygosity is a good indicator of inbreeding
    f = (PQ - 2 * p_freq * q_freq) / float(-2 * p_freq * q_freq)

    print "~" * 50
    print yellow("current population:"), "|AA: {}, Aa: {}, aa: {}|".format(pp, pq, qq)
    print purple("allele frequencies:"), ("p ="), (round(p_freq, 4)), "and", ("q ="), (round(q_freq, 4))
    print red("inbreeding coefficient:"), round(f, 3) if round(f, 3) != 0 else 0.0  # ignore "-0.0"s
    print yellow("equilibrium population:"), "|AA: {}, Aa: {}, aa: {}|".format(hw_e[0], hw_e[1], hw_e[2])
    print "~" * 50
    print


pop_genetics(pp=21, pq=29, qq=10)
pop_genetics(pp=5, pq=5, qq=20)
