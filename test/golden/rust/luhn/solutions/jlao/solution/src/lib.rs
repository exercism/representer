/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    // Err if there is an invalid character
    // Otherwise Ok(v) and v is a vector of the parsed digits
    let parsed: Result<Vec<u32>, &str> = code.chars()
        .filter_map(|c| 
            match c.to_digit(10) {
                // Filter out spaces
                None if c == ' ' => None,
                // Error on non-digits
                None => Some(Err("Invalid char")),
                // Digits are OK
                Some(n) => Some(Ok(n))
            }
        )
        .collect();
    
    match parsed {
        // There was an invalid character
        Err(_) => false,

        // There was only one digit
        Ok(ref v) if v.len() <= 1 => false,

        // Otherwise do the computation
        Ok(v) => {
            let sum: u32 = v.iter()
                .rev()
                .enumerate()
                .map(|(i, &n)| n + ((i % 2) as u32) * n)
                .map(|n| if n > 9 { n - 9 } else { n })
                .sum();
            
            sum % 10 == 0
        }    
    }
}
