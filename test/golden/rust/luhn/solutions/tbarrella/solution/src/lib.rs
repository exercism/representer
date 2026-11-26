pub fn is_valid(number_str: &str) -> bool {
    let stripped: String = number_str.chars().filter(|&x| x != ' ').collect();
    if stripped.len() <= 1 {
        return false;
    }
    let digits: Result<Vec<_>, _> = stripped.chars().map(|x| x.to_digit(10).ok_or(())).collect();
    if digits.is_err() {
        return false;
    }
    let sum: u32 = digits
        .unwrap()
        .iter()
        .rev()
        .enumerate()
        .map(|(i, x)| x * (i as u32 % 2 + 1))
        .map(|x| if x > 9 { x - 9 } else { x })
        .sum();
    sum % 10 == 0
}