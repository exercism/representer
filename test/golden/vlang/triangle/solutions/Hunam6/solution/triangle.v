module main

fn is_triangle(a f64, b f64, c f64) bool {
    return (a + b >= c && b + c >= a && a + c >= b)
}

fn is_isosceles(a f64, b f64, c f64) bool {
    mut equal_sides := int(a == b)
    equal_sides += int(b == c)
    equal_sides += int(a == c)
    return is_triangle(a, b, c) && equal_sides >= 1
}

fn is_equilateral(a f64, b f64, c f64) bool {
    return is_triangle(a, b, c) && a == b && b == c && c == a
}

fn is_scalene(a f64, b f64, c f64) bool {
    return is_triangle(a, b, c) && a != b && b != c && c != a
}