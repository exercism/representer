pub fn encode(phrase: ByteArray) -> ByteArray {
    let mut encoded_phrase: ByteArray = "";
    let mut l = 0;
    let mut c = '';
    let mut n: u32 = 0;
    while l < phrase.len() {
        c = phrase[l];
        if c < 47 { // saltar los espacios y signos
            l += 1;
            continue;
        } else if (c >= 48 && c <= 57) { // respetar los numeros
            encoded_phrase.append_byte(c);
            n += 1;
        } else if (c >= 65 && c <= 90) {
            encoded_phrase.append_byte(90 + 65 - c + 32);
            n += 1;
        } else if (c >= 97 && c <= 122) {
            encoded_phrase.append_byte(122 + 97 - c);
            n += 1;
        }
        l += 1;
        if (l + 1 < phrase.len()) && (n % 5 == 0) {
            encoded_phrase.append_byte(32);
        }
    };
    encoded_phrase
    //panic!("implement `encode`")
}

pub fn decode(phrase: ByteArray) -> ByteArray {
    let mut encoded_phrase: ByteArray = "";
    let mut l = 0;
    let mut c = '';
    while l < phrase.len() {
        c = phrase[l];
        if c < 47 { // saltar los espacios y signos
            l += 1;
            continue;
        } else if (c >= 48 && c <= 57) { // respetar los numeros
            encoded_phrase.append_byte(c);
        } else if (c >= 65 && c <= 90) {
            encoded_phrase.append_byte(90 + 65 - c + 32);
        } else if (c >= 97 && c < 122) {
            encoded_phrase.append_byte(122 + 97 - c);
        }
        l += 1;
        
    };
    encoded_phrase
    
    //panic!("implement `decode`")
}
