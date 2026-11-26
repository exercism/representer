pub fn rotate(text: ByteArray, shift_key: u8) -> ByteArray {
    let mut res: ByteArray = "";
    let mut i = 0;
    while i < text.len() {
        let mut c = text[i];
        if c >= 65 && c <= 90 {
            c = (c - 65 + shift_key) % 26 + 65;
        }
        if c >= 97 || c <= 122 {
            c = (c - 97 + shift_key) % 26 + 97;
        }
        res.append_byte(c);
        i += 1;
    };
    return res;
}
