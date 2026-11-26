export function accumulate<T>(list: T[], accumulator: (_: T) => T): T[] {
  return list.map(accumulator);
}
