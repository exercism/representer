// This stub file contains items that aren't used yet; feel free to remove this module attribute
// to enable stricter warnings.
#![allow(unused)]

use std::collections::HashMap;

pub fn can_construct_note(magazine: &[&str], note: &[&str]) -> bool {
    let mut map = HashMap::new();
    for item in magazine.iter(){
        if map.get(item) == None {
             map.insert(item,1);
        }else{
            map.insert(item,map.get(item).unwrap()-1);
        }
    }
    for item in note.iter(){
        if map.get(item) == Some(&0) || map.get(item) == None{
            return false;
        }
        map.insert(item,map.get(item).unwrap()-1);
    }
    return true;
}
