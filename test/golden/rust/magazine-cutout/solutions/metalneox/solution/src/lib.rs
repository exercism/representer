// This stub file contains items which aren't used yet; feel free to remove this module attribute
// to enable stricter warnings.
#![allow(unused)]
use std::collections::HashMap;
pub fn can_construct_note(magazine: &[&str], note: &[&str]) -> bool {

    let mut magazine_map = HashMap::new();
    
    for word in magazine {
        let id = magazine_map.entry(word).or_insert(0);
        *id += 1;
    }
    
    for word in note {
        let id = magazine_map.entry(word).or_insert(0);
        if *id == 0 {
            return false;
        }
        *id -= 1;
    }
    
    true
}