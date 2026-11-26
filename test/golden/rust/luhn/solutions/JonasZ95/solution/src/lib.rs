fn double_digit(n: u8) -> u8 {
    let result = n*2;
    if result > 9 {
        result - 9
    } else {
        result
    }
}

pub fn is_valid(s: &str) -> bool {
    let mut nums = Vec::<u8>::new();
    for num in s.chars().filter(|c| !c.is_whitespace()) {
        match num.to_digit(10) {
            Some(n) => nums.push(n as u8),
            None => return false
        };
    }

    if nums.len() <= 1 {
        return false
    }

    let doubled_sum: usize = nums.iter().rev().enumerate().map(|(i, n)| {
        if i % 2 != 0 {
            double_digit(*n) as usize
        } else {
            *n as usize
        }
    }).sum();

    doubled_sum % 10 == 0
}