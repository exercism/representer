pub fn is_valid(s: &str) -> bool {
    if s.chars().any(|c| !(c.is_digit(10) || c.is_whitespace())) {
        return false;
    }
    
    let digits: Vec<_> = s.chars()
        .filter_map(|c| c.to_digit(10))
        .collect();

    if digits.len() <= 1 {
        return false;
    }

    digits.into_iter()
        .rev()
        .enumerate()
        .fold(0, |acc, (i, x)| {
            let v = if i % 2 == 0 || x == 9 { x } else { (x * 2) % 9 };
            acc + v
        }) % 10 == 0
}