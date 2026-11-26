package triangle

import (
	"math"
	"sort"
)

const (
	testVersion = 2

	NaT = iota // not a triangle
	Equ = iota // equilateral
	Iso = iota // isosceles
	Sca = iota // scalene
)

type Kind int

func KindFromSides(a, b, c float64) Kind {
	t := []float64{a, b, c}
	sort.Sort(sort.Float64Slice(t))
	switch {
	case math.IsNaN(t[0]) || t[0] <= 0 && t[2] == math.Inf(1) || t[0]+t[1] <= t[2]:
		return NaT
	case t[0] == t[1] && t[1] == t[2]:
		return Equ
	case t[0] == t[1] || t[1] == t[2]:
		return Iso
	}
	return Sca
}