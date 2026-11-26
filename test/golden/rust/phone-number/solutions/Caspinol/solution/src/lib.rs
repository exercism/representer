pub fn number(user_number: &str) -> Option<String> {
    let normalised: String = user_number
        .chars()
        .filter(|c| c.is_numeric())
        .enumerate()
        .filter(|(i, c)| !((*i == 0 || *i == 1) && *c == '1'))
        .map(|(_, c)| c)
        .collect();

    let norm_str = normalised.as_bytes();

    if norm_str.len() != 10 {
        None
    } else if norm_str[0] as char == '0' || norm_str[3] as char == '0' || norm_str[3] as char == '1'
    {
        None
    } else {
        Some(normalised)
    }
}
