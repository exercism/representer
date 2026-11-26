pub fn series(digits: &str, len: usize) -> Vec<String> {
    let mut res = Vec::new();
    if digits.len() < len
    {
        return res;
    }
    let mut i = 0;
    while i + len <= digits.len(){
        res.push(digits[i..i+len].to_string());
        i+=1;
    }
    res
}
