use std::convert::From;
use std::fmt::{Display, Formatter, Result};

const CHUNK_SIZE: u64 = 1000;

pub struct SayInt(u64);

impl SayInt {
    pub fn new(n: u64) -> Self {
        SayInt(n)
    }
}

impl From<SayInt> for String {
    fn from(n: SayInt) -> Self {
        n.to_string()
    }
}

impl Display for SayInt {
    fn fmt(&self, f: &mut Formatter<'_>) -> Result {
        if self.0 == 0 {
            return write!(f, "zero");
        }

        let mut chunks = vec![];
        let mut value = self.0;

        while value > 0 {
            chunks.push(value % CHUNK_SIZE);
            value /= CHUNK_SIZE;
        }

        let result = chunks
            .iter()
            .enumerate()
            .map(|(i, val)| -> Option<String> {
                match translate(*val) {
                    Some(t) => Some(
                        t + match i {
                            0 => "",
                            1 => " thousand",
                            2 => " million",
                            3 => " billion",
                            4 => " trillion",
                            5 => " quadrillion",
                            6 => " quintillion",
                            _ => unreachable!(),
                        },
                    ),
                    None => None,
                }
            })
            .filter_map(|s| s)
            .collect::<Vec<_>>();

        write!(
            f,
            "{}",
            result.into_iter().rev().collect::<Vec<_>>().join(" ")
        )
    }
}

fn translate(n: u64) -> Option<String> {
    if n >= CHUNK_SIZE {
        panic!("Translate value must be less than {}", CHUNK_SIZE);
    }

    if n == 0 {
        return None;
    }

    let ones = n % 10;
    let tens = n % 100;
    let hundreds = n / 100;

    let mut result = vec![];

    if hundreds > 0 {
        result.push(digit_to_string(hundreds) + " hundred");
    }

    let mut tens_string = String::new();

    if tens > 0 && tens < 20 {
        tens_string = match tens {
            (1..=9) => digit_to_string(tens),
            10 => "ten".to_string(),
            11 => "eleven".to_string(),
            12 => "twelve".to_string(),
            13 => "thirteen".to_string(),
            14 => "fourteen".to_string(),
            15 => "fifteen".to_string(),
            16 => "sixteen".to_string(),
            17 => "seventeen".to_string(),
            18 => "eighteen".to_string(),
            19 => "nineteen".to_string(),
            _ => unreachable!(),
        }
    } else if tens >= 20 {
        tens_string = match tens / 10 {
            2 => "twenty".to_string(),
            3 => "thirty".to_string(),
            4 => "forty".to_string(),
            5 => "fifty".to_string(),
            6 => "sixty".to_string(),
            7 => "seventy".to_string(),
            8 => "eighty".to_string(),
            9 => "ninety".to_string(),
            _ => panic!("illegal value"),
        };

        if ones > 0 {
            tens_string = format!("{}-{}", tens_string, digit_to_string(ones));
        }
    }

    if !tens_string.is_empty() {
        result.push(tens_string);
    }

    Some(result.join(" "))
}

fn digit_to_string(n: u64) -> String {
    match n {
        1 => "one".to_string(),
        2 => "two".to_string(),
        3 => "three".to_string(),
        4 => "four".to_string(),
        5 => "five".to_string(),
        6 => "six".to_string(),
        7 => "seven".to_string(),
        8 => "eight".to_string(),
        9 => "nine".to_string(),
        _ => panic!("illegal value"),
    }
}
