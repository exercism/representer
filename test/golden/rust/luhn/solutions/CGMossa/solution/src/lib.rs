/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    code.chars()
        .rev()
        .try_fold((0, 0), |acc, symbol| match symbol {
            ' ' => Some(acc),
            '0'..='9' => {
                let number = symbol.to_digit(10).unwrap();
                if acc.0 % 2 == 0 {
                    Some((acc.0 + 1, acc.1 + number))
                } else {
                    let number = number.checked_mul(2)?;
                    Some((
                        acc.0 + 1,
                        acc.1 + if number > 9 { number - 9 } else { number },
                    ))
                }
            }
            _ => None,
        })
        .map_or(false, |(luhn_length, luhn_sum)| {
            luhn_length >= 2 && luhn_sum % 10 == 0
        })
}
