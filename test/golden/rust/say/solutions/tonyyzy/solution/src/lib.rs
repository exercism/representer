use std::collections::HashMap;

pub fn encode(n: u64) -> String {
    if n == 0 {
        return "zero".to_string();
    };
    let num_map = generate_num_map();
    let result = num_convert(n, &num_map);
    result
        .iter()
        .map(|x| (*x).to_string())
        .collect::<Vec<String>>()
        .join("")
}

fn generate_num_map<'a>() -> HashMap<u64, &'a str> {
    let mut num_convert: HashMap<u64, &str> = HashMap::new();
    num_convert.insert(1, "one");
    num_convert.insert(2, "two");
    num_convert.insert(3, "three");
    num_convert.insert(4, "four");
    num_convert.insert(5, "five");
    num_convert.insert(6, "six");
    num_convert.insert(7, "seven");
    num_convert.insert(8, "eight");
    num_convert.insert(9, "nine");
    num_convert.insert(10, "ten");
    num_convert.insert(11, "eleven");
    num_convert.insert(12, "twlve");
    num_convert.insert(13, "thirteen");
    num_convert.insert(14, "fourteen");
    num_convert.insert(15, "fifteen");
    num_convert.insert(16, "sixteen");
    num_convert.insert(17, "seventeen");
    num_convert.insert(18, "eighteen");
    num_convert.insert(19, "nineteen");
    num_convert.insert(20, "twenty");
    num_convert.insert(30, "thirty");
    num_convert.insert(40, "forty");
    num_convert.insert(50, "fifty");
    num_convert.insert(60, "sixty");
    num_convert.insert(70, "seventy");
    num_convert.insert(80, "eighty");
    num_convert.insert(90, "ninety");
    num_convert
}

fn num_convert<'a>(n: u64, num_map: &HashMap<u64, &'a str>) -> Vec<&'a str> {
    if n < 21 {
        return match num_map.get(&n) {
            Some(a) => vec![a],
            None => panic!("NUM MAP MISSING STUFF"),
        };
    } else if n < 100 {
        let mut result =
            vec![*num_map.get(&(n - n % 10)).expect("NUM MAP MISSING STUFF")];
        if n % 10 != 0 {
            result.push("-");
            result.append(&mut num_convert(n % 10, num_map));
        }
        result
    } else if n < 1_000 {
        let mut result = num_convert(n / 100, num_map);
        result.push(" hundred");
        if n % 100 != 0 {
            result.push(" ");
            result.append(&mut num_convert(n % 100, num_map));
        }
        result
    } else if n < 1_000_000 {
        let mut result = num_convert(n / 1_000, num_map);
        result.push(" thousand");
        if n % 1_000 != 0 {
            result.push(" ");
            result.append(&mut num_convert(n % 1_000, num_map))
        }
        result
    } else if n < 1_000_000_000 {
        let mut result = num_convert(n / 1_000_000, num_map);
        result.push(" million");
        if n % 1_000_000 != 0 {
            result.push(" ");
            result.append(&mut num_convert(n % 1_000_000, num_map))
        }
        result
    } else if n < 1_000_000_000_000 {
        let mut result = num_convert(n / 1_000_000_000, num_map);
        result.push(" billion");
        if n % 1_000_000_000 != 0 {
            result.push(" ");
            result.append(&mut num_convert(n % 1_000_000_000, num_map))
        }
        result
    } else if n < 1_000_000_000_000_000 {
        let mut result = num_convert(n / 1_000_000_000_000, num_map);
        result.push(" trillion");
        if n % 1_000_000_000_000 != 0 {
            result.push(" ");
            result.append(&mut num_convert(n % 1_000_000_000_000, num_map))
        }
        result
    } else if n < 1_000_000_000_000_000_000 {
        let mut result = num_convert(n / 1_000_000_000_000_000, num_map);
        result.push(" quadrillion");
        if n % 1_000_000_000_000_000 != 0 {
            result.push(" ");
            result.append(&mut num_convert(n % 1_000_000_000_000_000, num_map))
        }
        result
    } else {
        let mut result = num_convert(n / 1_000_000_000_000_000_000, num_map);
        result.push(" quintillion");
        if n % 1_000_000_000_000_000_000 != 0 {
            result.push(" ");
            result.append(&mut num_convert(
                n % 1_000_000_000_000_000_000,
                num_map,
            ))
        }
        result
    }
}
