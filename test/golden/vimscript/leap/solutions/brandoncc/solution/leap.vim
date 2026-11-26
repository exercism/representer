"
" This function takes a year and returns 1 if it's a leap year
" and 0 otherwise.
"
function! LeapYear(year) abort
  let divisible_by_4 = a:year % 4 == 0
  let divisible_by_100 = a:year % 100 == 0
  let divisible_by_400 = a:year % 400 == 0

  if divisible_by_4 && !divisible_by_100 || divisible_by_400
    return 1
  endif

  return 0
endfunction
