pub fn is_valid(s: &str) -> bool {
    let mut i = 0;
    let mut check = 0;
    for c in s.chars().filter(|c| *c != ' ').rev() {
        if !('0' <= c && c <= '9') {
            return false;
        }
        let mut c: u8 = (c as u8) - ('0' as u8);
        if i % 2 == 1 {
            c = 2*c;
            if c > 9 {
                c = c - 9;
            }
        };
        check = (check + c) % 10;
        i += 1;
    }
    i > 1 && check == 0
}