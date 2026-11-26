pub fn number(user_number: &str) -> Option<String> {
    Some(user_number.chars().filter(|c| c.is_numeric()).collect::<String>())
        .and_then(|n|
            match n.len() {
                10 => Some(n),
                11 => match n.get(0..1) {
                    Some("1") => n.get(1..).map(|s| s.to_string()),
                    _ => None,
                }
                _ => None,
            })
        .and_then(|n|
            match n.get(0..1) {
                Some("0") | Some("1") => None,
                _ => Some(n),
            })
        .and_then(|n|
            match n.get(3..4) {
                Some("0") | Some("1") => None,
                _ => Some(n),
            })
}
