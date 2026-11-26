"
" Tests whether a number is equal to the sum of its digits, 
" each raised to the power of the overall number of digits.
"
function! IsArmstrongNumber(number) abort
  "let digits = split(a:number, '\zs')
  "let len = len(digits)
  "let sum = 0

  "for digit in digits
  "  let sum += pow(str2nr(digit), len)
  "endfor

  "return sum == a:num

    if a:number < 0
        return 0
    endif
    
    let num_str = string(a:number)
    let digit_count = strlen(num_str)
    
    let sum = 0
    for i in range(digit_count)
        let digit = str2nr(strpart(num_str, i, 1))
        let sum += pow(digit, digit_count)
    endfor
    
    return sum == a:number ? 1 : 0
endfunction
