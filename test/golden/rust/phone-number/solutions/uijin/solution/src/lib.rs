pub fn number(user_number: &str) -> Option<String> {
    let digits = user_number.chars().filter(|c| c.is_digit(10));
    let digits = match digits.clone().count() {
        10 => digits.skip(0),
        11 => {
            if digits.clone().nth(0).unwrap() != '1' {
                return None;
            }
            digits.skip(1)
        }
        _ => return None,
    };
    let valid_digit = digits.enumerate().filter(|(i, c)| match i {
        0 | 3 => c.to_digit(10).unwrap() >= 2,
        _ => true,
    });
    if valid_digit.clone().count() < 10 {
        return None;
    }
    let phone_number: String = valid_digit.map(|(_, c)| c).collect();
    Some(phone_number)
}
