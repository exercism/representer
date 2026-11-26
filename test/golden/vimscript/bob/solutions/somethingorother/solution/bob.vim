"
" This function takes any remark and returns Bob's response.
"
function! Response(remark) abort

  " Whitespace check
  let remark = substitute(a:remark, '[[:space:]+]', '', 'g')
  if len(remark) == 0| return 'Fine. Be that way!' | endif

  let is_question = remark[len(remark)-1] == '?'
  let remark = substitute(remark, '\v[^A-Za-z]', '', 'g')
  let is_uppercase = match(remark, '\v^[A-Z]+$') == 0

  if is_uppercase
    if is_question
        return "Calm down, I know what I'm doing!"
    else
        return "Whoa, chill out!"
    endif
  else " is_lowercase
      if is_question
          return "Sure."
      else
          return "Whatever."
      endif
  endif

endfunction
