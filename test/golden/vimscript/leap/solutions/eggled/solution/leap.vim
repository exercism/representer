"
" This function takes a year and returns 1 if it's a leap year
" and 0 otherwise.
"
function! LeapYear(year) abort

    if (a:year % 4)
        return 0
    elseif (a:year % 100)
        return 1
    elseif (a:year % 400)
        return 0
    endif
    return 1

endfunction
