module main

import math
fn is_triangle(a f64, b f64, c f64) bool {
	return a+b>c && b+c>a && a+c>b
}
fn is_isosceles(a f64, b f64, c f64) bool {
	return is_triangle(a,b,c) && (math.alike(a,b) || math.alike(b,c) || math.alike(c,a))
}

fn is_equilateral(a f64, b f64, c f64) bool {
	return is_triangle(a,b,c) && (math.alike(a,b) && math.alike(b,c))
}

fn is_scalene(a f64, b f64, c f64) bool {
	return is_triangle(a,b,c) && (!math.alike(a,b) && !math.alike(b,c) && !math.alike(c,a))
}