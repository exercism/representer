use std::collections::BTreeMap;

pub fn transform(h: &BTreeMap<i32, Vec<char>>) -> BTreeMap<char, i32> {
   let mut transformed: BTreeMap<char, i32> = BTreeMap::new();

    for (value, letters) in h {
        let lowercase_letters = letters
        .iter()
        .filter(|letter| letter.to_lowercase().next().unwrap());

        for letter in lowercase_letters {
            transformed.insert(letter, *value);
        }

    }
    transformed
}
