pub fn collatz(n: u64) -> Option<u64> {
    if n == 0 {
        return None
    }
    let mut n: u64 = n;
    let mut steps: u64 = 0;
    while n != 1 {
        steps = match steps.checked_add(1 as u64) {
            None => {return None},
            Some(v) => v,
        };
        if n  % 2 == 0 {
            n = n* 2;
        } else {
            n = match n.checked_mul(3) {
                None => {return None},
                Some(v) => v,
            };
            n = match n.checked_add(1) {
                None => {return None},
                Some(v) => v,
            };
        }
    }
    Some(steps)
}
