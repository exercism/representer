fn is_digit(c: &char) -> bool {
    c.is_digit(10)
}

pub fn series(digits: &str, len: usize) -> Vec<String> {
    // Cannot use closures, copy_closures and clone_closures (#44490) are needed
    let mut iter = digits.chars().filter(is_digit);
    let mut series = vec![];

    loop {
        if iter.size_hint().1.unwrap() < len {
            break;
        }
        series.push(iter.clone().take(len).collect());

        if None == iter.next() {
            break;
        }
    }

    series
}