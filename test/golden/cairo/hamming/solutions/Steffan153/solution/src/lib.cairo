pub fn distance(strand1: ByteArray, strand2: ByteArray) -> u256 {
    if strand1.len() != strand2.len() {
        panic!("strands must be of equal length");
    }
    let mut i = 0;
    let mut s = 0;
    while i < strand1.len() {
        if strand1[i] != strand2[i] {
            s += 1;
        }
        i += 1;
    };
    return s;
}
