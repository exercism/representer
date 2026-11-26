pub fn is_valid(cc_num: &str) -> bool {

	let stripped_string: Vec<char> = cc_num
		.chars()
		.filter(|x| *x != ' ')
		.collect();

	let contains_non_digits = stripped_string
		.iter()
		.any(|x| !x.is_digit(10));

	if contains_non_digits {
		return false
	}

	let final_num: u32 = stripped_string
		.iter()
		.map(|x| x.to_digit(10).unwrap())
		.rev()
		.enumerate()
		.map(|(idx, val)| {
			if idx % 2 != 0 {
				let double = val * 2;
				if double > 9 {
					double - 9
				} else {
					double
				}
			} else {
				val
			}
		})
		.sum();

	return 
		(final_num % 10 == 0) 
		& (cc_num
			.chars()
			.filter(|x| *x != ' ').count() > 1
		)
}