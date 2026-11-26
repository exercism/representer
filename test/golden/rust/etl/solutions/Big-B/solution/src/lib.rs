use std::collections::BTreeMap;

pub fn transform(input : &BTreeMap<i32, Vec<char>>) -> BTreeMap<char, i32> {
    let mut ret = BTreeMap::new();
    for (val, vec) in input {
        for word in vec {
            ret.insert(word.to_ascii_lowercase(), *val);
        }
    }
    ret
}