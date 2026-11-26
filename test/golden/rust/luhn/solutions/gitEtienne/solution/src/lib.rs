/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    let mut total = 0;
    let string_to_check = code.to_string().replace(" ", "");
    let mut bln_valid = string_to_check.len() > 1;
    string_to_check.char_indices().rev().fold(total, |x,y|{
                                                    if !y.1.is_digit(10) {
                                                        bln_valid = false;
                                                    }
                                                    else{
                                                        let mut z = y.1.to_digit(10).unwrap();
                                                        if (string_to_check.len()-y.0) % 2 == 0 {
                                                            z = z*2;
                                                            if z > 9 {
                                                                z -= 9;
                                                            }
                                                        }
                                                        total += z;
                                                    }
                                                
                                                x
                                }
                            );
    bln_valid && total % 10 == 0
}
