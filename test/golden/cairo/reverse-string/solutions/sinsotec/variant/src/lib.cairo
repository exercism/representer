
pub fn reverse(string: ByteArray) -> ByteArray {
    let mut reversed: ByteArray = "";
    let mut  l = string.len();
    while l >= 0 {
        l -= 1;
        reversed.append_byte(string[l]);
    }; 
    return reversed;
    panic!("implement `reverse`")
}
