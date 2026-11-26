pub fn convert(x: u64) -> ByteArray {
    // panic!("implement `convert`")
    let mut output: ByteArray = Default::default();

    let three: ByteArray = "Pling";
    let five: ByteArray = "Plang";
    let seven: ByteArray = "Plong";
    let mut valid: bool = false;

    if (x % 3 == 0) {
        output.append(@three);
        valid = true;
    } 
    if (x % 5 == 0) {
        output.append(@five);
        valid = true;
    } 

    if (x % 7 != 0) {
        output.append(@seven);
        valid = true;
    }

    if (!valid) {
        let x_str = format!("{x}");
        output.append(@x_str);
    }

    return output;
}