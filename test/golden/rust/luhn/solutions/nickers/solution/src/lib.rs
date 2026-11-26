/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    let mut control_sum = 0;
    let mut min_length_exceeded = false;
    for (i, c) in code.chars().rev().filter(|c| c!=&' ').enumerate() {
        control_sum += match c.to_digit(10) {
            Some(x) => match i % 2 {
                0 => x,
                1 => if x*2>9 { x*2-9 } else { x*2 },
                _ => return false,
            },
            None => return false,
        };
        min_length_exceeded = i >= 1
    }
    min_length_exceeded && control_sum % 10 == 0
}
