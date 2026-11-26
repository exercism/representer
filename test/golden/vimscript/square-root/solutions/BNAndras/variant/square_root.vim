function! SquareRoot(number) abort
  let l:working = 0
  while pow(l:working, 2) != a:number
    let l:working += 2
  endwhile

  return l:working
endfunction
