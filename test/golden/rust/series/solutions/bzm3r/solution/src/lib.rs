pub fn series(digits: &str, len: usize) -> Vec<String> {
    match len <= digits.len() {
        false => Vec::new(),
        true => {
            (0..(digits.len() - len + 1))
                .map(|j| String::from(&digits[j..(j + len)]))
                .collect::<Vec<String>>()
        },
    }
}