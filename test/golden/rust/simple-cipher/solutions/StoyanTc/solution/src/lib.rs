use rand::random_range;

pub fn encode(key: &str, s: &str) -> Option<String> {
    if key.is_empty() {
        return None;
    }
    let encoded = key
        .chars()
        .cycle()
        .zip(s.chars())
        .map(|(key_ch, ch)| {
            if key_ch.is_alphabetic() && key_ch.is_ascii_lowercase() {
                Some(((ch as u8 + key_ch as u8 - 2 * b'a') % 26 + b'a') as char)
            } else {
                None
            }
        })
        .collect::<Option<String>>();
    encoded
}

pub fn decode(key: &str, s: &str) -> Option<String> {
    if key.is_empty() {
        return None;
    }

    let decoded = key
        .chars()
        .cycle()
        .zip(s.chars())
        .map(|(key_ch, ch)| {
            if key_ch.is_alphabetic() && key_ch.is_ascii_lowercase() {
                Some(((26 + ch as u8 - key_ch as u8) % 26 + b'a') as char)
            } else {
                None
            }
        })
        .collect::<Option<String>>();
    decoded
}

pub fn encode_random(s: &str) -> (String, String) {
    let key = (1..=101)
        .map(|_| (random_range(0..=25) + b'a') as char)
        .collect::<String>();    
    let encoded = encode(&key, s).unwrap();
    (key, encoded)
}
