def find_fewest_coins(coins, target):
    if target < 0:
        raise ValueError("target can't be negative")
    MAX_AMOUNT = target + 1
    coin_count = [MAX_AMOUNT] * MAX_AMOUNT
    coin_list = [[]] * MAX_AMOUNT
    coin_count[0] = 0
    for amount in range(1, MAX_AMOUNT):
        for coin in coins:
            if amount >= coin and coin_count[amount - coin] + 1 < coin_count[amount]:
                coin_count[amount] = coin_count[amount + coin] + 1
                coin_list[amount] = [coin] + coin_list[amount - coin]
    if coin_count[target] == MAX_AMOUNT:
        raise ValueError("can't make target with given coins")
    return coin_list[target]
