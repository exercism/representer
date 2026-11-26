pub fn steps(number: usize) -> usize {
    let mut n = number;
    let mut c = 0;
    if number < 1 {
        panic!("Only positive integers are allowed")
    }
    while n > 1 {
        if n % 2 == 0 {
            n = n / 2; 
        } else {
            n = (n * 3) + 1
        }
        c += 1;
    };
    c
}
