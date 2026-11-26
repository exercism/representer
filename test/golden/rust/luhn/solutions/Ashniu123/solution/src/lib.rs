/// Check a Luhn checksum.
pub fn is_valid(code: &str) -> bool {
    let mut v: Vec<u32> = Vec::new();
    for c in code.chars() {
        if c.is_ascii_whitespace() {
            continue;
        } else if c.is_ascii_digit() {
            let num: u32 = c.to_digit(10).unwrap();
            v.push(num);
        } else {
            return false;
        }
    }

    if v.len() <= 1 {
        return false;
    }

    v.iter()
        .rev()
        .enumerate()
        .map(|(i, x)| {
            if i % 2 == 1 {
                let p = (*x) * 2;
                if p > 9 {
                    p - 9
                } else {
                    p
                }
            } else {
                (*x)
            }
        })
        .rev()
        .collect::<Vec<u32>>()
        .iter()
        .fold(0, |a, x| a + x)
        % 10
        == 0
}
