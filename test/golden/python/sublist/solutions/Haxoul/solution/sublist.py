"""
This exercise stub and the test suite contain several enumerated constants.

Since Python 2 does not have the enum module, the idiomatic way to write
enumerated constants has traditionally been a NAME assigned to an arbitrary,
but unique value. An integer is traditionally used because it’s memory
efficient.
It is a common practice to export both constants and functions that work with
those constants (ex. the constants in the os, subprocess and re modules).

You can learn more here: https://en.wikipedia.org/wiki/Enumerated_type
"""

# Possible sublist categories.
# Change the values as you see fit.
SUBLIST = 2
SUPERLIST = 3
EQUAL = 4
UNEQUAL = 5


def sublist(list_one, list_two):
    if list_one == list_two:
        return 4
    elif len(list_one) < len(list_two):
        if sublist_test(list_one, list_two):
            return 2
        else:
            return 5
    elif len(list_one) > len(list_two):
        if sublist_test(list_two, list_one):
            return 3
        else:
            return 5
    else:
        return 5

def sublist_test(list_A, list_B):
    list_of_subset = []
    for x in range(0, len(list_B) - (len(list_A) - 1)):
        list_of_subset.append(list_B[x:x + len(list_A)])
    if list_A in list_of_subset:
        return True
    pass
