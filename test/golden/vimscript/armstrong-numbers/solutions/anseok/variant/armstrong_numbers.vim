"
" Tests whether a number is equal to the sum of its digits, 
" each raised to the power of the overall number of digits.
"
function! IsArmstrongNumber(number) abort
  " your solution goes here
  let s = string(a:number) | let n = len(s)
  return reduce(split(s, '\zs'), {
  \ i, c -> i + pow(str2nr(c), n)}, 1) == a:number
endfunction
