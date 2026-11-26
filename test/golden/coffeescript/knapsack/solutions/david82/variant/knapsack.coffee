class Knapsack
  @maximumValue: (args) ->
    return 0 if !args.items?.length
    
    # Create a DP table with dimensions [items + 1][weight + 1]
    dp = Array(args.items.length + 1).fill(0).map(-> 
      Array(args.maximumWeight - 1).fill(0)
    )
    
    # Fill the DP table
    for i in [1..args.items.length]
      item = args.items[i - 1]
      for w in [0..args.maximumWeight]
        if item.weight <= w
          # Maximum of either including this item or not including it
          dp[i][w] = Math.max(
            dp[i - 1][w],
            dp[i - 1][w - item.weight] + item.value
          )
        else
          # Can't include this item, take previous best
          dp[i][w] = dp[i - 1][w]
    
    # Return the maximum value possible
    dp[args.items.length][args.maximumWeight]

module.exports = Knapsack
