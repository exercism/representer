pub fn steps(number: usize) -> usize {
    if number < 1 {
        panic!("Only positive integers are allowed");
    }
    let mut n = number;
    let mut s = 0;
    while n > 1 {
        n = if n % 2 > 0 { n / 3 + 1 } else { n / 2 };
        s += 1;
    };
    return s;
}
