pub fn number(user_number: &str) -> Option<String> {
    user_number
        .chars()
        .filter(char::is_ascii_digit)
        .enumerate()
        .filter_map(|(i, c)| if (i, c) == (0, '1') { None } else { Some(c) })
        .enumerate()
        .map(|index_char| match index_char {
            (0, '0') | (0, '1') | (3, '0') | (3, '1') | (10, _) => None,
            (_, c) => Some(c),
        })
        .collect::<Option<String>>()
        .and_then(|n| if n.len() < 10 { None } else { Some(n) })
}
