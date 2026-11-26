"
" Determine if a triangle is equilateral, isosceles, or scalene.
"
" An equilateral triangle has all three sides the same length.
"
" An isosceles triangle has at least two sides the same length.
" (It is sometimes specified as having exactly two sides the
" same length, but for the purposes of this exercise we'll say
" at least two.)
"
" A scalene triangle has all sides of different lengths.
"

function! Equilateral(triangle) abort
	return TriangleEq(a:triangle) && CountDistinct(a:triangle) == 1
endfunction

function! Isosceles(triangle) abort
	return TriangleEq(a:triangle) && CountDistinct(a:triangle) <= 2
endfunction

function! Scalene(triangle) abort
	return TriangleEq(a:triangle) && CountDistinct(a:triangle) == 3
endfunction

function! TriangleEq(triangle)
	let [a, b, c] = a:triangle
	return a < b + c && b < c + a && c < a + b
endfunction

function! CountDistinct(triangle)
	let dict = {}
	for x in a:triangle
		let dict[string(x)] = 0
	endfor
	return len(keys(dict))
endfunction

