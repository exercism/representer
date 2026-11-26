pub fn encode(n: u64) -> String {
    if n == 0 {
        return "zero".to_string();
    }

    let powers_of_ten = vec![
        (1_000_000_000_000_000_000, " quintillion"),
        (1_000_000_000_000_000, " quadrillion"),
        (1_000_000_000_000, " trillion"),
        (1_000_000_000, " billion"),
        (1_000_000, " million"),
        (1_000, " thousand"),
        (1, ""),
    ];

    let mut rest = n;
    let mut result = "".to_string();

    while rest > 0 {
        let powers = powers_of_ten.iter().find(|p| rest / p.0 >= 1).unwrap();
        let current = rest / powers.0;
        rest -= current * powers.0;

        result = format!(
            "{} {}{}",
            result,
            if current >= 100 {
                format!("{} hundred {}", parse(current / 100), parse(current % 100))
            } else {
                parse(current)
            },
            powers.1
        )
    }
    result.trim().to_string()
}

fn parse(n: u64) -> String {
    fn calc_string(num: u64, roof: u64) -> String {
        format!(
            "{}{}{}",
            retrieve_heigh_number(num),
            if num % roof > 0 { "-" } else { "" },
            retrieve_low_number(num % roof)
        )
    }

    match n {
        0..=19 => retrieve_low_number(n).to_string(),
        20..=29 => calc_string(n, 20),
        30..=99 => calc_string(n, 10),
        _ => format!("{}", n),
    }
}

fn retrieve_heigh_number(n: u64) -> &'static str {
    match n {
        20..=29 => "twenty",
        30..=39 => "thirty",
        40..=49 => "forty",
        50..=59 => "fifty",
        60..=69 => "sixty",
        70..=79 => "seventy",
        80..=89 => "eighty",
        90..=99 => "ninety",
        _ => "",
    }
}

fn retrieve_low_number(n: u64) -> &'static str {
    match n {
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
        _ => "",
    }
}
