const MAGNITUDES: [u64; 7] = [
    1_000_000_000_000_000_000,
    1_000_000_000_000_000,
    1_000_000_000_000,
    1_000_000_000,
    1_000_000,
    1_000,
    100,
];

pub fn encode(n: u64) -> String {
    let mut n = n;

    if n == 0 {
        return say(n);
    }

    let mut parts: Vec<String> = Vec::new();

    for &m in MAGNITUDES.iter() {
        if n >= m {
            parts.push(format!("{} {}", encode(n / m), say(m)));
            n %= m;
        }
    }

    let last_digit = n % 10;

    if n > 20 && last_digit > 0 {
        parts.push(format!("{}-{}", say(n - last_digit), say(last_digit)));
    } else if n > 0 {
        parts.push(say(n));
    }

    parts.join(" ")
}

fn say(n: u64) -> String {
    match n {
        0 => "zero",
        1 => "one",
        2 => "two",
        3 => "three",
        4 => "four",
        5 => "five",
        6 => "six",
        7 => "seven",
        8 => "eight",
        9 => "nine",
        10 => "ten",
        11 => "eleven",
        12 => "twelve",
        13 => "thirteen",
        14 => "fourteen",
        15 => "fifteen",
        16 => "sixteen",
        17 => "seventeen",
        18 => "eighteen",
        19 => "nineteen",
        20 => "twenty",
        30 => "thirty",
        40 => "forty",
        50 => "fifty",
        60 => "sixty",
        70 => "seventy",
        80 => "eighty",
        90 => "ninety",
        100 => "hundred",
        1_000 => "thousand",
        1_000_000 => "million",
        1_000_000_000 => "billion",
        1_000_000_000_000 => "trillion",
        1_000_000_000_000_000 => "quadrillion",
        1_000_000_000_000_000_000 => "quintillion",
        _ => unreachable!(),
    }
    .to_string()
}
