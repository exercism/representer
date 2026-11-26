pub fn is_valid(code: &str) -> bool {
    let mut len = 0;
    let mut odd = true;
    let mut sum = 0;
    for c in code.chars().rev() {
        match c {
            '0'..='9' => {
                let mut number: u32 = c.to_digit(10).unwrap();
                if odd {
                    sum += number;
                    odd = false;
                } else {
                    number *= 2;
                    if number > 9 {
                        number -= 9;
                    }
                    sum += number;
                    odd = true;
                }
                len += 1;
            }
            ' ' => continue,
            _ => return false,
        }
    }
    if len < 2 {
        return false;
    }
    sum % 10 == 0
}
