pub fn add_prefix(n: u64, div: u64, prefix: &str) -> String {
    let result = encode(n / div) + " " + prefix;

    match n % div {
        0 => result,
        _ => result + " " + encode(n % div).as_str(),
    }
}

pub fn encode(n: u64) -> String {
    let ranges: [(u64, &str); 7] = [
        (1_000_000_000_000_000_000, "quintillion"),
        (1_000_000_000_000_000, "quadrillion"),
        (1_000_000_000_000, "trillion"),
        (1_000_000_000, "billion"),
        (1_000_000, "million"),
        (1_000, "thousand"),
        (100, "hundred"),
    ];

    let teens: [&str; 20] = [
        "",
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
        "ten",
        "eleven",
        "twelve",
        "thirteen",
        "fourteen",
        "fifteen",
        "sixteen",
        "seventeen",
        "eighteen",
        "nineteen",
    ];

    let tens: [&str; 8] = [
        "twenty",
        "thirty",
        "forty",
        "fifty",
        "sixty",
        "seventy",
        "eighty",
        "ninety",
    ];

    match n {
        1..=19 => teens[n as usize].to_string(),
        20..=99 => {
            let result = tens[(n / 10 - 2) as usize].to_string();
            match n % 10 {
                0 => result,
                _ => result + "-" + teens[(n % 10) as usize],
            }
        }
        _ => {
            for &(max, prefix) in &ranges {
                if n >= max {
                    return add_prefix(n, max, prefix);
                }
            }

            "zero".to_string()
        }
    }
}
