pub fn number(user_number: &str) -> Option<String> {
    let mut user_number = user_number
        .chars()
        .filter(|&c| c != ' ' && c != '.' && c != '-' && c != '+' && c != '(' && c != ')')
        .collect::<String>();

    if user_number[0..1] == *"1" {
        user_number = user_number[1..].to_string();
    }
    
    if user_number.chars().all(|c| c.is_numeric()) &&
        user_number.len() == 10 &&
        valid_part(&user_number[0..3]) &&
        valid_part(&user_number[3..]) {
        Some(user_number)
    } else {
        None
    }
}

pub fn valid_part(user_number_part: &str) -> bool {
    user_number_part[0..1] != *"1" && user_number_part[0..1] != *"0"
}
