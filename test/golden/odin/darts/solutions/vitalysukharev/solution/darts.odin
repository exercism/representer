package darts

score :: proc(x, y: f64) -> int {
	distance := x * x + y * y
    if distance > 100 {
        return 0
    } else if distance > 25 {
        return 1
    } else if distance > 1 {
        return 5
    } else {
        return 10
    }
	return 0
}
