"
" Clean up user-entered phone numbers so that they can be sent SMS messages.
"
" Example:
"
"   :echo ToNANP('+1 (613)-995-0253')
"   6139950253
"
function! ToNANP(number) abort
  let number_only = substitute(a:number, '\D', '', 'g')
  return matchstr(number_only, '^1\?\zs[2-9]\d\{2}[2-9]\d\{6}$')
endfunction
