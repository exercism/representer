"""optimising what to steal from an apartment which honestly feels like a very strange assignment."""

import itertools

def maximum_value(maximum_weight, items):

    n_items = len(items)
    w_total = 1000000
    v_total = 0

    mitnehmen = []

    for n in range(0, 8):

        if n_items - n >= 0:

            "first: make a list of all possible combinations of items when leaving x items behind"
            mitnehmen = list(itertools.combinations(items, n_items - n))
    
            "second: loop over these combinations, calculate weight and value and find the highest value"
            for combo in mitnehmen:
                w = 0
                v = 0
                for item in combo:
                    w = w + item["weight"]
                    v = v + item["value"]
                if w <= maximum_weight:
                    if v > v_total:
                        v_total = v

    return v_total
