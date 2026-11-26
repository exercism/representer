pub fn reverse(string: ByteArray) -> ByteArray {
    let mut reversed: ByteArray = Default::default();
    let string_len = string.len();

    for i in 0..string_len {
        let char = string.at(string_len - i + 1).unwrap();
        reversed.append_byte(char);
    };

    reversed
}
