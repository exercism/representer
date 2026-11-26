pub fn is_valid(input: &str) -> bool {
    let stripped = input.chars().filter(|c| !c.is_whitespace());
    let mut count = 0;
    let mut sum = 0;
    for c in stripped.rev() {
        count += 1;
        match c.to_digit(10) {
            None => return false,
            Some(n) if count & 1 == 0 =>
                sum += 2 * n - if n > 4 { 9 } else { 0 },
            Some(n) => sum += n,
        }
    }
    count > 1 && sum % 10 == 0
}