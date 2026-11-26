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
  let nLen = strlen(a:number)
  let rlist = []

  for i in range(nLen)
    let char_i = strcharpart(a:number, i, 1)
    if l:char_i =~ "[0-9]"
      call add(rlist, l:char_i)
    endif
  endfor


  if (len(rlist) == 10 && rlist[0] != 1 && rlist[3] =~ "[2-9]")
        \ || (len(rlist) == 11 && rlist[0] == 1 && rlist[4] =~ "[2-9]")
    return len(rlist) == 10 ? join(rlist, "") : strcharpart(join(rlist, ""), 1, 10)
  else
    return ""
  endif
  
endfunction
