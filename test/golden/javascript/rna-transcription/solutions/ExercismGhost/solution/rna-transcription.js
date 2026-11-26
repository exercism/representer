const mapping = {
	G: 'C',
	C: 'G',
	T: 'A',
	A: 'U'
};

export const toRna = input => {
	return input
		.split('')
		.map(c => mapping[c])
		.join('');
};
