pub fn score(word: ByteArray) -> u16 {
    let mut s: u16 = 0;
    let mut i = 0;
    let scores = array![1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10];
    while i < word.len() {
        if word[i] >= 65 && word[i] <= 90 || word[i] >= 97 && word[i] <= 122 {
            let k: usize = (word[i] % 32 - 1).try_into().unwrap();
            s += *scores[k];
        }
        i += 1;
    };
    return s;
}
