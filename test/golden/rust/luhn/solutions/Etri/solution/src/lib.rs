/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    if code.chars().any(|ch| !ch.is_digit(10) && ch != ' ') {
        return false;
    }

    let iter = code.chars()
    .filter_map(|ch| ch.to_digit(10)).rev().enumerate()
    .map(|(idx, digit)| {
        match idx % 2 {
            1 => digit * 2,
            _ => digit,
        }
    }).map(|n| { if n > 9 { n - 9 } else { n } });

    iter.clone().count() > 1 && iter.sum::<u32>() % 10 == 0
}
