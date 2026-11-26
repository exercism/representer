"
" This function takes a year and returns 1 if it's a leap year
" and 0 otherwise.
"
function! LeapYear(year) abort

  " your implementation goes here
  if fmod(a:year, 4) == 0
    if fmod(a:year, 100) == 0
      if fmod(a:year, 400) == 0
        return 1
      endif
      return 0
    endif
    return 1
  endif

  return 0

endfunction
