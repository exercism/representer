pub fn number(s: &str) -> Option<String> {
    let mut digits: Vec<char> = s.chars().filter(|c| c.is_ascii_digit()).collect();
    if let Some('1') = digits.first() {
        digits.remove(0);
    }
    if digits.len() != 10 || digits[0] < '2' || digits[3] < '2' {
        return None;
    }
    Some(digits.into_iter().collect::<String>())
}