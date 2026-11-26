export const primeFactors = (num) => {
	const factors = []

	while (num % 2 === 0) {
		factors.push(2)
		num /= 2
	}

	for (let i = 3; i <= num; i += 2) {
		while (num % i === 0) {
			factors.push(i)
			num /= i
		}
	}

	return factors
}
