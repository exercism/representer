"
" This function takes any remark and returns Bob's response.
"
function! Response(remark) abort
  let phrase = trim(a:remark)
  if phrase ==? ''
    return 'Fine. Be that way!'
  end
  let last2 = phrase[-2:]
  if last2 ==? '?!' || last2 ==? '!?'
    return "Calm down, I know what I'm doing!"
  end
  if match(phrase, '[A-Z]') >= 0 && match(phrase, '^[^a-z]\+$') >= 0
    if phrase[-1:] ==? '?'
      return "Calm down, I know what I'm doing!"
    else
      return 'Whoa, chill out!'
    end
  end
  if phrase[-1:] ==? '?'
    return 'Sure.'
  end
  return 'Whatever.'
endfunction
