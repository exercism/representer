package darts
import "core:math"

score :: proc(x, y: f64) -> int {
	dist: f64 = math.sqrt((x*x)+(y*y))
    if dist <= 1 { return 10 }
    else if dist <= 5 { return 5 }
    else if dist <= 10 { return 1 }
	else { return 0 }
}




        