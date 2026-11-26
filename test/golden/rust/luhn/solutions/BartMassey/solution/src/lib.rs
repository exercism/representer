/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    let mut digits: Vec<u32> = Vec::new();
    for c in code.chars() {
        if c == ' ' {
            continue;
        }
        match c.to_digit(10) {
            Some(d) => digits.push(d),
            None => return false,
        }
    }
    if digits.len() < 2 {
        return false;
    }
    let l: u32 = digits
        .iter()
        .rev()
        .enumerate()
        .map(|(i, d)| {
            let d = (1 + (i & 1) as u32) * d;
            d % 10 + (d > 9) as u32
        })
        .sum();
    l % 10 == 0
}