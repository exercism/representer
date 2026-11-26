pub fn abbreviate(phrase: ByteArray) -> ByteArray { 
    println!("{}hola",phrase);
    let mut x: ByteArray = "";
    let mut l = 1;
    let mut c1 = '';
    let mut c2 = '';
    x.append_byte(phrase[0]);
    while l < phrase.len() {
        c2 = phrase[l];
        if (c2 >= 65 && c2 <= 90) || (c2 >= 97 && c2 <= 122) || (c2 == 39) {
            l += 1;
            continue;
        }
        if (l + 1 < phrase.len()) {
            c1 = phrase[l + 1];
        }
        if (c1 >= 65 && c1 <= 90) || (c1 >= 97 && c1 <= 122) {
            if c1 > 96 {
                c1 -= 32
            }
            x.append_byte(c1);
        }
        l += 1;
    };
    x
    //panic!("implement `abbreviate`")
}
