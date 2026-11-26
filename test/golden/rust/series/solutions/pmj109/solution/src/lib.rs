pub fn series(digits: &str, len: usize) -> Vec<String> {
    if len > digits.len() {
        return vec![];
    }
    let mut seqs = Vec::new();
    for i in 0..digits.len() - len + 1 {
        seqs.push(digits[i..i+len].to_owned());
    }
    seqs
}