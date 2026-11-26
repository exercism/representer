use std::collections::BTreeMap;

pub fn transform(input: &BTreeMap<i32, Vec<char>>) -> BTreeMap<char, i32> {
    let mut result = BTreeMap::new();

    for (key, value) in input {
        for target in value {
            result.insert(target.to_ascii_lowercase(), *key);
        }
    }

    result
}