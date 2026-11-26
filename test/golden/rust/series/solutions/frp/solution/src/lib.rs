use std::str;

pub fn series(digits: &str, len: usize) -> Vec<String> {
    if len == 0 {
        vec!["".to_string(); digits.len() + 1]
    } else {
        let as_char_vec: Vec<char> = digits.chars().collect();
        as_char_vec.windows(len).map(|x| x.iter().collect()).collect()
    }
}