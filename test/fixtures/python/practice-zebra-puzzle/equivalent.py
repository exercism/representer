"""This solution for the Zebra Puzzle is adapted from a solution
by Peter Norvig for the course "Design of Computer Programs" on Udacity.
https://www.udacity.com/course/cs212
"""
from itertools import permutations

def placeholder_0(placeholder_1, placeholder_2):
    return placeholder_1 - placeholder_2 == 1

def placeholder_3(placeholder_1, placeholder_2):
    return abs(placeholder_1 - placeholder_2) == 1

def placeholder_4():
    placeholder_5 = placeholder_6, _, placeholder_8, _, _ = range(5)
    placeholder_9 = list(permutations(placeholder_5))
    placeholder_10 = next(([{placeholder_17: 'Englishman', placeholder_18: 'Spaniard', placeholder_19: 'Ukrainian', placeholder_20: 'Japanese', placeholder_21: 'Norwegian'}[placeholder_11] for placeholder_11 in (placeholder_26, placeholder_36)] for placeholder_12, placeholder_13, placeholder_14, placeholder_15, placeholder_16 in placeholder_9 if placeholder_0(placeholder_13, placeholder_14) for placeholder_17, placeholder_18, placeholder_19, placeholder_20, placeholder_21 in placeholder_9 if placeholder_17 is placeholder_12 if placeholder_21 is placeholder_6 if placeholder_3(placeholder_21, placeholder_16) for placeholder_22, placeholder_23, placeholder_24, placeholder_25, placeholder_26 in placeholder_9 if placeholder_22 is placeholder_13 if placeholder_19 is placeholder_23 if placeholder_24 is placeholder_8 for placeholder_27, placeholder_28, placeholder_29, placeholder_30, placeholder_31 in placeholder_9 if placeholder_28 is placeholder_15 if placeholder_30 is placeholder_25 if placeholder_20 is placeholder_31 for placeholder_32, placeholder_33, placeholder_34, placeholder_35, placeholder_36 in placeholder_9 if placeholder_18 is placeholder_32 if placeholder_27 is placeholder_33 if placeholder_3(placeholder_29, placeholder_34) if placeholder_3(placeholder_28, placeholder_35)))
    return placeholder_10

def placeholder_38():
    placeholder_39, _ = placeholder_4()
    return placeholder_39

def placeholder_40():
    _, placeholder_39 = placeholder_4()
    return placeholder_39
