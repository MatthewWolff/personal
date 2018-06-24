import math
from random import random


def to_binary(array):
    new_array = []
    for num in array:
        new_array.append(Binary(num))
    return new_array


def make_array(n):
    array = range(n)
    array.append(n)
    return array


def remove_number(array):
    num = select_num(len(array))
    removed = array[num]
    array.pop(num)
    return removed


def select_num(max):
    return int(math.floor(get_rand() * max))


def get_rand():
    rand = random()
    while math.floor(rand) is 1.0:  # not allowed!
        rand = random()
    return rand


def detect_missing(array):
    for index, num in enumerate(array):
        zero_at = find_first_zero(num)

        first = check_first(index, num)
        last = check_last(index, array, num)
        if first is not None:
            return first
        if last is not None:
            return last

        next_num = array[index + 1]
        is_valid = check_next_num(zero_at, num, next_num)
        if is_valid:
            return is_valid


def check_next_num(zero_at, num, next_num):
    if zero_at is None:  # no zeros in chain
        nxt = "0" * len(num)
        print "next num ends in {}, found {}".format(nxt, next_num)
        if next_num.at(len(next_num) - 1) not in "0":
            return num.int_value + 1
    else:
        nxt = "1" + "0" * (len(num) - zero_at - 1)
        print "next num ends in {}, found {}".format(nxt, next_num)
        if next_num.value[-len(nxt):] not in nxt:  # grabs more than one bit, but less than all
            return num.int_value + 1
    return None


def check_first(index, num):
    if index is 0 and num.int_value is not 0:
        return 0
    return None


def check_last(index, array, num):
    has_next = index + 1 < len(array)
    if not has_next:  # if we never found a num
        return num.int_value + 1
    return None


def find_first_zero(num):
    index = len(num)
    for digit in num.rev:
        index -= 1
        if digit is "0":
            return index
    return None


class Binary:
    def __init__(self, num):
        self.int_value = num
        self.value = bin(num)[2:]  # remove 0b
        self.length = len(self.value)
        self.rev = self.value[::-1]

    def __repr__(self):
        return "0b" + self.value

    def __getitem__(self, item):
        return self.at(item)

    def __len__(self):
        return self.length

    def at(self, num):
        if num < self.length:
            return self.value[num]
        else:
            raise ValueError("index {} is greater than len {}".format(num, self.length - 1))


if __name__ == "__main__":
    arr = make_array(10)
    missing = remove_number(arr)
    arr = to_binary(arr)
    print arr
    detected = detect_missing(arr)
    print "removed", missing, "- detected a missing", detected
