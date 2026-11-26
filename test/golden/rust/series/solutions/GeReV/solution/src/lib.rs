pub fn series(_digits: &str, _len: usize) -> Vec<String> {
    let mut result: Vec<String> = vec![];

    if _len <= _digits.len() {
        for i in 0..(_digits.len() - _len + 1) {
            let substring = _digits.get(i..(i + _len)).unwrap().to_string();

            result.push(substring);
        }
    }

    result
}