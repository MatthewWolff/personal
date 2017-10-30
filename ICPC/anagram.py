# def isAnagram(str1, str2):

    # make letter order uniform
    raw_a = sorted(str1)
    raw_b = sorted(str2)

    # remove non-letters
    a_list = [x if x.isalnum() and not x.isdigit() else "" for x in raw_a]
    b_list = [x if x.isalnum() and not x.isdigit() else "" for x in raw_b]

    # make sure case doesn't matter
    a = "".join(a_list).lower()
    b = "".join(b_list).lower()

    return (a == b)
