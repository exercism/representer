package complexnumbers

import "math"

// Number is an implementation of a complex number.
type Number struct {
	real      float64
	imaginary float64
}

// Real returns n's real part.
func (n Number) Real() float64 {
	return n.real
}

// Imaginary returns n's imaginary part.
func (n Number) Imaginary() float64 {
	return n.imaginary
}

// Add returns n1 + n2.
func (n1 Number) Add(n2 Number) Number {
	return Number{
		real:      n1.real + n2.real,
		imaginary: n1.imaginary + n2.imaginary,
	}
}

// Subtract returns n1 - n2.
func (n1 Number) Subtract(n2 Number) Number {
	return Number{
		real:      n1.real - n2.real,
		imaginary: n1.imaginary - n2.imaginary,
	}
}

// Multiply returns n1 * n2.
func (n1 Number) Multiply(n2 Number) Number {
	return Number{
		real:      n1.real*n2.real - n1.imaginary*n2.imaginary,
		imaginary: n1.imaginary*n2.real + n1.real*n2.imaginary,
	}
}

// Times returns n * factor.
func (n Number) Times(factor float64) Number {
	return Number{
		real:      factor * n.real,
		imaginary: factor * n.imaginary,
	}
}

// Divide returns n1 / n2.
func (n1 Number) Divide(n2 Number) Number {
	divisor := n2.real*n2.real + n2.imaginary*n2.imaginary
	return Number{
		real:      (n1.real*n2.real + n1.imaginary*n2.imaginary) / divisor,
		imaginary: (n1.imaginary*n2.real - n1.real*n2.imaginary) / divisor,
	}
}

// Conjugate returns a - ib for n = a + ib.
func (n Number) Conjugate() Number {
	return Number{
		real:      n.real,
		imaginary: -n.imaginary,
	}
}

// Abs returns the absolute value of the imaginary number, its Euclidean distance from the origin.
func (n Number) Abs() float64 {
	return math.Sqrt(n.real*n.real + n.imaginary*n.imaginary)
}

// Exp returns e^n, Euler's constant raised to n.
func (n Number) Exp() Number {
	factor := math.Exp(n.real)
	return Number{
		real:      factor * math.Cos(n.imaginary),
		imaginary: factor * math.Sin(n.imaginary),
	}
}
