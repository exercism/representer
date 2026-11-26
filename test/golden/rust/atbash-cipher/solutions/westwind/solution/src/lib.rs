pub fn encode(plain: &str) -> String {
    let plain: String = plain
        .chars()
        .filter(|&c| c.is_ascii_alphabetic() || c.is_ascii_digit())
        .map(|c| c.to_ascii_lowercase())
        .collect();
    let mut str = String::new();
    for (k, v) in plain.chars().enumerate() {
        if k != 0 && k % 5 == 0 {
            str.push(' ');
        }
        if v.is_ascii_alphabetic() {
            str.push(get_alp(v))
        }else {
            str.push(v);
        }
    }
    str
}

/// "Decipher" with the Atbash cipher.
pub fn decode(cipher: &str) -> String {
    let cipher: String = cipher.chars().filter(|c| !c.is_whitespace()).collect();
    cipher.chars().map(|c| if c.is_ascii_alphabetic() { get_alp(c) } else { c }).collect()
}

fn get_alp(c: char) -> char {
    let c_as_u8 = c as u8 - b'a';
    ((25 - c_as_u8) + b'a') as char
}