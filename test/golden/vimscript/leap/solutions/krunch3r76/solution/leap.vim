"
" This function takes a year and returns 1 if it's a leap year
" and 0 otherwise.
"

function! LeapYear(year) abort
  let l:isEvenlyDivisibleBy4 = (a:year%4==0)
  if !l:isEvenlyDivisibleBy4
	  return 0
  endif
  let l:isEvenlyDivisibleBy100 = (a:year%100==0)
  if l:isEvenlyDivisibleBy100
	  let l:isEvenlyDivisibleBy400 = (a:year%400==0)
	  if !l:isEvenlyDivisibleBy400
		  return 0
	  endif
  endif
  return 1
endfunction
