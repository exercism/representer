export const classify = (n) => {
  if (n < 1)
		throw new Error('Classification is only possible for natural numbers.');

	let facsum = 0;
	for (let i = 1; i <= n/2; i++) {
		if (n % i === 0)
			facsum += i;
	}

	if (facsum === n)
		return 'perfect';
	else if (facsum < n)
		return 'deficient';
	else if (facsum > n)
		return 'abundant';
};
