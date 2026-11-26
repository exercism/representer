"
" Classify a number as perfect, abundant, or deficient based on 
" the sum of its factors not including the number itself.
"
" Examples:
"
"   :echo Classify(6)
"   perfect
"
function! Classify(number) abort
  " your code goes here
  if a:number < 1
    throw 'Classification is only possible for positive integers.'
  elseif a:number == 1 | return 'deficient' | endif
  let l:n = sqrt(a:number) | let l:r = 1 | let l:i = 2
  while l:i < l:n && l:r <= a:number
    if !(a:number % l:i) | let l:r += l:i + a:number / l:i | endif
    let l:i += 1 | endwhile
  if l:i == l:n | let l:r += l:i | endif
  return l:r < a:number ? 'deficient' :
  \      l:r > a:number ? 'abundant' : 'perfect'
endfunction
