import operator
from random import randint, seed


class Flight:
    def __init__(self, time):
        self.launch_time = time
        self.start = [time[0], time[1] - 15]
        self.end = [time[0], time[1] + 15]

    def __repr__(self):
        return str(self.launch_time)

    def __getitem__(self, item):
        return self.launch_time[item]


class Shift:
    def __init__(self, time):
        self.time = time
        """"""""""""""""""
        self.start = [time[0], time[1] - 15]
        self.end = calc_end(self.start, 120)

    def __repr__(self):
        return str(["begin: %s" % self.start, "end: %s" % self.end])

    def __getitem__(self, item):
        return self.time[item]

    def __cmp__(self, other):
        if self[0] < other[0]:
            return 1
        if self[0] > other[0]:
            return -1
        if self[1] < other[1]:
            return 1
        if self[1] > other[1]:
            return -1
        return 0  # they're equal


def calc_end(time, duration):
    end_time = (time[1] + duration) % (24 * 60)
    if end_time != time[1] + duration:
        return [time[0] + 1, end_time]
    return [time[0], end_time]


def greater_than(time1, time2):
    if time1[0] < time2[0]:
        return False
    if time1[0] > time2[0]:
        return True
    if time1[1] < time2[1]:
        return False
    if time1[1] > time2[1]:
        return True
    return False  # they're equal


def r(): return [randint(1, days), randint(30, 23 * 60 + 30)]


def generate_flights(): return [Flight(r()) for __ in range(0, number_of_flights)]


def merge_sort(arr): return sorted(arr, key=operator.itemgetter(0, 1))  # not actually merge sort but lol


def schedule_employees(flight_schedule):
    if len(flight_schedule) is 0:
        return []

    flight_schedule = merge_sort(flight_schedule)

    prev_shift = NULL
    schedule = []

    for flight in flight_schedule:
        if not prev_shift:  # creates a new shift if there are none in the schedule
            prev_shift = Shift(flight)  # make a shift that can handle this flight
            schedule.append(prev_shift)  # add it to the sched
            continue

        curr = schedule[-1]
        if greater_than(flight.end, curr.end):  # if flight is not within the shift
            prev_shift = Shift(flight)  # make a shift that can handle this flight
            schedule.append(prev_shift)  # add it to the sched

    return schedule


NULL = None
if __name__ == "__main__":
    global days, number_of_flights
    """"""""""""""""""""""""""""""
    # edit these
    seed(2)
    days = 7
    number_of_flights = 30
    """"""""""""""""""""""""""""""
    flights = generate_flights()
    # flights = [Flight(x) for x in [[1, 40], [1, 40], [1, 130]]] # [day, minute in day (must be 30-1380)]
    print "flight times:", merge_sort(flights)
    sched = schedule_employees(flights)
    print "schedule:"
    for i, x in enumerate(sched):
        print "\tshift %i:" % (i + 1), str(x)
    print "employees needed:", len(sched)
