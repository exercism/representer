pub fn encode(n: u64) -> String {
    fn separate(n: u64, u: u64, l: &str) -> String {
        if n % u == 0 {
            encode(n / u) + " " + l
        } else {
            encode(n / u) + " " + l + " " + &encode(n % u)[..]
        }
    }
    match n {
        0 => "zero".to_string(),
        1 => "one".to_string(),
        2 => "two".to_string(),
        3 => "three".to_string(),
        4 => "four".to_string(),
        5 => "five".to_string(),
        6 => "six".to_string(),
        7 => "seven".to_string(),
        8 => "eight".to_string(),
        9 => "nine".to_string(),
        10 => "ten".to_string(),
        11 => "eleven".to_string(),
        12 => "twelve".to_string(),
        13 => "thirteen".to_string(),
        15 => "fifteen".to_string(),
        18 => "eighteen".to_string(),
        10..=19 => encode(n % 10) + "teen",
        20 => "twenty".to_string(),
        30 => "thirty".to_string(),
        40 => "forty".to_string(),
        50 => "fifty".to_string(),
        80 => "eighty".to_string(),
        60 | 70 | 90 => encode(n / 10) + "ty",
        0..=99 => encode((n / 10) * 10) + "-" + &encode(n % 10)[..],
        0..=999 => separate(n, 100, "hundred"),
        0..=999_999 => separate(n, 1_000, "thousand"),
        0..=999_999_999 => separate(n, 1_000_000, "million"),
        0..=999_999_999_999 => separate(n, 1_000_000_000, "billion"),
        0..=999_999_999_999_999 => separate(n, 1_000_000_000_000, "trillion"),
        0..=999_999_999_999_999_999 => separate(n, 1_000_000_000_000_000, "quadrillion"),
        _ => separate(n, 1_000_000_000_000_000_000, "quintillion"),
    }
}
