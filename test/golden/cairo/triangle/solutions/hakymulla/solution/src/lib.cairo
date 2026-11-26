pub fn is_equilateral(sides: [u64; 3]) -> bool {
    let [a, b, c] = sides;
    if !is_triangle(a, b, c) {
        return false;
    }
    if sum_len(a, b, c) {
        return false;
    }
    (a == b && b == c)
}

pub fn is_isosceles(sides: [u64; 3]) -> bool {
    let [a, b, c] = sides;
    if !is_triangle(a, b, c) {
        return false;
    }
    if sum_len(a, b, c) {
        return false;
    }
    ((a == b) ||  (b == c) || (a == c))
}

pub fn is_scalene(sides: [u64; 3]) -> bool {
    let [a, b, c] = sides;
    if !is_triangle(a, b, c) {
        return false;
    }
    if sum_len(a, b, c) {
        return false;
    }
    ((a != b) &&  (b != c) && (a != c))
}

fn is_triangle(a: u64, b: u64, c: u64) -> bool {
    !(a == 0 || b == 0 || c == 0)
}

fn sum_len(a: u64, b: u64, c: u64) -> bool {
    !(((a + b) >= c) && ((a + c) >= b) && ((b + c) >= a))
}