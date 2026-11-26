/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    let code = code.trim();
    let valid = code.chars().all(|c| c.is_digit(10) || c.is_whitespace()) && code.len() > 1;
    let sum: u32 = code.chars()
        .rev()
        .filter(|c| c.is_digit(10))
        .map(|c| c.to_string().parse::<u32>().unwrap())
        .enumerate()
        .map(|(i, v)| { match i % 2 == 0 {
            false => match 2 * v {
                e @ _ if e > 9 => e - 9,
                e @ _ => e,
            },
            true => v,
        }}).sum();
    valid && sum % 10 == 0
}