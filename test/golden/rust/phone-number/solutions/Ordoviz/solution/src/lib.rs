pub fn number(input: &str) -> Option<String> {
    let cleaned: String = input
        .chars()
        .filter(|c| !c.is_ascii_punctuation() && !c.is_whitespace())
        .collect();
    if cleaned.chars().any(|c| !c.is_ascii_digit()) {
        None
    } else {
        match cleaned.len() {
            11 => if cleaned.starts_with('1') {
                    validate(cleaned[1..].to_string())
                } else {
                    None
                },
            10 => validate(cleaned),
            _ => None
        }
    }
}

fn validate(input: String) -> Option<String> {
    if &input[0..1] < "2" || &input[3..4] < "2" {
        None
    } else {
        Some(input)
    }
}
