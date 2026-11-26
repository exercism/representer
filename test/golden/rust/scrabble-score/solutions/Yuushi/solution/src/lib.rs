static VALUES: [u32; 26] = [
    1,
    3,
    3,
    2,
    1,
    4,
    2,
    4,
    1,
    8,
    5,
    1,
    3,
    1,
    1,
    3,
    10,
    1,
    1,
    1,
    1,
    4,
    4,
    8,
    4,
    10,
];

pub fn score(word: &str) -> u64 {
    let mut total = 0;
    for c in word.chars().filter(|x| x.is_ascii_alphabetic()).map(|x| x.to_ascii_uppercase()) {
        let index = (c as u32) - ('A' as u32);
        total += VALUES[index as usize];
    }
    total.into() 
}
