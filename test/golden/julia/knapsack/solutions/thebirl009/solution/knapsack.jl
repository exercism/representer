"""Returns the maximum value that can be carried given a weight capacity and a list o items"""
function maximum_value(capacity::Int, items::Vector)::Int
    # Deal with special cases
    capacity == 0 && return 0
    isempty(items) && return 0

    # Initialize the dp array (dp[i+1] = max value achievable with weight i)
    dp = fill(0, capacity + 1)          # Base case: no items and zero capacity results in zero value
    item_used = fill(-1, capacity + 1)  # Used to track the last item index used for each capacity

    # Fill the dp array using the items
    for (index, item) in enumerate(items)
        weight, value = item
        # Iterate in reverse to prevent using the same item multiple times in this round (0/1 knapsack)
        for i in capacity:-1:weight
            # If using current item gives a better value
            if dp[i - weight + 1] + value > dp[i + 1]
                dp[i + 1] = dp[i - weight + 1] + value
                item_used[i + 1] = index    # Store item index for potential reconstruction
            end
        end
    end

    # The maximum value is stored at dp[capacity + 1]
    return dp[end]
end