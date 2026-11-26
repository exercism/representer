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
SUBLIST   = 0b001
SUPERLIST = 0b010
EQUAL     = 0b011
UNEQUAL   = 0b000


def sublist(list_one, list_two):
    str_one = f',{",".join(str(n) for n in list_one)},'
    str_two = f',{",".join(str(n) for n in list_two)},'
    
    bits = 0
    if len(list_one) == 0 or str_one in str_two:
        bits ^= SUBLIST
    if len(list_two) == 0 or str_two in str_one:
        bits ^= SUPERLIST

    return bits
