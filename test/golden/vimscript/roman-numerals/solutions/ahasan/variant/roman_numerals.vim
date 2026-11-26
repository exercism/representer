"
" Write a function to convert Arabic numbers to Roman numerals.
"
" Examples:
"
"   :echo ToRoman(1990)
"   MCMXC
"
"   :echo ToRoman(2008)
"   MMVIII
"
function! Digits(symbol, num, unit)
    let output = ''
    let idx = 0
    let factor = a:num/a:unit
    while idx < factor
        let output .= a:symbol
        let idx += 1
    endwhile
    return output
endfunction

function! ToRoman(number)
    let remainder = a:number
    let output = ''
    if a:number >= 1000
        let output = Digits('M', remainder, 1000)
        let remainder = a:number - 1000*(a:number/1000)
    endif
    if remainder >= 500 && remainder < 900
        let output .= Digits('D', remainder, 500)
        let remainder -= 500*(remainder/500)
    elseif remainder >= 900 && remainder <= 999
        let output .= 'CM'
        let remainder -= 100*(remainder/100)
    endif
    if remainder >= 100 && remainder < 400
        let output .= Digits('C', remainder, 100)
        let remainder -= 100*(remainder/100)
    elseif remainder >= 401 && remainder <= 499
        let output .= 'CD'
        let remainder -= 100*(remainder/100)
    endif
    if remainder >= 50 && remainder < 90
        let output .= Digits('L', remainder, 50)
        let remainder -= 50*(remainder/50)
    elseif remainder >= 90 && remainder <= 99
        let output .= 'XC'
        let remainder -= 10*(remainder/10)
    endif
    if remainder >= 10 && remainder < 40
        let output .= Digits('X', remainder, 10)
        let remainder -= 10*(remainder/10)
    elseif remainder >= 40 && remainder <= 49
        let output .= 'XL'
        let remainder -= 10*(remainder/10)
    endif
    if remainder >= 5 && remainder < 9
        let output .= Digits('V', remainder, 5)
        let remainder -= 5*(remainder/5)
    elseif remainder ==# 9
        let output .= 'IX'
        let remainder -= 9
    endif
    if remainder >= 1 && remainder < 4
        let output .= Digits('I', remainder, 1)
        let remainder -= 1*(remainder/1)
    elseif remainder ==# 4
        let output .= 'IV'
        let remainder -= 4
    endif
    return output
endfunction
