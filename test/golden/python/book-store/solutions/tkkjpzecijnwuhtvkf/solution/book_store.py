from typing import Sequence
from collections import Counter

DISCOUNT_MAP = {1: 800, 2: 1520, 3: 2160, 4: 2560, 5: 3000}

def total(basket: Sequence):

    # This is entirely inspired by LoneLune's solution

    counts = Counter(basket)
    groups = []
    
    while group := len(counts):
        # Append an int that represents a group length
        groups.append(group)
        # This reduces the value for each key by one
        counts.subtract(counts.keys())
        # This removes any keys who's value is now 0
        counts = +counts

    while 3 in groups and 5 in groups:
        # The only situation that needs to be refactored is set of 5 and 3 into 4 and 4, which is cheaper
        groups.remove(3)
        groups.remove(5)
        groups += [4,4]
    
    return sum([DISCOUNT_MAP[x] for x in groups])
    
