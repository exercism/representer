pub fn number(user_number: &str) -> Option<String> {
    let mut number = user_number.replace(|c: char| !c.is_numeric(), "");

    if number.len() == 11 && number.starts_with("1") {
        number = number[1..].to_string();
    }

    if number.len() == 10 && &number[0..1] >= "2" && &number[3..4] >= "2" {
        Some(number)
    } else {
        None
    }
}
