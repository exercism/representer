pub fn series(_digits: &str, _len: usize) -> Vec<String> {
    let mut result = Vec::new();
    for i in 0 .. _digits.len() + 1 { // +1 because of the silly length zero test
        if i + _len > _digits.len() {
            break;
        }
        else {
            result.push(String::from(&_digits[i .. i + _len]));
        }
    }
    result
}