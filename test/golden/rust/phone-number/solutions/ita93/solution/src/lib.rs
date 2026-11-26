pub fn number(user_number: &str) -> Option<String> {
    let filter_num = user_number.chars().filter(|ch| ch.is_numeric()).collect::<String>();
    //verry naive solution, I think regrex is better approach.
    let mut number_value:u64 = filter_num.parse().unwrap_or(0);
    if number_value / 10000000000 > 1 {
        return None;
    }
    number_value = number_value % 10000000000;
    match filter_num.len() {
        10|11 => {
            if number_value / 1000000000 < 2 { return None;}
            if ((number_value / 1000000) % 10) < 2 {return None;}
            Some(number_value.to_string())
        }
        _ => None,
    }
}
