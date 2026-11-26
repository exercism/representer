pub fn series(digits: &str, len: usize) -> Vec<String> {
    let mut strings = vec![];

    if len > digits.len() {
        return strings;
    }

    for i in 0..(digits.len() - len + 1) {
        strings.push(String::from(&digits[i..(i + len)]));
    }

    strings
}