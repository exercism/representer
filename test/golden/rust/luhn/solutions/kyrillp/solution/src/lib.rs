pub fn is_valid(number: &str) -> bool {
    if number.chars().any(|c| !(c.is_ascii_digit() || c == ' ')) {
        return false;
    }

    let digits: Vec<u32> = number.chars().filter_map(|c| c.to_digit(10)).collect();

    if digits.len() <= 1 {
        return false;
    }

    let step_mod = if digits.len() % 2 == 0 { 1 } else { 0 };
    digits
        .into_iter()
        .enumerate()
        .map(|(i, d)| {
            if (i + 1) % 2 == step_mod && d != 9 {
                (d * 2) % 9
            } else {
                d
            }
        })
        .sum::<u32>() % 10 == 0
}