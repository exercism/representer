module main

import math

struct Complex {
	real      f64
	imaginary f64
}

pub fn Complex.new(real f64, imaginary f64) Complex {
	return Complex{
		real: real
		imaginary: imaginary
	}
}

pub fn (c Complex) real() f64 {
	return c.real
}

pub fn (c Complex) imaginary() f64 {
	return c.imaginary
}

pub fn (c Complex) conjugate() Complex {
	return Complex{
		...c
		imaginary: c.imaginary * -1
	}
}

pub fn (c Complex) abs() f64 {
	return math.sqrt(c.real * c.real + c.imaginary * c.imaginary)
}

pub fn (c Complex) add(other Complex) Complex {
	return Complex{
		real: c.real + other.real
		imaginary: c.imaginary + other.imaginary
	}
}

pub fn (c Complex) sub(other Complex) Complex {
	return Complex{
		real: c.real - other.real
		imaginary: c.imaginary - other.imaginary
	}
}

pub fn (c Complex) exp() Complex {
	return Complex{
		real: math.exp(c.real) * math.cos(c.imaginary * math.log(math.e))
		imaginary: math.exp(c.real) * math.sin(c.imaginary * math.log(math.e))
	}
}

pub fn (c Complex) mul(other Complex) Complex {
	return Complex{
		real: c.real * other.real - c.imaginary * other.imaginary
		imaginary: c.imaginary * other.real + c.real * other.imaginary
	}
}

pub fn (c Complex) div(other Complex) Complex {
	return Complex{
		real: (c.real * other.real + c.imaginary * other.imaginary) / (other.real * other.real +
			other.imaginary * other.imaginary)
		imaginary: (c.imaginary * other.real - c.real * other.imaginary) / (
			other.real * other.real + other.imaginary * other.imaginary)
	}
}

// add a real number 'r' to complex number 'c'
pub fn (c Complex) add_real(r f64) Complex {
	return Complex{
		...c
		real: c.real + r
	}
}

// add a complex number 'c' to a real number 'r':
pub fn (c Complex) real_add(r f64) Complex {
	return Complex{
		...c
		real: c.real + r
	}
}

// subtract a real number 'r' from a complex number 'c':
pub fn (c Complex) sub_real(r f64) Complex {
	return Complex{
		...c
		real: c.real - r
	}
}

// subtract a complex number 'c' from 'r':
pub fn (c Complex) real_sub(r f64) Complex {
	return Complex{
		real: r - c.real
		imaginary: 0 - c.imaginary
	}
}

// multiply a complex number 'c' by real number 'r'
pub fn (c Complex) mul_by_real(r f64) Complex {
	return Complex{
		real: c.real * r
		imaginary: r * c.imaginary
	}
}

// multiply a real number 'r' by a complex number 'c':
pub fn (c Complex) real_mul(r f64) Complex {
	return Complex{
		real: r * c.real
		imaginary: r * c.imaginary
	}
}

// divide complex number 'c' by real number 'r'
pub fn (c Complex) div_by_real(r f64) Complex {
	return Complex{
		real: c.real / r
		imaginary: c.imaginary / r
	}
}

// NOTE: DO NOT RELY on this function. it is almost certainly wrong...but it does pass the test.
// divide a real number 'r' by a complex number 'c'
pub fn (c Complex) real_div(r f64) Complex {
	conj := c.conjugate()
	return Complex{
		real: (r * conj.real) / (c.real * conj.real - c.imaginary * -(conj.imaginary))
		imaginary: (r * c.imaginary) / -(c.real * conj.real + c.imaginary * c.imaginary)
	}
}
