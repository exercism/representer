#include "knapsack.h"
int knapsack::maximum_value(int max_weight, const std::vector<Item>& items)
{
    if (max_weight <= 0)
        return 0;
    std::vector<int> dp(static_cast<std::size_t>(max_weight + 1));
    for (auto item: items)
        for (auto weight = max_weight; weight >= item.weight; --weight)
            dp[weight] = std::max(dp[weight], item.value + dp[weight - item.weight]);
    return dp[max_weight];
}
