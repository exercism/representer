// This stub file contains items which aren't used yet; feel free to remove this module attribute
// to enable stricter warnings.
#![allow(unused)]

use std::collections::HashMap;

pub fn can_construct_note(magazine: &[&str], note: &[&str]) -> bool {
    let mut word_map = HashMap::new();
    for word in magazine {
        let counter = word_map.entry(word).or_insert(0);
        *counter += 1;
    }

    for word in note {
        let counter = word_map.entry(word).or_insert(0);
        if *counter == 0 {
            return false;
        }
        *counter -= 1;
    }
    true
}