/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool
{
	if code.trim().len() < 2 {
		return false;
	}

	fn luhn_digit_calc(d: u32) -> u32 {
		let v = d * 2;
		let rv = if v > 9 {
			v - 9
		} else {
			v
		};
		rv
	}

	let mut sum = 0u32;
	let mut odd = true;
	for ch in code.chars().rev() {
		match ch.to_digit(10) {
			None => {
				if ch != ' ' {
					// only nubmers and spaces allowed
					return false;
				}
			},
			Some(d) => {
				sum += match odd {
					false => luhn_digit_calc(d),
					true  => d
				};
				odd = !odd;
			}
		} // match ch.to_digit
	}
	(sum % 10) == 0
}
