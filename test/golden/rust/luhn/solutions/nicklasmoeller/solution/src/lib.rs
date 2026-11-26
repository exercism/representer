/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    // If the code contains anything that is not a 0-9 or a whitespace
    // we consider the code immediately invalid.
    if code.chars().any(|c| !c.is_digit(10) && !c.is_whitespace()) {
        return false;
    }

    let (product, occurences) = code
        .chars()
        .filter_map(|c| c.to_digit(10))
        .rev()
        .enumerate()
        .fold((0, 0), |(acc, _), (i, c)| {
            let v = if i % 2 == 1 {
                if c * 2 > 9 { c * 2 - 9 } else { c * 2 }
            } else {
                c
            };
            (acc + v, i + 1) 
        });
    
    // Only codes with a product that is evenly divisible by 10, and
    // more than one numeric character are considered valid.
    occurences > 1 && product % 10 == 0
}

