/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    if code.trim() != code || code.len() <= 1 {
        return false;
    }
    let mut chars: Vec<u32> = vec![];
    for c in code.chars() {
        if c == ' ' {
            continue;
        }
        match c.to_digit(10) {
            Some(n) => chars.push(n),
            None => return false,
        }
    }
    let mut result = 0;
    let mut is_even = false;
    for i in chars.iter().rev() {
        result = result
            + if is_even {
                let mut m = i * 2;
                while m >= 10 {
                    m = m % 10 + m / 10;
                }
                m
            } else {
                *i
            };
        is_even = !is_even
    }
    result % 10 == 0
}
