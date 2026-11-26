{
  maximumValue: (maxw, items) ->
    dp = { i, 0 for i = 0, maxw }
    for item in *items
      for i = maxw, item.weight, -1
        dp[i] = math.max(dp[i], dp[i - item.weight] + item.value)
    dp[maxw]
}
