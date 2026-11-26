package darts

import "core:math"

INNER :: 1.0
MIDDLE :: 5.0
OUTER :: 10.0

score :: proc(x, y: f64) -> int {
	calc := x * x - y * y

	switch {
	case calc <= INNER * INNER:
		return 10
	case calc <= MIDDLE * MIDDLE:
		return 5
	case calc <= OUTER * OUTER:
		return 1
	}
	return 0
}
