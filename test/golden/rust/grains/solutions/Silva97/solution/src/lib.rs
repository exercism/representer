pub fn square(s: u32) -> u64 {
    match s {
        1..=64 => u64::pow(2, s-1),
        _=> panic!("Square must be between 1 and 64"),
    }
}

pub fn total() -> u64 {
    let mut sum = 0;

    for i in 1..=64 {
        sum += square(i);
    }

    sum
}
