"
" Classify a number as perfect, abundant, or deficient based on 
" the sum of its factors not including the number itself.
"
" Examples:
"
"   :echo Classify(6)
"   perfect
"
function s:extract(number, p) abort
    let n = a:number
    let pp = 1
    while n % a:p == 0
        let pp *= a:p
        let n /= a:p
    endwhile
    return [n, pp]
endfunction

function! Classify(number) abort
  let n = a:number
  if n <= 0
    throw "Classification is only possible for positive integers."
  endif
  let [n, pp] = s:extract(n, 2)
  let sigma = 2 * pp - 1
  let p = 3
  while p * p <= n
     let [n, pp] = s:extract(n, p)
     if pp != 1
        let sigma *= (p * pp - 1)/(p - 1)
     endif
     let p += 3
  endwhile
  if n != 1
      let sigma *= n + 1
  endif
  if sigma == 2 * a:number
      return "perfect"
   elseif sigma < 2 * a:number
      return "deficient"
   else
      return "abundant"
   endif
endfunction
