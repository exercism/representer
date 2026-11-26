type Item = {
  weight: number
  value: number
}

export function maximumValue({ maximumWeight, items }: { maximumWeight: number, items: Item[] }): number {
  // 2D Array { items, maxvalue }, where items and maxvalue start at index 1, not 0
  let m = Array.from({ length: items.length + 1 }, () => new Array(maximumWeight + 1).fill(0))

  // https://en.wikipedia.org/wiki/Knapsack_problem#0-1_knapsack_problem
  const knapsack = (i: number, j: number, weight: number, value: number): number =>
    !i || !j ? 0 : weight > j ? m[i-1][j] : Math.max(m[i-1][j], m[i-1][j-weight] + value)

  m.forEach((row, i) => row.forEach((_, j) =>
      m[i][j] = knapsack(i, j, items[i-1]?.weight, items[i-1]?.value))
  )

  return m[items.length][maximumWeight]
}
