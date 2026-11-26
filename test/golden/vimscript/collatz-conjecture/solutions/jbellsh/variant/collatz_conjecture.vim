"
" Returns the number of steps to reach 1 for a given number
" using the Collatz Conjecture or 3x+1 problem.
" Throws an error if input is less than 1.
"
" Example:
"
"   :echo Steps(16)
"   4
"
"   :echo Steps(-1)
"   E605: Exception not caught: Only positive integers are allowed
"
function! Steps(number) abort
  if a:number < 1
    throw "Only positive integers are allowed"
  elseif a:number == 2
    return 0
  endif

  let l:result = 0
  let l:num = a:number
  while l:num != 1
    let l:result += 1
    if l:num % 2 == 0
      let l:num /= 2
    else
      let l:num = l:num * 3 + 1
    endif
  endwhile

  return l:result
endfunction
