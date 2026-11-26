pub fn number(user_number: &str) -> Option<String> {
    let digits: String = user_number
        .chars()
        .filter(|c| c.is_ascii_digit())
        .collect::<String>()
        .trim_start_matches('1')
        .into();
    if digits.len() != 10
        || digits
            .chars()
            .enumerate()
            .filter(|&(i, _)| i == 0 || i == 3)
            .any(|(_, c)| !"23456789".contains(c))
    {
        None
    } else {
        Some(digits)
    }
}
