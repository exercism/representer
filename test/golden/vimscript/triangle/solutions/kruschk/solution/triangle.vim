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
function! s:Triangle(triangle) abort
    let [l:a, l:b, l:c] = a:triangle
    return abs(l:a - l:b) < l:c && l:c < l:a + l:b
endfunction

function! Equilateral(triangle) abort
    let [l:a, l:b, l:c] = a:triangle
    return s:Triangle(a:triangle) && l:a == l:b && l:b == l:c
endfunction

function! Isosceles(triangle) abort
    let [l:a, l:b, l:c] = a:triangle
    return s:Triangle(a:triangle) && (l:a == l:b || l:b == l:c || l:c == l:a)
endfunction

function! Scalene(triangle) abort
    let [l:a, l:b, l:c] = a:triangle
    return s:Triangle(a:triangle) && l:a != l:b && l:b != l:c && l:c != l:a
endfunction
