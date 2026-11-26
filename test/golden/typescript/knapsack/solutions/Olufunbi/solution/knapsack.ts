type Item = {
  weight: number;
  value: number;
};

export function maximumValue({
  maximumWeight,
  items,
}: {
  maximumWeight: number;
  items: Item[];
}): number {
  const n = items.length;

  // Create a DP array, where dp[w] represents the maximum value achievable with weight limit w
  const dp = Array(maximumWeight + 1).fill(0);

  for (let i = 0; i < n; i++) {
    const { weight, value } = items[i];
    // Traverse the DP array backwards to avoid overwriting values in the current iteration
    for (let w = maximumWeight; w >= weight; w--) {
      dp[w] = Math.max(dp[w], dp[w - weight] + value);
    }
  }

  return dp[maximumWeight];
}