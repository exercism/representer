export function accumulate<T>(list: T[], accumulator: (value: T) => any): T[] {
  const results: T[] = []

  list.forEach(item => {
    results.push(accumulator(item))
  })

  return results
}
