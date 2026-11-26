pub fn abbreviate(phrase: ByteArray) -> ByteArray {
    let mut acronym = "";
    let mut new_word = true;

    for i in 0..phrase.len() {
        let byte = phrase[i];

        if byte == '-' || byte == ' ' {
            new_word = true; 
        } else if new_word {
            if byte >= 65 && byte <= 90 {
                acronym.append_byte(byte);
            } else if byte >= 97 && byte <= 122 {
                acronym.append_byte(byte - 32);
            } else {
                continue;
            }
            new_word = false;
        }
    };

    return acronym;
}

