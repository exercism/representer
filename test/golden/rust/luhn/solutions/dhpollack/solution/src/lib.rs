/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    //unimplemented!("Is the Luhn checksum for {} valid?", code);
    // 1. length 1 or less is invalid
    // 2. space allowed, but non-digits are not
    // 3. double every second digit, if number greater than 9 then subtract 9
    // 4. sum numbers
    // 5 valid if evenly divisible by 10
    let nonnum_nonspace = code.chars().filter(|c| !c.is_numeric() && !c.is_whitespace()).collect::<String>();
    let true_len = code.chars().filter(|c| c.is_numeric()).collect::<String>().len();
    if true_len <= 1 || nonnum_nonspace.len() > 0 {
        return false
    }
    let csum: u16 = code.chars()
        .rev()
        .filter(|c| c.is_numeric())
        .map(|c| c.to_string().parse::<u16>())
        .filter_map(Result::ok)
        .enumerate()
        .map(|(i, n)|
              if i % 2 == 0 {
                  n
              } else {
                  if n < 5 { 
                      n * 2
                  } else { 
                      n * 2 - 9
                  }
              }
        )
        .sum();
    csum % 10 == 0
}
