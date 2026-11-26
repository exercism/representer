class Knapsack
  @maximumValue: ({maximumWeight, items}) ->
    return 0 if maximumWeight is 0 or items.length is 0

    # dp[w] stores the maximum value attainable with capacity w
    dp = (0 for [0..maximumWeight])

    for item in items
      {weight, value} = item
      # Iterate backwards through capacities to avoid using the same item multiple times
      if weight <= maximumWeight
        for w in [maximumWeight..weight] by -1
          dp[w] = Math.max(dp[w], dp[w - weight] + value)

    dp[maximumWeight]

module.exports = Knapsack