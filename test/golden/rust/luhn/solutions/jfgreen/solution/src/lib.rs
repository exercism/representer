pub fn is_valid(number: &str) -> bool {

    let digits: Vec<Option<u32>> = number.chars()
        .filter(|&c| !c.is_whitespace())
        .map(|c| c.to_digit(10))
        .collect();

    if digits.iter().any(Option::is_none) || digits.len() < 2 {
        return false;
    }

    digits.iter()
        .map(|c| c.unwrap())
        .rev()
        .enumerate()
        .map(|(i, d)| if i % 2 == 1 { d * 2 } else { d })
        .map(|d| if d > 9 { d-9 } else { d })
        .sum::<u32>() % 10 == 0
}