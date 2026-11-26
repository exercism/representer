pub fn abbreviate(phrase: ByteArray) -> ByteArray {
    let mut i = 1;
    let mut res: ByteArray = "";
    let mut temp_res: ByteArray = "";
    res.append_byte(phrase.at(0).unwrap());
    while i < phrase.len() - 1{

        let next = phrase.at(i+1);
        if let Option::Some(c) = next{
            if check_good(c.clone()) && check_symbol(phrase.at(i).unwrap()) {
                temp_res.append_byte(c);
                println!("temp is {}", temp_res);
            }
        };
        i += 1;
    };
    // Caps check
    i = 0;
    while i < temp_res.len() {
        let ohyeah = caps(temp_res.at(i).unwrap());
        res.append_byte(ohyeah);
        i +=1;
        println!("RES is {}", res);

    };
    
    //panic!("implement `abbreviate`")
    res
}

fn check_good(input: u8) -> bool {
    if (input == 0x27) {
        return false;
    }
    if (input < 91 && input > 64) || (input > 96 && input < 123) {
        return true;
    }
    false
}

fn check_symbol(input: u8) -> bool {
    if (input == 0x27) {
        return false;
    }
    if (input > 90 && input < 97) || (input < 65) || (input > 122) {
        return true;
    }
    false
}

fn caps(input: u8) -> u8 {
    if (input > 96 || input < 123) {
        return input - 32;
    }
    input
}