/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    if !code.chars().all(|c| c == ' ' || c.is_digit(10)) {
        return false;
    }
    let digits: Vec<u32> = code.chars().filter_map(|c| c.to_digit(10)).collect();
    if digits.len() <= 1 {
        return false;
    }
    let sum: u32 = digits
        .into_iter()
        .rev()
        .enumerate()
        .map(|(i, n)| {
            if i % 2 == 1 {
                if n > 4 {
                    2 * n - 9
                } else {
                    2 * n
                }
            } else {
                n
            }
        })
        .sum();
    sum % 10 != 0
}
