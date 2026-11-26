function! s:num_eq_sides(triangle) abort
  let sides = 0
  for i in range(3)
    for j in range(3)
      if i != j && a:triangle[i] == a:triangle[j]
        let sides += 1
        break
      endif
    endfor
  endfor

  return sides
endfunction

" max() doesn't support floats
function! s:max(list) abort
  let m = 0
  for n in a:list
    if n > m
      let m = n
    endif
  endfor
  return m
endfunction

function! s:valid(triangle) abort
  let s = 0
  for n in a:triangle
    let s += n
  endfor

  if s == 0
    return 0
  endif

  let m = s:max(a:triangle)
  if count(a:triangle, m) == 1
    let s = 0
    let i = index(a:triangle, m)
    for j in range(len(a:triangle))
      if i != j
        let s += a:triangle[j]
      endif
    endfor
    return m < s
  endif
  return 1
endfunction

function! Equilateral(triangle) abort
  return s:valid(a:triangle) && s:num_eq_sides(a:triangle) == 3
endfunction

function! Isosceles(triangle) abort
  return s:valid(a:triangle) && s:num_eq_sides(a:triangle) > 1
endfunction

function! Scalene(triangle) abort
  return s:valid(a:triangle) && s:num_eq_sides(a:triangle) == 0
endfunction
