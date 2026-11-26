from itertools import combinations_with_replacement
def find_fewest_coins(coins, target):
    if target < 0:
        raise ValueError("target can't be negative")
    max_coins = 1 + target // min(coins)

    for i in range(max_coins):
        combos = combinations_with_replacement(coins, i)
        for combo in combos:
            if sum(combo) == target:
                return sorted(combo)
    raise ValueError("can't make target with given coins")

# This iteration was copied from RNeilsen's brilliant sollution just so I could keep a register of it.
