export function accumulate<T>(list: T[], accumulator: (x: T) => T): T[] {
	return list.map(accumulator);
}
