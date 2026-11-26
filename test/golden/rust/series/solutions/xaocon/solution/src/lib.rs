pub fn series(digits: &str, len: usize) -> Vec<String> {
    if len == 0 {
        vec![String::new(); digits.chars().count() + 1]
    } else {
        digits.chars().collect::<Vec<_>>().windows(len).map(|x| x.iter().collect() ).collect()
    }
}