export function squareRoot(radicand: number): number {
	let left: number = 0
	let right: number = 0xFFF
	while (left <= right) {
		const middle: number = Math.trunc((left + right) / 2)

		if (middle * middle === radicand) {
			return middle
		}
		if (middle * middle > radicand) {
			right = middle - 1
		} else {
			left = middle + 1
		}
	}
	return -1

}
