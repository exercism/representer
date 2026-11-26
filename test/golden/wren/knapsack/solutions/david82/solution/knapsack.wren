class Knapsack {
  static maximumValue(maximumWeight, items) {
    // Number of items
    var n = items.count
    if (n == 0) {
      return 0
    }
    
    // Table to store the maximum value at each n and maximumWeight
    var dp = Fiber.new {
      // Initialize a 2D array with zeros
      var array = []
      for (i in 0..n) {
        var row = []
        for (w in 0..maximumWeight) {
          row.add(0)
        }
        array.add(row)
      }
      Fiber.yield(array)
    }.call()

    // Build the table in a bottom-up manner
    for (i in 1..n) {
      for (w in 0..maximumWeight) {
        if (items[i - 1]["weight"] <= w) {
          dp[i][w] = max(dp[i - 1][w], dp[i - 1][w - items[i - 1]["weight"]] + items[i - 1]["value"])
        } else {
          dp[i][w] = dp[i - 1][w]
        }
      }
    }

    // The last cell of the table is the answer
    return dp[n][maximumWeight]
  }

  static max(a, b) {
    return a > b ? a : b
  }
}
