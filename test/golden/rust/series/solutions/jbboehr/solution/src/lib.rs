pub fn series(_digits: &str, _len: usize) -> Vec<String> {
    let mut r: Vec<String> = vec![];
    if _digits.len() >= _len {
        for i in 0..(_digits.len() - _len + 1) {
            r.push(_digits.chars().skip(i).take(_len).collect());
        }
    }
    r
}