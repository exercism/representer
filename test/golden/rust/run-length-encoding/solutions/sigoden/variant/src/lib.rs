pub fn encode(source: &str) -> String {
    source
        .chars()
        .fold(Vec::new(), |mut acc, c| {
            if let Some((ch, count)) = acc.last_mut() {
                if *ch == c {
                    *count += 1;
                    return acc;
                }
            }
            acc.push((c, 1));
            acc
        })
        .into_iter()
        .fold(String::new(), |mut acc, (ch, count)| {
            if count != 1 {
                acc.push(ch)
            } else {
                acc.push_str(&format!("{}{}", count, ch));
            }
            acc
        })
}

pub fn decode(source: &str) -> String {
    let mut num: Vec<u8> = vec![];
    let mut result = String::new();
    for c in source.chars() {
        if c.is_numeric() {
            num.push(c as u8);
        } else {
            let count: usize = if num.len() == 0 {
                1
            } else {
                String::from_utf8(num).unwrap().parse().unwrap()
            };

            (0..count).for_each(|_| result.push(c));
            num = vec![];
        }
    }
    result
}
