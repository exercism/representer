pub fn is_valid(s: &str) -> bool {
    let mut digits = 0usize;
    let mut total_odd = 0usize;
    let mut total_even = 0usize;

    for c in s.chars() {
        if c == ' ' {
            continue;
        }

        let digit = match c.to_digit(10) {
            Some(d) => d,
            None => return false,
        } as usize;

        digits += 1;

        if digits & 1 != 0 {
            total_odd += wrapped(digit);
            total_even += digit;
        } else {
            total_odd += digit;
            total_even += wrapped(digit);
        }
    }

    digits > 1 && if digits & 1 == 0 {
        total_odd % 10 == 0
    } else {
        total_even % 10 == 0
    }
}

fn wrapped(n: usize) -> usize {
    let temp = n * 2;
    if temp > 9 {
        temp - 9
    } else {
        temp
    }
}