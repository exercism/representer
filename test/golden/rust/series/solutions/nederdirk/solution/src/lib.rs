use std::iter::FromIterator;

pub fn series(digits: &str, len: usize) -> Vec<String> {
	if len == 0 {
		return vec!["".to_string(); digits.len() + 1];
	}
	digits.chars().collect::<Vec<char>>()
		.windows(len)
		.map(|x| String::from_iter(x))
		.collect()
}