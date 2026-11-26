"
" Clean up user-entered phone numbers so that they can be sent SMS messages.
"
" Example:
"
"   :echo ToNANP('+1 (613)-995-0253')
"   6139950253
"
function! ToNANP(number) abort
  " your code goes here
  let l:trim = substitute(a:number, "[^0-9]", "", "g")
  let l:trim = substitute(l:trim, "^1", "", "")
  if strlen(l:trim) < 10
    return ""
  endif
  if strlen(l:trim) > 10
    return ""
  endif
  if l:trim =~ "^[0-1]"
    return ""
  endif
  if l:trim =~ "^...[0-1]"
    return ""
  endif
  return l:trim
endfunction
