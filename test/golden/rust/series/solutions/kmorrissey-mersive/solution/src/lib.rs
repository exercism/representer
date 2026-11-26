/*
pub fn series(digits: &str, len: usize) -> Vec<String> {
    if len == 0 {
        return vec!["".to_string(); 6];
    }
    if digits.len() < len {
        return vec![];
    }
    let n = digits.len() - len;
    let chars = digits.chars().collect::<Vec<char>>();
    (0..n+1).map(|i|chars[i..i+len].iter().collect::<String>()).collect()
}
*/

pub fn series(digits: &str, len: usize) -> Vec<String> {
    if len == 0 {
        // Returning this strange value because it's what test case wants.
        vec![String::new(); digits.len()+1 ]
    }
    else if digits.len() < len {
        // This case is undefined in the specs.
        vec![]
    }
    else {
        let chars: Vec<_> = digits.chars().collect();
        chars.windows(len).map(|chs|chs.into_iter().collect()).collect()
    }
}