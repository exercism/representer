module main

fn is_isosceles(a f64, b f64, c f64) bool {
    if ! (a + b >= c && b + c >= a && a + c >= b) {
        return false
    }
    count := (if a == b {1} else {0}) + (if b == c {1} else {0}) + (if a == c {1} else {0})
    return count >= 1
}

fn is_equilateral(a f64, b f64, c f64) bool {
    if ! (a + b >= c && b + c >= a && a + c >= b) {
        return false
    }
    return a == b && b == c && a == c
}

fn is_scalene(a f64, b f64, c f64) bool {
    if ! (a + b >= c && b + c >= a && a + c >= b) {
        return false
    }
    return a != b && b != c && a != c
}