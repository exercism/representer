use std::collections::HashMap;

/// Determine whether a sentence is a pangram.
pub fn is_pangram(sentence: &str) -> bool {
    let mut dict = ('a'..='z').map(|c| { (c, 0) }).collect::<HashMap<char, i32>>();
    for c in sentence.chars() {
        if dict.contains_key(&c.to_ascii_lowercase()) {
            *dict.get_mut(&c.to_ascii_lowercase()).unwrap() = 1;
        }
    }
    dict.values().sum::<i32>() as usize == dict.len()
}
