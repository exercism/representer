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
function! ToRoman(number) abort
    let s:numerals = ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I']
    let s:values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    let s:roman = ''
    let s:number = a:number

    for i in range(len(s:values))
        while s:number >= s:values[i]
            let s:roman .= s:numerals[i]
            let s:number -= s:values[i]
        endwhile
    endfor

    return s:roman
endfunction
