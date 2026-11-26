package darts

import "core:math"

score :: proc(x, y: f64) -> (score: int) {
	d := math.hypot(x, y)
	switch {
		case d <= 1:  score = 10
		case d <= 5:  score = 5
		case d <= 10: score = 1
	}
	return score
}
