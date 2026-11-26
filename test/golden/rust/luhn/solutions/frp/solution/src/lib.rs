use std::cmp;

pub fn is_valid(code: &str) -> bool {
    let mut sum = 0;
    let mut count = 0;
    for (i, digit_opt) in code.chars().filter(|c| *c != ' ')
                            .map(|d| d.to_digit(10)).rev().enumerate() {
        if let Some(digit) = digit_opt {
            sum += if i % 2 == 1 {
                if digit * 2 > 9 { digit * 2 - 9 }  else { digit * 2 }
            } else { digit };
            count += 1;
        } else {
            return false;
        }
    }
    sum % 10 == 0 && count > 1
}