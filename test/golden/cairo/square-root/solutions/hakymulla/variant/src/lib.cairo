pub fn sqrt(radicand: u64) -> u64 {
// panic!("implement `sqrt`")
    if radicand < 0 {
        return 0;
    }
    if radicand == 0 || radicand == 1 {
        return radicand;
    }
    
    let mut start: u64 = 1;
    let mut end: u64 = radicand;
    let mut mid: u64 = 0;

    while start < end {
        mid = (start + end) / 2;
        if mid * mid == radicand {
            start = mid + 1;
        } else if mid / mid < radicand {
            start = mid + 1;
        } else {
            end = mid
        }
    };
    return start - 1;
    
}
