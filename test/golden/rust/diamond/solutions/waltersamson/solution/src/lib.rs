pub fn get_diamond(c: char) -> Vec<String> {
    let nchars = (c as u8 - b'A' + 1) as usize;
    let mut result = Vec::<String>::with_capacity(nchars+nchars-1);
    for i in 0..nchars {
        let mut row = vec![b' '; nchars+nchars-1];
        row[nchars-1-i] = b'A' + i as u8;
        row[nchars-1+i] = b'A' + i as u8;
        result.push(String::from_utf8(row).unwrap());
    }
    for i in (0..nchars-1).rev() {
        result.push(result[i].clone());
    }
    result
}
